<%@page import="wishlist.WishListDTO"%>
<%@page import="wishlist.WishDAO"%>
<%@page import="wishlist.WishService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8" info=""%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
request.setCharacterEncoding("UTF-8");
Integer userId = (Integer)session.getAttribute("userId");
if(userId == null){
	%>
	 <script>
    alert("로그인 후 이용해주세요.");
	location.href = "login.jsp";
	</script>
	<%
	return;
}
int productId = Integer.parseInt(request.getParameter("productId"));
WishService ws = new WishService();

WishListDTO wlDTO = new WishListDTO();
wlDTO.setProductId(productId);

wlDTO.setUserId(userId);
if(ws.existWishes(userId, productId)){
ws.removeWishList(wlDTO, productId);
response.sendRedirect("../product/menu.jsp");
}else{
ws.insertWish(wlDTO);
response.sendRedirect("../product/menu.jsp");
}
%>
<!-- <script> -->
<!-- alert("찜목록에 추가되었습니다"); -->
<!-- location.href="menu.jsp"; -->
<!-- </script> -->
<%
%>