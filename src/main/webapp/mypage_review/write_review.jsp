<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="order.OrderService, order.OrderDTO, order.OrderItemDTO, java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>리뷰 작성 - 주문별 상품</title>
    <c:import url="http://localhost/mall_prj/common/external_file.jsp"/>
 
</head>
<body>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/mypage_sidebar.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");
    if (session.getAttribute("userId") == null) {
		out.println("userId가 null임!!");
		return;
    }

    Integer userId = (Integer) session.getAttribute("userId");
    int orderId = Integer.parseInt(request.getParameter("order_id"));

    OrderService service = new OrderService();
    OrderDTO order = service.getReviewableItemsByOrder(userId, orderId);

    request.setAttribute("order", order);
%>

<div class="container" style="margin-left: 260px; max-width: 700px;">
    <h3 class="mb-4 mt-5">| 리뷰 작성 - 주문별 상품</h3>
    
    <c:if test="${empty order.items}">
      <script>
        alert("작성 가능한 리뷰가 없습니다. 메뉴 페이지로 이동합니다.");
        location.href = "my_orders.jsp";
      </script>
    </c:if>

    <c:choose>
        <c:when test="${empty order.items}">
            <p>작성 가능한 리뷰가 없습니다.</p>
        </c:when>
        <c:otherwise>
            <c:forEach var="item" items="${order.items}">
                <div class="border p-3 mb-4 rounded shadow-sm d-flex align-items-center">
                    <img src="/mall_prj/admin/common/upload/${item.thumbnailUrl}" alt="상품 이미지"
                         style="width:120px; height:120px; object-fit:cover; border-radius:8px; margin-right:20px;">
                    <div>
                        <h5>${item.productName}</h5>
                        <button type="button" class="btn btn-sm btn-primary"
                                onclick="openReviewPopup(${item.orderItemId});">
                            리뷰 작성
                        </button>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<script>
    function openReviewPopup(orderItemId) {
        const url = "write_review_form.jsp?order_item_id=" + orderItemId;
        const options = "width=600,height=500,scrollbars=yes,resizable=no";
        window.open(url, "리뷰작성", options);
    }
</script>
</body>
<%@ include file="../common/footer.jsp" %>
