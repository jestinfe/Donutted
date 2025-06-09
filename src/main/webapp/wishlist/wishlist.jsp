<%@page import="wishlist.WishListDTO"%>
<%@page import="java.util.List"%>
<%@page import="wishlist.WishService"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:import url="../common/external_file.jsp"/>

<%
Integer userId = (Integer)session.getAttribute("userId");
if(userId==null){
	  %>
	  	 <script>
		    alert("로그인 후 이용해주세요.");
	    	location.href = "../UserLogin/login.jsp";
	  	</script>
	  <% 
	  	return;
}
WishService ws = new WishService();

List<WishListDTO> wishList = ws.showWishList(userId);

request.setAttribute("wishList", wishList);
%>



<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>찜목록 | Donutted</title>
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
<script type="text/javascript">
window.onload = function () {
	  const checkAllTop = document.getElementById("checkAll");
	  const checkAllBottom = document.getElementById("checkAllBottom");
	  const checkboxes = document.querySelectorAll(".itemCheck")

	// 공통 함수
	  function setAllChecked(checked) {
	    checkboxes.forEach(cb => cb.checked = checked);
	  }

	  // 상단 전체선택
	  checkAllTop.addEventListener("change", function () {
	    setAllChecked(this.checked);
	    checkAllBottom.checked = this.checked;
	  });

	  // 하단 전체선택
	  checkAllBottom.addEventListener("change", function () {
	    setAllChecked(this.checked);
	    checkAllTop.checked = this.checked;
	  });

	  // 개별 체크박스 상태 바뀔 때 → 상단/하단 체크박스 상태 맞춰줌
	  checkboxes.forEach(cb => {
	    cb.addEventListener("change", function () {
	      const allChecked = Array.from(checkboxes).every(cb => cb.checked);
	      checkAllTop.checked = allChecked;
	      checkAllBottom.checked = allChecked;
	    });
	  });
	  
	  // 모든 선택삭제 버튼에 이벤트 연결
	  document.querySelectorAll(".deleteBtn").forEach(btn => {
	    btn.addEventListener("click", function () {
	      const checked = document.querySelectorAll("input[name='checkWish']:checked");
	      if (checked.length === 0) {
	    	  showToast("삭제할 항목을 선택해주세요.");
	        return;
	      }
	      if (confirm("선택한 항목을 삭제하시겠습니까?")) {
	    	  
	        document.getElementById("wishForm").submit();
	      }
	    });
	  });
	
	  document.querySelectorAll(".singleDeleteBtn").forEach(btn => {
		  btn.addEventListener("click", function () {
		    if (!confirm("이 항목을 삭제하시겠습니까?")) return;

		    const productId = this.closest("div").querySelector("input[name='productId']").value;

		    const form = document.createElement("form");
		    form.method = "POST";
		    form.action = "remove_wish.jsp";

		    const input = document.createElement("input");
		    input.type = "hidden";
		    input.name = "checkWish";
		    input.value = productId;

		    form.appendChild(input);
		    document.body.appendChild(form);
		    form.submit();
		  });
		});
	  
	document.getElementById("selectGoCartBtn").addEventListener("click", function(){
		const checked = document.querySelectorAll("input[name='checkWish']:checked");
		if(checked.length === 0){
			showToast("장바구니에 담을 항목을 선택해주세요.");
			return;
		}//if
		
		if(!confirm("선택한 항목을 장바구니로 담으시겠습니까?")){
			return;
		}
		
		const form = document.getElementById("addWishToCart");
		form.innerHTML="";
		
		checked.forEach(cb => {
			const productId = cb.value;
			

		      const inputProduct = document.createElement("input");
		      inputProduct.type = "hidden";
		      inputProduct.name = "productId";
		      inputProduct.value = productId;
		      form.appendChild(inputProduct);

		      const inputQty = document.createElement("input");
		      inputQty.type = "hidden";
		      inputQty.name = "qty";
		      inputQty.value = "1"; // qty는 항상 1로 고정
		      form.appendChild(inputQty);
			
		});//checked
		form.submit();
		});	  	  
    
    
    };

</script>
</head>
<body>

	<!-- ✅ 공통 헤더 -->
	<c:import url="/common/header.jsp" />

	<!-- ✅ 본문 영역 -->
	<main class="container" style="min-height: 600px; padding: 60px 20px;">
		<h2 style="font-size: 28px; font-weight: bold; margin-bottom: 20px;">찜목록</h2>
		<!-- 전체 선택 영역 -->
		<div style="margin-bottom: 10px;">
			<input type="checkbox" id="checkAll" form="wishForm"/> 전체선택 <input type="button"
				value="선택삭제" id="selectDeleteBtn" class=deleteBtn 
				style="margin-left: 10px; width: 100px; height: 30px; background: white; color: hotpink; border: 1px solid hotpink; border-radius: 4px; font-weight: bold;" />
		</div>
		<!-- 🔁 찜 상품 리스트 반복 -->

<c:choose>
  <c:when test="${not empty wishList }">
    <div>
      <c:forEach var="wish" items="${wishList }">
        <div style="display: flex; align-items: flex-start; padding: 10px 0; border-top: 1px solid #ddd; border-bottom: 1px solid #ddd;">

          <!-- 체크박스 -->
          <div style="margin-right: 10px;">
            <input type="checkbox" name="checkWish" class="itemCheck" form="wishForm" value="${wish.productId}" />
             <input type="hidden" name="qty" value="1">
          </div>

          <!-- 이미지 -->
          <div style="margin-right: 20px;">
            <img src="<c:url value='/admin/common/images/products/${wish.thumbnailUrl }'/>" width="200"
                 style="vertical-align: middle; margin-right:50px;"/>
          </div>

          <!-- 상품 설명 -->
          <div style="flex-grow: 1;">
            <div style="color: gray; font-size: 13px;">무료배송</div>
            <div style="font-size: 14px; margin-top: 5px;">
              <strong>${wish.name}</strong>
            </div>
            <div style="color: red; font-weight: bold; margin-top: 5px;">
              <fmt:formatNumber value="${wish.price }" pattern="#,###"/>원
            </div>
          </div>

          <!-- 버튼 -->
          <div style="display: flex; flex-direction: column; justify-content: center; gap: 5px;">
          <form action="../cart/addToCart.jsp" method="POST">
            <input type="submit" value="장바구니 담기" class="goCartBtn"
                   style="margin-left: 10px; width: 100px; height: 30px; background: white; color: hotpink; border: 1px solid hotpink; border-radius: 4px; font-weight: bold;">
                      <input type="hidden" name="productId" value="${wish.productId}">
                      <input type="hidden" name="qty" value="1">
          </form>
            <input type="button" value="삭제" class="singleDeleteBtn"
                   style="margin-left: 10px; width: 100px; height: 30px; background: white; color: hotpink; border: 1px solid hotpink; border-radius: 4px; font-weight: bold;">
                   <input type="hidden" name="productId" value="${wish.productId}">
          </div>
        </div>
      </c:forEach>
    </div>
  </c:when>
  <c:otherwise>
    <div style="text-align:center;">찜 목록이 비어 있습니다.</div>
  </c:otherwise>
</c:choose>

<form action="remove_wish.jsp" method="POST" id="wishForm">

</form>
 				<form action="../cart/addToCart.jsp" method="POST" id="addWishToCart"></form>

		<!-- 이미지 -->
			

		<!-- 아래 전체선택 -->
		<div style="margin-top: 10px;">
			<input type="checkbox" id="checkAllBottom" form=""/> 전체선택 <input
				type="button" value="선택삭제" id="selectDeleteBtn2" class=deleteBtn 
				style="margin-left: 10px; width: 100px; height: 30px; background: white; color: hotpink; border: 1px solid hotpink; border-radius: 4px; font-weight: bold;" />
			<input type="button" value="장바구니 선택 담기" id="selectGoCartBtn" class="goCartBtn"
				style="margin-left: 10px; width: 150px; height: 30px; background: white; color: hotpink; border: 1px solid hotpink; border-radius: 4px; font-weight: bold; text-align: center;" />
				
		</div>
	</main>

	<!-- ✅ 공통 푸터 -->
	<c:import url="/common/footer.jsp" />
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
	}</script>
</body>
</html>
