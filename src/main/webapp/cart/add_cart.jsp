<%@page import="java.net.URLEncoder"%>
<%@page import="cart.CartItemDTO"%>
<%@page import="cart.CartService"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
   pageEncoding="UTF-8" info=""%>

<%
request.setCharacterEncoding("UTF-8");
Integer userId = (Integer)session.getAttribute("userId");
if(userId == null){
	out.print("{\"success\": false, \"message\": \"로그인이 필요합니다.\"}");
	return;
}

int productId = Integer.parseInt(request.getParameter("productId"));
int qty = Integer.parseInt(request.getParameter("quantity"));

CartService cs = new CartService();

Integer cartId = cs.searchCartId(userId);

if(cartId == null){
	cartId = cs.makeCartId(userId);
}
CartItemDTO ciDTO = new CartItemDTO();


if(cs.existsCart(cartId, productId)){
	cs.addQuantity(cartId, productId, qty);
}else{

ciDTO.setCartId(cartId);
ciDTO.setProductId(productId);
ciDTO.setQuantity(qty);
cs.addToCart(ciDTO);
}
out.print("{\"success\": true}");
%>

