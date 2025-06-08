<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  // 세션 무효화 (로그아웃 처리)
  session.invalidate();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>로그아웃</title>
  <script>
    alert("로그아웃되었습니다.");
    location.href = "login.jsp";
  </script>
</head>
<body>
</body>
</html>
