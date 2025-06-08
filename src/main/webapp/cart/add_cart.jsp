<%@page import="java.net.URLEncoder"%>
<%@page import="cart.CartItemDTO"%>
<%@page import="cart.CartService"%>
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
	alert("로그인하세요");
	location.href = "../UserLogin/login.jsp";
	</script>
	
	<%
	return;
}

int productId = Integer.parseInt(request.getParameter("productId"));
int qty = Integer.parseInt(request.getParameter("qty"));

CartService cs = new CartService();

Integer cartId = cs.searchCartId(userId);

if(cartId == null){
	cartId = cs.makeCartId(userId);
}
CartItemDTO ciDTO = new CartItemDTO();


if(cs.existsCart(cartId, productId)){
	cs.addQuantity(cartId, productId, qty);
	session.setAttribute("toast", "장바구니에 추가되었습니다.");
	response.sendRedirect("../product/product_detail.jsp?productId=" + productId);
}else{

ciDTO.setCartId(cartId);
ciDTO.setProductId(productId);
ciDTO.setQuantity(qty);
cs.addToCart(ciDTO);
session.setAttribute("toast", "장바구니에 추가되었습니다.");
response.sendRedirect("../product/product_detail.jsp?productId=" + productId);
}
%>

