<%@page import="java.util.HashSet"%>
<%@page import="wishlist.WishListDTO"%>
<%@page import="java.util.List"%>
<%@page import="wishlist.WishService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="product.ProductService"%>
<%@ page import="product.ProductDTO"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:import url="../common/external_file.jsp" />

<%
  int productId = Integer.parseInt(request.getParameter("productId"));
  Integer userId = (Integer)session.getAttribute("userId");
  ProductService ps = new ProductService();
  ProductDTO prd = ps.getProductById(productId);
  HashSet<Integer> wishProductId = new HashSet<>();
  if(userId != null){
	  WishService ws = new WishService();
	  List<WishListDTO> wishList = ws.showWishList(userId);
  	  for(WishListDTO w : wishList){
		 if(w.getProductId() == productId){
	 	  wishProductId.add(w.getProductId());
			 break;
		 }
  	  	  
  	  }
  }
  request.setAttribute("prd", prd);
  request.setAttribute("wishProductId", wishProductId);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${prd.name}| Donutted</title>
<c:if test="${not empty sessionScope.toast}">
	<div id="toast-msg"
		style="position: fixed; top: 30px; left: 50%; transform: translateX(-50%); background-color: #f8a6c9; color: white; padding: 14px 24px; border-radius: 30px; font-size: 16px; font-weight: bold; z-index: 9999; opacity: 0; transition: opacity 0.5s ease-in-out;">
		${sessionScope.toast}</div>
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
<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto,
		'Helvetica Neue', Arial, sans-serif;
	background-color: #fafafa;
	color: #333;
	line-height: 1.6;
}

.product-container {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 80px;
	max-width: 1400px;
	margin: 40px auto;
	padding: 0 40px;
	background: white;
	border-radius: 20px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
	overflow: hidden;
}

.product-img {
	position: relative;
	padding: 60px 40px;
	display: flex;
	flex-direction: column;
	align-items: center;
	background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
}

.product-img img#mainImg {
	width: 100%;
	max-width: 450px;
	height: 450px;
	object-fit: cover;
	border-radius: 16px;
	box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
	transition: transform 0.3s ease;
}

.product-img img#mainImg:hover {
	transform: scale(1.02);
}

.thumbnail-list {
	display: flex;
	justify-content: center;
	margin-top: 24px;
	gap: 12px;
	flex-wrap: wrap;
}

.thumbnail-list img {
	width: 70px;
	height: 70px;
	object-fit: cover;
	border: 3px solid transparent;
	border-radius: 12px;
	cursor: pointer;
	transition: all 0.3s ease;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.thumbnail-list img:hover {
	border-color: #6366f1;
	transform: translateY(-2px);
	box-shadow: 0 4px 16px rgba(99, 102, 241, 0.3);
}

.product-img.sold-out img {
	opacity: 0.3;
	filter: grayscale(100%);
}

.sold-out-badge {
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
	color: white;
	padding: 12px 24px;
	border-radius: 12px;
	font-size: 18px;
	font-weight: 700;
	text-transform: uppercase;
	letter-spacing: 1px;
	box-shadow: 0 4px 16px rgba(239, 68, 68, 0.4);
	z-index: 10;
}

.product-info {
	padding: 60px 40px;
	display: flex;
	flex-direction: column;
	justify-content: center;
	gap: 24px;
}

.product-info h2 {
	font-size: 32px;
	font-weight: 700;
	color: #1f2937;
	margin-bottom: 8px;
	line-height: 1.3;
}

.price {
	color: #F8A5C2;
	font-size: 28px;
	font-weight: 800;
	letter-spacing: -0.5px;
}

.low-stock {
	background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
	color: #d97706;
	font-size: 14px;
	font-weight: 600;
	padding: 8px 16px;
	border-radius: 8px;
	border-left: 4px solid #f59e0b;
	display: inline-block;
}

.qty-section {
	background: #f8fafc;
	padding: 24px;
	border-radius: 12px;
	border: 1px solid #e2e8f0;
}

.qty-section label {
	font-weight: 600;
	color: #4b5563;
	margin-bottom: 12px;
	display: block;
}

.qty-controls {
	display: flex;
	align-items: center;
	gap: 16px;
	margin-bottom: 16px;
}

.qty-section input {
	width: 80px;
	padding: 12px;
	text-align: center;
	border: 2px solid #e2e8f0;
	border-radius: 8px;
	font-size: 16px;
	font-weight: 600;
	transition: border-color 0.3s ease;
}

.qty-section input:focus {
	outline: none;
	border-color: #6366f1;
	box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
}

.qty-section input[disabled] {
	background-color: #f1f5f9;
	color: #94a3b8;
	cursor: not-allowed;
}

.total-price {
	font-size: 18px;
	font-weight: 700;
	color: #1f2937;
	padding: 12px 16px;
	background: white;
	border-radius: 8px;
	border: 1px solid #e2e8f0;
}

.buttons {
	display: flex;
	gap: 16px;
	align-items: center;
	flex-wrap: wrap;
}

.buttons button {
	padding: 16px 32px;
	border: none;
	border-radius: 12px;
	font-size: 16px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.3s ease;
	text-transform: uppercase;
	letter-spacing: 0.5px;
	min-width: 140px;
}

.btn-cart {
	background: linear-gradient(135deg, #F8A5C2, #FFB6C1);
	color: white;
	box-shadow: 0 4px 16px rgba(248, 165, 194, 0.3);
}

.btn-cart:hover:not([disabled]) {
	transform: translateY(-2px);
	box-shadow: 0 8px 24px rgba(248, 165, 194, 0.4);
}

.btn-buy {
	background: linear-gradient(135deg, #F8A5C2, #FFB6C1);
	color: white;
	ox-shadow: 0 4px 16px rgba(248, 165, 194, 0.3);
}

.btn-buy:hover:not([disabled]) {
	transform: translateY(-2px);
	box-shadow: 0 8px 24px rgba(248, 165, 194, 0.4);
}

.buttons button[disabled] {
	background: #e2e8f0 !important;
	color: #94a3b8 !important;
	cursor: not-allowed !important;
	transform: none !important;
	box-shadow: none !important;
	border-color: #e2e8f0 !important;
}

.wishlist-btn {
	background: white;
	color: #ef4444;
	border: 2px solid #fee2e2;
	border-radius: 12px !important;
	padding: 12px 16px !important;
	font-size: 20px !important;
	min-width: auto !important;
	transition: all 0.3s ease;
}

.wishlist-btn:hover {
	background: #fef2f2;
	border-color: #fecaca;
	transform: scale(1.1);
}

.detail-img-section {
	max-width: 1000px;
	margin: 80px auto;
	padding: 0 40px;
}

.detail-img-section img {
	width: 100%;
	border-radius: 16px;
	margin-bottom: 32px;
	box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
	transition: transform 0.3s ease;
}

.detail-img-section img:hover {
	transform: scale(1.01);
}

@media ( max-width : 1024px) {
	.product-container {
		grid-template-columns: 1fr;
		gap: 40px;
		margin: 20px;
		padding: 0;
	}
	.product-img, .product-info {
		padding: 40px 30px;
	}
	.product-info h2 {
		font-size: 28px;
	}
	.price {
		font-size: 24px;
	}
	.buttons {
		justify-content: center;
	}
}

@media ( max-width : 768px) {
	.product-img, .product-info {
		padding: 30px 20px;
	}
	.buttons {
		flex-direction: column;
		width: 100%;
	}
	.buttons button {
		width: 100%;
	}
	.detail-img-section {
		padding: 0 20px;
	}
}
</style>
</head>
<body>

	<%@ include file="../common/header.jsp"%>

	<main>
		<div class="product-container">
			<div
				class="product-img <c:if test='${prd.stock == 0}'>sold-out</c:if>">
				<img id="mainImg"
					src="<c:url value='/admin/common/images/products/${prd.thumbnailImg}' />"
					alt="${prd.name}"
					onerror="this.onerror=null; this.dataset.error='true'; this.src='${pageContext.request.contextPath}/admin/common/images/default/error.png';">

				<c:if test="${prd.stock == 0}">
					<div class="sold-out-badge">SOLD OUT</div>
				</c:if>

				<div class="thumbnail-list">
					<c:if test="${not empty prd.productImg1}">
						<img
							src="<c:url value='/admin/common/images/products/${prd.productImg1}' />"
							onmouseover="if (!this.dataset.error) changeMainImg(this);"
							onmouseout="if (!this.dataset.error) resetMainImg();"
							onerror="this.onerror=null; this.dataset.error='true'; this.src='${pageContext.request.contextPath}/admin/common/images/default/error.png';">
					</c:if>
					<c:if test="${not empty prd.productImg2}">
						<img
							src="<c:url value='/admin/common/images/products/${prd.productImg2}' />"
							onmouseover="if (!this.dataset.error) changeMainImg(this);"
							onmouseout="if (!this.dataset.error) resetMainImg();"
							onerror="this.onerror=null; this.dataset.error='true'; this.src='${pageContext.request.contextPath}/admin/common/images/default/error.png';">
					</c:if>
					<c:if test="${not empty prd.productImg3}">
						<img
							src="<c:url value='/admin/common/images/products/${prd.productImg3}' />"
							onmouseover="if (!this.dataset.error) changeMainImg(this);"
							onmouseout="if (!this.dataset.error) resetMainImg();"
							onerror="this.onerror=null; this.dataset.error='true'; this.src='${pageContext.request.contextPath}/admin/common/images/default/error.png';">
					</c:if>
					<c:if test="${not empty prd.productImg4}">
						<img
							src="<c:url value='/admin/common/images/products/${prd.productImg4}' />"
							onmouseover="if (!this.dataset.error) changeMainImg(this);"
							onmouseout="if (!this.dataset.error) resetMainImg();"
							onerror="this.onerror=null; this.dataset.error='true'; this.src='${pageContext.request.contextPath}/admin/common/images/default/error.png';">
					</c:if>
				</div>
			</div>

			<div class="product-info">
				<div>
					<h2>${prd.name}</h2>
					<p class="price">
						<fmt:formatNumber value="${prd.price}" pattern="#,###" />
						원
					</p>
				</div>

				<c:if test="${prd.stock > 0 && prd.stock <= 5}">
					<div class="low-stock">[품절임박] 잔여 ${prd.stock}개</div>
				</c:if>

				<div class="qty-section">
					<label>수량 선택</label>
					<div class="qty-controls">
						<input type="number" id="qty"
							value="<c:choose><c:when test='${prd.stock == 0}'>0</c:when><c:otherwise>1</c:otherwise></c:choose>"
							min="1" max="${prd.stock}" name="qty"
							<c:if test="${prd.stock == 0}">disabled</c:if>>
					</div>
					<div class="total-price">
						총 상품금액: <span id="total"><fmt:formatNumber
								value="${prd.price}" pattern="#,###" /></span>원
					</div>
				</div>

				<div class="buttons">
				
						<button class="btn-cart" type="button"
						data-product-id="${prd.productId }"
							<c:if test="${prd.stock == 0}">disabled</c:if>>장바구니</button>
							
					<form action="../order/order_single.jsp" method="POST">
						<input type="hidden" name="productId"
							value="<%= prd.getProductId() %>"> <input type="hidden"
							name="qty" id="singleQty" value="1">
						<button class="btn-buy" type="submit"
							<c:if test="${prd.stock == 0}">disabled</c:if>>구매하기</button>
					</form>

					<button type="button" class="wishlist-btn"
						data-product-id="${prd.productId }"
						data-in-wishlist="${wishProductId.contains(prd.productId) }">
						<c:choose>
							<c:when test="${wishProductId.contains(prd.productId)}">❤️
           </c:when>
							<c:otherwise>
           🤍
           </c:otherwise>
						</c:choose>
					</button>
				</div>
			</div>
		</div>

		<div
			style="max-width: 1000px; margin: 60px auto 40px; padding: 0 40px; border-bottom: 1px solid #eee;">
			<ul
				style="display: flex; gap: 40px; list-style: none; padding: 0; font-size: 16px; font-weight: 600; color: #888;">
				<li><a href="#detail"
					style="color: #333; text-decoration: none;">상세설명</a></li>
				<li><a href="#review"
					style="color: #333; text-decoration: none;">리뷰</a></li>
			</ul>
		</div>

		<div id="detail" class="detail-img-section">
			<c:if test="${not empty prd.detailImg}">
				<img
					src="<c:url value='/admin/common/images/products/${prd.detailImg}' />"
					onerror="this.onerror=null; this.dataset.error='true'; this.src='${pageContext.request.contextPath}/admin/common/images/default/error.png';">
			</c:if>
			<c:if test="${not empty prd.detailImg2}">
				<img
					src="<c:url value='/admin/common/images/products/${prd.detailImg2}' />"
					onerror="this.onerror=null; this.dataset.error='true'; this.src='${pageContext.request.contextPath}/admin/common/images/default/error.png';">
			</c:if>
			<c:if test="${not empty prd.detailImg3}">
				<img
					src="<c:url value='/admin/common/images/products/${prd.detailImg3}' />"
					onerror="this.onerror=null; this.dataset.error='true'; this.src='${pageContext.request.contextPath}/admin/common/images/default/error.png';">
			</c:if>
			<c:if test="${not empty prd.detailImg4}">
				<img
					src="<c:url value='/admin/common/images/products/${prd.detailImg4}' />"
					onerror="this.onerror=null; this.dataset.error='true'; this.src='${pageContext.request.contextPath}/admin/common/images/default/error.png';">
			</c:if>
		</div>

		<div id="review">
			<c:import url="../mypage_review/review.jsp" />
		</div>
	</main>

	<script>
  const price = ${prd.price};
  const stock = ${prd.stock};
  const originalMainImg = "<c:url value='/admin/common/images/products/${prd.thumbnailImg}' />";

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
      document.getElementById("cartQty").value = qtyVal;
      document.getElementById("singleQty").value = qtyVal;
      console.log(qtyVal)
    }
  }

  const qtyInput = document.getElementById("qty");
  if (qtyInput && !qtyInput.disabled) {
    qtyInput.addEventListener("input", updateTotal);
    qtyInput.addEventListener("change", updateTotal);
  }

  function changeMainImg(thumb) {
    document.getElementById("mainImg").src = thumb.src;
  }

  function resetMainImg() {
    document.getElementById("mainImg").src = originalMainImg;
  }

</script>
	<script>
$(function(){
	$(".wishlist-btn").click(function(){
		const button = $(this);
		const productId = button.data("product-id");
		const isInWishlist = button.data("in-wishlist")===true;
		const action = isInWishlist ? "remove" : "add";
	$.ajax({
		url:"add_wish_indetail.jsp",
		type:"POST",
		data:{
			productId : productId,
			action : action
		},
		dataType:"JSON",
		success: function(response){
			if(response.success){
				if(response.action === "added"){
					   button.html("❤️").data("in-wishlist", true);
					   showToast("찜 목록에 추가하였습니다!");
		          } else {
		            button.html("🤍").data("in-wishlist", false);
		          }
				}else{
					 alert(response.message || "처리에 실패했습니다.");
			          if (response.message === "로그인이 필요합니다.") {
			            window.location.href = "../UserLogin/login.jsp";
			          }//if
				}//else
		},
		error:function(){
			alert("서버 오류 발생");
		}
		});//ajax
	});
});
</script>
<script>
$(function(){
	$(".btn-cart").click(function(){
		const button = $(this);
		const productId = button.data("product-id");
		const quantity = $("#qty").val();
		
		$.ajax({
			url:"../cart/add_cart.jsp",
			type:"POST",
			data:{
				productId: productId,
				quantity: quantity
			},
			dataType:"JSON",
			success:function(res){
				if(res.success){
					showToast("장바구니에 담겼습니다! 🛒");
				} else{
					  if (res.message === "로그인이 필요합니다.") {
			        	  alert("로그인이 필요");
			            window.location.href = "../UserLogin/login.jsp";
			          } else {
			            alert("문제가 발생했습니다.");
			          }
				}
			},
			error: function(){
				alert("서버오류 발생");
			}
		});//ajax
	});//click
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
	<c:import url="../common/footer.jsp" />
</body>
</html>