<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="review.*, java.util.*, order.OrderService, order.OrderItemDTO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>리뷰관리</title>
</head>
<body>

<%
  request.setCharacterEncoding("UTF-8");
  Integer userId = (Integer) session.getAttribute("userId");
  List<ReviewDTO> reviews = new ArrayList<>();
  Map<Integer, OrderItemDTO> itemMap = new HashMap<>();

  if (userId != null) {
    ReviewService reviewService = new ReviewService();
    reviews = reviewService.getUserReviews(userId);

    OrderService orderService = new OrderService();
    for (ReviewDTO review : reviews) {
        OrderItemDTO item = orderService.getOrderItemDetail(review.getOrderItemId());
        itemMap.put(review.getOrderItemId(), item);
    }
  }
%>

<%@ include file="../common/header.jsp" %>
<%@ include file="../common/mypage_sidebar.jsp" %>

<style>
  html, body {
    margin: 0;
    padding: 0;
    height: 100%;
    font-family: 'Pretendard', sans-serif;
    background-color: #fff;
  }

  .wrapper {
    display: flex;
    min-height: calc(100vh - 100px);
  }

  .sidebar {
    width: 260px;
    flex-shrink: 0;
    position: sticky;
    top: 0;
    height: 100vh;
    background-color: #f9f9f9;
    padding-top: 20px;
  }

  .main-content {
    flex-grow: 1;
    padding: 40px;
    background-color: #fff;
  }

  .review-card {
    border: 1px solid #ddd;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    border-radius: 10px;
    overflow: hidden;
    margin-bottom: 30px;
    transition: box-shadow 0.3s;
  }

  .review-card:hover {
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
  }

  .review-card .row {
    display: flex;
    align-items: stretch;
  }

  .review-card img {
    width: 150px;
    height: 150px;
    object-fit: cover;
    border-radius: 10px 0 0 10px;
  }

  .review-card .card-body {
    padding: 20px;
  }

  .review-actions a {
    margin-right: 8px;
  }

  .stars {
    color: gold;
    font-size: 18px;
  }

  .no-reviews {
    padding: 20px;
    text-align: center;
    color: #888;
  }
</style>

<div class="wrapper">
  <!-- 사이드바 -->
  <div class="sidebar">
    <jsp:include page="/common/mypage_sidebar.jsp" />
  </div>

  <!-- 본문 -->
  <div class="main-content">
    <h3 class="mb-4">| 내가 작성한 리뷰</h3>

    <%
      for (ReviewDTO review : reviews) {
          OrderItemDTO item = itemMap.get(review.getOrderItemId());
    %>
    <div class="review-card">
      <div class="row g-0">
        <div>
          <img src="/mall_prj/admin/common/upload/<%= item.getThumbnailUrl() %>" alt="상품 이미지">
        </div>
        <div class="col-md-9">
          <div class="card-body">
            <h5 class="card-title mb-2"><%= item.getProductName() %></h5>
            <p class="stars">
              <%
                for (int i = 1; i <= 5; i++) {
                    if (i <= review.getRating()) out.print("★");
                    else out.print("☆");
                }
              %>
            </p>
            <p class="mb-2"><%= review.getContent() %></p>
            <p class="text-muted"><small>작성일: <%= review.getCreatedAt() %></small></p>
            <div class="review-actions">
              <button type="button" class="btn btn-sm btn-warning"
        onclick="openEditPopup(<%= review.getReviewId() %>)">
  수정
</button>
              <a href="review_delete.jsp?review_id=<%= review.getReviewId() %>" class="btn btn-sm btn-danger" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
            </div>
          </div>
        </div>
      </div>
    </div>
    <%
      }
      if (reviews.isEmpty()) {
    %>
    <p class="no-reviews">작성한 리뷰가 없습니다.</p>
    <%
      }
    %>
  </div>
</div>
</body>

<script>
  function openEditPopup(reviewId) {
    const url = "review_edit.jsp?review_id=" + reviewId;
    const options = "width=600,height=500,scrollbars=yes,resizable=no";
    window.open(url, "리뷰수정", options);
  }
</script>


<%@ include file="../common/footer.jsp" %>
