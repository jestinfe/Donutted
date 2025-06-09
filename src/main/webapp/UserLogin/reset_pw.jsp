<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
String id = request.getParameter("id");
if (id == null || id.trim().isEmpty()) {
  response.sendRedirect("login.jsp");
  return;
}
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>비밀번호 재설정 | Donutted</title>
  <style>
    body { font-family: '맑은 고딕'; background: #f9f9f9; padding: 50px; }
    .box {
      max-width: 500px; margin: 0 auto; padding: 20px;
      background: #fff; border: 1px solid #ccc; border-radius: 10px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    input, button { width: 100%; padding: 10px; margin: 10px 0; box-sizing: border-box;}
    button { background: #f8a7bb; color: white; font-weight: bold; border: none; }
    button:hover { background: #f18aa7; }
  </style>
</head>
<body>
  <div class="box">
    <h2>새 비밀번호 설정</h2>
    <p><strong>현재 사용자 ID:</strong> <%= id %></p>
    <form id="resetPwForm" method="post">
      <input type="hidden" name="id" value="<%= id %>">
      <input type="password" name="newPw" placeholder="새 비밀번호" required>
      <input type="password" name="confirmPw" placeholder="비밀번호 확인" required>
      <button type="submit">비밀번호 변경</button>
    </form>
  </div>

  <script>
  document.addEventListener("DOMContentLoaded", function () {
    document.getElementById("resetPwForm").addEventListener("submit", function(e) {
      e.preventDefault();

      var form = e.target;
      var formData = new FormData(form);
      var params = new URLSearchParams(formData);

      fetch("reset_pw_ok.jsp", {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: params
      })
      .then(res => res.text())
      .then(data => {
        var result = data.trim().toUpperCase();
        if (result === "OK") {
          alert("비밀번호가 성공적으로 변경되었습니다.");
          location.href = "login.jsp";
        } else if (result === "MISMATCH") {
          alert("비밀번호가 서로 일치하지 않습니다.");
        } else if (result === "SAME") {
          alert("이전 비밀번호와 동일합니다.");
        } else {
          alert("비밀번호 변경에 실패했습니다. 다시 시도해주세요.");
        }
      })
      .catch(err => {
        alert("서버 통신 중 오류 발생: " + err.message);
      });
    });
  });
  </script>
</body>
</html>
