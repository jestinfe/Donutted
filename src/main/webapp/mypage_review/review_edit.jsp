<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="review.*, order.*" %>
<%
  request.setCharacterEncoding("UTF-8");
  int reviewId = Integer.parseInt(request.getParameter("review_id"));
  ReviewService reviewService = new ReviewService();
  ReviewDTO review = reviewService.getReviewById(reviewId);
  OrderItemDTO item = new OrderService().getOrderItemDetail(review.getOrderItemId());
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>리뷰 수정</title>
  <c:import url="http://localhost/mall_prj/common/external_file.jsp"/>
  <style>
    .product-img {
      width: 120px; height: 120px; object-fit: cover; border-radius: 8px;
    }
    .review-img {
      width: 120px; max-height: 120px; object-fit: cover; border-radius: 8px; margin-top: 10px;
    }
    .star-rating { font-size: 24px; cursor: pointer; }
    .star { color: #ccc; }
    .star.selected { color: gold; }
  </style>
</head>
<body>
  <div class="container mt-5">
    <h3 class="mb-4">| 리뷰 수정</h3>

    <div class="row mb-4">
      <div class="col-md-4">
        <img src="/mall_prj/admin/common/upload/<%= item.getThumbnailUrl() %>" alt="상품 이미지" class="product-img">
      </div>
      <div class="col-md-8 d-flex align-items-center">
        <h5><%= item.getProductName() %></h5>
      </div>
    </div>

    <form action="review_update.jsp" method="post" enctype="multipart/form-data">
      <input type="hidden" name="review_id" value="<%= review.getReviewId() %>">
      <input type="hidden" name="rating" id="ratingInput" value="<%= review.getRating() %>">

      <div class="mb-3">
        <label>평점</label>
        <div id="stars" class="star-rating">
          <% int currentRating = review.getRating();
             for (int i = 1; i <= 5; i++) { %>
            <span class="star <%= i <= currentRating ? "selected" : "" %>" data-value="<%= i %>">★</span>
          <% } %>
        </div>
      </div>

      <div class="mb-3">
        <label>내용</label>
        <textarea name="content" class="form-control" rows="4" required><%= review.getContent() %></textarea>
      </div>

      <div class="mb-3">
        <label>리뷰 이미지</label>
        <% if (review.getImageUrl() != null) { %>
          <div>
            <img src="/mall_prj/common/images/review/<%= review.getImageUrl() %>" alt="리뷰 이미지" class="review-img">
            <div class="form-check mt-2">
              <input class="form-check-input" type="checkbox" name="delete_image" value="true" id="deleteImageCheck">
              <label class="form-check-label" for="deleteImageCheck">기존 이미지 삭제</label>
            </div>
          </div>
        <% } %>
        <input type="file" name="image" class="form-control mt-2" accept="image/*">
      </div>

      <div class="text-end">
        <button type="submit" class="btn btn-primary">수정 완료</button>
      </div>
    </form>
  </div>

  <script>
    const stars = document.querySelectorAll('.star');
    const ratingInput = document.getElementById('ratingInput');

    function updateStars(value) {
      stars.forEach(star => {
        star.classList.toggle('selected', star.getAttribute('data-value') <= value);
      });
    }

    stars.forEach(star => {
      star.addEventListener('click', () => {
        const value = star.getAttribute('data-value');
        ratingInput.value = value;
        updateStars(value);
      });
    });

    // 초기 별점 표시
    updateStars(<%= review.getRating() %>);
  </script>
</body>
</html>
