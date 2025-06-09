<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/common/external_file.jsp" %>
<%@ include file="/common/header.jsp" %>
<%@ include file="/common/login_chk.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("userId");
    String name = request.getParameter("name");
    String phone = request.getParameter("phone");
    String email = request.getParameter("email");
    String zipCode = request.getParameter("zipCode");
    String addr1 = request.getParameter("addr1");
    String addr2 = request.getParameter("addr2");
    String memo = request.getParameter("memo");
    String totalCost = request.getParameter("totalCost");

    String productId = request.getParameter("productId");
    String productName = request.getParameter("productName");
    String unitPrice = request.getParameter("unitPrice");
    String quantity = request.getParameter("quantity");

    String cartId = request.getParameter("cartId");
    String[] selectedIds = request.getParameterValues("selectedProductIds");
%>

<title>주문 확인 | Donutted</title>
<div class="container mt-5 mb-5">
  <h2 class="mb-4 fw-bold">📝 주문 확인</h2>
  <p class="text-muted">아래 정보로 주문을 진행합니다. 확인 후 결제 버튼을 눌러주세요.</p>

  <!-- 수령자 정보 -->
  <div class="card p-4 shadow-sm mb-4">
    <h5 class="fw-bold mb-3">📦 수령자 정보</h5>
    <ul class="list-group list-group-flush">
      <li class="list-group-item"><b>수취인:</b> <%= name %></li>
      <li class="list-group-item"><b>전화번호:</b> <%= phone %></li>
      <li class="list-group-item"><b>이메일:</b> <%= email %></li>
      <li class="list-group-item"><b>주소:</b> [<%= zipCode %>] <%= addr1 %> <%= addr2 %></li>
      <li class="list-group-item"><b>배송메모:</b> <%= memo %></li>
    </ul>
  </div>

  <!-- 주문 내역 -->
  <div class="card p-4 shadow-sm mb-4">
    <h5 class="fw-bold mb-3">🛒 주문 내역</h5>

    <% if (productId != null) { %>
      <!-- 단일 상품 주문 -->
      <ul class="list-group list-group-flush">
        <li class="list-group-item"><b>상품명:</b> <%= productName %></li>
        <li class="list-group-item"><b>수량:</b> <%= quantity %>개</li>
        <li class="list-group-item"><b>단가:</b> <fmt:formatNumber value="<%= Integer.parseInt(unitPrice) %>" type="number" /> 원</li>
      </ul>
    <% } else if (selectedIds != null && selectedIds.length > 0 && cartId != null) {
        cart.CartService cs = new cart.CartService();
        java.util.List<cart.CartItemDTO> allItems = cs.showAllCartItem(Integer.parseInt(userId));
        java.util.Set<Integer> selectedSet = new java.util.HashSet<>();
        for (String id : selectedIds) selectedSet.add(Integer.parseInt(id));
    %>
    <div class="d-flex flex-column gap-3">
      <% for (cart.CartItemDTO item : allItems) {
           if (!selectedSet.contains(item.getProductId())) continue; %>
        <div class="card p-3 bg-light border">
          <p class="mb-2"><b>상품명:</b> <%= item.getProductName() %></p>
          <p class="mb-2"><b>수량:</b> <%= item.getQuantity() %>개</p>
          <p class="mb-0"><b>단가:</b> <fmt:formatNumber value="<%= item.getPrice() %>" type="number" /> 원</p>
        </div>
      <% } %>
    </div>
    <% } %>
  </div>

  <!-- 결제 금액 -->
  <div class="card p-4 shadow-sm mb-4">
    <h5 class="fw-bold mb-3">💰 결제 금액</h5>
    <p class="fs-5 fw-bold text-end"><fmt:formatNumber value="<%= Integer.parseInt(totalCost) %>" type="number" /> 원</p>
  </div>

  <!-- 주문 확인 폼 -->
  <form action="order_process.jsp" method="post" class="text-center">
    <!-- 공통 정보 -->
    <input type="hidden" name="userId" value="<%= userId %>"/>
    <input type="hidden" name="name" value="<%= name %>"/>
    <input type="hidden" name="phone" value="<%= phone %>"/>
    <input type="hidden" name="email" value="<%= email %>"/>
    <input type="hidden" name="zipCode" value="<%= zipCode %>"/>
    <input type="hidden" name="addr1" value="<%= addr1 %>"/>
    <input type="hidden" name="addr2" value="<%= addr2 %>"/>
    <input type="hidden" name="memo" value="<%= memo %>"/>
    <input type="hidden" name="totalCost" value="<%= totalCost %>"/>

    <% if (productId != null) { %>
      <input type="hidden" name="productId" value="<%= productId %>"/>
      <input type="hidden" name="productName" value="<%= productName %>"/>
      <input type="hidden" name="unitPrice" value="<%= unitPrice %>"/>
      <input type="hidden" name="quantity" value="<%= quantity %>"/>
    <% } else if (selectedIds != null && selectedIds.length > 0 && cartId != null) { %>
      <input type="hidden" name="cartId" value="<%= cartId %>"/>
      <% for (String id : selectedIds) { %>
        <input type="hidden" name="selectedProductIds" value="<%= id %>"/>
      <% } %>
    <% } %>

    <div class="alert alert-warning mt-4 text-start" role="alert" style="font-size:15px;">
      ⚠️ <strong>주문 전 반드시 확인해주세요</strong><br>
      · 본 상품은 <strong>식품</strong>으로, 단순 변심에 의한 <u>반품/환불이 제한</u>될 수 있습니다.<br>
      · <strong>배송 완료 전까지는 주문 취소</strong>가 가능하며, <strong>배송 완료 후에는 환불 요청</strong>으로 처리됩니다.<br>
      · <strong>리뷰 작성</strong>은 배송 완료 후에 가능합니다.<br>
      · 수취인 정보 및 배송지를 <u>정확히 입력</u>해 주세요. 배송 오류에 대한 책임은 고객에게 있을 수 있습니다.
    </div>

    <button type="submit" class="btn btn-primary btn-lg me-3">✅ 결제하기</button>
    <button type="button" onclick="history.back()" class="btn btn-outline-secondary btn-lg">↩ 돌아가기</button>
  </form>
</div>

<%@ include file="/common/footer.jsp" %>
