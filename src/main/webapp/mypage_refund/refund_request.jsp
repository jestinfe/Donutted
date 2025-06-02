<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="order.OrderService, order.OrderItemDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
  request.setCharacterEncoding("UTF-8");
  int orderItemId = Integer.parseInt(request.getParameter("order_item_id"));

  OrderService service = new OrderService();
  OrderItemDTO item = service.getOrderItemDetail(orderItemId);

  String productName = item.getProductName();
  String productImage = item.getThumbnailUrl();
  
  String contextPath = request.getContextPath();
  String imagePath = contextPath + "/admin/common/upload/" + productImage;
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>환불 사유 선택</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
  <link href="https://fonts.googleapis.com/css2?family=Pretendard&display=swap" rel="stylesheet" />
  <style>
    body {
      font-family: 'Pretendard', sans-serif;
      background: #fffefc;
    }
    .refund-container {
      margin-left: 260px;
      max-width: 800px;
      padding: 40px 20px;
    }
    h3 {
      font-weight: 700;
      margin-bottom: 30px;
      border-left: 5px solid #ef84a5;
      padding-left: 10px;
    }
    .product-preview {
      display: flex;
      align-items: center;
      gap: 20px;
      margin-bottom: 30px;
    }
    .product-preview img {
      width: 120px;
      height: 120px;
      border-radius: 8px;
      object-fit: cover;
      border: 1px solid #eee;
    }
    .reason-box {
      background: #fff;
      border: 1px solid #ddd;
      border-radius: 10px;
      padding: 20px;
    }
    .reason-box label {
      display: block;
      margin-bottom: 10px;
      cursor: pointer;
    }
    .reason-box input[type="radio"] {
      margin-right: 8px;
    }
    .btn-next {
      margin-top: 30px;
      background-color: #ef84a5;
      border: none;
      padding: 10px 30px;
      color: white;
      font-weight: bold;
      border-radius: 6px;
    }
  </style>
</head>
<body>

<c:import url="/common/header.jsp" />
<c:import url="/common/mypage_sidebar.jsp" />

<div class="refund-container">
  <h3>환불 신청 - 사유 선택</h3>

  <!-- 선택 상품 요약 -->
  <div class="product-preview">
  <img src="<%= imagePath %>" alt="<%= productName %>" onerror="this.src='/images/no_image.png';" />
    <div>
      <strong><%= productName %></strong><br>
      주문상품번호: <%= orderItemId %>
    </div>
  </div>

  <!-- 환불 사유 선택 -->
  <form action="refund_confirm.jsp" method="post">
    <input type="hidden" name="order_item_id" value="<%= orderItemId %>" />
    <input type="hidden" name="product_name" value="<%= productName %>" />
    <input type="hidden" name="product_image" value="<%= productImage %>" />

    <div class="reason-box">
	  <p><strong>단순 변심</strong></p>
	  <label><input type="radio" name="reason" value="RR1" required /> 상품이 마음에 들지 않음</label>
	  <label><input type="radio" name="reason" value="RR2" /> 같은 상품의 다른 옵션으로 교환</label>
	
	  <p class="mt-3"><strong>배송문제</strong></p>
	  <label><input type="radio" name="reason" value="RR3" /> 배송된 장소에 박스가 분실됨</label>
	  <label><input type="radio" name="reason" value="RR4" /> 선택한 주소가 아닌 다른 주소로 배송됨</label>
	
	  <p class="mt-3"><strong>상품문제</strong></p>
	  <label><input type="radio" name="reason" value="RR5" /> 상품의 구성품/부속품이 들어있지 않음</label>
	  <label><input type="radio" name="reason" value="RR6" /> 상품이 설명과 다름</label>
	  <label><input type="radio" name="reason" value="RR7" /> 다른 상품이 배송됨</label>
	  <label><input type="radio" name="reason" value="RR8" /> 상품이 파손됨/기능 오동작</label>
	</div>


    <div class="text-end">
      <button type="submit" class="btn btn-next">다음 단계 &gt;</button>
    </div>
  </form>
</div>

<c:import url="/common/footer.jsp" />
</body>
</html>
