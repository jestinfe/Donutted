<%@page import="wishlist.WishListDTO"%>
<%@page import="wishlist.WishService"%>
<%@page import="java.util.HashSet"%>
<%@page import="product.ProductDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="product.ProductService" %>
<%@ page import="product.CategoryService" %>
<%@ page import="product.CategoryDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


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
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>메뉴</title>
  <c:import url="http://localhost/mall_prj/common/external_file.jsp"/>
  <style>
    .category-bar {
      display: flex;
      justify-content: center;
      gap: 40px;
      margin: 50px 0 30px;
      font-size: 20px;
      font-weight: bold;
    }
    .category-bar a {
      text-decoration: none;
      color: #333;
      padding-bottom: 5px;
    }
    .category-bar a.selected {
      border-bottom: 3px solid #FF69B4;
      color: #FF69B4;
    }

    .product-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 30px;
      padding: 0 40px;
    }
    
     .img-wrapper {
      position: relative;
    }
    
    
    .img-wrapper.sold-out img {
  opacity: 0.4;
  filter: grayscale(100%);
	}

	.sold-out-badge {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background-color: rgba(0,0,0,0.7);
  color: white;
  padding: 6px 12px;
  border-radius: 5px;
  font-size: 14px;
  font-weight: bold;
  text-transform: uppercase;
	}
    
    
    
       



    .product-card {
      border: 1px solid #ddd;
      padding: 15px;
      border-radius: 10px;
      text-align: center;
      box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    }

    .product-card img {
      width: 100%;
      height: 160px;
      object-fit: cover;
      border-radius: 5px;
    }

    .product-card h3 {
      margin: 10px 0 5px;
      font-size: 16px;
    }

    .wishlist-btn {
      margin-top: 8px;
      background-color: #FF69B4;
      color: white;
      border: none;
      border-radius: 20px;
      padding: 5px 12px;
      font-size: 13px;
      cursor: pointer;
    }
    
     .low-stock {
      color: red;
      font-weight: bold;
      font-size: 13px;
      margin-top: 5px;
    }
  </style>
</head>
<body>

<!-- ✅ 공통 헤더 -->
<c:import url="/common/header.jsp" />

<%
  int categoryId = request.getParameter("categoryId") != null
      ? Integer.parseInt(request.getParameter("categoryId"))
      : 0;

  ProductService ps = new ProductService();
  List<ProductDTO> products = categoryId > 0
      ? ps.getProductsByCategory(categoryId)
      : ps.getAllProducts();

  CategoryService cs = new CategoryService();
  List<CategoryDTO> categories = cs.getAllCategories();

  request.setAttribute("products", products);
  request.setAttribute("categories", categories);
  request.setAttribute("currentCategoryId", categoryId);
%>

<main class="container" style="min-height: 600px; padding-bottom: 60px;">

  <!-- 🔹 중앙 카테고리 바 -->
  <div class="category-bar">
    <a href="menu.jsp" class="${currentCategoryId == 0 ? 'selected' : ''}">전체</a>
    <c:forEach var="cat" items="${categories}">
      <a href="menu.jsp?categoryId=${cat.categoryId}" class="${currentCategoryId == cat.categoryId ? 'selected' : ''}">
        ${cat.categoryName}
      </a>
    </c:forEach>
  </div>

  <!-- 🔹 상품 목록 -->
  <c:choose>
    <c:when test="${empty products}">
      <p style="text-align:center;">해당 카테고리에 등록된 상품이 없습니다.</p>
    </c:when>
    <c:otherwise>
      <div class="product-grid">
        <c:forEach var="prd" items="${products}">
          <div class="product-card">
            <div class="img-wrapper <c:if test='${prd.stock == 0}'>sold-out</c:if>">
              <a href="product_detail.jsp?productId=${prd.productId}">
                <img src="<c:url value='/admin/common/upload/${prd.thumbnailImg}' />" alt="${prd.name}" />
                <c:if test="${prd.stock == 0}">
                  <div class="sold-out-badge">SOLD OUT</div>
                </c:if>
              </a>
            </div>
            

            <a href="product_detail.jsp?productId=${prd.productId}">
              <h3>${prd.name}</h3>
            </a>
            <form action="add_wish.jsp" method="POST" id="form">
              <p><fmt:formatNumber value="${prd.price}" pattern="#,###" /> 원
              
              <!-- 🔹 품절임박 표시 -->
            <c:if test="${prd.stock > 0 && prd.stock <= 5}">
              <p class="low-stock">[품절임박] 잔여 ${prd.stock}개</p>
            </c:if>
            
            <!-- 찜하기 버튼 (UI만 토글됨) -->
             <input type="hidden" name="productId" value="${prd.productId}">
            <button type="button" class="wishlist-btn" onclick="toggleHeart(this)">
            <c:choose>
            <c:when test="${wishProductId.contains(prd.productId)}">❤️
            </c:when>
            <c:otherwise>🤍
            </c:otherwise>
            </c:choose>
            </button>
            </form>
            
              </p>
          </div>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>
</main>

<!-- ✅ 공통 푸터 -->
<c:import url="/common/footer.jsp" />

<!-- 🔧 하트 버튼 토글 스크립트 -->
<script>
  function toggleHeart(btn) {
    if (btn.innerText.includes("🤍")) {
      btn.innerText = "❤️";
    } else {
      btn.innerText = "🤍";
    }
    
    btn.closest("form").submit();
  }
</script>

</body>
</html>
