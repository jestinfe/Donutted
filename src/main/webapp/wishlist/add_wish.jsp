<%@page import="wishlist.WishListDTO"%>
<%@page import="wishlist.WishDAO"%>
<%@page import="wishlist.WishService"%>
<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");

Integer userId = (Integer) session.getAttribute("userId");
String productIdParam = request.getParameter("productId");

if (userId == null) {
    out.print("{\"success\": false, \"message\": \"로그인이 필요합니다.\"}");
    return;
}

if (productIdParam == null || productIdParam.trim().isEmpty()) {
    out.print("{\"success\": false, \"message\": \"상품 ID가 유효하지 않습니다.\"}");
    return;
}

int productId = Integer.parseInt(productIdParam);
WishService ws = new WishService();

WishListDTO wlDTO = new WishListDTO();
wlDTO.setProductId(productId);
wlDTO.setUserId(userId);

try {
    if (ws.existWishes(userId, productId)) {
        ws.removeWishList(wlDTO, productId);
        out.print("{\"success\": true, \"action\": \"removed\"}");
    } else {
        ws.insertWish(wlDTO);
        out.print("{\"success\": true, \"action\": \"added\"}");
    }
} catch (Exception e) {
    e.printStackTrace();
    out.print("{\"success\": false, \"message\": \"서버 오류가 발생했습니다.\"}");
}
%>