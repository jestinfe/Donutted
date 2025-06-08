<%@page import="java.net.URLEncoder"%>
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
int addedCount = 0;
String msg = "";

if (productIds != null && productIds.length > 1) {
	for (int i = 0; i < productIds.length; i++) {
		int checkProductId = Integer.parseInt(productIds[i]);
		int checkQty = Integer.parseInt(qtys[i]);

		if (cs.existsCart(cartId, checkProductId)) {
			removedList.addAll(cs.searchRemoved(checkProductId, cartId));
			continue;
		}

		ciDTO.setProductId(checkProductId);
		ciDTO.setQuantity(checkQty);
		ciDTO.setCartId(cartId);
		cs.addToCart(ciDTO);
		addedCount++;
	}

	if (addedCount == 0 && !removedList.isEmpty()) {
		String name = String.join(", ", removedList);
		msg = "이미 장바구니에 있는 상품입니다: [" + name + "]";
	} else if (!removedList.isEmpty()) {
		String name = String.join(", ", removedList);
		msg = "이미 장바구니에 있는 상품 [" + name + "]을 제외 후 장바구니에 추가되었습니다.";
	} else {
		msg = "장바구니에 추가되었습니다.";
	}
} else {
	int productId = Integer.parseInt(request.getParameter("productId"));
	int qty = Integer.parseInt(request.getParameter("qty"));

	if (cs.existsCart(cartId, productId)) {
		msg = "이미 장바구니에 있는 상품 입니다.";
	} else {
		ciDTO.setProductId(productId);
		ciDTO.setQuantity(qty);
		ciDTO.setCartId(cartId);
		cs.addToCart(ciDTO);
		msg = "장바구니에 추가되었습니다.";
	}
}
session.setAttribute("toast", msg);
response.sendRedirect("../wishlist/wishlist.jsp");
%>
