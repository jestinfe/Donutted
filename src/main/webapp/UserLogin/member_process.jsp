<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" info="회원가입 처리" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="user.UserDTO, user.UserService" %>
<%@ page import="java.sql.Date" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>회원가입 처리 | Donutted</title>
  <style>
    #container { min-height: 600px; margin-top: 30px; margin-left: 20px }
    .result-img { width: 300px; margin: 20px 0; }
    .center-text { text-align: center; }
  </style>
</head>
<body>

<jsp:include page="../common/header.jsp"/>

<main>
<div id="container">

<%
request.setCharacterEncoding("UTF-8");

UserDTO dto = new UserDTO();
dto.setUsername(request.getParameter("id"));
dto.setPassword(request.getParameter("pass"));
dto.setName(request.getParameter("name"));

pageContext.setAttribute("userName", dto.getName());

// 생일: String → java.sql.Date 변환
String birthStr = request.getParameter("birth");
if (birthStr != null && !birthStr.trim().isEmpty()) {
    try {
        dto.setBirthdate(Date.valueOf(birthStr)); // yyyy-MM-dd
    } catch (Exception e) {
        System.out.println("[WARN] 생일 형식 오류: " + birthStr);
    }
}

dto.setPhone(request.getParameter("tel"));

String email = request.getParameter("email");
String domain = request.getParameter("domain");
if (email != null && domain != null) {
    dto.setEmail(email.trim() + "@" + domain.trim());
}

dto.setGender(request.getParameter("gender"));
dto.setZipcode(request.getParameter("zipcode"));
dto.setAddress1(request.getParameter("addr"));
dto.setAddress2(request.getParameter("addr2"));
//dto.setIp(request.getRemoteAddr());

boolean result = false;
try {
    UserService userService = new UserService(); // 일반 클래스
    result = userService.insertUser(dto);
} catch (Exception e) {
    e.printStackTrace();
}

pageContext.setAttribute("addResult", result);
%>

<c:choose>
  <c:when test="${addResult}">
    <div class="center-text">
      <h2>회원가입을 축하드립니다.</h2>
      <img src="images/member_success.png" alt="회원가입 성공" class="result-img" />
      <p style="font-size: 20px;">
        <strong><c:out value="${userName}"/></strong> 님, 환영합니다!
      </p>
      <p>
        <a href="login.jsp" class="btn"
           style="background-color: #f8a7bb; color: white; border: none; font-weight: bold;">
        로그인하러 가기</a>
      </p>
    </div>
  </c:when>
  <c:otherwise>
    <div class="center-text">
      <h2 style="color:red;">회원가입이 정상적으로 이루어지지 않았습니다.</h2>
      <img src="images/member_fail.png" alt="회원가입 실패" class="result-img"/>
      <h3>잠시 후 다시 시도해주세요.</h3>
      <a href="http://localhost/mall_prj/index.jsp" class="btn"  
         style="background-color: #f8a7bb; color: white; border: none; font-weight: bold;">메인화면</a>
      <a href="javascript:history.back()" class="btn" 
         style="background-color: #f8a7bb; color: white; border: none; font-weight: bold;">다시 시도</a>
    </div>
  </c:otherwise>
</c:choose>

</div>
</main>

<footer class="text-body-secondary py-5">
  <jsp:include page="../common/footer.jsp"/>
</footer>
</body>
</html>
