<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserService" %>
<%@ include file="../common/login_check.jsp" %>


<%
  int userId = 0;
  boolean result = false;

  try {
    userId = Integer.parseInt(request.getParameter("user_id"));

    UserService service = new UserService();
    result = service.withdrawUser(userId); // 또는 forceWithdraw(userId)
  } catch (Exception e) {
    e.printStackTrace();  // 실제 운영에서는 로그 처리 또는 관리자 이메일 전송
  }

  if (result) {
    response.sendRedirect("member_withdraw_done.jsp");
  } else {
    response.sendRedirect("member_detail.jsp?user_id=" + userId + "&error=true");
  }
%>
