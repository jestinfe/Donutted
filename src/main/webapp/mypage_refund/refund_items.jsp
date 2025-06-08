<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="order.OrderItemDTO, order.OrderService, java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/common/login_chk.jsp" %>

<link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>

<%
request.setCharacterEncoding("UTF-8");

Integer userId = (Integer) session.getAttribute("userId");

String orderIdStr = request.getParameter("order_id");
if (orderIdStr == null) {
    out.print("<script>alert('잘못된 접근입니다.'); history.back();</script>");
    return;
}

int orderId = Integer.parseInt(orderIdStr);
OrderService service = new OrderService();

// ✅ 주문 소유자 확인
if (!service.isOrderOwnedByUser(orderId, userId)) {
    out.print("<script>alert('권한이 없습니다.'); history.back();</script>");
    return;
}

List<OrderItemDTO> refundables = service.getRefundableItemsByOrderId(orderId);
request.setAttribute("refundables", refundables);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>환불 상품 선택 | Donutted</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Pretendard&display=swap" rel="stylesheet">
  <style>
    body {
      font-family: 'Pretendard', sans-serif;
      background: #fffefc;
      margin: 0;
    }

    .content-wrapper {
      margin-left: 240px;
      padding: 40px 20px;
      display: flex;
      justify-content: center;
    }

    .refund-container {
      width: 100%;
      max-width: 1000px;
    }

    h3 {
      font-weight: 700;
      margin-bottom: 20px;
      border-left: 5px solid #ef84a5;
      padding-left: 10px;
    }

    .product-list {
      display: flex;
      flex-wrap: wrap;
      gap: 30px;
    }

    .product-item {
      width: 180px;
      background: #ffffff;
      border: 1px solid #f0f0f0;
      border-radius: 12px;
      text-align: center;
      padding: 20px 15px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.04);
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }

    .product-item:hover {
      transform: translateY(-5px);
      box-shadow: 0 8px 16px rgba(0,0,0,0.08);
    }

    .product-item img {
      width: 100%;
      height: 140px;
      object-fit: cover;
      border-radius: 8px;
      margin-bottom: 10px;
    }

    .product-name {
      font-size: 15px;
      font-weight: 500;
      margin-bottom: 8px;
      color: #333;
    }

    .product-item form .btn {
      background-color: #ef84a5;
      border: none;
      font-size: 14px;
      font-weight: bold;
      padding: 6px 12px;
      border-radius: 6px;
      color: #fff;
    }

    .order-info {
      font-size: 16px;
      font-weight: 500;
      margin-bottom: 30px;
    }

    @media (max-width: 768px) {
      .content-wrapper {
        margin-left: 0;
        padding: 20px;
      }

      .refund-container {
        max-width: 100%;
      }

      .product-list {
        justify-content: center;
      }

      .product-item {
        width: 45%;
      }
    }
  </style>
</head>
<body>

<c:import url="/common/header.jsp" />
<c:import url="/common/mypage_sidebar.jsp" />

<div class="content-wrapper">
  <div class="refund-container">
    <h3>환불 신청 - 상품 선택</h3>
    <p class="order-info">환불 가능한 상품을 선택하세요.</p>

    <div class="product-list">
      <c:choose>
        <c:when test="${not empty refundables}">
          <c:forEach var="item" items="${refundables}">
            <div class="product-item">
              <img src="<c:url value='/admin/common/images/products/${item.thumbnailUrl}' />"
                   alt="${item.productName}"
                   onerror="this.src='/images/no_image.png';" />
              <div class="product-name">${item.productName}</div>
              <form method="post" action="refund_request.jsp">
                <input type="hidden" name="order_item_id" value="${item.orderItemId}" />
                <input type="hidden" name="product_name" value="${item.productName}" />
                <input type="hidden" name="product_image" value="${item.thumbnailUrl}" />
                <button type="submit" class="btn btn-sm">환불 신청</button>
              </form>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <p>환불 가능한 상품이 없습니다.</p>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>

<c:import url="/common/footer.jsp" />
</body>
</html>
