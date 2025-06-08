<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="review.*, order.*, user.*" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>

<head>
<title>리뷰 상세조회</title>
</head>


<%
  request.setCharacterEncoding("UTF-8");

  int reviewId = Integer.parseInt(request.getParameter("review_id"));

  ReviewService reviewService = new ReviewService();
  ReviewDTO review = reviewService.getReviewById(reviewId);

  OrderItemDTO item = new OrderService().getOrderItemDetail(review.getOrderItemId());
  UserDTO user = new UserService().getUserById(review.getUserId());
%>

<div class="main">
  <h3>리뷰 관리 - 리뷰 상세 조회</h3>

  <table class="table table-bordered align-middle" style="width: 80%; margin: 0 auto;">
    <tr>
      <th style="width: 20%;">작성자</th>
      <td><%= user != null ? user.getUsername() : "탈퇴자" %></td>
    </tr>
    <tr>
      <th>작성일</th>
      <td><%= review.getCreatedAt() %></td>
    </tr>
    <tr>
      <th>이미지</th>
      <td>
        <% if (review.getImageUrl() != null && !review.getImageUrl().isEmpty()) { %>
          <img src="/mall_prj/common/images/review/<%= review.getImageUrl() %>" width="80">
        <% } else { %>
          (이미지 없음)
        <% } %>
      </td>
    </tr>
    <tr>
      <th>상품명</th>
      <td><%= item.getProductName() %></td>
    </tr>
    <tr>
      <th>내용</th>
      <td><%= review.getContent() %></td>
    </tr>
    <tr>
      <th>별점</th>
      <td>
        <%
          for (int i = 1; i <= 5; i++) {
            if (i <= review.getRating()) out.print("★");
            else out.print("☆");
          }
        %>
      </td>
    </tr>
  </table>

  <div class="mt-4 text-center">
    <form action="review_delete_process.jsp" method="post" style="display:inline;">
      <input type="hidden" name="review_id" value="<%= review.getReviewId() %>">
      <button type="submit" class="btn btn-danger">삭제</button>
    </form>
    <a href="review_list.jsp" class="btn btn-success">뒤로</a>
  </div>
</div>
