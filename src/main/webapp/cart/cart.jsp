<%@page import="java.util.ArrayList"%>
<%@page import="cart.CartService"%>
<%@page import="cart.CartItemDTO"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
Integer userId = (Integer) session.getAttribute("userId");
if (userId == null) {
%>
<script>
	alert("로그인 후 이용해주세요.");
	location.href = "../UserLogin/login.jsp";
</script>
<%
return;
}
CartService cs = new CartService();

if (cs.searchCartId(userId) != null) {
List<CartItemDTO> cartItem = cs.showAllCartItem(userId);

Integer cartId = cs.searchCartId(userId);
int cnt = cs.searchCartCnt(cartId);



int totalCartPrice = 0;
int totalQuantity=0;

for (CartItemDTO ciDTO : cartItem) {
	totalCartPrice += ciDTO.getPrice() * ciDTO.getQuantity();
	totalQuantity += ciDTO.getQuantity();
}

request.setAttribute("cnt", cnt);
request.setAttribute("cartId", cartId);
request.setAttribute("cartItem", cartItem);
request.setAttribute("totalCartPrice", totalCartPrice);
request.setAttribute("totalQuantity", totalQuantity);
}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>장바구니</title>
<c:if test="${not empty param.msg}">
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
    ${param.msg}
  </div>
  <script>
    const toast = document.getElementById("toast-msg");
    if (toast) {
      toast.style.opacity = "1";
      setTimeout(() => {
        toast.style.opacity = "0";
      }, 1500);
    }
  </script>
</c:if>
<c:import url="../common/external_file.jsp" />
<script type="text/javascript">
function showToast(message) {
	  const toast = document.getElementById("toast-msg");
	  if (!toast) return;
	  toast.textContent = message;
	  toast.style.opacity = "1";

	  setTimeout(() => {
	    toast.style.opacity = "0";
	  }, 2000);
	}

	window.onload = function() {
		const checkAll = document.getElementById("checkAllBottom");
		const checkboxes = document
				.querySelectorAll("tbody input[type='checkbox']");

		checkAll.addEventListener("change", function() {
			checkboxes.forEach(function(cb) {
				cb.checked = checkAll.checked;
			});
		});
		document
				.getElementById("deleteBtn")
				.addEventListener(
						"click",
						function() {
							const checked = document
									.querySelectorAll("input[name='checkCart']:checked");
							if (checked.length === 0) {
								 alert("삭제할 항목을 선택해주세요.");
							       return;
							} else {
								 document.getElementById("cartForm").submit();
							}

							// submit
							document.getElementById("cartForm").submit();
						});
	};

	$(document).ready(function() {
		$(".quantity-control").each(function(){
			const container = $(this);
			const plusBtn = container.find(".plus-btn");
			const minusBtn = container.find(".minus-btn");
			const input = container.find(".quantity-input");
			
			const productId = container.data("product-id");
			const cartId = container.data("cart-id");
			function updatePlusButtonStyle() {
				  if (parseInt(input.val()) >= parseInt(container.data("stock"))) {
				    plusBtn.addClass("disabled");
				  } else {
				    plusBtn.removeClass("disabled");
				  }
				}
			updatePlusButtonStyle();
			function updateQuantity(newQty){
				if(newQty<1 || isNaN(newQty)){
					input.val(1);
					return;
				}
			$.ajax({
				url: "update_cart_quantity.jsp",
				method:"POST",
				data:{
					productId: productId,
					cartId: cartId,
					quantity: newQty
					
				},
				dataType:"JSON",
				success: function(res){
					if(res.error){
						alert(res.message);
						return;
					}
					console.log("업데이트성공: ", res);
					const totalQty = document.querySelector("#totalQuantity");
					const totalPrice = document.querySelector("#totalPrice");
					const totalOrderPrice = document.querySelector("#totalOrderPrice");
					const prdId=res.productId;
						
					totalQty.textContent=res.totalQuantity;
					totalPrice.textContent=res.totalPrice.toLocaleString()+"원";
					totalOrderPrice.textContent=(res.totalPrice+3000).toLocaleString()+"원";
					
					var cls=".unitPrice[data-products-id='"+res.productId+"']";
// 					alert( cls )
					const unitEl = document.querySelector(cls);
// 					const unitEl = document.querySelector(".unitPrice[data-products-id='" + res.productId + "']");

					if (unitEl) {
					    unitEl.textContent = res.unitPrice.toLocaleString() + "원";
					} else {
					    console.warn("❗ 단가 요소 못 찾음: ", res.productId);
					    console.log("현재 존재하는 .unitPrice 목록: ", document.querySelectorAll(".unitPrice"));
					    console.log(typeof res.productId);
					    console.log("🔍 res.productId 타입:", typeof prdId); // number
					    console.log("🔍 selector 비교용:", `.unitPrice[data-products-id="${res.productId.toString()}"]`);
					}
				},
				error: function(){
					console.log("업데이트 실패");
				}
				
			});//ajax
			}
			plusBtn.click(function(){
				let qty = parseInt(input.val());
				const stock = parseInt(container.data("stock"));
				if(qty < stock){
				qty+=1;
				input.val(qty);
				updateQuantity(qty);
				updatePlusButtonStyle();
				} else{
					showToast("재고 수량을 넘길수 없음.");
				}
			});
			
			minusBtn.click(function(){
				let qty = parseInt(input.val());
				if(qty > 1){
					qty-= 1;
					input.val(qty);
					updateQuantity(qty);
					updatePlusButtonStyle();
				}
			});
			input.on("change", function(){
				const newQty = parseInt(input.val());
				updateQuantity(newQty);
				updatePlusButtonStyle();
			});//change
			
			
			
			
			
		});//evt

	});//event
</script>


</head>
<style>
.plus-btn.disabled {
  color: gray !important;
  cursor: not-allowed;
  opacity: 0.5;
}
.quantity-control button:disabled {
  color: gray;
  cursor: not-allowed;
  opacity: 0.5;
}
.quantity-control {
  display: flex;
  align-items: center;
  border: 1px solid #ccc;
  border-radius: 8px;
  padding: 5px 10px;
  width: fit-content;
}

.quantity-control button {
  background: none;
  border: none;
  font-size: 20px;
  width: 30px;
  cursor: pointer;
}

.quantity-input {
  width: 50px;
  text-align: center;
  font-size: 18px;
  border: none;
}
</style>
<body>

	<!-- ✅ 공통 헤더 -->
	<c:import url="/common/header.jsp" />

	<!-- ✅ 본문 영역 -->
	<main class="container" style="min-height: 600px; padding: 60px 20px;">
		<h2 style="font-size: 28px; font-weight: bold; margin-bottom: 20px;">
			<strong style="position: relative; display: inline-block;">
				장바구니 <span
				style="background-color: #f8a6c9; color: white; font-size: 13px; font-weight: bold; border-radius: 50%; padding: 2px 8px; position: relative; top: -5px; left: 5px; display: inline-block; line-height: 1;">1</span>
			</strong>
		</h2>

		<!-- TODO: 실제 컨텐츠 작성 영역 -->
		<p
			style="color: #333; font-size: 24px; font-weight: bold; margin-bottom: 30px; margin-top: 40px;">
		<form action="remove_cart.jsp" method="POST" id="cartForm">

			<table border="0" width="100%" cellpadding="10" cellspacing="0"
				style="border-collapse: collapse; margin-bottom: 30px;">
				<thead>
					<tr
						style="background-color: #f9f9f9; border-bottom: 2px solid #ddd; text-align: center;">
						<th style="width: 10%;">선택</th>
						<th style="width: 40%; text-align: left;">상품 정보</th>
						<th style="width: 15%;">수량</th>
						<th style="width: 15%;">주문금액</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${not empty cartItem }">
							<c:forEach var="item" items="${cartItem }">
								<tr style="text-align: center; border-bottom: 1px solid #eee;">
									<td><input type="checkbox" name="checkCart"
										value="${item.productId }" /></td>

									<td style="text-align: left;"><img
										src="<c:url value='/admin/common/upload/${item.thumbnailImg}'/>"
										width="200"
										style="vertical-align: middle; margin-right: 50px;" />
										${item.productName}
										<c:if test="${item.stockQuantity==0}"> <span style="color: red; font-weight: bold;">[품절]</span></c:if>
										</td>
									<td>

										<div class="quantity-control"
											data-product-id="${item.productId}"
											data-cart-id="${cartId}"
											data-stock="${item.stockQuantity}">
											<button type="button" class="minus-btn"<c:if test="${item.stockQuantity==0}">disabled</c:if>>−</button>
											<input type="text" class="quantity-input"
												value="${item.quantity}" min="1"  <c:if test="${item.stockQuantity == 0}">disabled</c:if> />
											<button type="button" class="plus-btn" <c:if test="${item.stockQuantity == 0}">disabled</c:if>>+</button>
										</div>
									</td>
									<td><strong class="unitPrice" data-products-id="${item.productId}"><fmt:formatNumber
												value="${item.price * item.quantity}" pattern="#,###" />원</strong></td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="5" style="text-align: center;">장바구니가 비어 있습니다.</td>
							</tr>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</form>
		<div>
			<input type="checkbox" id="checkAllBottom" /> 전체선택 <input
				type="button" value="선택상품 삭제" id="deleteBtn"
				class="btn btn-success btn-sm"
				style="background-color: #f48fb1; border: none; color: white; font-size: 18px; padding: 12px 20px; border-radius: 30px; cursor: pointer;" />
		</div>
		<!-- 총 금액 요약 박스 -->
		<div
			style="background-color: #fff0f5; padding: 30px; text-align: center; font-size: 18px; border-radius: 15px; margin-top: 40px;">
			<div style="margin-bottom: 20px;">
				<strong style="font-size: 20px;">총 주문 상품</strong> <span id="totalQuantity"
					style="font-size: 25px; color: hotpink;"><c:out
						value="${totalQuantity}" />개</span>
			</div>

			<div
				style="display: flex; justify-content: center; align-items: center; font-size: 20px;">
				<div style="margin: 0 10px;">
					<strong id="totalPrice"><fmt:formatNumber value="${totalCartPrice}"
							pattern="#,###" />원</strong>
					<div style="font-size: 14px; color: gray;">상품금액</div>
				</div>
				<div style="font-size: 20px;">+</div>
				<div style="margin: 0 10px;">
					<strong>3,000원</strong>
					<div style="font-size: 14px; color: gray;">배송비</div>
				</div>
				<div style="font-size: 20px;">=</div>
				<div style="margin: 0 10px;">
					<strong id="totalOrderPrice" style="color: hotpink;"><fmt:formatNumber
							value="${totalCartPrice+3000}" pattern="#,###" />원</strong>
					<div style="font-size: 14px; color: gray;">총 주문금액</div>
				</div>
			</div>
		</div>

		<!-- 주문 버튼 -->
		<div style="text-align: center; margin-top: 30px;">
			<form action="order_multiple.jsp" method="GET">
				<button
					style="background-color: #f48fb1; border: none; color: white; font-size: 18px; padding: 12px 40px; border-radius: 30px; cursor: pointer;">
					주문하기</button>
				<input type="hidden" value="${ userId }" name="userId" /> <input
					type="hidden" value="<%=cs.searchCartId(userId)%>" name="cartId" />
			</form>
		</div>
	</main>

	<!-- ✅ 공통 푸터 -->
	<c:import url="/common/footer.jsp" />

</body>
</html>
