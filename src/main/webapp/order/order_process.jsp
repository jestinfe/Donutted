<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="order.OrderService" %>
<%@ page import="java.io.*, java.util.*" %>

<%
response.setHeader("Cache-Control", "no-store");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
request.setCharacterEncoding("UTF-8");

if (session.getAttribute("userId") == null) {
    response.sendRedirect("/mall_prj/UserLogin/login.jsp");
    return;
}

// 중복 주문 방지
Boolean alreadyOrdered = (Boolean) session.getAttribute("alreadyOrdered");
if (alreadyOrdered != null && alreadyOrdered) {
    response.sendRedirect("order_success.jsp");
    return;
}

try {
    String userIdStr = request.getParameter("userId");
    String totalCostStr = request.getParameter("totalCost");

    if (userIdStr == null || totalCostStr == null || userIdStr.trim().isEmpty() || totalCostStr.trim().isEmpty()) {
%>
    <script>
        alert("필수 주문 정보가 누락되었습니다.");
        response.sendRedirect("index.jsp");
    </script>
<%
        return;
    }

    int userId = Integer.parseInt(userIdStr.trim());
    int totalCost = Integer.parseInt(totalCostStr.trim());

    // 공통 정보
    String name = request.getParameter("name");
    String phone = request.getParameter("phone");
    String email = request.getParameter("email");
    String zipCode = request.getParameter("zipCode");
    String addr1 = request.getParameter("addr1");
    String addr2 = request.getParameter("addr2");
    String memo = request.getParameter("memo");

    OrderService service = new OrderService();
    boolean success = false;

    // ✅ 장바구니 기반 주문 처리
    String cartIdStr = request.getParameter("cartId");
    if (cartIdStr != null && !cartIdStr.trim().isEmpty()) {
        int cartId = Integer.parseInt(cartIdStr.trim());
        success = service.placeOrder(userId, cartId, name, phone, email, zipCode, addr1, addr2, memo, totalCost);
    }
    // ✅ 단일 상품 주문 처리
    else {
        String productIdStr = request.getParameter("productId");
        String productName = request.getParameter("productName");
        String unitPriceStr = request.getParameter("unitPrice");
        String quantityStr = request.getParameter("quantity");

        if (productIdStr == null || unitPriceStr == null || quantityStr == null ||
            productIdStr.trim().isEmpty() || unitPriceStr.trim().isEmpty() || quantityStr.trim().isEmpty()) {
%>
    <script>
        alert("상품 주문 정보가 누락되었습니다.");
        response.sendRedirect("index.jsp");
    </script>
<%
            return;
        }

        int productId = Integer.parseInt(productIdStr.trim());
        int unitPrice = Integer.parseInt(unitPriceStr.trim());
        int quantity = Integer.parseInt(quantityStr.trim());

        success = service.placeSingleOrder(userId, productId, productName, unitPrice, quantity, name, phone, email, zipCode, addr1, addr2, memo, totalCost);
    }

    if (success) {
        session.setAttribute("alreadyOrdered", true);
        response.sendRedirect("order_success.jsp");
    } else {
%>
    <script>
        alert("주문 처리 중 오류가 발생했습니다.");
        history.back();
    </script>
<%
    }

} catch (Exception e) {
    e.printStackTrace();
%>
    <script>
        alert("시스템 오류 발생: <%= e.getMessage().replaceAll("\"", "\\\\\"") %>");
        history.back();
    </script>
<%
}
%>
