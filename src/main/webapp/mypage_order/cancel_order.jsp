<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="order.OrderService" %>
<%
  request.setCharacterEncoding("UTF-8");
  String orderIdParam = request.getParameter("order_id");
  
  if (session.getAttribute("userId") ==null ) {
	  response.sendRedirect("/mall_prj/UserLogin/login.jsp");
	  return;
	}
  
  Integer userId = (Integer) session.getAttribute("userId");

  if (orderIdParam == null) {
    out.print("<script>alert('잘못된 접근입니다.'); history.back();</script>");
    return;
  }

  int orderId = Integer.parseInt(orderIdParam);
  OrderService service = new OrderService();

  boolean result = service.cancelOrder(orderId);

  if (result) {
    out.print("<script>alert('주문이 성공적으로 취소되었습니다.'); location.href='my_orders.jsp';</script>");
  } else {
    out.print("<script>alert('주문 취소에 실패했습니다. 관리자에게 문의하세요.'); history.back();</script>");
  }
%>
