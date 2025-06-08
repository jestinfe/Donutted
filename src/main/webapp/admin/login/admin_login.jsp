<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<%@ include file="../common/external_file.jsp" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>관리자 로그인</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <style>
    body {
      background-color: #f5f5f5;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }
    .login-box {
      background: white;
      padding: 30px;
      border-radius: 10px;
      width: 360px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
  </style>
</head>
<body>
  <div class="container" style="max-width: 400px;">
    <div class="login-box">
      <h3 class="text-center mb-4">관리자 로그인</h3>
      <form action="admin_login_process.jsp" method="post">
        <div class="mb-3">
          <label for="adminId" class="form-label">아이디</label>
          <input type="text" class="form-control" id="adminId" name="adminId" required>
        </div>
        <div class="mb-3">
          <label for="adminPass" class="form-label">비밀번호</label>
          <input type="password" class="form-control" id="adminPass" name="adminPass" required>
        </div>
        <button type="submit" class="btn btn-dark w-100">로그인</button>
      </form>
    </div>
  </div>
</body>
</html>
