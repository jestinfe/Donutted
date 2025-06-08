<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserService" %>
<%@ include file="/common/login_chk.jsp" %>

<%
  request.setCharacterEncoding("UTF-8");
  Integer userId = (Integer) session.getAttribute("userId");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>비밀번호 변경</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <style>
    body {
      font-family: 'Pretendard', 'Segoe UI', sans-serif;
      background-color: #f8f9fa;
      padding: 30px;
    }
    .form-box {
      background-color: white;
      padding: 30px;
      border-radius: 10px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
      max-width: 500px;
      margin: auto;
    }
    .form-label {
      font-weight: bold;
    }
    .btn-pink {
      background-color: #ef84a5;
      color: white;
      border: none;
    }
    .btn-pink:hover {
      background-color: #e26c93;
    }
  </style>
</head>
<body>

<div class="form-box">
  <h4 class="mb-4">비밀번호 변경</h4>
  <form action="change_password_process.jsp" method="post">
    <input type="hidden" name="user_id" value="<%= userId %>">

    <div class="mb-3">
      <label class="form-label">현재 비밀번호</label>
      <input type="password" name="currentPassword" class="form-control" required>
    </div>

    <div class="mb-3">
      <label class="form-label">새 비밀번호</label>
      <input type="password" name="newPassword" class="form-control" required>
    </div>

    <div class="mb-3">
      <label class="form-label">새 비밀번호 확인</label>
      <input type="password" name="confirmPassword" class="form-control" required>
    </div>

    <div class="text-center">
      <button type="submit" class="btn btn-pink px-5">변경</button>
    </div>
  </form>
</div>

</body>
</html>
