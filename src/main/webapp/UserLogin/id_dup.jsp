<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="user.UserService" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>아이디 중복확인 | Donutted</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css">
  <style>
    #wrap { position: relative; margin: 0 auto; width: 500px; }
    #inputDiv { margin-top: 50px; text-align: center; }
    #resultDiv { margin-top: 20px; text-align: center; }
    #btn2 { margin-top: 15px; }
  </style>
</head>
<body>
<%
  String id = request.getParameter("id");
  boolean idFlag = false;

  if (id != null && !id.trim().equals("")) {
    try {
      UserService service = new UserService();
      idFlag = service.isUsernameExists(id.trim()); // true면 이미 존재함
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  request.setAttribute("inputId", id);
  request.setAttribute("idFlag", idFlag);
%>

<div id="wrap">
  <div id="inputDiv">
    <form id="frm" method="get" action="id_dup.jsp">
      <label for="id">아이디</label>
      <input type="text" name="id" id="id" maxlength="10" 
      	value="<c:out value='${inputId}'/>" autofocus />
      <input type="submit" value="중복확인" class="btn btn-primary btn-sm" />
    </form>
  </div>

  <div id="resultDiv">
    <c:if test="${not empty inputId}">
      <span><strong><c:out value='${inputId}'/></strong></span>는
      <c:choose>
        <c:when test="${idFlag}">
          <span style="color:red;">이미 사용 중인 아이디입니다.</span>
        </c:when>
        <c:otherwise>
          <span style="color:blue;">사용 가능한 아이디입니다.</span>
          <input type="hidden" id="tempId" value="${inputId}" />
          <div>
            <input type="button" value="사용" class="btn btn-success btn-sm" id="btn2" />
          </div>
        </c:otherwise>
      </c:choose>
    </c:if>
  </div>
</div>

<script>
$(function() {
  // 사용 버튼 처리
  $('#btn2').click(function() {
    const id = $('#tempId').val();
    if (id === "") {
      alert("아이디가 비어 있습니다.");
      return;
    } 

    opener.document.frm.id.value = id;
    opener.document.frm.id.setAttribute('readonly', 'readonly');
    opener.idChecked = true;

    window.close();
  });

  // 아이디 유효성 검증 추가
  $('#frm').submit(function(e) {
    const id = $('#id').val().trim();
    const idPattern = /^[A-Za-z]{1,10}$/;

    if (id === "") {
      alert("아이디를 입력하세요.");
      $('#id').focus();
      e.preventDefault();
      return;
    }

    if (!idPattern.test(id)) {
      alert("아이디는 영문자만 사용하며, 최대 10자까지 가능합니다.");
      $('#id').focus();
      e.preventDefault();
      return;
      
    }
    // 유효성 통과 시 그대로 submit 진행됨
  });
});
</script>


</body>
</html>
