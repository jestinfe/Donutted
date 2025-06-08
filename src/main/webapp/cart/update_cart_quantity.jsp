<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.util.List"%>
<%@page import="cart.CartItemDTO"%>
<%@page import="cart.CartService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8" info=""%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%

request.setCharacterEncoding("UTF-8");
int productId=Integer.parseInt(request.getParameter("productId"));
int quantity = Integer.parseInt(request.getParameter("quantity"));
int cartId = Integer.parseInt(request.getParameter("cartId"));
int userId = (Integer)session.getAttribute("userId");

CartService cs = new CartService();
int cnt = cs.plusQuantity(cartId, productId, quantity);
int stock = cs.searchStockQuantity(productId);


int totalPrice=0;
int totalQuantity=0;
int unitPrice=0;
if(quantity > stock){
    response.setContentType("application/json;charset=UTF-8");
    JSONObject errorJson = new JSONObject();
    errorJson.put("error", true);
    errorJson.put("message", "재고 수량을 초과했습니다. (최대 " + stock + "개)");
    out.print(errorJson.toString());
    return;

}else{
List<CartItemDTO> list = cs.showAllCartItem(userId);
for(CartItemDTO ciDTO : list){
	int itemTotal= ciDTO.getPrice()*ciDTO.getQuantity();
	totalPrice += ciDTO.getPrice()*ciDTO.getQuantity();
	totalQuantity += ciDTO.getQuantity();
	if(productId == ciDTO.getProductId()){
		unitPrice = itemTotal;
		}
	}//for
}//else

response.setContentType("application/json;charset=UTF-8");
JSONObject json = new JSONObject();
json.put("totalPrice", totalPrice);
json.put("totalQuantity", totalQuantity);
json.put("unitPrice", unitPrice);
json.put("productId", productId);
json.put("quantity", quantity);
json.put("stock", stock);

out.print(json.toString());
%>
