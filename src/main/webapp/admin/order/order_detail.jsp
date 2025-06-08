<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="order.OrderService, order.OrderDTO, order.OrderItemDTO" %>
<%@ page import="util.CryptoUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>
<head>
  <title>주문관리 - 상세조회</title>
</head>
<%
    String orderIdParam = request.getParameter("order_id");
    int orderId = 0;
    try {
        orderId = Integer.parseInt(orderIdParam);
    } catch (Exception e) {
        response.sendRedirect("order_list.jsp");
        return;
    }

    OrderService orderService = new OrderService();
    OrderDTO order = orderService.getOrder(orderId);
    if (order == null) {
        response.sendRedirect("order_list.jsp");
        return;
    }
    List<OrderItemDTO> items = orderService.getOrderItems(orderId);
    request.setAttribute("order", order);
    request.setAttribute("items", items);

    String encName = order.getUserName();
    String decName = "";
    try {
        if (encName != null) {
            decName = CryptoUtil.decrypt(encName);
        }
    } catch (Exception e) {
        decName = "[복호화 오류]";
        e.printStackTrace();
    }
%>

<div class="main container py-4">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h3>🧾 주문 상세</h3>
    <a href="order_list.jsp" class="btn btn-outline-secondary">← 목록으로 돌아가기</a>
  </div>

  <!-- 주문 기본 정보 -->
  <div class="mb-4 p-3 border rounded bg-light">
    <h5 class="mb-3">주문 정보</h5>
    <p><strong>주문 ID:</strong> ${order.orderId}</p>
    <p><strong>회원 ID:</strong> ${order.userId} (<%= decName %>)</p>
    <p><strong>주문일시:</strong> <fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd HH:mm:ss" /></p>
  </div>

  <!-- 상품 목록 -->
  <div class="mb-4">
    <h5>📦 상품 목록</h5>
    <table class="table table-bordered mt-2">
      <thead class="table-light">
        <tr>
          <th>번호</th>
          <th>주문상품ID</th>
          <th>상품명</th>
          <th>수량</th>
          <th>단가</th>
          <th>합계</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="item" items="${items}" varStatus="sts">
          <tr>
            <td>${sts.index + 1}</td>
            <td>${item.orderItemId}</td>
            <td>${fn:escapeXml(item.productName)}</td>
            <td>${item.quantity}개</td>
            <td><fmt:formatNumber value="${item.unitPrice}" pattern="#,###" />원</td>
            <td><fmt:formatNumber value="${item.quantity * item.unitPrice}" pattern="#,###" />원</td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>

  <!-- 배송 정보 -->
  <div class="mb-4 p-3 border rounded">
    <h5 class="mb-3">🚚 배송 정보</h5>
    <p><strong>수령인:</strong> ${fn:escapeXml(order.receiverName)}</p>
    <p><strong>연락처:</strong> ${fn:escapeXml(order.receiverPhone)}</p>
    <p><strong>이메일:</strong> ${fn:escapeXml(order.receiverEmail)}</p>
    <p><strong>우편번호:</strong> ${fn:escapeXml(order.receiverZip)}</p>
    <p><strong>주소:</strong> ${fn:escapeXml(order.receiverAddress1)} ${fn:escapeXml(order.receiverAddress2)}</p>
    <p><strong>총 결제금액 (배송비 포함):</strong> <fmt:formatNumber value="${order.totalPrice}" pattern="#,###" />원</p>
  </div>

  <!-- 주문 상태 -->
  <div class="mb-4">
    <h5>📌 주문 상태</h5>
    <p>
      <c:choose>
        <c:when test="${order.orderStatus == 'O0'}"><span class="text-danger fw-bold">주문취소됨 (O0)</span></c:when>
        <c:when test="${order.orderStatus == 'O1'}">결제 완료 (O1)</c:when>
        <c:when test="${order.orderStatus == 'O2'}">배송 준비중 (O2)</c:when>
        <c:when test="${order.orderStatus == 'O3'}">배송 중 (O3)</c:when>
        <c:when test="${order.orderStatus == 'O4'}">배송 완료 (O4)</c:when>
        <c:otherwise>${order.orderStatus}</c:otherwise>
      </c:choose>
    </p>
  </div>

  <!-- 배송 상태 변경 -->
  <div class="mb-5">
    <h5>📦 배송 상태 변경</h5>

    <c:if test="${order.orderStatus == 'O0'}">
      <div class="alert alert-warning">주문이 취소된 상태입니다. 배송 상태를 변경할 수 없습니다.</div>
    </c:if>

    <c:if test="${order.orderStatus != 'O0'}">
      <form method="post" action="order_detail.jsp?order_id=${order.orderId}">
        <div class="row g-2 align-items-center">
          <div class="col-md-3">
            <select name="newStatus" class="form-select">
             <option value="O1" ${order.orderStatus == 'O1' ? 'selected' : ''}
  <c:if test="${order.orderStatus > 'O1'}">style="display:none"</c:if>>
  결제 완료 (O1)
</option>
<option value="O2" ${order.orderStatus == 'O2' ? 'selected' : ''}
  <c:if test="${order.orderStatus > 'O2'}">style="display:none"</c:if>>
  배송 준비중 (O2)
</option>
<option value="O3" ${order.orderStatus == 'O3' ? 'selected' : ''}
  <c:if test="${order.orderStatus > 'O3'}">style="display:none"</c:if>>
  배송 중 (O3)
</option>
<option value="O4" ${order.orderStatus == 'O4' ? 'selected' : ''}>
  배송 완료 (O4)
</option>

            </select>
          </div>
          <div class="col-md-2">
            <button type="submit" class="btn btn-primary">변경</button>
          </div>
        </div>
      </form>

      <c:if test="${not empty param.newStatus}">
        <%
          String newStatus = request.getParameter("newStatus");
          boolean updated = orderService.changeOrderStatus(orderId, newStatus);
          if (updated) {
        %>
          <div class="alert alert-success mt-3">배송 상태가 성공적으로 변경되었습니다.</div>
        <%
            response.sendRedirect("order_detail.jsp?order_id=" + orderId + "&statusUpdate=success");
            return;
          } else {
        %>
          <div class="alert alert-danger mt-3">배송 상태 변경에 실패했습니다. 다시 시도해주세요.</div>
        <%
          }
        %>
      </c:if>
    </c:if>
  </div>

  <!-- 배송 메모 -->
  <div class="mb-4">
    <h5>✏️ 배송 메모</h5>
    <textarea class="form-control" rows="3" readonly>${fn:escapeXml(order.orderMemo)}</textarea>
  </div>
</div>
