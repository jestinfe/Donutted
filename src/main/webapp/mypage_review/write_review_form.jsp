<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="order.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/common/login_chk.jsp" %>

<link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>

<%
  request.setCharacterEncoding("UTF-8");
  int orderItemId = Integer.parseInt(request.getParameter("order_item_id"));
  OrderItemDTO item = new OrderService().getOrderItemDetail(orderItemId);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <c:import url="../common/external_file.jsp"/>
  <title>리뷰 작성</title>
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
      box-sizing: border-box;
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
      padding-bottom: 20px;
    }

    .image-row {
      display: flex;
      align-items: center;
      gap: 12px;
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

    <!-- 작성 폼 -->
    <form id="reviewForm" action="review_submit.jsp" method="post" enctype="multipart/form-data">
      <input type="hidden" name="order_item_id" value="<%= orderItemId %>">
      <input type="hidden" name="rating" id="ratingInput" value="0">

      <!-- 평점 -->
      <div class="section setPadBot">
        <label><strong>만족도</strong></label>
        <div id="stars" class="star-rating">
          <% for (int i = 1; i <= 5; i++) { %>
            <span class="star" data-value="<%= i %>">★</span>
          <% } %>
        </div>
      </div>

      <!-- 내용 -->
      <div class="section setPadBot">
        <label><strong>리뷰 작성란</strong></label>
        <textarea name="content" rows="4" maxlength="200"></textarea>
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
          <img class="review-img" id="previewImg" style="display: none;">
          <label for="photo-input" class="file-label">+</label>
          <input type="file" id="photo-input" name="image" accept="image/*" hidden>
        </div>
      </div>
	  <button type="button" id="deleteImageBtn" style="display: none; margin-top: 10px;">사진 삭제</button>
      <!-- 제출 -->
      <div style="text-align: center; margin-top: 20px;">
        <button type="submit" class="submit-btn">리뷰 작성하기</button>
      </div>
    </form>
  </div>

<script>
	// 별점 선택
	const stars = document.querySelectorAll('.star');
	const ratingInput = document.getElementById('ratingInput');
	stars.forEach(star => {
	  star.addEventListener('click', () => {
	    const value = star.getAttribute('data-value');
	    ratingInput.value = value;
	    stars.forEach((s) => {
	      s.classList.toggle('selected', s.getAttribute('data-value') <= value);
	    });
	  });
	});
	
	// 글자 수 실시간 반영
	const charCount = document.getElementById('charCount');
	const textarea = document.querySelector('textarea');
	textarea.addEventListener('input', () => {
	  charCount.textContent = textarea.value.length;
	});

  const previewImg = document.getElementById("previewImg");
  const deleteImageBtn = document.getElementById("deleteImageBtn");
  const fileLabel = document.querySelector(".file-label");
  let photoInput = document.getElementById("photo-input");

  previewImg.className = "review-img";

  function bindPhotoInput(input) {
    input.addEventListener("change", () => {
      const file = input.files[0];

      if (file && file.type.startsWith("image/")) {
        const reader = new FileReader();
        reader.onload = function (e) {
          previewImg.src = e.target.result;
          previewImg.style.display = "block";
          deleteImageBtn.style.display = "inline-block";
        };
        reader.readAsDataURL(file);
      } else if (!file) {
        // 선택 후 아무 것도 선택 안 하고 창 닫은 경우: 미리보기 유지
        return;
      } else {
        // 이미지가 아닌 파일
        previewImg.style.display = "none";
        deleteImageBtn.style.display = "none";
      }
    });
  }

  bindPhotoInput(photoInput);

  function replacePhotoInput() {
    const newInput = document.createElement("input");
    newInput.type = "file";
    newInput.name = "image";
    newInput.id = "photo-input";
    newInput.accept = "image/*";
    newInput.hidden = true;
    fileLabel.after(newInput);
    photoInput.remove();
    photoInput = newInput;
    bindPhotoInput(photoInput);
  }

  deleteImageBtn.addEventListener("click", () => {
    previewImg.src = "";
    previewImg.style.display = "none";
    deleteImageBtn.style.display = "none";
    replacePhotoInput();
  });
  
  fileLabel.addEventListener("click", () => {
	  e.preventDefault();  
	  
	  replacePhotoInput();  // (1) input 교체
	  setTimeout(() => {    // (2) 이벤트 큐로 밀어넣음
	    photoInput.click(); // (3) input 교체가 끝난 다음 주기에 실행됨 ✅
	  }, 0);
	});
</script>
</body>
</html>
