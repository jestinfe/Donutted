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
	out.print("{\"success\": false, \"message\": \"로그인이 필요합니다.\"}");
	return;
}
int productId = Integer.parseInt(request.getParameter("productId"));

WishService ws = new WishService();
WishListDTO wlDTO = new WishListDTO();
wlDTO.setProductId(productId);
wlDTO.setUserId(userId);
try{
if(ws.existWishes(userId, productId)){
	ws.removeWishList(wlDTO, productId);
	out.print("{\"success\": true, \"action\": \"removed\"}");
}else{
	ws.insertWish(wlDTO);
	 out.print("{\"success\": true, \"action\": \"added\"}");
}
}catch(Exception e){
	  e.printStackTrace();
	    out.print("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
}

%>