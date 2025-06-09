<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../common/external_file.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>로그인 | Donutted</title>
  <style>
  body {
    display: flex;
    flex-direction: column;
    min-height: 100vh;
    font-family: '맑은 고딕', sans-serif;
    background-color: #f9f9f9;
    margin: 0;
    padding: 0;
  }

  main {
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 30px 20px;
  }

  .login-box {
  background-color: #fff;
  padding: 50px 40px; /* padding 위아래 50px로 줄임 */
  border-radius: 12px;
  box-shadow: 0 0 12px rgba(0,0,0,0.12);
  width: 420px;
  max-width: 90%;
  min-height: 450px; /* min-height 450px로 줄임 → 적당한 느낌 */
}

.login-box h2 {
  text-align: center;
  margin-bottom: 40px; /* 제목 아래 공간도 약간 늘리면 예쁨 */
  font-size: 24px; /* 글자 크기도 약간 키움 */
}

.input-field {
  width: 100%;
  padding: 14px; /* 입력창 padding도 약간 키움 */
  margin-bottom: 18px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
  font-size: 16px; /* 글자 크기도 약간 키움 */
}

.login-btn {
  width: 100%;
  padding: 14px; /* 버튼 padding도 키움 */
  background-color: #f8a7bb;
  color: #fff;
  border: none;
  border-radius: 4px;
  font-weight: bold;
  cursor: pointer;
  font-size: 16px; /* 버튼 글씨도 키움 */
}

    .login-btn:hover {
      background-color: #f18aa7;
    }
    .link-box {
  display: flex;
  justify-content: space-between;
  margin-top: 15px;
  font-size: 16px; /* 기존 14px → 16px 으로 키움 */
}

.link-box a {
  color: #333;
  text-decoration: none;
  font-weight: bold; /* 조금 더 강조하고 싶으면 bold 추가 가능 */
}

.link-box a:hover {
  text-decoration: underline;
}
    .modal-overlay {
      position: fixed; top: 0; left: 0; width: 100%; height: 100%;
      background: rgba(0,0,0,0.6); display: flex;
      justify-content: center; align-items: center; z-index: 1000;
    }
    .modal-content {
      background: white; padding: 30px; width: 400px; border-radius: 10px;
      box-shadow: 0 0 10px rgba(0,0,0,0.3);
    }
    .tabs { display: flex; margin-bottom: 10px; }
    .tab { flex: 1; text-align: center; padding: 10px; cursor: pointer; border-bottom: 2px solid #ccc; }
    .tab.active { border-bottom: 3px solid #f8a7bb; font-weight: bold; }
    .tab-content { display: none; }
    .tab-content.active { display: block; }
    .modal-content input, .modal-content button { width: 100%; margin: 5px 0; padding: 10px; }
  </style>
</head>
<body>

  <c:import url="../common/header.jsp" />

  <main>
    <div class="login-box">
      <h2>로그인</h2>
      <form action="login_process.jsp" method="post">
        <input type="text" name="id" placeholder="아이디" class="input-field" required>
        <input type="password" name="pass" placeholder="비밀번호" class="input-field" required>
        <button type="submit" class="login-btn">로그인</button>
      </form>
      <div class="link-box">
        <a href="member_frm.jsp">회원가입</a>
        <a href="javascript:void(0);" onclick="openModal()">아이디 · 비밀번호 찾기</a>
      </div>
    </div>
  </main>

  <c:import url="../common/footer.jsp" />

  <!-- 아이디 / 비밀번호 찾기 모달 -->
  <div id="findModal" class="modal-overlay" style="display: none;">
    <div class="modal-content">
      <div class="tabs">
        <div class="tab active" data-target="find-id">아이디 찾기</div>
        <div class="tab" data-target="find-pw">비밀번호 찾기</div>
      </div>

      <div id="find-id" class="tab-content active">
        <form id="findIdForm">
          <input type="text" name="name" placeholder="이름" required>
          <input type="tel" name="tel" placeholder="전화번호 (예: 010-1234-5678)" 
           pattern="^010-\d{4}-\d{4}$" title="010-1234-5678 형식으로 입력해주세요" required>
          <button type="submit">아이디 찾기</button>
        </form>
        <div id="idResultMsg"></div>
      </div>

      <div id="find-pw" class="tab-content">
        <form id="findPwForm">
          <input type="text" name="id" placeholder="아이디" required>
          <input type="email" name="email" placeholder="이메일 (예 : kdnotted@domain.com)" required>
          <input type="tel" name="tel" placeholder="전화번호 (예: 010-1234-5678)" 
           pattern="^010-\d{4}-\d{4}$" title="010-1234-5678 형식으로 입력해주세요" required>
          <button type="submit">비밀번호 찾기</button>
        </form>
        <div id="pwResultMsg"></div>
      </div>

      <button onclick="closeModal()" style="margin-top:15px;">닫기</button>
    </div>
  </div>

<script>
function openModal() {
  document.getElementById("findModal").style.display = "flex";
}
function closeModal() {
  document.getElementById("findModal").style.display = "none";
}
document.querySelectorAll(".tab").forEach(tab => {
  tab.addEventListener("click", () => {
    document.querySelectorAll(".tab").forEach(t => t.classList.remove("active"));
    document.querySelectorAll(".tab-content").forEach(c => c.classList.remove("active"));
    tab.classList.add("active");
    document.getElementById(tab.dataset.target).classList.add("active");
  });
});

document.getElementById("findIdForm").addEventListener("submit", function(e) {
  e.preventDefault();
  var form = this;
  var name = form.querySelector("input[name='name']").value;
  var tel = form.querySelector("input[name='tel']").value;

  var params = new URLSearchParams();
  params.append("name", name);
  params.append("tel", tel);

  fetch("find_id_ok.jsp", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: params
  })
  .then(res => res.text())
  .then(data => {
	  document.getElementById("idResultMsg").innerHTML = data;
  })
  .catch(err => {
    console.error("아이디 찾기 중 오류", err);
    alert("오류가 발생했습니다. 다시 시도해주세요.");
  });
});

document.getElementById("findPwForm").addEventListener("submit", function(e) {
  e.preventDefault();

  var form = this;
  var idValue = form.querySelector("input[name='id']").value;

  var params = new URLSearchParams();
  params.append("id", idValue);
  params.append("email", form.querySelector("input[name='email']").value);
  params.append("tel", form.querySelector("input[name='tel']").value);

  fetch("find_pw_ok.jsp", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: params
  })
  .then(res => res.text())
  .then(data => {
    if (data.trim().toUpperCase() === "OK") {
      alert("회원 정보가 확인되었습니다.");
      location.href = "reset_pw.jsp?id=" + encodeURIComponent(idValue);
    } else {
      alert("입력하신 정보와 일치하는 회원이 없습니다.");
    }
  })
  .catch(err => {
    console.error("비밀번호 찾기 요청 중 오류 발생", err);
    alert("오류가 발생했습니다. 다시 시도해주세요.");
  });
});
</script>

</body>
</html>
