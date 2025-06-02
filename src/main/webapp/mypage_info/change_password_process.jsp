<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserService, user.UserDTO" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>

<%
request.setCharacterEncoding("UTF-8");

// 세션에서 로그인된 사용자 ID 가져오기
Integer userId = (Integer) session.getAttribute("userId");
if (userId == null) {
    response.sendRedirect("/login.jsp");
    return;
}

// 입력값 받기
String currentPassword = request.getParameter("currentPassword");
String newPassword = request.getParameter("newPassword");
String confirmPassword = request.getParameter("confirmPassword");

if (currentPassword == null || newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
%>
  <script>
    alert("입력값이 올바르지 않거나 새 비밀번호가 일치하지 않습니다.");
    history.back();
  </script>
<%
  return;
}

UserService service = new UserService();
UserDTO user = service.getUserById(userId); // ★ 한 번만 호출해서 재사용

if (user == null) {
%>
  <script>
    alert("사용자 정보를 찾을 수 없습니다.");
    history.back();
  </script>
<%
  return;
}

// 현재 비밀번호 검증
boolean validUser = service.isValidLogin(user.getUsername(), currentPassword);

if (!validUser) {
%>
  <script>
    alert("현재 비밀번호가 올바르지 않습니다.");
    history.back();
  </script>
<%
  return;
}

// 비밀번호 업데이트 시도
boolean result = service.resetPassword(user.getUsername(), newPassword);

if (result) {
%>
  <script>
    alert("비밀번호가 성공적으로 변경되었습니다.");
    location.href = "my_page.jsp";
  </script>
<%
} else {
%>
  <script>
    alert("비밀번호 변경 중 오류가 발생했습니다.");
    history.back();
  </script>
<%
}
%>
