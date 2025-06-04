<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page
	import="review.*, java.util.*, order.OrderService, order.OrderItemDTO"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>리뷰관리</title>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="http://localhost/mall_prj/common/external_file.jsp" />

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
	padding: 100px 450px 100px 150px;
	background-color: #fff;
}

.review-card {
	display: flex;
	border: 1px solid #ddd;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
	border-radius: 10px;
	overflow: hidden;
	margin-bottom: 30px;
	padding: 10px;
	transition: box-shadow 0.3s;
}

.review-card:hover {
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

/* ✅ 왼쪽 영역: 상품명 + 이미지 */
.left-block {
	flex-shrink: 0;
	width: 270px;
	display: flex;
	flex-direction: column;
	border-right: 1px solid #ccc;
	padding-left: 10px;
	padding-right: 40px; /* 구분선과 콘텐츠 사이 간격 */
}

.card-title {
	margin: 10px;
	font-size: 20px;
	font-weight: bold;
	text-align: left !important;
}

.itemImage {
	width: 200px;
	height: 200px;
	object-fit: cover;
	border-radius: 10px;
	margin: 10px;
}

/* ✅ 오른쪽 영역: 별점, 내용 등 */
.right-block {
  flex-grow: 1;
  padding-left: 50px;
  display: flex;
  flex-direction: column;
  justify-content: space-between; /* 상단 내용 + 하단 버튼 영역을 분리 */
  padding-right: 20px;
  padding-bottom: 10px;
}

.review-card .card-body {
	padding: 20px 20px 20px 0px;
}

.review-actions {
  margin-top: auto; /* 하단으로 밀착 */
  align-self: flex-end; /* 오른쪽 정렬 */
  text-align: right;
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

<%@ include file="../common/header.jsp"%>
<%@ include file="../common/mypage_sidebar.jsp"%>


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
		
		    <!-- 왼쪽: 상품명 + 이미지 -->
		    <div class="left-block">
			    <h4 class="card-title">
			    	<a href="/mall_prj/product/product_detail.jsp?productId=<%= item.getProductId() %>" style="text-decoration: none; color: inherit;">
			   			<%= item.getProductName() %>
			   		</a>
			   	</h4>
			   	<a href="/mall_prj/product/product_detail.jsp?productId=<%= item.getProductId() %>" style="text-decoration: none; color: inherit;">
			    	<img src="/mall_prj/admin/common/upload/<%= item.getThumbnailUrl() %>"
			        	alt="상품 이미지" class="itemImage">
			 	</a>
		    </div>
		
		    <!-- 오른쪽: 리뷰 정보 -->
		    <div class="right-block">
		      <div class="card-body">
		        <div style="color:black; padding-top: 20px;">나의 평점 </div>
		        <p class="stars">
		          <%
		            for (int i = 1; i <= 5; i++) {
		              out.print(i <= review.getRating() ? "★" : "☆");
		            }
		          %>
		        </p>
		        <div style="color:black;">작성한 내용 </div>
				<%
				  String content = review.getContent();
				  if (content.length() > 27) {
				    content = content.substring(0, 27) + "...";
				  }
				%>
				<p class="mb-2" style="font-size: 0.8em;"><%= content %></p>
		      </div>
		      <div class="review-actions">
		        <small>작성일: <%= review.getCreatedAt() %></small>
		        <br>
		        <button type="button" class="btn btn-sm btn-warning"
		                onclick="openEditPopup(<%= review.getReviewId() %>)">수정</button>
		        <a href="review_delete.jsp?review_id=<%= review.getReviewId() %>"
		           class="btn btn-sm btn-danger"
		           onclick="return confirm('삭제하시겠습니까?');">삭제</a>
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


<%@ include file="../common/footer.jsp"%>