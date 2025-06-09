<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>아이디 / 비밀번호 찾기 | Donutted</title>
  <style>
    body {
      font-family: '맑은 고딕';
      background: #fff;
    }
    .tab-container {
      width: 400px;
      margin: 100px auto;
      border: 1px solid #ccc;
      border-radius: 10px;
      padding: 20px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    .tabs {
      display: flex;
      margin-bottom: 20px;
    }
    .tab {
      flex: 1;
      text-align: center;
      padding: 10px;
      cursor: pointer;
      border-bottom: 2px solid #ddd;
    }
    .tab.active {
      border-bottom: 3px solid #f8a7bb;
      font-weight: bold;
    }
    .tab-content {
      display: none;
    }
    .tab-content.active {
      display: block;
    }
    input {
      width: 100%;
      padding: 10px;
      margin: 10px 0;
      border: 1px solid #ccc;
      border-radius: 5px;
      box-sizing: border-box;
    }
    button {
      width: 100%;
      padding: 12px;
      background: #f8a7bb;
      border: none;
      color: #fff;
      font-weight: bold;
      cursor: pointer;
    }
    button:hover {
      background: #f18aa7;
    }
    .result-box {
      margin-top: 15px;
      font-size: 14px;
    }
  </style>
</head>
<body>

<div class="tab-container">
  <div class="tabs">
    <div class="tab active" onclick="showTab('find-id')">아이디 찾기</div>
    <div class="tab" onclick="showTab('find-pw')">비밀번호 찾기</div>
  </div>

  <!-- 아이디 찾기 탭 -->
  <div id="find-id" class="tab-content active">
    <form id="findIdForm">
      <input type="text" name="name" placeholder="이름을 입력하세요" required>
      <input type="text" name="tel" placeholder="전화번호('-' 포함)" required>
      <button type="button" onclick="submitFindId()">아이디 찾기</button>
    </form>
    <div id="findIdResult" class="result-box"></div>
  </div>

  <!-- 비밀번호 찾기 탭 -->
  <div id="find-pw" class="tab-content">
    <form action="find_pw_result.jsp" method="post">
      <input type="text" name="id" placeholder="아이디를 입력하세요" required>
      <input type="text" name="email" placeholder="이메일을 입력하세요" required>
      <input type="text" name="tel" placeholder="전화번호('-' 포함)" required>
      <button type="submit">비밀번호 찾기</button>
    </form>
  </div>
</div>

<script>
  function showTab(tabId) {
    document.querySelectorAll('.tab').forEach(tab => tab.classList.remove('active'));
    document.querySelectorAll('.tab-content').forEach(div => div.classList.remove('active'));
    document.getElementById(tabId).classList.add('active');
  }

  function submitFindId() {
    const form = document.getElementById("findIdForm");
    const formData = new FormData(form);

    fetch("find_id_ok.jsp", {
      method: "POST",
      body: formData
    })
    .then(res => res.text())
    .then(html => {
      document.getElementById("findIdResult").innerHTML = html;
    })
    .catch(err => {
      document.getElementById("findIdResult").innerHTML = "<span style='color: red;'>에러 발생: " + err + "</span>";
    });
  }
</script>

</body>
</html>
