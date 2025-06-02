<%@page import="java.util.ArrayList"%>
<%@page import="cart.CartService"%>
<%@page import="cart.CartItemDTO"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
Integer userId = (Integer) session.getAttribute("userId");
if (userId == null) {
  %>
  	 <script>
	    alert("로그인 후 이용해주세요.");
    	location.href = "login.jsp";
  	</script>
  <% 
  return;
}
CartService cs = new CartService();

if(cs.searchCartId(userId) != null){
List<CartItemDTO> cartItem = cs.showAllCartItem(userId);
request.setAttribute("cartItem", cartItem);
}


%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>장바구니</title>
  <c:import url="jsp/external_file.jsp"/>
<script type="text/javascript">
window.onload = function () {
    const checkAll = document.getElementById("checkAllBottom");
    const checkboxes = document.querySelectorAll("tbody input[type='checkbox']");

    checkAll.addEventListener("change", function () {
      checkboxes.forEach(function (cb) {
        cb.checked = checkAll.checked;
      });
    });
    $("#deleteBtn").click(function () {
    	  const checked = $("input[name='checkCart']:checked");

    	  if (checked.length === 0) {
    	    alert("삭제할 상품을 선택해주세요.");
    	    return;
    	  }

    	  if (!confirm("정말 삭제하시겠습니까?")) return;
		
    	  const productIds = [];
    	  checked.each(function () {
    	    productIds.push($(this).val());
    	  });
    	  
    	  $.ajax({
    		  url: "remove_AjaxCart.jsp",
    		  type: "POST",
    		  data: {productsIds : productIds},
    		  traditional : true, //배열 구조 보낼대 필수 
    		  success:function(res){
    			  if(res.trim() == "ok"){
    			       checked.each(function () {
    			           $(this).closest("tr").remove();
    			  });
    			       alert("삭제되었습니다.");
    		  }else{
    			alert("삭제 실패 : " + res);  
    		  	}
    		  },
    		  error:function(){
    			  alert("서버 통신 중 오류 ");
    		  }
    		  
    		  
    	  
    	  	});
    	  });
  };
  

</script>
</head>
<body>

  <!-- ✅ 공통 헤더 -->
  <c:import url="/common/header.jsp" />

  <!-- ✅ 본문 영역 -->
  <main class="container" style="min-height: 600px; padding: 60px 20px;">
    <h2 style="font-size: 28px; font-weight: bold; margin-bottom: 20px;">  <strong style="position: relative; display: inline-block;">
    장바구니
    <span style="
      background-color: #f8a6c9;
      color: white;
      font-size: 13px;
      font-weight: bold;
      border-radius: 50%;
      padding: 2px 8px;
      position: relative;
      top: -5px;
      left: 5px;
      display: inline-block;
      line-height: 1;
    ">1</span>
  </strong>
  </h2>
   
    <!-- TODO: 실제 컨텐츠 작성 영역 -->
	<p style="color: #333; font-size: 24px; font-weight: bold; margin-bottom: 30px; margin-top: 40px;">

  	 <table border="0" width="100%" cellpadding="10" cellspacing="0" style="border-collapse: collapse; margin-bottom: 30px;">
 	 <thead>
    <tr style="background-color: #f9f9f9; border-bottom: 2px solid #ddd; text-align: center;">
      <th style="width: 10%;">선택</th>
      <th style="width: 40%; text-align: left;">상품 정보</th>
      <th style="width: 15%;">수량</th>
      <th style="width: 15%;">주문금액</th>
      <th style="width: 20%;">배송 정보</th>
    </tr>
  </thead>
  <tbody>
  <c:choose>
  	<c:when test="${not empty cartItem }">
	<c:forEach var="item" items="${cartItem }">
	<tr style="text-align: center; border-bottom: 1px solid #eee;">
	<td><input type="checkbox" name="checkCart" value="${item.productId }"/>
	</td>
	
	<td style="text-align: left;">
	<img src="<c:url value='/admin/common/upload/${item.thumbnailImg}'/>" width="200"
             style="vertical-align: middle; margin-right: 50px;"/>
             ${item.productName}
	</td>
	<td>
        <input type="number" value="${item.quantity}" min="1" style="width: 50px; text-align: center;">
      </td>
      <td>
        <strong><fmt:formatNumber value="${item.price * item.quantity}" pattern="#,###" />원</strong>
      </td>
      <td>+ 3,000원</td>
    </tr>
	</c:forEach>	    
  	</c:when>
  	 <c:otherwise>
      <tr>
<!--       <td> -->
<%--       	<img src="<c:url value='/common/upload/ronaldo.jpg'/>" width="200" --%>
<!--              style="vertical-align: middle; margin-right: 50px;"/> -->
<!--         </td> -->
        <td colspan="5" style="text-align:center;">장바구니가 비어 있습니다.</td>
      </tr>
    </c:otherwise>
  </c:choose>
  </tbody>
</table>
<div>
<input type="checkbox" id="checkAllBottom"  /> 전체선택
<input type="button" value="선택상품 삭제" id="deleteBtn" class="btn btn-success btn-sm" 
style="background-color: #f48fb1; border: none; color: white; font-size: 18px; padding: 12px 20px; border-radius: 30px; cursor: pointer;"/>
</div>
<!-- 총 금액 요약 박스 -->
<div style="background-color: #fff0f5; padding: 30px; text-align: center; font-size: 18px; border-radius: 15px; margin-top: 40px;">
  <div style="margin-bottom: 20px;">
    <strong style="font-size: 20px;">총 주문 상품</strong> <span style="color: hotpink;">1 개</span>
  </div>

  <div style="display: flex; justify-content: center; align-items: center; font-size: 20px;">
    <div style="margin: 0 10px;">
      <strong>27,900원</strong>
      <div style="font-size: 14px; color: gray;">상품금액</div>
    </div>
    <div style="font-size: 20px;">+</div>
    <div style="margin: 0 10px;">
      <strong>3,000원</strong>
      <div style="font-size: 14px; color: gray;">배송비</div>
    </div>
    <div style="font-size: 20px;">=</div>
    <div style="margin: 0 10px;">
      <strong style="color: hotpink;">30,900원</strong>
      <div style="font-size: 14px; color: gray;">총 주문금액</div>
    </div>
  </div>
</div>

<!-- 주문 버튼 -->
<div style="text-align: center; margin-top: 30px;">
	<form action="order_multiple.jsp" method="GET">
  <button style="background-color: #f48fb1; border: none; color: white; font-size: 18px; padding: 12px 40px; border-radius: 30px; cursor: pointer;">
    주문하기
  </button>
  <input type="hidden" value="${ userId }" name="userId"/>
  <input type="hidden" value="<%= cs.searchCartId(userId) %>" name="cartId"/>
  </form>
</div>
  </main>

  <!-- ✅ 공통 푸터 -->
  <c:import url="/common/footer.jsp" />

</body>
</html>
