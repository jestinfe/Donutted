<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="order.*, util.RangeDTO, java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
  request.setCharacterEncoding("UTF-8");

  String userIdStr = request.getParameter("userId");
  String pageStr = request.getParameter("page");
  String limitStr = request.getParameter("limit");

  if (userIdStr == null || pageStr == null || limitStr == null) return;

  int userId = Integer.parseInt(userIdStr);
  int pageNum = Integer.parseInt(pageStr);
  int limit = Integer.parseInt(limitStr);
  int start = (pageNum - 1) * limit + 1;
  int end = pageNum * limit;

  RangeDTO range = new RangeDTO(start, end);
  OrderService service = new OrderService();
  List<OrderDTO> orders = service.getOrdersByUserWithRange(userId, range);
  request.setAttribute("orders", orders);
%>
<c:forEach var="order" items="${orders}">
  <div class="order-box">
    <div class="order-date">
      <fmt:formatDate value="${order.orderDate}" pattern="yyyy.MM.dd HH:mm" />
      주문번호: ${order.orderId}
    </div>

    <div class="order-status-bar">
      <span class="${order.orderStatus eq 'O1' ? 'active' : ''}">주문완료</span>
      <span class="${order.orderStatus eq 'O2' ? 'active' : ''}">배송 준비 중</span>
      <span class="${order.orderStatus eq 'O3' ? 'active' : ''}">배송 중</span>
      <span class="${order.orderStatus eq 'O4' ? 'active' : ''}">배송 완료</span>
      <span class="${order.orderStatus eq 'O0' ? 'active text-danger' : ''}">주문취소</span>
    </div>

    <div class="product-list">
      <c:forEach var="item" items="${order.items}">
        <div class="product-item">
          <img src="<c:url value='/admin/common/upload/${item.thumbnailUrl}' />" alt="상품 이미지" />
          <div>${item.productName}</div>
        </div>
      </c:forEach>
    </div>

    <div class="text-end">
      <c:if test="${not empty order.items and order.orderStatus eq 'O4'}">
        <a href="write_review.jsp?order_id=${order.orderId}" class="btn-review">리뷰작성</a>
        <a href="refund_items.jsp?order_id=${order.orderId}" class="btn-refund">환불요청</a>
      </c:if>

      <c:if test="${order.orderStatus == 'O1' || order.orderStatus == 'O2' || order.orderStatus == 'O3'}">
        <a href="cancel_order.jsp?order_id=${order.orderId}" class="btn-refund"
           onclick="return confirm('정말 주문을 취소하시겠습니까?');">
           주문취소
        </a>
      </c:if>

      <c:if test="${order.orderStatus == 'O0'}">
        <span class="text-danger">이 주문은 취소된 주문입니다.</span>
      </c:if>
    </div>
  </div>
</c:forEach>
