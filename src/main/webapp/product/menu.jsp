<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="wishlist.WishListDTO"%>
<%@page import="wishlist.WishService"%>
<%@page import="java.util.HashSet"%>
<%@page import="product.ProductDTO"%>
<%@ page import="java.util.List" %>
<%@ page import="product.ProductService" %>
<%@ page import="product.CategoryService" %>
<%@ page import="product.CategoryDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:import url="../common/external_file.jsp"/>
<%
Integer userId = (Integer)session.getAttribute("userId");
HashSet<Integer> wishProductId = new HashSet<>();

if(userId != null){
  WishService ws = new WishService();
  List<WishListDTO> wishList = ws.showWishList(userId);
  for(WishListDTO w : wishList){
    wishProductId.add(w.getProductId());
  }
}
request.setAttribute("wishProductId", wishProductId);

String sort = request.getParameter("sort");
int categoryId = request.getParameter("categoryId") != null
    ? Integer.parseInt(request.getParameter("categoryId"))
    : 0;
ProductService ps = new ProductService();
List<ProductDTO> products = categoryId > 0
        ? ps.getProductsByCategory(categoryId, sort)
        : ps.getAllProducts(sort);
CategoryService cs = new CategoryService();
List<CategoryDTO> categories = cs.getAllCategories();
request.setAttribute("products", products);
request.setAttribute("categories", categories);
request.setAttribute("currentCategoryId", categoryId);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>고객 메뉴 | Donutted</title>
   <c:if test="${not empty sessionScope.toast}">
  <div id="toast-msg" style="
      position: fixed;
      top: 30px;
      left: 50%;
      transform: translateX(-50%);
      background-color: #f8a6c9;
      color: white;
      padding: 14px 24px;
      border-radius: 30px;
      font-size: 16px;
      font-weight: bold;
      z-index: 9999;
      opacity: 0;
      transition: opacity 0.5s ease-in-out;
  ">
    ${sessionScope.toast}
  </div>
  <%
    session.removeAttribute("toast");  // 1회용으로 제거
  %>
  <script>
    const toast = document.getElementById("toast-msg");
    if (toast) {
      toast.style.opacity = "1";
      setTimeout(() => {
        toast.style.opacity = "0";
        setTimeout(() => {
            toast.remove();  // DOM에서 제거
          }, 500);  // transition 시간만큼 기다려서 지움
      }, 1500);
    }
  </script>
</c:if>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  
  <style>
    .low-stock-label {
      margin-top: 6px;
      padding: 4px 10px;
      background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
      color: #d97706;
      font-size: 12px;
      font-weight: 600;
      border-radius: 8px;
      text-align: center;
    }
    .sold-out-img {
  filter: grayscale(100%) brightness(0.85);
  opacity: 0.6;
}
.sold-out-overlay {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background: #ef4444;
  color: white;
  padding: 10px 20px;
  border-radius: 12px;
  font-size: 14px;
  font-weight: 700;
  box-shadow: 0 4px 16px rgba(239, 68, 68, 0.4);
  z-index: 10;
}
    *, *::before, *::after {
      box-sizing: border-box;
    }

    :root {
      --primary-color: #F8A5C2;
      --primary-gradient: linear-gradient(135deg, #F8A5C2, #FFB6C1);
      --secondary-color: #F8F9FA;
      --text-dark: #2C3E50;
      --text-light: #6C757D;
      --card-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
      --card-hover-shadow: 0 16px 48px rgba(0, 0, 0, 0.15);
      --border-radius: 20px;
      --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    /* 이 부분은 유지됩니다. */
    body {
      background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
      font-family: 'Noto Sans KR', sans-serif;
      color: var(--text-dark);
      line-height: 1.6;
      min-height: 100vh;
    }

    /* 변경: 컨테이너 최대 너비 제거 및 width: 100% */
    .container {
   width: 100% !important;
  max-width: 93% !important;
  margin: 0 auto;
 padding: 0 20px;
  box-sizing: border-box;
}

    /* Category Bar - 더 큰 크기 */
    .category-bar {
      display: flex;
      justify-content: center;
      gap: 20px;
      flex-wrap: wrap;
      padding: 50px 0 40px;
      margin-bottom: 20px;
    }

    .category-bar a {
      padding: 18px 35px;
      background: rgba(255, 255, 255, 0.9);
      backdrop-filter: blur(10px);
      border: 2px solid transparent;
      border-radius: 50px;
      font-size: 18px;
      font-weight: 600;
      color: var(--text-dark);
      text-decoration: none;
      transition: var(--transition);
      position: relative;
      overflow: hidden;
      min-width: 120px;
      text-align: center;
    }

    .category-bar a::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: var(--primary-gradient);
      transition: var(--transition);
      z-index: -1;
    }

    .category-bar a:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(248, 165, 194, 0.3);
      border-color: var(--primary-color);
    }

    .category-bar a:hover::before {
      left: 0;
    }

    .category-bar a:hover {
      color: white;
    }

    .category-bar a.selected {
      background: var(--primary-gradient);
      color: white;
      border-color: var(--primary-color);
      box-shadow: 0 8px 25px rgba(248, 165, 194, 0.4);
      transform: translateY(-2px);
    }

    .category-bar a.selected::before {
      left: 0;
    }

    /* Sort Box - Enhanced */
    .sort-box {
      display: flex;
      justify-content: flex-end;
      padding: 0 20px 30px;
    }

    .sort-box select {
      padding: 12px 20px;
      font-size: 14px;
      font-weight: 500;
      border: 2px solid rgba(255, 255, 255, 0.8);
      border-radius: 25px;
      background: rgba(255, 255, 255, 0.9);
      backdrop-filter: blur(10px);
      color: var(--text-dark);
      cursor: pointer;
      transition: var(--transition);
      appearance: none;
      background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
      background-position: right 12px center;
      background-repeat: no-repeat;
      background-size: 16px;
      padding-right: 40px;
    }

    .sort-box select:focus {
      outline: none;
      border-color: var(--primary-color);
      box-shadow: 0 0 0 4px rgba(248, 165, 194, 0.1);
    }

    /* Product Grid - 5개씩 배열 (유지) */
  .product-grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);  /* 💡 항상 5열 */
  gap: 24px;
  width: 100%;
  padding: 0 20px;
  box-sizing: border-box;
}



    /* Product Card - 세로 길이 줄이기 */
    .product-card {
      background: rgba(255, 255, 255, 0.95);
      backdrop-filter: blur(20px);
      border: 1px solid rgba(255, 255, 255, 0.3);
      border-radius: var(--border-radius);
      padding: 0;
      overflow: hidden;
      display: flex;
      flex-direction: column;
      box-shadow: var(--card-shadow);
      transition: var(--transition);
      position: relative;
    }

    .product-card::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 4px;
      background: var(--primary-gradient);
      transform: scaleX(0);
      transition: var(--transition);
        z-index: 0;
    }

    .product-card:hover {
      transform: translateY(-12px);
      box-shadow: var(--card-hover-shadow);
    }

    .product-card:hover::before {
      transform: scaleX(1);
    }

    /* 변경: 이미지 높이 줄이기 */
    .product-card img {
  width: 100%;
  height: 300px;          /* 기존보다 ↑ 증가 (ex: 180 → 240) */
  object-fit: cover;
  border-radius: 16px 16px 0 0;
  transition: transform 0.3s ease;
}


    .product-card:hover img {
      transform: scale(1.05);
    }
    
    .product-card:hover img.sold-out-img {
  transform: scale(1);  /* 확대 없음 */
  filter: grayscale(100%) brightness(0.85);
  opacity: 0.6;
}

    /* 변경: Product Info 패딩 및 텍스트 크기 조정 */
    .product-info {
      padding: 15px; /* 기존 20px에서 15px로 줄임 */
      flex: 1;
      display: flex;
      flex-direction: column;
    }

    .product-info h3 {
  font-size: 18px;
  font-weight: 600;
  margin: 10px 0 4px;     /* ✅ 이름 아래 간격 줄임 */
  text-align: center;
}

.price-heart {
  display: flex;
  justify-content: center;
  align-items: center;
  margin: 0 0 10px;       /* ✅ 위 아래 여백 축소 */
  padding: 0;
}


    .price-heart .price {
      font-size: 20px; /* 기존 22px에서 20px로 줄임 */
      font-weight: 700;
      color: var(--primary-color);
      margin: 0;
      text-align: center;
      background: var(--primary-gradient);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }

    .price-heart form {
      position: absolute;
      top: 64%;
      right: 0;
      transform: translateY(-50%);
     
    }

    .heart-btn {
      background: none;
      border: none;
      font-size: 20px; /* 기존 26px에서 22px로 줄임 */
      cursor: pointer;
      transition: var(--transition);
      padding: 6px; /* 기존 8px에서 6px로 줄임 */
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
    }

  .heart-btn:hover {
      transform: scale(1.2);
      background: rgba(248, 165, 194, 0.1);
    }

    /* 변경: Add Button 패딩 조정 */
    .product-info .add-btn {
      background: var(--primary-gradient);
      border: none;
      color: white;
      font-size: 15px; /* 기존 16px에서 15px로 줄임 */
      font-weight: 600;
      cursor: pointer;
      padding: 10px 0; /* 기존 12px에서 10px로 줄임 */
      border-radius: 15px;
      width: 100%;
      text-align: center;
      transition: var(--transition);
      position: relative;
      overflow: hidden;
      margin-top: auto;
    }

    .product-info .add-btn::before {
      content: '';
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background: linear-gradient(135deg, #FFB6C1, #F8A5C2);
      transition: var(--transition);
      z-index: -1;
    }

    .product-info .add-btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(248, 165, 194, 0.4);
    }

    .product-info .add-btn:active {
      transform: translateY(0);
    }

    /* Loading Animation */
    .loading {
      display: flex;
      justify-content: center;
      align-items: center;
      height: 200px;
    }

    .spinner {
      width: 40px;
      height: 40px;
      border: 4px solid rgba(248, 165, 194, 0.1);
      border-left: 4px solid var(--primary-color);
      border-radius: 50%;
      animation: spin 1s linear infinite;
    }

    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }

    /* Responsive Design - 미디어 쿼리 조정 */
    /* 1600px 이하에서는 4개로 줄이기 */
    @media (max-width: 1600px) {
      .product-grid {
        grid-template-columns: repeat(4, 1fr);
      }
    }

    @media (max-width: 1200px) {
      .product-grid {
        grid-template-columns: repeat(3, 1fr);
      }
    }

    @media (max-width: 768px) {
      .container {
        padding: 0 15px;
      }
      
      .product-grid {
        grid-template-columns: repeat(2, 1fr);
        gap: 20px;
        padding: 15px;
      }
      
      .category-bar {
        gap: 12px;
        padding: 30px 0 20px;
      }
      
      .category-bar a {
        padding: 14px 25px;
        font-size: 16px;
        min-width: 100px;
      }
      
      .sort-box {
        padding: 0 15px 25px;
      }

      /* 변경: 반응형에서 이미지 높이 다시 조정 */
      .product-card img {
        height: 180px; 
        position: relative;
  		z-index: 1;
      }

      /* 변경: 반응형에서 H3 높이 다시 조정 */
      .product-info h3 {
        font-size: 16px;
        min-height: 40px;
      }
    }

    @media (max-width: 480px) {
      .product-grid {
        grid-template-columns: 1fr;
        gap: 15px;
      }
      
      .category-bar {
        flex-direction: column;
        align-items: center;
      }

      .category-bar a {
        font-size: 14px;
        padding: 12px 20px;
      }
    }

    /* Animation for page load */
    .product-card {
      animation: fadeInUp 0.8s ease forwards;
      opacity: 0;
      transform: translateY(30px);
    }

    .product-card:nth-child(1) { animation-delay: 0.1s; }
    .product-card:nth-child(2) { animation-delay: 0.2s; }
    .product-card:nth-child(3) { animation-delay: 0.3s; }
    .product-card:nth-child(4) { animation-delay: 0.4s; }
    .product-card:nth-child(5) { animation-delay: 0.5s; }
    .product-card:nth-child(6) { animation-delay: 0.6s; }
    .product-card:nth-child(7) { animation-delay: 0.7s; }
    .product-card:nth-child(8) { animation-delay: 0.8s; }
    .product-card:nth-child(9) { animation-delay: 0.9s; }
    .product-card:nth-child(10) { animation-delay: 1.0s; }

    @keyframes fadeInUp {
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }
    
    /* 품절 이미지 처리 */
.product-card.sold-out img {
  pointer-events: none;     /* 🔒 마우스 이벤트 무시 */
  filter: grayscale(100%) brightness(0.85);
  opacity: 0.6;
  transform: none !important;
}

/* 호버 효과 제거 */
.product-card.sold-out:hover {
  transform: none !important;
  box-shadow: none !important;
}

.product-card.sold-out:hover::before {
  display: none !important;
}

/* 버튼 hover/active 효과도 제거 */
.product-card.sold-out .add-btn {
  pointer-events: none;
  opacity: 0.4;
}
    
  </style>
</head>

<body>
<body style="margin: 0 !important; padding: 0 !important;">
<c:import url="../common/header.jsp" />

<main class="container">
  <div class="category-bar">
    <a href="menu.jsp" class="${currentCategoryId == 0 ? 'selected' : ''}">
      <i class="fas fa-th-large"></i> 전체
    </a>
    <c:forEach var="cat" items="${categories}">
      <a href="menu.jsp?categoryId=${cat.categoryId}" 
         class="${currentCategoryId == cat.categoryId ? 'selected' : ''}">
        ${cat.categoryName}
      </a>
    </c:forEach>
  </div>

  <div class="sort-box">
    <form method="get" action="menu.jsp">
      <input type="hidden" name="categoryId" value="${currentCategoryId}" />
      <select name="sort" onchange="this.form.submit()">
        <option value="">정렬 선택</option>
        <option value="latest" ${param.sort == 'latest' ? 'selected' : ''}>최신 등록순</option>
        <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>가격 낮은순</option>
        <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>가격 높은순</option>
        <option value="name_asc" ${param.sort == 'name_asc' ? 'selected' : ''}>이름 오름차순</option>
        <option value="name_desc" ${param.sort == 'name_desc' ? 'selected' : ''}>이름 내림차순</option>
      </select>
    </form>
  </div>

 <div class="product-grid">
    <c:forEach var="prd" items="${products}">
      <!-- 전체 코드 중 product-card 영역만 수정 -->
<div class="product-card ${prd.stock == 0 ? 'sold-out' : ''}">
  <a href="product_detail.jsp?productId=${prd.productId}">
    <div style="position:relative;">
      <img src="${pageContext.request.contextPath}/admin/common/images/products/${prd.thumbnailImg}"
           class="<c:if test='${prd.stock == 0}'>sold-out-img</c:if>"
           onmouseover="if(this.dataset.error !== 'true' && '${prd.thumbnailHover}' && '${prd.thumbnailHover}' !== 'null') this.src='${pageContext.request.contextPath}/admin/common/images/products/${prd.thumbnailHover}';"
           onmouseout="if(this.dataset.error !== 'true') this.src='${pageContext.request.contextPath}/admin/common/images/products/${prd.thumbnailImg}';"
           onerror="this.onerror=null; this.dataset.error='true'; this.src='${pageContext.request.contextPath}/admin/common/images/default/error.png';"
           data-error="false"
           alt="${prd.name}" />

      <!-- 품절임박 라벨: 이미지 아래 고정 -->
      <c:if test="${prd.stock > 0 && prd.stock <= 5}">
        <div class="low-stock-label" style="
            position: absolute;
            bottom: 8px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 5;">
          품절임박 (${prd.stock}개 남음)
        </div>
      </c:if>

      <c:if test="${prd.stock == 0}">
        <div class="sold-out-overlay">SOLD OUT</div>
      </c:if>
    </div>
  </a>

  <div class="product-info">
    <!-- 이름 + 하트 같은 선상 -->
  <div class="name-heart" style="position: relative; margin: 10px 0;">
  <h3 style="text-align: center; margin: 0;">${prd.name}</h3>

<button type="button"
        class="heart-btn"
        data-product-id="${prd.productId}"
        data-in-wishlist="${wishProductId.contains(prd.productId)}"
          style="position: absolute; right: 0; top: 50%; transform: translateY(-50%); margin: 0;">
  <c:choose>
    <c:when test="${wishProductId.contains(prd.productId)}">
      ❤️
    </c:when>
    <c:otherwise>
      🤍
    </c:otherwise>
  </c:choose>
</button>
</div>


    <div class="price-heart" style="justify-content: center;">
      <p class="price">
        <fmt:formatNumber value="${prd.price}" pattern="#,###" />원
      </p>
    </div>
    
    <button class="add-btn" 
    		type="button"
    		data-product-id="${prd.productId}"
    		>
      <i class="fas fa-shopping-cart"></i> 담기
    </button>
  </div>
  
</div>
    </c:forEach>
  </div>
</main>
<c:import url="../common/footer.jsp" />

<script>

  // 알림 표시 함수
  function showNotification(message) {
    // 알림 요소 생성
    const notification = document.createElement('div');
    notification.innerHTML = 
      <div style="
        position: fixed;
        top: 20px;
        right: 20px;
        background: linear-gradient(135deg, #F8A5C2, #FFB6C1);
        color: white;
        padding: 16px 24px;
        border-radius: 12px;
        box-shadow: 0 8px 32px rgba(0,0,0,0.15);
        z-index: 1000;
        font-weight: 500;
        backdrop-filter: blur(10px);
        animation: slideIn 0.3s ease;
      ">
        <i class="fas fa-check-circle" style="margin-right: 8px;"></i>
        ${message}
      </div>
    ;
    
    document.body.appendChild(notification);
    
    // 3초 후 제거
    setTimeout(() => {
      notification.style.animation = 'slideOut 0.3s ease';
      setTimeout(() => {
        document.body.removeChild(notification);
      }, 300);
    }, 3000);
  }

  // CSS 애니메이션 추가
  const style = document.createElement('style');
  style.textContent = 
    @keyframes slideIn {
      from {
        transform: translateX(100%);
        opacity: 0;
      }
      to {
        transform: translateX(0);
        opacity: 1;
      }
    }
    
    @keyframes slideOut {
      from {
        transform: translateX(0);
        opacity: 1;
      }
      to {
        transform: translateX(100%);
        opacity: 0;
      }
    }
  ;
  document.head.appendChild(style);

  // 페이지 로드 시 부드러운 애니메이션
  document.addEventListener('DOMContentLoaded', function() {
    const cards = document.querySelectorAll('.product-card');
    cards.forEach((card, index) => {
      setTimeout(() => {
        card.style.animationDelay = ${index * 0.1}s;
      }, 100);
    });
  });
</script>
<script>
$(function () {
  $(".heart-btn").click(function () {
    const button = $(this);
    const productId = button.data("product-id");
    const isInWishlist = button.data("in-wishlist") === true;

    const action = isInWishlist ? "remove" : "add";

    $.ajax({
      url: "../wishlist/add_wish.jsp",
      type: "POST",
      data: {
        productId: productId,
        action: action
      },
      dataType: "json",
      success: function (response) {
        if (response.success) {
          if (response.action === "added") {
            button.html("❤️").data("in-wishlist", true);
          } else {
            button.html("🤍").data("in-wishlist", false);
          }
        } else {
          alert(response.message || "처리에 실패했습니다.");
          if (response.message === "로그인이 필요합니다.") {
            window.location.href = "../UserLogin/login.jsp";
          }
        }
      },
      error: function () {
        alert("서버 오류 발생");
      }
    });
  });
});
</script>
<script>
$(function () {
	  $(".add-btn").click(function () {
	    const button = $(this);
	    const productId = button.data("product-id");
	    const qty = 1; // 기본 수량 1

	    $.ajax({
	      url: "../cart/addMenuTocart.jsp",
	      type: "POST",
	      data: {
	        productId: productId,
	        qty: qty
	      },
	      dataType: "json",
	      success: function (res) {
	        if (res.success) {
	         showToast("장바구니에 담겼습니다! 🛒");
	        } else {
	          if (res.message === "로그인이 필요합니다.") {
	        	  alert("로그인이 필요");
	            window.location.href = "../UserLogin/login.jsp";
	          } else {
	            alert("문제가 발생했습니다.");
	          }
	        }
	      },
	      error: function () {
	        alert("서버 오류 발생");
	      }
	    });
	  });
	});

</script>
<script>
function showToast(message) {
	  let toast = document.getElementById("toast-msg");

	  if (!toast) {
	    toast = document.createElement("div");
	    toast.id = "toast-msg";
	    toast.style.position = "fixed";
	    toast.style.top = "30px";
	    toast.style.left = "50%";
	    toast.style.transform = "translateX(-50%)";
	    toast.style.backgroundColor = "#f8a6c9";
	    toast.style.color = "white";
	    toast.style.padding = "14px 24px";
	    toast.style.borderRadius = "30px";
	    toast.style.fontSize = "16px";
	    toast.style.fontWeight = "bold";
	    toast.style.zIndex = "9999";
	    toast.style.opacity = "0";
	    toast.style.transition = "opacity 0.5s ease-in-out";
	    document.body.appendChild(toast);
	  }

	  toast.textContent = message;
	  toast.style.opacity = "1";

	  setTimeout(() => {
	    toast.style.opacity = "0";
	    setTimeout(() => {
	      toast.remove();
	    }, 500);
	  }, 1500);
	}
	</script>
</body>
</html>