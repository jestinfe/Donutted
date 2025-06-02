<%@page import="java.util.ArrayList"%>
<%@page import="order.OrderItemDTO"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- <%@ page import="order.OrderItemDTO, order.OrderService" %>
 --%><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="order.OrderService" %>
<%
  String orderIdStr = request.getParameter("order_id");
  int orderId = Integer.parseInt(orderIdStr);

  OrderService orderService = new OrderService();
  List<OrderItemDTO> refundables = orderService.getRefundableItemsByOrderId(orderId);

  request.setAttribute("refundables", refundables);
%>




<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>환불 상품 선택</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Pretendard&display=swap" rel="stylesheet">
  <style>
    body {
      font-family: 'Pretendard', sans-serif;
      background: #fffefc;
    }
    h3 {
      font-weight: 700;
      margin-bottom: 20px;
      border-left: 5px solid #ef84a5;
      padding-left: 10px;
    }
    .refund-container {
      margin-left: 260px;
      max-width: 1000px;
      padding: 40px 20px;
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
    .product-item .btn {
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
  </style>
</head>
<body>

<!-- 헤더 -->
<c:import url="/common/header.jsp" />
<c:import url="/common/mypage_sidebar.jsp" />

<div class="refund-container">
  <h3>환불 신청 - 상품 선택</h3>
  <p class="order-info">환불 가능한 상품을 선택하세요.</p>

  <div class="product-list">
    <c:choose>
      <c:when test="${not empty refundables}">
        <c:forEach var="item" items="${refundables}">
  <div class="product-item">
    <img src="<c:url value='/admin/common/upload/${item.thumbnailUrl}' />"
         alt="${item.productName}"
         onerror="this.src='/images/no_image.png';" />
    <div class="product-name">${item.productName}</div>
    <a href="refund_request.jsp?order_item_id=${item.orderItemId}&product_name=${item.productName}&product_image=${item.thumbnailUrl}" class="btn btn-sm">환불 신청</a>
  </div>
</c:forEach>

      </c:when>
      <c:otherwise>
        <p>환불 가능한 상품이 없습니다.</p>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<!-- 푸터 -->
<c:import url="/common/footer.jsp" />
</body>
</html>
