<%@page import="java.util.ArrayList"%>
<%@page import="cart.CartService"%>
<%@page import="cart.CartItemDTO"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:import url="../common/external_file.jsp" />

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
int totalQuantity = 0;

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
<title>장바구니 | Donutted</title>
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
<script type="text/javascript">
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

	window.onload = function() {
		const checkAll = document.getElementById("checkAllBottom");
		const checkboxes = document
				.querySelectorAll("tbody input[type='checkbox']");

		checkAll.addEventListener("change", function() {
			checkboxes.forEach(function(cb) {
				cb.checked = checkAll.checked;
			});
			updateSelectedTotals();
		});
		document
				.getElementById("deleteBtn")
				.addEventListener(
						"click",
						function() {
							const checked = document
									.querySelectorAll("input[name='checkCart']:checked");
							if (checked.length === 0) {
								 showToast("삭제할 항목을 선택해주세요.");
							       return;
							} else {
								 document.getElementById("cartForm").submit();
							}

							// submit
							document.getElementById("cartForm").submit();
						});
		  document.querySelectorAll(".cart-item-checkbox").forEach(cb => {
		        cb.addEventListener("change", updateSelectedTotals);
		    });

		    // ✅ 페이지 로드 시 초기화
		    updateSelectedTotals();
	};

	function updateSelectedTotals() {
		  let totalPrice = 0;
		  let totalQuantity = 0;

		  document.querySelectorAll(".cart-item-checkbox:checked").forEach(cb => {
		    const price = parseInt(cb.getAttribute("data-price"));
		    const quantity = parseInt(cb.getAttribute("data-quantity"));

		    if (!isNaN(price)) totalPrice += price;
		    if (!isNaN(quantity)) totalQuantity += quantity;
		  });

		  document.getElementById("totalPrice").textContent = totalPrice.toLocaleString() + "원";
		  document.getElementById("totalQuantity").textContent = totalQuantity + "개";
		  document.getElementById("totalOrderPrice").textContent = (totalPrice + 3000).toLocaleString() + "원";
		}

		
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
						
					const cb = document.querySelector(".cart-item-checkbox[value='" + res.productId.toString()+ "']");
					if (cb) {
						const newPrice = Number(res.unitPrice) * Number(res.quantity);
						if (isNaN(newPrice) && isNaN(res.quantity)) {
						    console.error("❌ newPrice or quantity is NaN", res.unitPrice, res.quantity);
						    return;
						  }
						  cb.setAttribute("data-price", res.unitPrice.toString());
						  cb.setAttribute("data-quantity", res.quantity.toString());
   						console.log("✔ data-price 갱신 완료: ", cb.getAttribute("data-price")); // ✅ 여기서 확인
   						console.log("prd : ", res.productId);
   						 if (cb.checked) {
   		                    updateSelectedTotals();
   		                }
					}
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
				
				const cb = container.closest("tr").querySelector(".cart-item-checkbox");
				if (cb && cb.checked) {
					// AJAX는 비동기라 딜레이 있음 → 여기서 한 번 강제로 업데이트
					setTimeout(updateSelectedTotals, 100); 
				}
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
						style="background: linear-gradient(to right, #ffe4ec, #fddde6); border-bottom: 2px solid #f8a6c9; text-align: center; color: #d63384; font-weight: bold; font-size: 16px; height: 50px;">
						<th style="width: 10%;">선택</th>
						<th style="width: 40%; text-align: left;">상품 정보</th>
						<th style="width: 15%;">수량</th>
						<th style="width: 15%;">주문금액</th>
						<th style="width: 15%;">삭제</th>
					</tr>
				</thead>

				<tbody>
					<c:choose>
						<c:when test="${not empty cartItem }">
							<c:forEach var="item" items="${cartItem }">
								<tr
									style="text-align: center; border-bottom: 1px solid #eee; transition: background-color 0.3s ease;"
									onmouseover="this.style.backgroundColor='#fff0f5';"
									onmouseout="this.style.backgroundColor='white';">
									<td><input type="checkbox" name="checkCart"
										value="${item.productId}" class="cart-item-checkbox"
										data-price="${item.price * item.quantity}"
										data-quantity="${item.quantity}"
										<c:if test="${item.stockQuantity == 0}">disabled</c:if> /></td>

									<td style="text-align: left; padding: 10px;"><img
										src="<c:url value='/admin/common/images/products/${item.thumbnailImg}'/>"
										width="100"
										style="vertical-align: middle; margin-right: 20px; border-radius: 8px;" />
										${item.productName} <c:if test="${item.stockQuantity == 0}">
											<span style="color: red; font-weight: bold;">[품절]</span>
										</c:if></td>

									<td>
										<div class="quantity-control"
											data-product-id="${item.productId}" data-cart-id="${cartId}"
											data-stock="${item.stockQuantity}">
											<button type="button" class="minus-btn"
												<c:if test="${item.stockQuantity == 0}">disabled</c:if>>−</button>
											<input type="text" class="quantity-input"
												value="${item.quantity}" min="1"
												<c:if test="${item.stockQuantity == 0}">disabled</c:if> />
											<button type="button" class="plus-btn"
												<c:if test="${item.stockQuantity == 0}">disabled</c:if>>+</button>
										</div>
									</td>

									<td><strong class="unitPrice"
										data-products-id="${item.productId}"> <fmt:formatNumber
												value="${item.price * item.quantity}" pattern="#,###" />원
									</strong></td>

									<td><input type="button" value="삭제"
										class="singleDeleteBtn"
										style="margin-left: 10px; width: 100px; height: 30px; background: white; color: hotpink; border: 1px solid hotpink; border-radius: 4px; font-weight: bold;">
										<input type="hidden" name="productId"
										value="${item.productId}"></td>
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
				<strong style="font-size: 20px;">총 주문 상품</strong> <span
					id="totalQuantity" style="font-size: 25px; color: hotpink;"><c:out
						value="${totalQuantity}" />개</span>
			</div>

			<div
				style="display: flex; justify-content: center; align-items: center; font-size: 20px;">
				<div style="margin: 0 10px;">
					<strong id="totalPrice"><fmt:formatNumber
							value="${totalCartPrice}" pattern="#,###" />원</strong>
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

			<c:set var="hasInStockItem" value="false" />
			<c:forEach var="item" items="${cartItem}">
				<c:if test="${item.stockQuantity > 0}">
					<c:set var="hasInStockItem" value="true" />
				</c:if>
			</c:forEach>

			<c:if test="${hasInStockItem}">
				<button id="orderBtn"

					style="background-color: #f48fb1; border: none; color: white; font-size: 18px; padding: 12px 40px; border-radius: 30px; cursor: pointer;">
					주문하기</button>
			</c:if>

		</div>
	</main>

	<!-- ✅ 공통 푸터 -->
	<c:import url="/common/footer.jsp" />
	<script>
document.querySelectorAll(".cart-item-checkbox").forEach(cb => {
//	  cb.addEventListener("change", updateSelectedTotals);
		  cb.addEventListener("change", () => {
			  console.log("📌 [체크박스 클릭됨]");
			    console.log("  data-price:", cb.getAttribute("data-price"));
			    console.log("  data-quantity:", cb.getAttribute("data-quantity"));
			    console.log("  typeof price:", typeof cb.getAttribute("data-price"));
			    console.log("변경된 체크박스 값: ", cb.getAttribute("data-price"), cb.getAttribute("data-quantity"));
			    updateSelectedTotals();
			  });
	});
</script>
	<script>
document.getElementById("orderBtn").addEventListener("click", function () {
    const checkedItems = document.querySelectorAll("input[name='checkCart']:checked");
    if (checkedItems.length === 0) {
       	showToast("주문할 상품을 선택해주세요.");
        return;
    }

    const form = document.createElement("form");
    form.method = "GET";
    form.action = "../order/order_multiple.jsp";

    // 사용자 ID
    const userIdInput = document.createElement("input");
    userIdInput.type = "hidden";
    userIdInput.name = "userId";
    userIdInput.value = "<%= userId %>";
    form.appendChild(userIdInput);

    // 장바구니 ID
    const cartIdInput = document.createElement("input");
    cartIdInput.type = "hidden";
    cartIdInput.name = "cartId";
    cartIdInput.value = "<%= cs.searchCartId(userId) %>";
    form.appendChild(cartIdInput);

    // 선택된 상품들
    checkedItems.forEach(item => {
        const input = document.createElement("input");
        input.type = "hidden";
        input.name = "productIds";
        input.value = item.value;
        form.appendChild(input);
    });

    document.body.appendChild(form);
    form.submit();
});

document.querySelectorAll(".singleDeleteBtn").forEach(btn => {
	  btn.addEventListener("click", function () {
	
	    const productId = this.closest("tr").querySelector("input[name='productId']").value;

	    const form = document.createElement("form");
	    form.method = "POST";
	    form.action = "remove_cart.jsp";

	    const input = document.createElement("input");
	    input.type = "hidden";
	    input.name = "checkCart";
	    input.value = productId;

	    form.appendChild(input);
	    document.body.appendChild(form);
	    form.submit();
	  });
	});
</script>

</body>
</html>
