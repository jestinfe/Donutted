<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="order.*, java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>마이페이지 - 주문목록/배송조회</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Pretendard&display=swap" rel="stylesheet">
  <style>
    body { font-family: 'Pretendard', sans-serif; background-color: #fffefc; margin: 0; }
    .orders-container { margin-left: 260px; max-width: 1000px; padding: 40px 20px; }
    h3 { font-weight: 700; margin-bottom: 30px; border-left: 5px solid #ef84a5; padding-left: 10px; }

    .order-box {
      background-color: #fff; border: 1px solid #ddd; border-radius: 12px;
      padding: 20px 25px; margin-bottom: 30px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.06);
    }

    .order-date { font-weight: bold; font-size: 16px; margin-bottom: 15px; }

    .order-status-bar {
      display: flex; justify-content: space-between; padding: 10px 15px;
      margin-bottom: 15px; background: #f1f1f1;
      border-radius: 8px; font-size: 15px; font-weight: 500;
    }

    .order-status-bar span {
      flex: 1; text-align: center; color: #888;
    }

    .order-status-bar span.active {
      font-weight: bold; color: #222; background: #ffe58f;
      border-radius: 6px; padding: 6px;
    }

    .product-list { display: flex; flex-wrap: wrap; gap: 20px; margin-bottom: 20px; }
    .product-item { width: 110px; text-align: center; font-size: 14px; }
    .product-item img {
      width: 100px; height: 100px; border-radius: 10px;
      object-fit: cover; box-shadow: 0 2px 6px rgba(0,0,0,0.08);
      transition: transform 0.2s ease;
    }

    .product-item img:hover { transform: scale(1.05); }
    .text-end { text-align: right; }

    .btn-review {
      background-color: #f38fb3; color: #fff; border: none;
      padding: 8px 16px; border-radius: 6px; margin-right: 10px;
    }

    .btn-refund {
      background-color: #eee; color: #333; border: none;
      padding: 8px 16px; border-radius: 6px;
    }

    .btn-review:hover { background-color: #e9729e; }
    .btn-refund:hover { background-color: #ddd; }

    .alert-box {
      background: #fffbe6; padding: 12px 20px;
      border-left: 4px solid #ffe58f; margin-bottom: 25px; color: #666;
    }

    .text-danger { color: red; font-weight: bold; }

    @media (max-width: 768px) {
      .orders-container { margin-left: 0; padding: 30px 16px; }
      .order-status-bar { flex-direction: column; gap: 5px; }
      .product-list { justify-content: center; }
      .product-item { width: 45%; }
      .text-end { text-align: center; }
      .btn-review, .btn-refund { margin-top: 10px; }
    }
  </style>
</head>
<body>

<c:import url="/common/header.jsp" />
<c:import url="/common/mypage_sidebar.jsp" />

<%
  request.setCharacterEncoding("UTF-8");
  Integer userId = (Integer) session.getAttribute("userId");

  if (userId == null) {
    out.print("세션에 user_id가 없습니다.");
    return;
  }

  OrderService service = new OrderService();
  List<OrderDTO> orders = service.getOrdersByUser(userId);
  request.setAttribute("orders", orders);
%>

<div class="orders-container">
  <h3>주문배송 조회</h3>

  <c:if test="${empty orders}">
    <div class="alert-box">
      <span class="text-danger">❌ 주문 내역이 없습니다.</span>
    </div>
  </c:if>

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
  <!-- 리뷰/환불 버튼: 배송완료(O4)일 때만 -->
  <c:if test="${not empty order.items and order.orderStatus eq 'O4'}">
    <a href="write_review.jsp?order_id=${order.orderId}" class="btn-review">리뷰작성</a>
    <a href="refund_items.jsp?order_id=${order.orderId}" class="btn-refund">환불요청</a>
  </c:if>

  <!-- 주문취소 버튼: O1~O3일 때만 노출 -->
  <c:if test="${order.orderStatus == 'O1' || order.orderStatus == 'O2' || order.orderStatus == 'O3'}">
    <a href="cancel_order.jsp?order_id=${order.orderId}" class="btn-refund"
       onclick="return confirm('정말 주문을 취소하시겠습니까?');">
       주문취소
    </a>
  </c:if>

  <!-- 주문취소됨 안내 메시지 -->
  <c:if test="${order.orderStatus == 'O0'}">
    <span class="text-danger">이 주문은 취소된 주문입니다.</span>
  </c:if>
</div>

    </div>
  </c:forEach>
</div>

<c:import url="/common/footer.jsp" />
</body>
</html>
