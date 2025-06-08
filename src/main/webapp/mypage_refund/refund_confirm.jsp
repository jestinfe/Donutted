<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="order.OrderService, order.OrderItemDTO" %>
<%@ include file="/common/login_chk.jsp" %>

<link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>

<%
  request.setCharacterEncoding("UTF-8");


  int userId = (Integer) session.getAttribute("userId");
  int orderItemId = Integer.parseInt(request.getParameter("order_item_id"));

  OrderService service = new OrderService();

  if (!service.isOrderItemOwnedByUser(orderItemId, userId)) {
    out.print("<script>alert('잘못된 접근입니다.'); history.back();</script>");
    return;
  }

  OrderItemDTO item = service.getOrderItemDetail(orderItemId);
  String productName = item.getProductName();
  String productImage = item.getThumbnailUrl();

  String reason = request.getParameter("reason");
  String contextPath = request.getContextPath();
  String imagePath = contextPath + "/admin/common/images/products/" + productImage;

  String reasonText = "";
  switch (reason) {
    case "RR1": reasonText = "상품이 마음에 들지 않음"; break;
    case "RR2": reasonText = "같은 상품의 다른 옵션으로 교환"; break;
    case "RR3": reasonText = "배송된 장소에 박스가 분실됨"; break;
    case "RR4": reasonText = "선택한 주소가 아닌 다른 주소로 배송됨"; break;
    case "RR5": reasonText = "상품의 구성품/부속품이 들어있지 않음"; break;
    case "RR6": reasonText = "상품이 설명과 다름"; break;
    case "RR7": reasonText = "다른 상품이 배송됨"; break;
    case "RR8": reasonText = "상품이 파손됨/기능 오동작"; break;
    default: reasonText = "기타 사유"; break;
  }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>환불신청 확인 | Donutted</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Pretendard&display=swap" rel="stylesheet">
  <style>
    body {
      font-family: 'Pretendard', sans-serif;
      background-color: #fffefc;
      margin: 0;
    }

    .content-wrapper {
      margin-left: 240px;
      padding: 40px 20px;
      display: flex;
      justify-content: center;
    }

    .confirm-container {
      width: 100%;
      max-width: 800px;
    }

    h3 {
      font-weight: 700;
      margin-bottom: 30px;
      border-left: 5px solid #ef84a5;
      padding-left: 10px;
    }

    .summary-box {
      background: #fff;
      border: 1px solid #ddd;
      border-radius: 10px;
      padding: 20px;
      margin-bottom: 30px;
    }

    .summary-row {
      display: flex;
      align-items: center;
      gap: 20px;
    }

    .summary-row img {
      width: 120px;
      height: 120px;
      border-radius: 8px;
      object-fit: cover;
      border: 1px solid #eee;
    }

    .summary-detail {
      font-size: 16px;
    }

    .btn-submit {
      background-color: #ef84a5;
      border: none;
      padding: 10px 30px;
      color: white;
      font-weight: bold;
      border-radius: 6px;
    }

    @media (max-width: 768px) {
      .content-wrapper {
        margin-left: 0;
        padding: 20px;
      }

      .confirm-container {
        max-width: 100%;
      }

      .summary-row {
        flex-direction: column;
        text-align: center;
      }

      .summary-row img {
        margin-bottom: 10px;
      }

      .text-end {
        text-align: center !important;
      }
    }
  </style>
</head>
<body>

<c:import url="/common/header.jsp" />
<c:import url="/common/mypage_sidebar.jsp" />

<div class="content-wrapper">
  <div class="confirm-container">
    <h3>환불 신청 - 확인</h3>

    <div class="summary-box">
      <div class="summary-row">
        <img src="<%= imagePath %>" alt="<%= productName %>" onerror="this.src='/images/no_image.png';">
        <div class="summary-detail">
          <p><strong>상품명:</strong> <%= productName %></p>
          <p><strong>주문상품번호:</strong> <%= orderItemId %></p>
          <p><strong>환불 사유:</strong> <%= reasonText %></p>
        </div>
      </div>
    </div>

    <form action="refund_complete.jsp" method="post">
      <input type="hidden" name="order_item_id" value="<%= orderItemId %>">
      <input type="hidden" name="product_name" value="<%= productName %>">
      <input type="hidden" name="product_image" value="<%= productImage %>">
      <input type="hidden" name="reason" value="<%= reason %>">

      <div class="text-end">
        <button type="submit" class="btn btn-submit">환불 신청 완료</button>
      </div>
    </form>
  </div>
</div>

<c:import url="/common/footer.jsp" />
</body>
</html>
