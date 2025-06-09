<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="review.*, order.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/common/login_chk.jsp" %>

<link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>

<%
  request.setCharacterEncoding("UTF-8");
  int reviewId = Integer.parseInt(request.getParameter("review_id"));
  ReviewService reviewService = new ReviewService();
  ReviewDTO review = reviewService.getReviewById(reviewId);
  OrderItemDTO item = new OrderService().getOrderItemDetail(review.getOrderItemId());
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <c:import url="../common/external_file.jsp"/>
  <title>리뷰 수정 | Donutted</title>
  <style>
    body {
      font-family: 'Pretendard', sans-serif;
      margin: 0;
      padding: 20px;
      background-color: #fff;
    }

    .container {
      max-width: 500px;
      margin: 0 auto;
      border: 1px solid #ddd;
      padding: 20px;
    }

    .product-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
    }

    .product-info {
      display: flex;
	  align-items: center;
    }

    .product-img {
      max-width: 35px;
      max-height: 35px;
      margin-right: 10px;
      border-radius: 4px;
      object-fit: cover;
    }

	.product-text {
		font-size: 1.1em;
	}

    .product-text p {
      margin: 0;
    }

    .divider {
      border-top: 1px solid #ccc;
      margin: 20px 0;
    }

    textarea {
      width: 100%;
      padding: 8px;
      resize: vertical;
    }

    .char-counter {
      text-align: right;
      font-size: 12px;
      color: #666;
    }

    .file-label {
      display: inline-flex;
      width: 60px;
      height: 60px;
      border: 1px dashed #ccc;
      justify-content: center;
      align-items: center;
      font-size: 24px;
      cursor: pointer;
    }

    .review-img {
      width: 200px;
      height: 200px;
      object-fit: contain;
      border-radius: 4px;
      margin-top: 10px;
    }

    .star-rating {
      font-size: 24px;
      cursor: pointer;
    }

    .star {
      color: #ccc;
    }

    .star.selected {
      color: gold;
    }

    .submit-btn {
      background-color: pink;
      border: none;
      padding: 10px 20px;
      font-weight: bold;
      color: white;
      cursor: pointer;
    }

    .note {
      font-size: 12px;
      color: #666;
    }
    
    .setPadBot {
    	padding-bottom: 20px
    }
    
    .image-row {
	  display: flex;
	  align-items: center;
	  gap: 12px;
	  margin-top: 10px;
	}
	
	.mg-10 {
	  margin-top: 10px;
	}
  </style>
</head>
<body>
  <div class="container">
    <!-- 상품 정보 -->
    <header class="product-header">
      <div class="product-info">
        <img src="/mall_prj/admin/common/images/products/<%= item.getThumbnailUrl() %>" alt="상품 이미지" class="product-img">
        <div class="product-text">
          <p><strong><%= item.getProductName() %></strong></p>
        </div>
      </div>
    </header>

    <div class="divider"></div>

    <!-- 인사말 -->
    <p style="font-size: 0.8em" class="setPadBot">고객님, 구매 상품은 어떠셨나요?</p>

    <!-- 수정 폼 -->
    <form action="review_update.jsp" method="post" enctype="multipart/form-data">
      <input type="hidden" name="review_id" value="<%= review.getReviewId() %>">
      <input type="hidden" name="rating" id="ratingInput" value="<%= review.getRating() %>">

      <!-- 평점 -->
      <div class="section setPadBot">
        <label><strong>만족도</strong></label>
        <div id="stars" class="star-rating">
          <% int currentRating = review.getRating();
             for (int i = 1; i <= 5; i++) { %>
            <span class="star <%= i <= currentRating ? "selected" : "" %>" data-value="<%= i %>">★</span>
          <% } %>
        </div>
      </div>

      <!-- 내용 -->
      <div class="section setPadBot">
        <label><strong>리뷰 작성란</strong></label>
        <textarea name="content" rows="4" maxlength="200" required style="width: 100%; box-sizing: border-box;"><%= review.getContent() %></textarea>
        <div class="char-counter"><span id="charCount">0</span>/200</div>
      </div>

	<!-- 이미지 -->
	<div class="section setPadBot">
	  <label><strong>사진 첨부</strong></label>
	  <p class="note">
	    사진은 한 장만 첨부할 수 있으며,<br>
	    상품과 상관없는 사진은 첨부된 리뷰는 통보 없이 삭제될 수 있습니다.
	  </p>
	
	  <div class="image-row">
	    <%-- 기존 이미지가 있으면 보여주고, 없으면 display: none --%>
	    <img
	      src="/mall_prj/common/images/review/<%= review.getImageUrl() != null ? review.getImageUrl() : "" %>"
	      class="review-img"
	      id="existingImage"
	      style="display: <%= review.getImageUrl() != null ? "block" : "none" %>;">
	    
	    <img class="review-img" id="previewImg" style="display: none;">
	    <label for="photo-input" class="file-label">+</label>
	    <input type="file" id="photo-input" name="image" accept="image/*" hidden>
	  </div>
	
	  <%-- 삭제 버튼은 항상 출력, 표시 여부만 조건 처리 --%>
	  <button type="button" id="deleteImageBtn" class="mg-10"
	    style="display: <%= review.getImageUrl() != null ? "inline-block" : "none" %>;">
	    기존 사진 삭제
	  </button>
	
	  <input type="hidden" name="delete_image" id="deleteImageFlag" value="false">
	</div>

      <!-- 제출 -->
      <div style="text-align: center; margin-top: 20px;">
        <button type="submit" class="submit-btn">리뷰 수정하기</button>
      </div>
    </form>
  </div>

<script>
  const stars = document.querySelectorAll('.star');
  const ratingInput = document.getElementById('ratingInput');
  // 별점 선택 로직
  stars.forEach(star => {
    star.addEventListener('click', () => {
      const value = star.getAttribute('data-value');
      ratingInput.value = value;
      stars.forEach(s => {
        s.classList.toggle('selected', s.getAttribute('data-value') <= value);
      });
    });
  });

  const charCount = document.getElementById('charCount');
  const textarea = document.querySelector('textarea');
  // 텍스트 입력 길이 실시간 표시
  textarea.addEventListener('input', () => {
    charCount.textContent = textarea.value.length;
  });
  charCount.textContent = textarea.value.length;

  // 사진 관련 요소
  const deleteImageBtn = document.getElementById("deleteImageBtn");
  const deleteImageFlag = document.getElementById("deleteImageFlag");
  const existingImage = document.getElementById("existingImage");
  const fileLabel = document.querySelector(".file-label");
  const previewImg = document.getElementById("previewImg");

  previewImg.className = "review-img";
  previewImg.style.display = "none";

  // 기존 이미지 삭제 버튼 클릭 시
  if (deleteImageBtn) {
    deleteImageBtn.addEventListener("click", () => {
      if (existingImage) {
        existingImage.style.display = "none";
      }
      deleteImageBtn.style.display = "none";
      previewImg.style.display = "none";
      deleteImageFlag.value = "true";
      fileLabel.style.display = "inline-flex";
    });
  }

  let photoInput = document.getElementById("photo-input"); // let으로 바꿈
  // 이미지 선택 처리
  function onPhotoChange() {
    const file = photoInput.files[0];
    if (file && file.type.startsWith("image/")) {
      const reader = new FileReader();
      reader.onload = function (e) {
        previewImg.src = e.target.result;
        previewImg.style.display = "block";
        if (existingImage) {
          existingImage.style.display = "none";
        }
        deleteImageFlag.value = "false";
        if (deleteImageBtn) {
          deleteImageBtn.style.display = "inline-block";
        }
      };
      reader.readAsDataURL(file);
    } else {
      previewImg.style.display = "none";
      fileLabel.style.display = "inline-flex";
	  if (existingImage) {
	    existingImage.style.display = "block";
	  }
    }
  }
  
  // 초기 이벤트 연결
  photoInput.addEventListener("change", onPhotoChange);
  
  // 새 파일 input으로 교체
  function replacePhotoInput() {
    const newInput = document.createElement("input");
    newInput.type = "file";
    newInput.id = "photo-input";
    newInput.name = "image";
    newInput.accept = "image/*";
    newInput.hidden = true;

    photoInput.parentNode.replaceChild(newInput, photoInput);
    photoInput = newInput;
    photoInput.addEventListener("change", onPhotoChange);
  }

  // + 버튼(label) 클릭 시 input 교체
  fileLabel.addEventListener("click", () => {
    replacePhotoInput();
  });
</script>
</body>
</html>
