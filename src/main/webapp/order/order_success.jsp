<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ page import="order.OrderService, order.OrderDTO, order.OrderItemDTO" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/common/login_chk.jsp" %>

<%
  session.removeAttribute("alreadyOrdered");

  Integer userId = (Integer) session.getAttribute("userId");

  OrderService service = new OrderService();

  // 가장 최근 주문 가져오기
  OrderDTO latestOrder = service.getOrdersByUser(userId).get(0); // 최신 주문이 맨 앞이라는 전제
  int orderId = latestOrder.getOrderId();
  java.util.List<order.OrderItemDTO> itemList = service.getOrderItems(orderId);

  // 총합은 DB에 저장된 값 기준으로 (배송비 포함)
  double totalPriceFromDB = latestOrder.getTotalPrice();   // DB에 저장된 총액 (배송비 포함)
  int deliveryCost = 3000;                              // 정액 배송비
  double productTotal = totalPriceFromDB - deliveryCost;   // 상품 가격 총합
%>
<title>주문 완료 | Donutted</title>
<div class="container mt-5">
  <div class="text-center p-5 bg-light rounded-4 shadow-sm mb-5">
    <h2 class="text-success fw-bold mb-3">🎉 주문이 성공적으로 완료되었습니다!</h2>
    <p>고객님의 주문이 정상적으로 접수되었습니다.<br>아래에서 상세 내역을 확인하세요.</p>
  </div>

  <div class="card shadow-sm p-4 mb-5">
    <h4 class="mb-4">📦 주문 상세 내역</h4>
    <table class="table table-bordered align-middle text-center">
      <thead class="table-light">
        <tr>
          <th>상품명</th>
          <th>수량</th>
          <th>단가</th>
          <th>합계</th>
        </tr>
      </thead>
      <tbody>
        <%
          for (OrderItemDTO item : itemList) {
            int subtotal = item.getQuantity() * item.getUnitPrice();
        %>
        <tr>
          <td><%= item.getProductName() %></td>
          <td><%= item.getQuantity() %></td>
          <td><fmt:formatNumber value="<%= item.getUnitPrice() %>" type="number"/> 원</td>
          <td><fmt:formatNumber value="<%= subtotal %>" type="number"/> 원</td>
        </tr>
        <% } %>
      </tbody>
      <tfoot class="table-light">
        <tr>
          <th colspan="3">상품 총액</th>
          <th><fmt:formatNumber value="<%= productTotal %>" type="number"/> 원</th>
        </tr>
        <tr>
          <th colspan="3">배송비</th>
          <th><fmt:formatNumber value="<%= deliveryCost %>" type="number"/> 원</th>
        </tr>
        <tr>
          <th colspan="3" class="table-success">총 결제 금액</th>
          <th class="table-success">
            <fmt:formatNumber value="<%= totalPriceFromDB %>" type="number"/> 원
          </th>
        </tr>
      </tfoot>
    </table>
  </div>

  <div class="text-center mb-5">
    <a href="../mypage_order/my_orders.jsp" class="btn btn-outline-secondary">내 주문 내역 보기</a>
  </div>
</div>

<%@ include file="../common/footer.jsp" %>
