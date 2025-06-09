<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/common/login_chk.jsp" %>
<link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>

<%
Integer userId = (Integer) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>회원탈퇴 | Donutted</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
  <link href="https://fonts.googleapis.com/css2?family=Pretendard&display=swap" rel="stylesheet" />
  <style>
    body {
      font-family: 'Pretendard', sans-serif;
      background-color: #fff;
    }

    .mypage-container {
      margin-left: 230px;
      min-height: 80vh;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .withdraw-box {
      background-color: #fff0f0;
      border: 1px solid #f5c2c7;
      padding: 40px;
      border-radius: 12px;
      width: 100%;
      max-width: 700px;
      box-shadow: 0 0 10px rgba(0,0,0,0.05);
    }

    .withdraw-title {
      font-size: 30px;
      font-weight: bold;
      color: #dc3545;
      margin-bottom: 25px;
    }

    .withdraw-message {
      font-size: 18px;
      margin-bottom: 30px;
      color: #333;
      line-height: 1.8;
    }

    .btn-withdraw {
      background-color: #dc3545;
      border: none;
      font-weight: bold;
      padding: 12px 30px;
      font-size: 16px;
    }

    .btn-withdraw:hover {
      background-color: #bb2d3b;
    }
  </style>
</head>
<body>

<!-- ✅ header -->
<c:import url="/common/header.jsp" />

<!-- ✅ 사이드바 및 본문 -->
<div class="mypage-container">
  <!-- ✅ 사이드바 -->
  <c:set var="activeMenu" value="withdraw" />
  <c:import url="/common/mypage_sidebar.jsp" />

  <!-- ✅ 탈퇴 박스 -->
  <div class="withdraw-box">
    <div class="withdraw-title">⚠ 회원탈퇴 안내</div>
    <div class="withdraw-message">
      정말로 <strong>회원 탈퇴</strong>를 진행하시겠습니까?<br/>
      탈퇴 후에는 <span class="text-danger">해당 계정으로 로그인할 수 없으며</span><br/>
      <strong>작성하신 리뷰, 문의글 등은 삭제되지 않고 남아있습니다.</strong><br/>
      이 작업은 되돌릴 수 없습니다.
    </div>
    <form action="withdraw_process.jsp" method="post"
      onsubmit="return confirm('정말로 회원 탈퇴를 진행하시겠습니까?\n탈퇴 후에는 계정 복구가 불가능합니다.')">
  	<button type="submit" class="btn btn-withdraw">탈퇴하기</button>
	</form>
  </div>
</div>

<!-- ✅ footer -->
<c:import url="/common/footer.jsp" />

</body>
</html>
