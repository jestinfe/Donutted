<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserService" %>
<%@ include file="/common/login_chk.jsp" %>

<%
  Integer userId = (Integer) session.getAttribute("userId");
  UserService service = new UserService();
  boolean result = service.withdrawUser(userId);

  if (result) {
    session.invalidate();
%>
    <script>
      alert("회원 탈퇴가 정상적으로 완료되었습니다. 이용해주셔서 감사합니다.");
      location.href = "/mall_prj/index.jsp";
    </script>
<%
  } else {
%>
    <script>
      alert("회원 탈퇴 중 오류가 발생했습니다. 다시 시도해주세요.");
      history.back();
    </script>
<%
  }
%>
