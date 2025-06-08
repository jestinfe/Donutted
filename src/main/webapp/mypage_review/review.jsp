<%@page import="review.ReviewService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>

<%

  int productId = Integer.parseInt(request.getParameter("productId"));
  request.setAttribute("productId", productId);

  ReviewService rs = new ReviewService();
  int reviewCount = rs.countReviewsByProductIdAndRating(productId, 0);
  // 임시 데이터 (Service에서 가져오도록 구현 필요)
  request.setAttribute("reviewAvg",rs.getAverageRatingByProductId(productId) );
  request.setAttribute("reviewCount", reviewCount);
  int star = 5;
  while (star >= 1) {
      int count = rs.countReviewsByProductIdAndRating(productId, star);
      int percent = reviewCount > 0 ? (int) Math.round(count * 100.0 / reviewCount) : 0;

      // setAttribute 설정 (review5percent ~ review1percent)
      request.setAttribute("review" + star + "percent", percent);

      star--;
  }
%>

 

  <style>
 

a { text-decoration:none; color:inherit; }
  ul { list-style:none; }
    .container { max-width: 800px; margin: 50px auto; }
  
    .options li.active { background-color: #ffe6e6; }
    .starRed { color: #f42; }
    .starGrey { color: #ccc;  margin-left: 0; }
    .stat-box { background: #f9f9f9; padding: 20px; border-radius: 10px; margin-top: 20px; max-width: 700px; text-align: center; margin-left: auto; margin-right: auto;}
    .bar-row { display: flex; align-items: center; margin: 8px 0; }
    .bar-row span { width: 40px; }
    .bar { flex: 1; height: 10px; background: #ddd; border-radius: 5px; margin-left: 10px; }
    .bar-fill { background: #f42; height: 100%; border-radius: 5px; }
    .ratingAvg { font-size: 24px; font-weight: bold; text-align: center; margin: 15px 0; }
    .star-svg { width: 120px; height: 24px; display: block; margin: 0 auto; }
    .star-shape { fill: lightgray; }
    .star-fill { fill: #f42; }
    .dropdown {
      font-size: 12px;
      text-align: left;
      position: relative;
      width: 120px;
      user-select: none;
      cursor: pointer;
    }

    .selected {
      border: 1px solid #aaa;
      border-radius: 5px;
      padding: 12px;
      background: #fff;
    }
    
    .selected:hover {
      border-color: black;
    }

    .options {
      list-style: none;
      padding-left: 0;
      display: none;
      position: absolute;
      margin-top: 2px;
      top: 100%;
      left: 0;
      right: 0;
      background: white;
      border: 1px solid #aaa;
      z-index: 10;
      border-radius: 5px;
      max-height: none;
      overflow-y: visible;
    }

    .options li {
      padding: 10px;
      display: flex;
      justify-content: space-between;
    }

    .options li.active {
      background-color: #f5f5f5;
      font-weight: bold;
    }
    
    .options li:hover {
      background-color: #f0f0f0;
    }

	.starRed {
	  color: #f42;
	}
	
	.starGrey {
	  color: #ccc;
	}
  </style>



<div class="review-container">
  <div class="container">


    <!-- 별점 통계 -->
    <div class="stat-box">
      <svg viewBox="0 0 100 20" class="star-svg">
        <defs>
          <clipPath id="starClip">
            <rect x="0" y="0" width="90" height="20" id="starClipRect" />
          </clipPath>
        </defs>
        <text x="0" y="17" font-size="20" class="star-shape">★★★★★</text>
        <text x="0" y="17" font-size="20" class="star-fill" clip-path="url(#starClip)">★★★★★</text>
      </svg>
      <div class="ratingAvg"><fmt:formatNumber value="${reviewAvg}" maxFractionDigits="1" /> / 5.0</div>
      <p class="text-center text-muted">구매평 ${reviewCount}개</p>

      <div class="bar-row"><span>5점</span><div class="bar"><div class="bar-fill" style="width:${review5percent}%"></div></div></div>
      <div class="bar-row"><span>4점</span><div class="bar"><div class="bar-fill" style="width:${review4percent}%"></div></div></div>
      <div class="bar-row"><span>3점</span><div class="bar"><div class="bar-fill" style="width:${review3percent}%"></div></div></div>
      <div class="bar-row"><span>2점</span><div class="bar"><div class="bar-fill" style="width:${review2percent}%"></div></div></div>
      <div class="bar-row"><span>1점</span><div class="bar"><div class="bar-fill" style="width:${review1percent}%"></div></div></div>
    </div>
    
	<!-- 드롭다운 위치 조정 -->
	<div style="display: flex; justify-content: flex-end; padding-top: 30px;">
	  <div class="dropdown" id="ratingDropdown">
	    <div class="selected">전체 평점 보기</div>
	    <ul class="options">
	      <li class="active" data-value="0">전체 평점 보기 <span></span></li>
	      <li data-value="5">최고 <span><span class="starRed">★★★★★</span></span></li>
	      <li data-value="4">좋음 <span><span class="starRed">★★★★</span><span class="starGrey">★</span></span></li>
	      <li data-value="3">보통 <span><span class="starRed">★★★</span><span class="starGrey">★★</span></span></li>
	      <li data-value="2">별로 <span><span class="starRed">★★</span><span class="starGrey">★★★</span></span></li>
	      <li data-value="1">나쁨 <span><span class="starRed">★</span><span class="starGrey">★★★★</span></span></li>
	    </ul>
	  </div>
	</div>

    <!-- 리뷰 목록 (AJAX 대상) -->
    <div id="reviewListContainer" class="mt-4">
      <jsp:include page="review_process.jsp">
        <jsp:param name="productId" value="${productId}" />
        <jsp:param name="rating" value="0" />
      </jsp:include>
    </div>
  </div>
  </div>

<script>
  const dropdown = document.getElementById('ratingDropdown');
  const selected = dropdown.querySelector('.selected');
  const options = dropdown.querySelector('.options');

  selected.addEventListener('click', (e) => {
    e.stopPropagation();
    options.style.display = options.style.display === 'block' ? 'none' : 'block';
  });

  options.addEventListener('click', (e) => {
    const li = e.target.closest('li');
    if (li) {
      selected.innerHTML = li.innerHTML;
      options.querySelectorAll('li').forEach(item => item.classList.remove('active'));
      li.classList.add('active');
      options.style.display = 'none';

      const ratingValue = li.dataset.value || '';
      const productId = '<c:out value="${productId}" />';

      $.ajax({
        url: '../mypage_review/review_process.jsp',
        data: { productId: productId, rating: ratingValue },
        success: function(data) {
          $('#reviewListContainer').html(data);
        }
      });
    }
  });

  document.addEventListener('click', (e) => {
    if (!dropdown.contains(e.target)) options.style.display = 'none';
  });

  const ratingAvg = ${reviewAvg};
  const percentage = Math.floor(ratingAvg * 20); // 5점 만점 → 100%
  document.getElementById("starClipRect").setAttribute("width", percentage);
</script>


