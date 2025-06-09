<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="inquiry.InquiryService" %>
<%@ include file="../common/external_file.jsp" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("../UserLogin/login.jsp");
        return;
    }

    String userIdStr = String.valueOf(userId);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>1:1 문의 작성 | Donutted</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Pretendard&display=swap" rel="stylesheet">
  <style>
    body {
      font-family: 'Pretendard', sans-serif;
      background: #fff;
      margin: 0;
      overflow-x: hidden;
    }

    .main-layout {
      display: flex;
      min-height: 100vh;
      min-width: 1000px; /* 사이드바 고정 */
    }

    .mypage-sidebar {
      flex: 0 0 220px;
      background-color: #f8d7da;
      padding: 20px;
      border-right: 2px solid #e5e5e5; /* 구분선 추가 */
      position: sticky;
      top: 120px;
      height: calc(100vh - 120px);
      box-sizing: border-box;
    }

    .main-container {
      padding: 20px;
      margin: 0 auto; /* 가운데 정렬 */
      max-width: 1000px; /* 고정 */
      box-sizing: border-box;
    }

    h4 {
      font-weight: 700;
      margin-bottom: 30px;
      border-left: 5px solid #f18aa7;
      padding-left: 10px;
      color: #f18aa7;
    }

    .form-label {
      font-weight: bold;
      margin-top: 15px;
    }

    .form-control {
      border-radius: 5px;
      max-width: 900px; /* 기존 800px → 900px로 더 넓힘 */
      margin: 0 auto 20px auto; /* 아래 여백 추가 */
      display: block;
      width: 100%;
      padding: 16px 18px; /* padding 더 증가 */
      font-size: 17px;    /* 글씨 약간 키움 */
    }

    textarea.form-control {
      min-height: 300px; /* 내용 입력창 더 키움 */
      resize: vertical;  /* 사용자가 크기 조절 가능 */
    }

    .submit-btn {
      background-color: #f3a7bb;
      color: white;
      border: none;
      padding: 12px 30px;
      font-weight: bold;
      border-radius: 30px;
      transition: background-color 0.3s ease;
      font-size: 16px;
    }

    .submit-btn:hover {
      background-color: #f18aa7;
    }

    .btn-back {
      background-color: #8b4513;
      color: white;
      border: none;
      padding: 12px 30px;
      font-weight: bold;
      border-radius: 30px;
      transition: background-color 0.3s ease;
      font-size: 16px;
    }

    .btn-back:hover {
      background-color: #f4a460;
    }

    .button-group {
      display: flex;
      justify-content: center; /* 버튼들 중앙 정렬 */
      gap: 15px;
      margin-top: 30px;
    }

    @media (max-width: 991px) {
      .main-layout {
        flex-direction: row; /* 원래대로 유지 */
        min-width: 1000px; /* 유지 */
      }

      .mypage-sidebar {
        flex: 0 0 220px;
        width: 220px;
        height: calc(100vh - 120px);
        position: sticky;
        top: 120px;
      }

      .main-container {
        padding: 20px;
        margin: 0 auto;
        max-width: 1000px;
        box-sizing: border-box;
      }
    }
  </style>
</head>
<body>

<input type="hidden" name="userId" value="<%= userIdStr %>">
<c:import url="/common/header.jsp" />

<div class="main-layout">
  <c:import url="/common/mypage_sidebar.jsp" />

  <div class="main-container">
    <h4>1:1 문의 작성</h4>

    <form action="inquiry_process.jsp" method="post">
      <input type="hidden" name="userId" value="<%= userIdStr %>">

      <label for="title" class="form-label">제목</label>
      <input type="text" class="form-control" id="title" name="title" required>

      <label for="content" class="form-label">내용</label>
      <textarea class="form-control" id="content" name="content" rows="12" required></textarea>

      <!-- 버튼 그룹 중앙정렬 -->
      <div class="button-group">
        <button type="button" class="btn-back" onclick="location.href='my_inquiry.jsp'">목록으로</button>
        <button type="submit" class="submit-btn">등록하기</button>
      </div>

    </form>
  </div>
</div>

<c:import url="/common/footer.jsp" />

</body>
</html>
