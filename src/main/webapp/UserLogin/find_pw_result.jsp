<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserService" %>
<%@ page import="java.net.URLEncoder" %>

<%
  System.out.println("==== [DEBUG] find_pw_result.jsp ====");

  request.setCharacterEncoding("UTF-8");

  String id = request.getParameter("id");
  String email = request.getParameter("email");
  String tel = request.getParameter("tel");

  System.out.println("id 파라미터: " + id);
  System.out.println("email 파라미터: " + email);
  System.out.println("tel 파라미터: " + tel);

  boolean verified = false;

  if (id != null && email != null && tel != null &&
      !id.trim().isEmpty() && !email.trim().isEmpty() && !tel.trim().isEmpty()) {

    UserService service = new UserService();
    verified = service.isValidUserForPasswordReset(id.trim(), email.trim(), tel.trim());

    System.out.println(">>> [DEBUG] 인증 결과 verified: " + verified);
  } else {
    System.out.println(">>> [DEBUG] 입력 파라미터에 null 또는 공백 있음 <<<");
  }

  if (verified) {
    response.sendRedirect("reset_pw.jsp?id=" + URLEncoder.encode(id, "UTF-8")); 
  } else {
%>
<script>
  alert("일치하는 회원 정보가 없습니다.");
  history.back();
</script>
<%
  }
%>
