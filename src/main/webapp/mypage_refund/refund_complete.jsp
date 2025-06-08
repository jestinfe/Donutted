<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="refund.RefundService, refund.RefundDTO, order.OrderService, order.OrderItemDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/common/login_chk.jsp" %>

<link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>

<%
  request.setCharacterEncoding("UTF-8");


  Integer userId = (Integer) session.getAttribute("userId");
  int orderItemId = Integer.parseInt(request.getParameter("order_item_id"));

  OrderService orderService = new OrderService();
  if (!orderService.isOrderItemOwnedByUser(orderItemId, userId)) {
      out.print("<script>alert('잘못된 접근입니다.'); history.back();</script>");
      return;
  }

  String productName = request.getParameter("product_name");
  String productImage = request.getParameter("product_image");
  String reason = request.getParameter("reason");

  RefundDTO dto = new RefundDTO();
  dto.setOrderItemId(orderItemId);
  dto.setRefundStatus("RS1"); // 환불 신청
  dto.setRefundReason(reason);

  RefundService refundService = new RefundService();
  refundService.applyRefund(dto);

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
  <title>환불신청 완료 | Donutted</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
  <link href="https://fonts.googleapis.com/css2?family=Pretendard&display=swap" rel="stylesheet" />
  <style>
    body {
      font-family: 'Pretendard', sans-serif;
      background-color: #fffefc;
      margin: 0;
    }

    .content-wrapper {
      margin-left: 240px;
      padding: 60px 20px;
      display: flex;
      justify-content: center;
    }

    .complete-container {
      width: 100%;
      max-width: 700px;
      text-align: center;
    }

    .complete-box {
      background: #fff;
      border: 1px solid #eee;
      border-radius: 12px;
      padding: 40px 20px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    }

    .complete-box h3 {
      color: #ef84a5;
      font-weight: bold;
      margin-bottom: 20px;
    }

    .complete-box p {
      font-size: 16px;
      margin-bottom: 10px;
    }

    .btn-home {
      margin-top: 30px;
      background-color: #ef84a5;
      border: none;
      padding: 10px 30px;
      color: white;
      font-weight: bold;
      border-radius: 6px;
      text-decoration: none;
      display: inline-block;
    }

    @media (max-width: 768px) {
      .content-wrapper {
        margin-left: 0;
        padding: 40px 16px;
      }

      .complete-container {
        max-width: 100%;
      }
    }
  </style>
</head>
<body>

<c:import url="/common/header.jsp" />
<c:import url="/common/mypage_sidebar.jsp" />

<div class="content-wrapper">
  <div class="complete-container">
    <div class="complete-box">
      <h3>환불 신청이 완료되었습니다</h3>
      <p><strong>상품명:</strong> <%= productName %></p>
      <p><strong>주문상품번호:</strong> <%= orderItemId %></p>
      <p><strong>사유:</strong> <%= reasonText %></p>
      <p class="text-muted">관리자 확인 후 2~3일 내 환불이 처리됩니다.<br>환불 진행 상황은 마이페이지에서 확인해주세요.</p>
      <a href="my_refunds.jsp" class="btn-home">환불 내역 보기</a>
    </div>
  </div>
</div>

<c:import url="/common/footer.jsp" />
</body>
</html>
