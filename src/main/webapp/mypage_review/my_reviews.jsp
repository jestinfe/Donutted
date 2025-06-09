<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page
	import="review.*, java.util.*, order.OrderService, order.OrderItemDTO"%>
<%@ include file="/common/login_chk.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>리뷰관리 | Donutted</title>
<link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:import url="http://localhost/mall_prj/common/external_file.jsp" />
<link href="https://fonts.googleapis.com/css2?family=Pretendard:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>
:root {
  --primary-pink: #f8bbd9;
  --primary-pink-light: #fdd7e4;
  --primary-pink-dark: #e2a2c7;
  --secondary-pink: #f5a6cd;
  --accent-rose: #f4c2c2;
  --accent-cream: #fef7f7;
  --background-cream: #fefafa;
  --text-pink: #8b4a6b;
  --text-soft: #a86b7a;
  --text-light: #c4859a;
  --border-pink: #f2d7dd;
  --shadow-pink: rgba(248, 187, 217, 0.15);
  --card-bg: linear-gradient(135deg, #ffffff 0%, #fef9fb 100%);
}

* {
  box-sizing: border-box;
}

html, body {
	margin: 0;
	padding: 0;
	height: 100%;
	font-family: 'Pretendard', sans-serif;
	background: linear-gradient(135deg, var(--background-cream) 0%, #fef4f6 100%);
	color: var(--text-pink);
	line-height: 1.6;
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
	background: linear-gradient(135deg, #f9f9f9 0%, #f7f2f4 100%);
	padding-top: 20px;
	border-right: 2px solid var(--border-pink);
}

.main-content {
  flex-grow: 1;
  padding: 80px 20px 100px 20px;
  background: transparent;
  animation: fadeInUp 0.8s ease-out;
  max-width: 1000px;
  margin: 0 auto;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.main-content h3 {
  font-size: 2.2rem;
  font-weight: 700;
  margin-bottom: 40px;
  color: var(--text-pink);
  position: relative;
  padding-left: 20px;
}

.main-content h3::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  width: 6px;
  height: 100%;
  background: linear-gradient(135deg, var(--primary-pink), var(--secondary-pink));
  border-radius: 3px;
}

.main-content h3::after {
  content: '📝';
  position: absolute;
  right: 0;
  top: 50%;
  transform: translateY(-50%);
  font-size: 1.5rem;
  opacity: 0.7;
}

.review-card {
	display: flex;
	background: var(--card-bg);
	border: 2px solid var(--border-pink);
	box-shadow: 
	  0 8px 32px var(--shadow-pink),
	  0 2px 8px rgba(0, 0, 0, 0.05);
	border-radius: 20px;
	overflow: hidden;
	margin-bottom: 35px;
	padding: 25px;
	transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
	position: relative;
	opacity: 0;
	transform: translateY(20px);
	animation: slideInUp 0.6s ease-out forwards;
}

.review-card:nth-child(even) {
  animation-delay: 0.1s;
}

.review-card:nth-child(odd) {
  animation-delay: 0.2s;
}

@keyframes slideInUp {
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.review-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-pink), var(--secondary-pink), var(--accent-rose));
}

.review-card:hover {
	transform: translateY(-8px);
	box-shadow: 
	  0 16px 48px var(--shadow-pink),
	  0 4px 16px rgba(0, 0, 0, 0.1);
	border-color: var(--primary-pink-light);
}

/* 왼쪽 영역: 상품명 + 이미지 */
.left-block {
	flex-shrink: 0;
	width: 280px;
	display: flex;
	flex-direction: column;
	border-right: 2px dashed var(--border-pink);
	padding-right: 30px;
	margin-right: 30px;
}

.card-title {
	margin: 10px 0 20px 0;
	font-size: 1.3rem;
	font-weight: 600;
	text-align: left !important;
	color: var(--text-pink);
	line-height: 1.4;
	transition: color 0.3s ease;
}

.card-title a {
  text-decoration: none;
  color: inherit;
  position: relative;
}

.card-title a::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 0;
  height: 2px;
  background: linear-gradient(90deg, var(--primary-pink), var(--secondary-pink));
  transition: width 0.3s ease;
}

.card-title a:hover::after {
  width: 100%;
}

.card-title a:hover {
  color: var(--primary-pink);
}

.itemImage {
	width: 220px;
	height: 220px;
	object-fit: cover;
	border-radius: 15px;
	margin: 10px 0;
	box-shadow: 
	  0 8px 25px rgba(248, 187, 217, 0.2),
	  0 2px 10px rgba(0,0,0,0.05);
	transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
	border: 3px solid transparent;
}

.itemImage:hover {
	transform: scale(1.05) rotate(1deg);
	border-color: var(--primary-pink-light);
	box-shadow: 
	  0 12px 35px rgba(248, 187, 217, 0.3),
	  0 4px 15px rgba(0,0,0,0.1);
}

/* 오른쪽 영역: 리뷰 정보 */
.right-block {
  flex-grow: 1;
  padding-left: 20px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  padding-right: 20px;
  padding-bottom: 10px;
}

.review-card .card-body {
	padding: 20px 20px 20px 0px;
}

.card-body > div {
  color: var(--text-soft) !important;
  font-weight: 600;
  margin-bottom: 12px;
  font-size: 1rem;
}

.card-body > div:first-child {
  display: flex;
  align-items: center;
  gap: 8px;
}

.card-body > div:first-child::before {
  content: '⭐';
  font-size: 1.1rem;
}

.card-body > div:nth-child(3) {
  display: flex;
  align-items: center;
  gap: 8px;
}

.card-body > div:nth-child(3)::before {
  content: '💭';
  font-size: 1.1rem;
}

.review-actions {
  margin-top: auto;
  align-self: flex-end;
  text-align: right;
  padding: 20px 0 0 0;
  border-top: 2px dashed var(--border-pink);
  width: 100%;
}

.stars {
	color: #ff9ec7;
	font-size: 1.5rem;
	text-shadow: 0 2px 4px rgba(255, 158, 199, 0.3);
	letter-spacing: 2px;
	margin: 8px 0 15px 0;
}

.review-content {
  background: linear-gradient(135deg, var(--accent-cream), #fdf0f2);
  padding: 15px 20px;
  border-radius: 12px;
  border: 1px solid var(--border-pink);
  font-size: 0.95rem;
  line-height: 1.6;
  color: var(--text-pink);
  margin: 8px 0 15px 0;
  position: relative;
}

.review-content::before {
  content: '"';
  position: absolute;
  top: -5px;
  left: 10px;
  font-size: 2rem;
  color: var(--accent-rose);
  font-family: serif;
}

.review-content::after {
  content: '"';
  position: absolute;
  bottom: -15px;
  right: 10px;
  font-size: 2rem;
  color: var(--accent-rose);
  font-family: serif;
}

.review-actions small {
  color: var(--text-light);
  font-size: 0.85rem;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 8px;
  margin-bottom: 15px;
}

.review-actions small::before {
  content: '📅';
  font-size: 1rem;
}

.btn {
  padding: 10px 20px;
  border: none;
  border-radius: 25px;
  font-size: 0.9rem;
  font-weight: 600;
  margin-left: 8px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  position: relative;
  overflow: hidden;
  text-decoration: none;
  display: inline-block;
}

.btn-warning {
  background: linear-gradient(135deg, var(--accent-rose), #f2b3c4);
  color: #fff;
  box-shadow: 0 4px 15px rgba(244, 194, 194, 0.4);
}

.btn-warning:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(244, 194, 194, 0.5);
  background: linear-gradient(135deg, #f2b3c4, var(--accent-rose));
}

.btn-danger {
  background: linear-gradient(135deg, #e28ba8, #d77391);
  color: #fff;
  box-shadow: 0 4px 15px rgba(226, 139, 168, 0.4);
}

.btn-danger:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(226, 139, 168, 0.5);
  background: linear-gradient(135deg, #d77391, #e28ba8);
  text-decoration: none;
  color: #fff;
}

.no-reviews {
	padding: 60px 40px;
	text-align: center;
	color: var(--text-soft);
	background: var(--card-bg);
	border: 2px dashed var(--border-pink);
	border-radius: 20px;
	font-size: 1.2rem;
	position: relative;
}

.no-reviews::before {
  content: '🤔';
  display: block;
  font-size: 3rem;
  margin-bottom: 20px;
}

.no-reviews::after {
  content: '첫 번째 리뷰를 작성해보세요!';
  display: block;
  font-size: 1rem;
  color: var(--text-light);
  margin-top: 10px;
}

/* 반응형 디자인 */
@media (max-width: 1200px) {
  .main-content {
    padding: 80px 50px 100px 80px;
  }
}

@media (max-width: 768px) {
  .wrapper {
    flex-direction: column;
  }
  
  .sidebar {
    width: 100%;
    height: auto;
    position: static;
  }
  
  .main-content {
    padding: 30px 20px;
  }
  
  .main-content h3 {
    font-size: 1.8rem;
    margin-bottom: 30px;
  }
  
  .review-card {
    flex-direction: column;
    padding: 20px;
    margin-bottom: 25px;
  }
  
  .left-block {
    width: 100%;
    border-right: none;
    border-bottom: 2px dashed var(--border-pink);
    padding-right: 0;
    padding-bottom: 20px;
    margin-right: 0;
    margin-bottom: 20px;
    text-align: center;
  }
  
  .itemImage {
    width: 180px;
    height: 180px;
    margin: 10px auto;
  }
  
  .right-block {
    padding-left: 0;
  }
  
  .review-actions {
    text-align: center;
    margin-top: 20px;
  }
  
  .btn {
    margin: 5px;
    padding: 8px 16px;
    font-size: 0.85rem;
  }
}

/* 버튼 클릭 효과 */
.btn.clicked {
  transform: scale(0.95);
  transition: transform 0.1s ease;
}

/* 호버 시 카드 내 이미지 효과 */
.review-card:hover .itemImage {
  transform: scale(1.02);
}

/* 스크롤바 스타일링 */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: var(--accent-cream);
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: var(--primary-pink-light);
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: var(--primary-pink);
}
</style>
</head>
<body>

<%
request.setCharacterEncoding("UTF-8");
Integer userId = (Integer) session.getAttribute("userId");
List<ReviewDTO> reviews = new ArrayList<>();
Map<Integer, OrderItemDTO> itemMap = new HashMap<>();

	ReviewService reviewService = new ReviewService();
	reviews = reviewService.getUserReviews(userId);

	OrderService orderService = new OrderService();
	for (ReviewDTO review : reviews) {
		OrderItemDTO item = orderService.getOrderItemDetail(review.getOrderItemId());
		itemMap.put(review.getOrderItemId(), item);
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
		<h3 class="mb-4">내가 작성한 리뷰</h3>

		<%
		for (ReviewDTO review : reviews) {
			OrderItemDTO item = itemMap.get(review.getOrderItemId());
		%>
		<div class="review-card">
		
		    <!-- 왼쪽: 상품명 + 이미지 -->
		    <div class="left-block">
			    <h4 class="card-title">
			    	<a href="/mall_prj/product/product_detail.jsp?productId=<%= item.getProductId() %>">
			   			<%= item.getProductName() %>
			   		</a>
			   	</h4>
			   	<a href="/mall_prj/product/product_detail.jsp?productId=<%= item.getProductId() %>">
			    	<img src="/mall_prj/admin/common/images/products/<%= item.getThumbnailUrl() %>"
			        	alt="상품 이미지" class="itemImage">
			 	</a>
		    </div>
		
		    <!-- 오른쪽: 리뷰 정보 -->
		    <div class="right-block">
		      <div class="card-body">
		        <div>나의 평점</div>
		        <p class="stars">
		          <%
		            for (int i = 1; i <= 5; i++) {
		              out.print(i <= review.getRating() ? "★" : "☆");
		            }
		          %>
		        </p>
		        <div>작성한 내용</div>
				<%
				  String content = review.getContent();
				  if (content.length() > 27) {
				    content = content.substring(0, 27) + "...";
				  }
				%>
				<div class="review-content"><%= content %></div>
		      </div>
		      <div class="review-actions">
		        <small>작성일: <%= review.getCreatedAt() %></small>
		        <div>
			        <button type="button" class="btn btn-sm btn-warning"
			                onclick="openEditPopup(<%= review.getReviewId() %>)">✏️ 수정</button>
			        <a href="review_delete.jsp?review_id=<%= review.getReviewId() %>"
			           class="btn btn-sm btn-danger"
			           onclick="return confirm('정말로 이 소중한 리뷰를 삭제하시겠어요? 🥺');">🗑️ 삭제</a>
		        </div>
		      </div>
		    </div>
		
		</div>
		<%
		}
		if (reviews.isEmpty()) {
		%>
		<div class="no-reviews">아직 작성한 리뷰가 없어요</div>
		<%
		}
		%>
	</div>
</div>

<script>
  function openEditPopup(reviewId) {
    const url = "review_edit.jsp?review_id=" + reviewId;
    const options = "width=700,height=600,scrollbars=yes,resizable=no";
    window.open(url, "리뷰수정", options);
  }

  // 버튼 클릭 효과
  document.addEventListener('click', function(e) {
    if (e.target.classList.contains('btn')) {
      e.target.classList.add('clicked');
      setTimeout(() => {
        e.target.classList.remove('clicked');
      }, 200);
    }
  });

  // 페이지 로드 시 카드 애니메이션 순차 실행
  document.addEventListener('DOMContentLoaded', function() {
    const cards = document.querySelectorAll('.review-card');
    cards.forEach((card, index) => {
      card.style.animationDelay = `${index * 0.1}s`;
    });
  });
</script>

<%@ include file="../common/footer.jsp"%>
</body>
</html>