<%@page import="java.net.URLEncoder"%>
<%@page import="wishlist.WishListDTO"%>
<%@page import="wishlist.WishDAO"%>
<%@page import="wishlist.WishService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8" info=""%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
Integer userId = (Integer)session.getAttribute("userId");
if(userId == null){
%>
	<script>
	alert("로그인 하세요.");
	location.href="../UserLogin/login.jsp";
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
	response.sendRedirect("product_detail.jsp?productId="+productId);
}else{
	ws.insertWish(wlDTO);
	session.setAttribute("toast", "찜목록에 추가되었습니다.");
	response.sendRedirect("product_detail.jsp?productId=" + productId);
	
}






%>