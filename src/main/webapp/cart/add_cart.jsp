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
	location.href = "login.jsp";
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
	%>
	<script>
	alert("이미 상품이 장바구니에 존재합니다.");
	location.href = "cart.jsp";
	</script>
	<%
	return;
}



ciDTO.setCartId(cartId);
ciDTO.setProductId(productId);
ciDTO.setQuantity(qty);
cs.addToCart(ciDTO);

response.sendRedirect("cart.jsp");

%>

