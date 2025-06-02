<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="cart.CartItemDTO"%>
<%@page import="cart.CartService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
request.setCharacterEncoding("UTF-8");
Integer userId = (Integer) session.getAttribute("userId");



CartService cs = new CartService();

Integer cartId = cs.searchCartId(userId);

if (cartId == null) {
	cartId = cs.makeCartId(userId);
}
CartItemDTO ciDTO = new CartItemDTO();

String[] productIds = request.getParameterValues("productId");
String[] qtys = request.getParameterValues("qty");
			List<String> removedList = new ArrayList<String>();
if (productIds != null && productIds.length > 0) {
	boolean flag = false;	
	
	for (int i = 0; i < productIds.length; i++) {
		int checkProductId = Integer.parseInt(productIds[i]);
		int checkQty = Integer.parseInt(qtys[i]);
		
		if(cs.existsCart(cartId, checkProductId)){
			removedList.addAll(cs.searchRemoved(checkProductId, cartId));
			continue;
		}
		
		ciDTO.setProductId(checkProductId);
		ciDTO.setQuantity(checkQty);
		ciDTO.setCartId(cartId);

		
		cs.addToCart(ciDTO);
	}//end for
		if (!removedList.isEmpty()) {
			String name = String.join(", " , removedList);
				%>
				<script>
			alert("장바구니에 있는 항목들은 추가 하지 않았습니다. : <%=name%>");
			location.href = "wishlist.jsp";				
				</script>
				<%
		}else{
			%>
			<script>
			alert("장바구니에 추가 하였습니다.");
			location.href="wishlist.jsp";
			</script>
			<% 
		}//end else;
		
	}else{ //end if
		int productId = Integer.parseInt(request.getParameter("productId"));
		int qty = Integer.parseInt(request.getParameter("qty"));
	
		if(cs.existsCart(cartId, productId)){
			%>
			<script>
			alert("장바구니에 이미 있음");
			location.href="wishlist.jsp";
			</script>
			<% 
		}
		ciDTO.setProductId(productId);
		ciDTO.setQuantity(qty);
		ciDTO.setCartId(cartId);
		cs.addToCart(ciDTO);
		%>
		<script>
		alert("장바구니에 추가되었음");
		location.href="wishlist.jsp";
		</script>
		
		<%
	}

%>
