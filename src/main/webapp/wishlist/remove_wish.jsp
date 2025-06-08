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
	}
	session.setAttribute("toast", "선택한 상품이 삭제되었습니다.");
	response.sendRedirect("wishlist.jsp");
return;
} else {
	session.setAttribute("toast", "선택한 삭제할 항목을 선택하세요.");
	response.sendRedirect("wishlist.jsp");
return;
}

%>