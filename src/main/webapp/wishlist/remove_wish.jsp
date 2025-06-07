<%@page import="java.net.URLEncoder"%>
<%@page import="wishlist.WishListDTO"%>
<%@page import="wishlist.WishService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8" info=""%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
Integer userId = (Integer)session.getAttribute("userId");

WishService ws = new WishService();
WishListDTO wlDTO = new WishListDTO();
wlDTO.setUserId(userId);

String [] selectedWishList = request.getParameterValues("checkWish");

if(selectedWishList != null && selectedWishList.length>0){
	for(String wishItem : selectedWishList){
		int items = Integer.parseInt(wishItem);
		ws.removeWishList(wlDTO, items);
	} response.sendRedirect("wishlist.jsp?msg=" + URLEncoder.encode("선택한 상품이 삭제되었습니다.", "UTF-8"));
return;
} else {
response.sendRedirect("wishlist.jsp?msg=" + URLEncoder.encode("삭제할 항목을 선택해주세요.", "UTF-8"));
return;
}

%>