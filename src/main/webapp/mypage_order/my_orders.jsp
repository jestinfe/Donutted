<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    .order-box { background-color: #fff; border: 1px solid #ddd; border-radius: 12px; padding: 20px 25px; margin-bottom: 30px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); }
    .order-date { font-weight: bold; font-size: 16px; margin-bottom: 15px; }
    .order-status-bar { display: flex; justify-content: space-between; padding: 10px 15px; margin-bottom: 15px; background: #f1f1f1; border-radius: 8px; font-size: 15px; font-weight: 500; }
    .order-status-bar span { flex: 1; text-align: center; color: #888; }
    .order-status-bar span.active { font-weight: bold; color: #222; background: #ffe58f; border-radius: 6px; padding: 6px; }
    .product-list { display: flex; flex-wrap: wrap; gap: 20px; margin-bottom: 20px; }
    .product-item { width: 110px; text-align: center; font-size: 14px; }
    .product-item img { width: 100px; height: 100px; border-radius: 10px; object-fit: cover; box-shadow: 0 2px 6px rgba(0,0,0,0.08); transition: transform 0.2s ease; }
    .product-item img:hover { transform: scale(1.05); }
    .text-end { text-align: right; }
    .btn-review { background-color: #f38fb3; color: #fff; border: none; padding: 8px 16px; border-radius: 6px; margin-right: 10px; }
    .btn-refund { background-color: #eee; color: #333; border: none; padding: 8px 16px; border-radius: 6px; }
    .btn-review:hover { background-color: #e9729e; }
    .btn-refund:hover { background-color: #ddd; }
    .alert-box { background: #fffbe6; padding: 12px 20px; border-left: 4px solid #ffe58f; margin-bottom: 25px; color: #666; }
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
    out.print("<script>alert('로그인이 필요합니다.'); location.href='/UserLogin/login.jsp';</script>");
    return;
  }
%>
<div class="orders-container">
  <h3>주문배송 조회</h3>
  <div id="orderList"></div>
  <div id="loading" style="text-align:center; padding:20px; display:none;">로딩 중...</div>
</div>
<c:import url="/common/footer.jsp" />
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
  let page = 1;
  let loading = false;
  const limit = 5;

  function loadMoreOrders() {
    if (loading) return;
    loading = true;
    $('#loading').show();

    $.ajax({
      url: 'order_list_ajax.jsp',
      type: 'GET',
      data: {
        userId: '<%= userId %>',
        page: page,
        limit: limit
      },
      success: function (html) {
        if ($.trim(html) !== '') {
          $('#orderList').append(html);
          page++;
        }
        $('#loading').hide();
        loading = false;
      },
      error: function () {
        $('#loading').hide();
        loading = false;
        alert('주문 데이터를 불러오는 중 오류가 발생했습니다.');
      }
    });
  }

  $(window).scroll(function () {
    if ($(window).scrollTop() + $(window).height() >= $(document).height() - 150) {
      loadMoreOrders();
    }
  });

  $(document).ready(function () {
    loadMoreOrders();
  });
</script>
</body>
</html>
