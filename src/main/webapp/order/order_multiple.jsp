<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="order.OrderService, order.OrderItemDTO" %>
<%@ page import="product.ProductDAO, product.ProductDTO" %>
<%@ page import="user.UserService, user.UserDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
  session.removeAttribute("alreadyOrdered");

  Integer userId = (Integer) session.getAttribute("userId");
  int cartId = Integer.parseInt(request.getParameter("cartId"));

  OrderService os = new OrderService();
  List<OrderItemDTO> orderList = os.makeNewOrderItems(userId, cartId);

  UserService us = new UserService();
  UserDTO user = us.getUserById(userId);

  int deliveryCost = 3000;
  int totalPrice = 0;
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>주문하기</title>
  <c:import url="/common/external_file.jsp" />
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  <style>
    .orderDiv { display: flex; justify-content: space-between; gap: 30px; }
    .divLeft, .divRight { width: 50%; }
    .itemList { border: 1px solid #ddd; padding: 20px; border-radius: 16px; background-color: #fafafa; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
    .itemImgDiv img { width: 140px; border-radius: 16px; box-shadow: 0 2px 6px rgba(0,0,0,0.1); }
    .itemInfoTitle, .itemInfoPrice { display: flex; align-items: center; gap: 10px; margin-top: 15px; font-size: 16px; }
    .infoTitle { width: 80px; font-weight: bold; color: #555; }
    .infoInput input, .infoInput select { width: 100%; padding: 6px 10px; border: 1px solid #ccc; border-radius: 8px; }
    table { width: 100%; margin-top: 20px; font-size: 15px; }
    .cost { text-align: right; }
    .orderBtnDiv { text-align: center; margin-top: 25px; }
    .orderBtn { padding: 12px 40px; font-size: 17px; background-color: #ff69b4; color: white; border: none; border-radius: 8px; cursor: pointer; }
    .checkBox2 { margin-top: 15px; font-size: 14px; color: #555; }
  </style>
</head>
<body>
  <c:import url="/common/header.jsp" />

  <main class="container" style="min-height:600px; padding:60px 20px;">
    <h2 style="font-size:28px; font-weight:bold; margin-bottom:20px;">주문하기</h2>
    <form action="order_confirm.jsp" method="POST">
      <div class="orderDiv">
        <div class="divLeft">
          <h4>주문상품</h4>
          <div class="itemList">
            <% for (OrderItemDTO item : orderList) {
                 ProductDTO p = ProductDAO.getInstance().selectProductById(item.getProductId());
                 request.setAttribute("productImage", p.getThumbnailImg());

                 int itemTotal = item.getUnitPrice() * item.getQuantity();
                 totalPrice += itemTotal;
            %>
              <div class="singleItemDiv" style="margin-bottom: 30px;">
                <div class="itemImgDiv">
                  <img src="<c:url value='/admin/common/upload/${productImage}' />" />
                </div>
                <div class="itemInfoTitle">
                  <div><%= p.getName() %></div>
                  <div>수량:</div>
                  <div><%= item.getQuantity() %>개</div>
                </div>
                <div class="itemInfoPrice">
                  <div><fmt:formatNumber value="<%= item.getUnitPrice() %>" pattern="###,###" />원 × <%= item.getQuantity() %> =</div>
                  <div><b><fmt:formatNumber value="<%= itemTotal %>" pattern="###,###" />원</b></div>
                </div>
              </div>
            <% } %>
          </div>
        </div>

        <div class="divRight">
          <h4>주문자 정보</h4>

          <div class="form-check mb-3 text-end" style="font-weight:bold;">
            <label class="form-check-label" for="sameAsUserInfo" style="cursor:pointer;">
              <input class="form-check-input me-1" type="checkbox" id="sameAsUserInfo" style="cursor:pointer;">
              회원정보와 동일
            </label>
          </div>

          <div class="orderInfo">
            <div class="infoTitle">수취인</div>
            <div class="infoInput"><input type="text" name="name" id="nameInput" required></div>

            <div class="infoTitle">전화번호</div>
            <div class="infoInput"><input type="text" name="phone" id="phoneInput" required></div>

            <div class="infoTitle">이메일</div>
            <div class="infoInput"><input type="email" name="email" id="emailInput" required></div>

            <div class="infoTitle">우편번호</div>
            <div class="infoInput">
              <input type="text" name="zipCode" id="zipcode" readonly style="width:120px;">
              <button type="button" onclick="findZipcode()" class="btn btn-outline-secondary btn-sm">주소 검색</button>
            </div>

            <div class="infoTitle">주소</div>
            <div class="infoInput">
              <input type="text" name="addr1" id="addr" required placeholder="도로명 주소"><br>
              <input type="text" name="addr2" id="addr2" placeholder="상세 주소">
            </div>

            <div class="infoTitle">배송메모</div>
            <div class="infoInput">
              <select name="memoSelect" id="memoSelect" onchange="toggleMemoInput()">
                <option value="">선택하세요</option>
                <option value="부재 시 경비실에 맡겨주세요">부재 시 경비실에 맡겨주세요</option>
                <option value="문 앞에 놓아주세요">문 앞에 놓아주세요</option>
                <option value="배송 전 연락주세요">배송 전 연락주세요</option>
                <option value="직접입력">직접입력</option>
              </select>
              <input type="text" name="memo" id="memoInput" placeholder="요청사항 직접입력" style="margin-top:8px; display:none;">
            </div>
          </div>

          <table>
            <tr><td>상품금액</td><td class="cost"><fmt:formatNumber value="<%= totalPrice %>" pattern="###,###" /> 원</td></tr>
            <tr><td>배송비</td><td class="cost">+ <fmt:formatNumber value="<%= deliveryCost %>" pattern="###,###" /> 원</td></tr>
            <tr><td colspan="2"><hr></td></tr>
            <tr><td><b>총 주문금액</b></td><td class="cost"><b><fmt:formatNumber value="<%= totalPrice + deliveryCost %>" pattern="###,###" /> 원</b></td></tr>
          </table>

          <div class="checkBox2">
            <input type="checkbox" required> 구매조건 확인 및 결제진행에 동의합니다.
          </div>

          <input type="hidden" name="totalCost" value="<%= totalPrice + deliveryCost %>" />
          <input type="hidden" name="userId" value="<%= userId %>" />
          <input type="hidden" name="cartId" value="<%= cartId %>" />

          <div class="orderBtnDiv">
            <input type="submit" value="결제하기" class="orderBtn" />
          </div>
        </div>
      </div>
    </form>
  </main>

  <c:import url="/common/footer.jsp" />

  <!-- 회원정보 히든 입력 -->
  <input type="hidden" id="hiddenName" value="<%= user.getName() %>">
  <input type="hidden" id="hiddenPhone" value="<%= user.getPhone() %>">
  <input type="hidden" id="hiddenEmail" value="<%= user.getEmail() %>">
  <input type="hidden" id="hiddenZipcode" value="<%= user.getZipcode() %>">
  <input type="hidden" id="hiddenAddr1" value="<%= user.getAddress1() %>">
  <input type="hidden" id="hiddenAddr2" value="<%= user.getAddress2() %>">

  <script>
    function findZipcode() {
      new daum.Postcode({
        oncomplete: function(data) {
          $('#zipcode').val(data.zonecode);
          $('#addr').val(data.roadAddress);
          $('#addr2').focus();
        }
      }).open();
    }

    $(function () {
      $('#sameAsUserInfo').on('change', function () {
        if (this.checked) {
          $('#nameInput').val($('#hiddenName').val());
          $('#phoneInput').val($('#hiddenPhone').val());
          $('#emailInput').val($('#hiddenEmail').val());
          $('#zipcode').val($('#hiddenZipcode').val());
          $('#addr').val($('#hiddenAddr1').val());
          $('#addr2').val($('#hiddenAddr2').val());
        } else {
          $('#nameInput, #phoneInput, #emailInput, #zipcode, #addr, #addr2').val('');
        }
      });
    });

    function toggleMemoInput() {
      const selected = document.getElementById("memoSelect").value;
      const input = document.getElementById("memoInput");
      if (selected === "직접입력") {
        input.style.display = "block";
        input.value = "";
      } else {
        input.style.display = "none";
        input.value = selected;
      }
    }
  </script>
</body>
</html>
