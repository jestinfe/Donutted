<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="order.*, util.RangeDTO, java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
  request.setCharacterEncoding("UTF-8");

  String userIdStr = request.getParameter("userId");
  String pageStr = request.getParameter("page");
  String limitStr = request.getParameter("limit");

  if (userIdStr == null || pageStr == null || limitStr == null) {
    response.setStatus(400);
    return;
  }

  int userId = Integer.parseInt(userIdStr);
  int pageNum = Integer.parseInt(pageStr);
  int limit = Integer.parseInt(limitStr);
  int start = (pageNum - 1) * limit + 1;
  int end = pageNum * limit;

  RangeDTO range = new RangeDTO(start, end);
  OrderService service = new OrderService();
  List<OrderDTO> orders = service.getOrdersByUserWithRange(userId, range);
  boolean isLastPage = (orders == null || orders.size() < limit);

  request.setAttribute("orders", orders);
  request.setAttribute("pageNum", pageNum);
  request.setAttribute("isLastPage", isLastPage);
%>

  <!-- 첫 페이지에서 아무 주문도 없을 때 -->
<c:choose>
  <c:when test="${empty orders && pageNum == 1}">
    <div class="order-box" style="text-align:center; padding:30px; background:#fffbe6; border-left:5px solid #ffe58f;">
      주문 내역이 없습니다.
    </div>
    <div id="no-more-orders" style="display:none;"></div>
  </c:when>

  <c:when test="${empty orders && pageNum > 1}">
    <div id="no-more-orders" style="display:none;"></div>
  </c:when>

  <c:otherwise>
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
            <div class="product-item" style="width: 110px; text-align: center; font-size: 14px; min-height: 180px; display: flex; flex-direction: column; justify-content: space-between;">
              <img src="<c:url value='/admin/common/images/products/${item.thumbnailUrl}' />" alt="상품 이미지"
                   style="width:100px; height:100px; border-radius:10px; object-fit:cover; box-shadow:0 2px 6px rgba(0,0,0,0.08);" />
              <div>${item.productName}</div>
              <div style="margin-top: 8px; min-height: 30px;">
                <c:choose>
                  <c:when test="${item.reviewed}">
                    <span class="text-success small">작성 완료</span>
                  </c:when>
                  <c:when test="${order.orderStatus eq 'O4'}">
                    <a href="javascript:void(0);"
                       onclick="window.open('../mypage_review/write_review_form.jsp?order_item_id=${item.orderItemId}',
                       'reviewPopup', 'width=600,height=700,scrollbars=yes');"
                       class="btn-review btn-sm">리뷰 작성</a>
                  </c:when>
                </c:choose>
              </div>
            </div>
          </c:forEach>
        </div>

        <div class="text-end">
          <c:if test="${order.orderStatus eq 'O4'}">
            <form method="post" action="../mypage_refund/refund_items.jsp" style="display:inline;">
              <input type="hidden" name="order_id" value="${order.orderId}" />
              <button type="submit" class="btn-refund">환불요청</button>
            </form>
          </c:if>

          <c:if test="${order.orderStatus == 'O1' || order.orderStatus == 'O2' || order.orderStatus == 'O3'}">
            <form method="post" action="cancel_order.jsp" style="display:inline;">
              <input type="hidden" name="order_id" value="${order.orderId}" />
              <button type="submit" class="btn-refund"
                      onclick="return confirm('정말 주문을 취소하시겠습니까?');">
                주문취소
              </button>
            </form>
          </c:if>

          <c:if test="${order.orderStatus == 'O0'}">
            <span class="text-danger">이 주문은 취소된 주문입니다.</span>
          </c:if>
        </div>
      </div>
    </c:forEach>

    <c:if test="${isLastPage}">
      <div id="no-more-orders" style="display:none;"></div>
    </c:if>
  </c:otherwise>
</c:choose>
