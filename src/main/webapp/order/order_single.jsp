<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="order.OrderService, order.SingleOrderDTO" %>
<%@ page import="user.UserService, user.UserDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/common/login_chk.jsp" %>

<jsp:useBean id="userService" class="user.UserService" />
<%
    request.setCharacterEncoding("UTF-8");

    int productId = Integer.parseInt(request.getParameter("productId"));
    int qty = Integer.parseInt(request.getParameter("qty"));
    int userId = (Integer) session.getAttribute("userId");

    OrderService os = new OrderService();
    SingleOrderDTO soDTO = os.getSingleOrder(productId);

    int deliveryCost = 3000;
    int itemPrice = soDTO.getPrice();
    int itemTotal = itemPrice * qty;
    int totalCost = itemTotal + deliveryCost;

    UserDTO loginUser = userService.getUserById(userId);

    request.setAttribute("productId", productId);
    request.setAttribute("orderedItemName", soDTO.getName());
    request.setAttribute("orderedItemPrice", itemPrice);
    request.setAttribute("orderedItemImg", soDTO.getThumbnailImg());
    request.setAttribute("singleOrderQty", qty);
    request.setAttribute("deliveryCost", deliveryCost);
    request.setAttribute("currentTotalPrice", itemTotal);
    request.setAttribute("totalCost", totalCost);
    request.setAttribute("loginUser", loginUser);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>주문하기 | Donutted</title>
  <c:import url="/common/external_file.jsp" />
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  <style>
    /* ==== 공통 레이아웃 ==== */
    .main-container {
      max-width: 1400px;
      margin: 0 auto;
      padding: 40px 20px;
      min-height: 100vh;
    }
    .page-title {
      font-size: 32px;
      font-weight: 700;
      color: #2c3e50;
      margin-bottom: 40px;
      text-align: center;
    }
    .order-layout {
      display: grid;
      grid-template-columns: 1fr 450px;
      gap: 40px;
      align-items: start;
    }

    /* ==== 왼쪽: 상품 리스트 ==== */
    .order-items-section {
      background: white;
      border-radius: 20px;
      padding: 32px;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
      border: 1px solid #e9ecef;
    }
    .section-title {
      font-size: 24px;
      font-weight: 700;
      color: #2c3e50;
      margin-bottom: 24px;
      padding-bottom: 12px;
      border-bottom: 3px solid #ff69b4;
      display: inline-block;
    }
    .item-card {
      background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);
      border-radius: 16px;
      padding: 24px;
      margin-bottom: 20px;
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
      border: 1px solid #e9ecef;
      transition: all 0.3s ease;
    }
    .item-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
    }
    .item-content {
      display: flex;
      gap: 20px;
      align-items: center;
    }
    .item-image {
      width: 120px;
      height: 120px;
      border-radius: 12px;
      object-fit: cover;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }
    .item-details {
      flex: 1;
    }
    .item-name {
      font-size: 20px;
      font-weight: 700;
      color: #2c3e50;
      margin-bottom: 8px;
    }
    .item-quantity {
      font-size: 16px;
      color: #6c757d;
      margin-bottom: 12px;
    }
    .item-quantity .qty-number {
      font-weight: 600;
      color: #ff69b4;
      margin-left: 8px;
    }
    .item-price-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 18px;
    }
    .price-calculation {
      color: #6c757d;
    }
    .price-total {
      font-weight: 700;
      color: #ff69b4;
      font-size: 20px;
    }

    /* ==== 오른쪽: 주문자 정보 ==== */
    .order-form-section {
      background: white;
      border-radius: 20px;
      padding: 32px;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
      border: 1px solid #e9ecef;
      position: sticky;
      top: 40px;
      max-height: calc(100vh - 80px);
      overflow-y: auto;
    }
    .same-info-checkbox {
      text-align: right;
      margin-bottom: 24px;
    }
    .same-info-checkbox label {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      font-weight: 600;
      color: #495057;
      cursor: pointer;
      padding: 8px 12px;
      border-radius: 8px;
      transition: background-color 0.2s;
    }
    .same-info-checkbox label:hover {
      background-color: #f8f9fa;
    }
    .same-info-checkbox input[type="checkbox"] {
      width: 18px;
      height: 18px;
      accent-color: #ff69b4;
    }
    .form-group {
      margin-bottom: 20px;
    }
    .form-label {
      display: block;
      font-weight: 600;
      color: #495057;
      margin-bottom: 8px;
      font-size: 14px;
    }
    .form-input {
      width: 100%;
      padding: 12px 16px;
      border: 2px solid #e9ecef;
      border-radius: 12px;
      font-size: 16px;
      transition: all 0.3s ease;
      background-color: #fff;
    }
    .form-input:focus {
      outline: none;
      border-color: #ff69b4;
      box-shadow: 0 0 0 3px rgba(255, 105, 180, 0.1);
    }
    .address-row {
      display: flex;
      gap: 12px;
      align-items: end;
    }
    .zipcode-input {
      flex: 0 0 140px;
    }
    .address-search-btn {
      padding: 12px 20px;
      background: linear-gradient(135deg, #ff69b4 0%, #ff1493 100%);
      color: white;
      border: none;
      border-radius: 12px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      white-space: nowrap;
    }
    .address-search-btn:hover {
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(255, 105, 180, 0.3);
    }
    .address-detail {
      margin-top: 8px;
    }
    .memo-select {
      width: 100%;
      padding: 12px 16px;
      border: 2px solid #e9ecef;
      border-radius: 12px;
      font-size: 16px;
      background-color: white;
      cursor: pointer;
    }
    .memo-input {
      margin-top: 8px;
      display: none;
    }

    /* ==== 주문 요약 ==== */
    .order-summary {
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      border-radius: 16px;
      padding: 24px;
      margin: 32px 0;
    }
    .summary-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 12px 0;
      font-size: 16px;
    }
    .summary-row:not(:last-child) {
      border-bottom: 1px solid #dee2e6;
    }
    .summary-label {
      color: #495057;
    }
    .summary-value {
      font-weight: 600;
      color: #2c3e50;
    }
    .summary-total {
      font-size: 20px;
      font-weight: 700;
      color: #ff69b4;
    }
    .summary-total .summary-label {
      color: #2c3e50;
    }

    /* ==== 동의 & 결제 버튼 ==== */
    .agreement-section {
      margin: 24px 0;
      text-align: center;
    }
    .agreement-checkbox {
      display: inline-flex;
      align-items: center;
      gap: 12px;
      font-size: 16px;
      color: #495057;
      cursor: pointer;
      padding: 16px 20px;
      border-radius: 12px;
      background-color: #f8f9fa;
      transition: background-color 0.2s;
    }
    .agreement-checkbox:hover {
      background-color: #e9ecef;
    }
    .agreement-checkbox input[type="checkbox"] {
      width: 20px;
      height: 20px;
      accent-color: #ff69b4;
    }
    .payment-button {
      width: 100%;
      padding: 20px;
      background: linear-gradient(135deg, #ff69b4 0%, #ff1493 100%);
      color: white;
      border: none;
      border-radius: 16px;
      font-size: 20px;
      font-weight: 700;
      cursor: pointer;
      transition: all 0.3s ease;
      box-shadow: 0 4px 16px rgba(255, 105, 180, 0.3);
    }
    .payment-button:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(255, 105, 180, 0.4);
    }
    .payment-button:active {
      transform: translateY(0);
    }

    /* ==== 반응형 ==== */
    @media (max-width: 1200px) {
      .order-layout {
        grid-template-columns: 1fr;
        gap: 32px;
      }
      .order-form-section {
        position: static;
        max-height: none;
      }
    }
    @media (max-width: 768px) {
      .main-container {
        padding: 20px 16px;
      }
      .order-items-section,
      .order-form-section {
        padding: 24px;
      }
      .item-content {
        flex-direction: column;
        text-align: center;
      }
      .item-image {
        width: 100px;
        height: 100px;
      }
      .address-row {
        flex-direction: column;
      }
      .zipcode-input {
        flex: 1;
      }
    }
  </style>
</head>
<body>
  <c:import url="/common/header.jsp" />

  <div class="main-container">
    <h1 class="page-title">주문하기</h1>

    <form action="order_confirm.jsp" method="POST">
      <div class="order-layout">

        <!-- 주문 상품 섹션 -->
        <div class="order-items-section">
          <h2 class="section-title">주문상품</h2>
          <div class="item-card">
            <div class="item-content">
              <img src="<c:url value='/admin/common/images/products/${orderedItemImg}'/>"
                   alt="${orderedItemName}" class="item-image" />
              <div class="item-details">
                <div class="item-name">${orderedItemName}</div>
                <div class="item-quantity">
                  수량: <span class="qty-number">${singleOrderQty}개</span>
                </div>
                <div class="item-price-row">
                  <span class="price-calculation">
                    <fmt:formatNumber value="${orderedItemPrice}" pattern="###,###"/>원 × ${singleOrderQty}
                  </span>
                  <span class="price-total">
                    <fmt:formatNumber value="${currentTotalPrice}" pattern="###,###"/>원
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 주문자 정보 섹션 -->
        <div class="order-form-section">
          <h2 class="section-title">주문자 정보</h2>

          <div class="same-info-checkbox">
            <label for="sameAsUserInfo">
              <input type="checkbox" id="sameAsUserInfo">
              회원정보와 동일
            </label>
          </div>

          <div class="form-group">
            <label class="form-label">수취인</label>
            <input type="text" name="name" id="nameInput" class="form-input" required>
          </div>
          <div class="form-group">
            <label class="form-label">전화번호</label>
            <input type="tel" name="phone" id="phoneInput" class="form-input" required>
          </div>
          <div class="form-group">
            <label class="form-label">이메일</label>
            <input type="email" name="email" id="emailInput" class="form-input" required>
          </div>
          <div class="form-group">
            <label class="form-label">우편번호</label>
            <div class="address-row">
              <input type="text" name="zipCode" id="zipcode" class="form-input zipcode-input" readonly>
              <button type="button" onclick="findZipcode()" class="address-search-btn">주소 검색</button>
            </div>
          </div>
          <div class="form-group">
            <label class="form-label">주소</label>
            <input type="text" name="addr1" id="addr" class="form-input" placeholder="도로명 주소" required>
            <input type="text" name="addr2" id="addr2" class="form-input address-detail" placeholder="상세 주소">
          </div>
          <div class="form-group">
            <label class="form-label">배송 메모</label>
            <select name="memoSelect" id="memoSelect" class="memo-select" onchange="toggleMemoInput()">
              <option value="">선택하세요</option>
              <option value="부재 시 경비실에 맡겨주세요">부재 시 경비실에 맡겨주세요</option>
              <option value="문 앞에 놓아주세요">문 앞에 놓아주세요</option>
              <option value="배송 전 연락주세요">배송 전 연락주세요</option>
              <option value="직접입력">직접입력</option>
            </select>
            <input type="text" name="memo" id="memoInput" class="memo-input" placeholder="요청사항 직접입력">
          </div>

          <!-- 주문 요약 -->
          <div class="order-summary">
            <div class="summary-row">
              <span class="summary-label">상품금액</span>
              <span class="summary-value">
                <fmt:formatNumber value="${currentTotalPrice}" pattern="###,###"/> 원
              </span>
            </div>
            <div class="summary-row">
              <span class="summary-label">배송비</span>
              <span class="summary-value">
                + <fmt:formatNumber value="${deliveryCost}" pattern="###,###"/> 원
              </span>
            </div>
            <div class="summary-row summary-total">
              <span class="summary-label">총 주문금액</span>
              <span class="summary-value">
                <fmt:formatNumber value="${totalCost}" pattern="###,###"/> 원
              </span>
            </div>
          </div>

          <!-- 동의 체크박스 -->
          <div class="agreement-section">
            <label class="agreement-checkbox">
              <input type="checkbox" required>
              구매조건 확인 및 결제진행에 동의합니다.
            </label>
          </div>

          <!-- 히든 필드 -->
          <input type="hidden" name="productId" value="${productId}" />
          <input type="hidden" name="productName" value="${orderedItemName}" />
          <input type="hidden" name="unitPrice" value="${orderedItemPrice}" />
          <input type="hidden" name="quantity" value="${singleOrderQty}" />
          <input type="hidden" name="totalCost" value="${totalCost}" />
          <input type="hidden" name="userId" value="${loginUser.userId}" />

          <!-- 결제 버튼 -->
          <div class="orderBtnDiv">
            <input type="submit" class="payment-button" value="결제하기" />
          </div>
        </div>
      </div>
    </form>
  </div>

  <c:import url="/common/footer.jsp" />

  <!-- 회원정보 자동입력을 위한 히든 필드 -->
  <input type="hidden" id="hiddenName" value="${loginUser.name}">
  <input type="hidden" id="hiddenPhone" value="${loginUser.phone}">
  <input type="hidden" id="hiddenEmail" value="${loginUser.email}">
  <input type="hidden" id="hiddenZipcode" value="${loginUser.zipcode}">
  <input type="hidden" id="hiddenAddr1" value="${loginUser.address1}">
  <input type="hidden" id="hiddenAddr2" value="${loginUser.address2}">

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
