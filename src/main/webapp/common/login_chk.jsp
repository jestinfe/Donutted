<%
  request.setCharacterEncoding("UTF-8");

  if (session.getAttribute("userId") == null) {
%>
    <script>
      alert("로그인이 필요합니다.");
      location.href = "/mall_prj/UserLogin/login.jsp";
    </script>
<%
    return;
  }
%>
