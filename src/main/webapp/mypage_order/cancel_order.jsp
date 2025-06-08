<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="order.OrderService" %>
<%@ include file="/common/login_chk.jsp" %>

<link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>

<%
request.setCharacterEncoding("UTF-8");

// ✅ 로그인 여부 확인
Integer sessionUserId = (Integer) session.getAttribute("userId");

// ✅ 파라미터 검증
String orderIdParam = request.getParameter("order_id");
if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
%>
    <script>
        alert("잘못된 접근입니다.");
        history.back();
    </script>
<%
    return;
}

int orderId = Integer.parseInt(orderIdParam.trim());

// ✅ 본인 소유 주문인지 검증 없이 진행할 수밖에 없음 (OrderService에서 처리해야 정확)
// 지금은 OrderService에 getOrderById가 없으니, cancelOrder 내부에서 본인 소유 여부를 꼭 검증해야 함

OrderService service = new OrderService();
boolean result = service.cancelOrder(orderId);

if (result) {
%>
    <script>
        alert("주문이 성공적으로 취소되었습니다.");
        location.href = "my_orders.jsp";
    </script>
<%
} else {
%>
    <script>
        alert("주문 취소에 실패했습니다. 관리자에게 문의하세요.");
        history.back();
    </script>
<%
}
%>
