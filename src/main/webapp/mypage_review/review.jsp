<%@page import="review.ReviewService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

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
 
.nav a {
    font-size: 18px;
    font-weight: 700;
    color: #212121;
  }
a { text-decoration:none; color:inherit; }
  ul { list-style:none; }
    .container { max-width: 800px; margin: 50px auto; }
  
    .options li.active { background-color: #ffe6e6; }
    .starRed { color: #f42; }
    .starGrey { color: #ccc;  margin-left: 0; }
    .stat-box { background: #f9f9f9; padding: 20px; border-radius: 10px; margin-top: 20px; }
    .bar-row { display: flex; align-items: center; margin: 8px 0; }
    .bar-row span { width: 40px; }
    .bar { flex: 1; height: 10px; background: #ddd; border-radius: 5px; margin-left: 10px; }
    .bar-fill { background: #f42; height: 100%; border-radius: 5px; }
    .ratingAvg { font-size: 24px; font-weight: bold; text-align: center; margin: 15px 0; }
    .star-svg { width: 120px; height: 24px; display: block; margin: 0 auto; }
    .star-shape { fill: lightgray; }
    .star-fill { fill: #f42; }
    .dropdown {
  font-size: 14px;
  text-align: left;
  position: relative;
  display: inline-block;
  min-width: auto;
  user-select: none;
  cursor: pointer;
}

.selected {
  border: 1px solid #aaa;
  border-radius: 5px;
  padding: 8px 12px;
  background: #fff;
  white-space: nowrap;
  display: inline-flex;
  align-items: center;
  gap: 5px;
}

.options {
  list-style: none;
  padding-left: 0;
  margin: 0;
  display: none;
  position: absolute;
  top: 100%;
  left: 0;
  background: white;
  border: 1px solid #aaa;
  z-index: 10;
  border-radius: 5px;
  max-height: 200px;
  overflow-y: auto;
  min-width: 100%;
}

.options li {
  padding: 8px 12px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  white-space: nowrap;
}

.options li:hover {
  background-color: #f1f1f1;
}
  </style>



<div class="review-container">
  <div class="container">
    <!-- 드롭다운 -->
    <div class="dropdown" id="ratingDropdown">
      <div class="selected">전체 평점 보기 ▼</div>
      <ul class="options">
        <li class="active" data-value="0">전체 평점 보기</li>
        <li data-value="5">최고<span class="starRed">★ ★ ★ ★ ★</span></li>
        <li data-value="4">좋음<span class="starRed">★ ★ ★ ★</span><span class="starGrey">★</span></li>
        <li data-value="3">보통<span class="starRed">★ ★ ★</span><span class="starGrey">★ ★</span></li>
        <li data-value="2">별로<span class="starRed">★ ★</span><span class="starGrey">★ ★ ★</span></li>
        <li data-value="1">나쁨<span class="starRed">★</span><span class="starGrey">★ ★ ★ ★</span></li>
      </ul>
    </div>

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

    <!-- 리뷰 목록 (AJAX 대상) -->
    <div id="reviewListContainer" class="mt-4">
      <jsp:include page="review_process.jsp">
        <jsp:param name="productId" value="${productId}" />
        <jsp:param name="rating" value="" />
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
      selected.innerHTML = li.innerHTML + " ▼";
      options.querySelectorAll('li').forEach(item => item.classList.remove('active'));
      li.classList.add('active');
      options.style.display = 'none';

      const ratingValue = li.dataset.value || '';
      const productId = '<c:out value="${productId}" />';

      $.ajax({
        url: 'review_process.jsp',
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


