<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserService, user.UserDTO" %>
<%
request.setCharacterEncoding("UTF-8");

String id = request.getParameter("id");
String pass = request.getParameter("pass");

UserService service = new UserService();
UserDTO user = service.login(id, pass); // 로그인 로직

if (user != null) {
    session.setAttribute("userId", user.getUserId());        
    session.setAttribute("loginId", user.getUsername());

%>
    <script>
      alert("<%=id %>님, 환영합니다");
      location.href = "/mall_prj/index.jsp";
    </script>
<%
} else {
%>
    <script>
      alert("로그인 실패. 아이디 또는 비밀번호를 확인하세요.");
      history.back();
    </script>
<%
}
%>
