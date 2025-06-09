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
    }
    .d-flex {
      position: relative;
    }
    .mypage-sidebar {
      position: fixed;
      top: 120px;
      left: 0;
      width: 200px;
      background-color: #f8d7da;
      padding: 20px;
      z-index: 10;
    }
    .inquiry-wrapper {
      flex: 1;
      margin-left: 220px;
      padding: 30px;
    }
    .form-label {
      font-weight: bold;
      margin-top: 15px;
    }
    .form-control {
      border-radius: 5px;
    }
    .submit-btn {
      margin-top: 25px;
      background-color: #f3a7bb;
      color: white;
      border: none;
      padding: 10px 20px;
      font-weight: bold;
    }
    .submit-btn:hover {
      background-color: #f18aa7;
    }
     .btn-back {
      margin-top: 30px;
      background-color: #8b4513;
      color: white;
      border: none;
      padding: 10px 20px;
      font-weight: bold;
    }
    .btn-back:hover {
      background-color: #f4a460;
    }
  </style>
</head>
<body>

<input type="hidden" name="userId" value="<%= userIdStr %>">
<c:import url="/common/header.jsp" />

<div class="d-flex mt-5">
  <c:import url="/common/mypage_sidebar.jsp" />

  <div class="inquiry-wrapper">
    <h4>1:1 문의 작성</h4>

    <form action="inquiry_process.jsp" method="post">
      <input type="hidden" name="userId" value="<%= userIdStr %>">

      <label for="title" class="form-label">제목</label>
      <input type="text" class="form-control" id="title" name="title" required>

      <label for="content" class="form-label">내용</label>
      <textarea class="form-control" id="content" name="content" rows="8" required></textarea>
<div class="text-center">
	<button type="button" class="btn-back" onclick="location.href='my_inquiry.jsp'">목록으로</button>
	
    </div>
      <div class="text-end">
        <button type="submit" class="submit-btn">등록하기</button>
      </div>
    </form>
  </div>
</div>

<c:import url="/common/footer.jsp" />

</body>
</html>
