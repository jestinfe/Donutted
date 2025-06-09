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

    body {
      font-family: 'Pretendard', sans-serif;
      margin: 0;
      padding: 20px;
      background: linear-gradient(135deg, var(--background-cream) 0%, #fef4f6 100%);
      color: var(--text-pink);
      line-height: 1.6;
      min-height: 100vh;
    }

    .container {
      max-width: 500px;
      margin: 0 auto;
      background: var(--card-bg);
      border: 2px solid var(--border-pink);
      border-radius: 20px;
      padding: 30px;
      box-shadow: 
        0 8px 32px var(--shadow-pink),
        0 2px 8px rgba(0, 0, 0, 0.05);
      position: relative;
      animation: fadeInUp 0.6s ease-out;
    }

    @keyframes fadeInUp {
      from {
        opacity: 0;
        transform: translateY(20px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }



    .product-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 20px;
    }

    .product-info {
      display: flex;
      align-items: center;
    }

    .product-img {
      max-width: 45px;
      max-height: 45px;
      margin-right: 15px;
      border-radius: 8px;
      object-fit: cover;
      box-shadow: 0 4px 12px rgba(248, 187, 217, 0.2);
      border: 2px solid var(--border-pink);
      transition: all 0.3s ease;
    }

    .product-img:hover {
      transform: scale(1.05);
      box-shadow: 0 6px 16px rgba(248, 187, 217, 0.3);
    }

    .product-text {
      font-size: 1.1em;
      font-weight: 600;
      color: var(--text-pink);
    }

    .product-text p {
      margin: 0;
    }

    .divider {
      border-top: 2px dashed var(--border-pink);
      margin: 25px 0;
    }

    .section {
      margin-bottom: 25px;
    }

    .section label {
      display: block;
      margin-bottom: 10px;
      font-weight: 600;
      color: var(--text-pink);
      font-size: 1.05rem;
    }

    textarea {
      width: 100%;
      padding: 15px;
      resize: vertical;
      border: 2px solid var(--border-pink);
      border-radius: 12px;
      font-family: 'Pretendard', sans-serif;
      font-size: 0.95rem;
      color: var(--text-pink);
      background: linear-gradient(135deg, var(--accent-cream), #fdf0f2);
      transition: all 0.3s ease;
      line-height: 1.5;
    }

    textarea:focus {
      outline: none;
      border-color: var(--primary-pink);
      box-shadow: 0 0 0 3px rgba(248, 187, 217, 0.2);
    }

    .char-counter {
      text-align: right;
      font-size: 0.85rem;
      color: var(--text-soft);
      margin-top: 8px;
      font-weight: 500;
    }

	.file-label {
	  position: relative; /* 내부 span 정렬을 위한 설정 */
	  display: flex;
	  width: 70px;
	  height: 70px;
	  border: 2px dashed var(--border-pink);
	  border-radius: 12px;
	  justify-content: center;
	  align-items: center;
	  font-size: 28px;
	  cursor: pointer;
	  color: var(--text-soft);
	  background: var(--accent-cream);
	  transition: all 0.3s ease;
	  line-height: 1;
	  text-align: center;
	  font-family: 'Pretendard', sans-serif;
	  font-weight: 600;
	}

    .file-label:hover {
      border-color: var(--primary-pink);
      background: var(--primary-pink-light);
      color: var(--text-pink);
      transform: scale(1.05);
    }

    .review-img {
      width: 200px;
      height: 200px;
      object-fit: contain;
      border-radius: 12px;
      margin-top: 10px;
      box-shadow: 0 6px 20px rgba(248, 187, 217, 0.2);
      border: 2px solid var(--border-pink);
      transition: all 0.3s ease;
    }

    .review-img:hover {
      transform: scale(1.02);
      box-shadow: 0 8px 25px rgba(248, 187, 217, 0.3);
    }

    .star-rating {
      font-size: 32px;
      cursor: pointer;
      margin: 10px 0;
      letter-spacing: 4px;
    }

    .star {
      color: #e0e0e0;
      transition: all 0.2s ease;
      text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .star:hover {
      transform: scale(1.1);
    }

    .star.selected {
      color: #ff9ec7;
      text-shadow: 0 2px 6px rgba(255, 158, 199, 0.4);
    }

    .submit-btn {
      background: linear-gradient(135deg, var(--primary-pink), var(--secondary-pink));
      border: none;
      padding: 15px 30px;
      font-weight: 700;
      color: white;
      cursor: pointer;
      border-radius: 25px;
      font-size: 1.1rem;
      font-family: 'Pretendard', sans-serif;
      box-shadow: 0 4px 15px rgba(248, 187, 217, 0.4);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      position: relative;
      overflow: hidden;
    }

    .submit-btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(248, 187, 217, 0.5);
      background: linear-gradient(135deg, var(--secondary-pink), var(--primary-pink));
    }

    .submit-btn:active {
      transform: translateY(0);
    }

    .note {
      font-size: 0.85rem;
      color: var(--text-soft);
      background: var(--accent-cream);
      padding: 12px 15px;
      border-radius: 10px;
      border-left: 4px solid var(--primary-pink-light);
      margin: 10px 0;
      line-height: 1.5;
    }
    
    .setPadBot {
      padding-bottom: 20px;
    }
    
    .image-row {
      display: flex;
      align-items: center;
      gap: 15px;
      margin-top: 15px;
    }
    
    .mg-10 {
      margin-top: 15px;
      padding: 8px 16px;
      background: linear-gradient(135deg, var(--accent-rose), #f2b3c4);
      color: white;
      border: none;
      border-radius: 20px;
      cursor: pointer;
      font-size: 0.9rem;
      font-weight: 600;
      transition: all 0.3s ease;
      box-shadow: 0 3px 10px rgba(244, 194, 194, 0.3);
    }

    .mg-10:hover {
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(244, 194, 194, 0.4);
      background: linear-gradient(135deg, #f2b3c4, var(--accent-rose));
    }

    .greeting {
      font-size: 0.9em;
      color: var(--text-soft);
      background: var(--accent-cream);
      padding: 15px;
      border-radius: 12px;
      margin-bottom: 25px;
      border-left: 4px solid var(--primary-pink-light);
      position: relative;
    }

    .greeting::before {
      content: '💭';
      position: absolute;
      top: 15px;
      right: 15px;
      font-size: 1.2em;
    }

    /* 반응형 디자인 */
    @media (max-width: 600px) {
      .container {
        margin: 10px;
        padding: 20px;
        max-width: none;
      }
      
      .review-img {
        width: 150px;
        height: 150px;
      }
      
      .star-rating {
        font-size: 28px;
        letter-spacing: 2px;
      }
      
      .submit-btn {
        width: 100%;
        padding: 12px;
      }
    }

    /* 스크롤바 스타일링 */
    ::-webkit-scrollbar {
      width: 6px;
    }

    ::-webkit-scrollbar-track {
      background: var(--accent-cream);
      border-radius: 3px;
    }

    ::-webkit-scrollbar-thumb {
      background: var(--primary-pink-light);
      border-radius: 3px;
    }

    ::-webkit-scrollbar-thumb:hover {
      background: var(--primary-pink);
    }
    
    .plus-icon {
	  position: absolute;
	  top: 50%;
	  left: 50%;
	  transform: translate(-50%, -50%);
	  font-size: 28px;
	  font-family: 'Pretendard', sans-serif;
	  font-weight: 600;
	  color: var(--text-soft);
	  pointer-events: none;
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
    <div class="greeting">고객님, 구매 상품은 어떠셨나요?</div>

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
          <label for="photo-input" class="file-label">
          	  <span class="plus-icon">+</span>
          </label>
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
        <button type="submit" class="submit-btn">✏️ 리뷰 수정하기</button>
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