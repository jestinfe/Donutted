<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>

<head>
  <title>회원관리 - 회원탈퇴</title>
</head>
<%
  String username = request.getParameter("username");
  if (username == null || username.trim().equals("")) {
    username = "알 수 없음";
  }
  int userId = Integer.parseInt(request.getParameter("user_id"));
%>

<div class="main d-flex justify-content-center align-items-center" style="height: 80vh;">
  <div class="text-center border rounded p-5 shadow" style="max-width: 500px; width: 100%;">
    <div style="font-size: 60px;">😢</div>
    <h4 class="mt-3 mb-4"><strong><%= username %>님을 정말 탈퇴시키겠습니까?</strong></h4>
    <div class="d-flex justify-content-center gap-3">
  		<button class="btn btn-outline-secondary px-4" onclick="history.back()">취소</button>
  		<form action="member_withdraw_process.jsp" method="post" class="d-inline mb-0 align-self-center">
    		<input type="hidden" name="user_id" value="<%= userId %>">
    		<button class="btn btn-danger px-4" type="submit">확인</button>
	 	</form>
	</div>

  </div>
</div>
