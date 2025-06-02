<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="product.ProductService" %>
<%@ page import="product.ProductDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
  int productId = Integer.parseInt(request.getParameter("productId"));
  ProductService ps = new ProductService();
  ProductDTO prd = ps.getProductById(productId);
  request.setAttribute("prd", prd);
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>${prd.name}</title>
  <c:import url="/common/external_file.jsp" />
  <style>
    .product-container {
      display: flex;
      justify-content: center;
      gap: 60px;
      padding: 80px 20px;
      max-width: 1200px;
      margin: 0 auto;
    }

    .product-img {
      flex: 1;
      position: relative;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .product-img img {
      width: 100%;
      max-width: 400px;
      border-radius: 10px;
    }

    .product-img.sold-out img {
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
      padding: 8px 16px;
      border-radius: 5px;
      font-size: 16px;
      font-weight: bold;
      text-transform: uppercase;
      pointer-events: none;
      line-height: 1;
    }

    .product-info {
      flex: 1;
      display: flex;
      flex-direction: column;
      justify-content: center;
    }

    .product-info h2 {
      font-size: 26px;
      margin-bottom: 10px;
    }

    .product-info .price {
      color: #ff3366;
      font-size: 22px;
      font-weight: bold;
      margin-bottom: 10px;
    }

    .low-stock {
      color: red;
      font-size: 14px;
      font-weight: bold;
      margin-bottom: 15px;
    }

    .qty-section {
      margin-bottom: 20px;
    }

    .qty-section input {
      width: 60px;
      text-align: center;
    }

    .qty-section input[disabled] {
      background-color: #eee;
      color: #888;
      cursor: not-allowed;
    }

    .buttons {
      display: flex;
      gap: 15px;
      align-items: center;
    }

    .buttons button {
      padding: 12px 25px;
      border: none;
      border-radius: 25px;
      font-size: 16px;
      cursor: pointer;
    }

    .btn-cart {
      background-color: #ff69b4;
      color: white;
    }

    .btn-buy {
      background-color: white;
      border: 1px solid #ccc;
    }

    .buttons button[disabled] {
      background-color: #ccc !important;
      color: #fff !important;
      cursor: not-allowed !important;
    }

    .wishlist-btn {
      background-color: #FF69B4;
      color: white;
      border: none;
      border-radius: 20px;
      padding: 5px 12px;
      font-size: 13px;
      cursor: pointer;
    }

    .detail-img-section {
      text-align: center;
      margin: 80px auto;
      max-width: 800px;
    }

    .detail-img-section img {
      width: 100%;
      border-radius: 10px;
    }
  </style>
</head>
<body>

<%@ include file="/common/header.jsp" %>

<main>
  <!-- 상품 요약 -->
  <div class="product-container">
    <div class="product-img <c:if test='${prd.stock == 0}'>sold-out</c:if>">
      <img src="<c:url value='/admin/common/upload/${prd.thumbnailImg}' />" alt="${prd.name}" />
      <c:if test="${prd.stock == 0}">
        <div class="sold-out-badge">SOLD OUT</div>
      </c:if>
    </div>

    <div class="product-info">
      <h2>${prd.name}</h2>
      <p class="price"><fmt:formatNumber value="${prd.price}" pattern="#,###" />원</p>

      <!-- 🔴 품절임박 표시 -->
      <c:if test="${prd.stock > 0 && prd.stock <= 5}">
        <p class="low-stock">[품절임박] 잔여 ${prd.stock}개</p>
      </c:if>

      <div class="qty-section">
        수량:
        <input type="number" id="qty" 
          value="<c:choose><c:when test='${prd.stock == 0}'>0</c:when><c:otherwise>1</c:otherwise></c:choose>"
          min="1" 
          max="${prd.stock}"
          name="qty"
          <c:if test="${prd.stock == 0}">disabled</c:if>
        >
        <br>총 상품금액:
        <span id="total"><fmt:formatNumber value="${prd.price}" pattern="#,###" /></span>원
      </div>

      <div class="buttons">
        <!-- 장바구니 -->
        <form action="../cart/add_cart.jsp" method="POST">
          <input type="hidden" name="productId" value="<%= prd.getProductId() %>">
          <input type="hidden" name="qty" id="cartQty" value="1">
          <button class="btn-cart" type="submit" <c:if test="${prd.stock == 0}">disabled</c:if>>장바구니</button>
        </form>

        <!-- 바로구매 -->
        <form action="../order/order_single.jsp" method="POST">
          <input type="hidden" name="productId" value="<%= prd.getProductId() %>">
          <input type="hidden" name="qty" id="singleQty" value="1">
          <button class="btn-buy" type="submit" <c:if test="${prd.stock == 0}">disabled</c:if>>구매하기</button>
        </form>

        <!-- 찜 버튼: 항상 활성화 -->
        <button type="button" class="wishlist-btn" onclick="toggleHeart(this)">🤍</button>
      </div>
    </div>
  </div>

  <!-- 상세 이미지 -->
  <div class="detail-img-section">
    <img src="<c:url value='/admin/common/upload/${prd.detailImg}' />" alt="${prd.name}" />
  </div>

  <c:import url="../mypage_review/review.jsp" />
</main>

<script>
const price = ${prd.price};
const stock = ${prd.stock};

function updateTotal() {
  const qty = document.getElementById("qty");
  const totalSpan = document.getElementById("total");
  if (qty && totalSpan) {
    let qtyVal = parseInt(qty.value);
    if (qtyVal > stock) {
      alert("구매 가능 수량은 최대 " + stock + "개입니다.");
      qty.value = stock;
      qtyVal = stock;
    }
    if (qtyVal < 1) {
      qty.value = 1;
      qtyVal = 1;
      
    }
    const total = price * qtyVal;
    totalSpan.innerText = total.toLocaleString();

    const cartQty = document.getElementById("cartQty");
    const singleQty = document.getElementById("singleQty");
    if (cartQty) cartQty.value = qtyVal;
    if (singleQty) singleQty.value = qtyVal;
  }
}

// 🔥 input + change 이벤트 모두 등록
const qtyInput = document.getElementById("qty");
if (qtyInput && !qtyInput.disabled) {
  qtyInput.addEventListener("input", updateTotal);
  qtyInput.addEventListener("change", updateTotal);
}


</script>

<c:import url="/common/footer.jsp" />
</body>
</html>
