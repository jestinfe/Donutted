<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserService" %>

<%
  request.setCharacterEncoding("UTF-8");
  String name = request.getParameter("name");
  String tel = request.getParameter("tel");
  String foundId = null;

  try {
    if (name != null && tel != null && !name.trim().isEmpty() && !tel.trim().isEmpty()) {
      // UserService 인스턴스 생성
      UserService userService = new UserService();

      // 이름과 전화번호로 사용자 아이디 조회
      foundId = userService.findUsernameByNameAndPhone(name.trim(), tel.trim());
      System.out.println("[DEBUG] foundId: " + foundId);
    } else {
      System.out.println("[DEBUG] 파라미터 누락 또는 공백");
    }
  } catch (Exception e) {
    e.printStackTrace();
  }
%>

<% if (foundId != null && !foundId.trim().isEmpty()) { %>
  <div style="color: green;">아이디는 <strong><%= foundId %></strong> 입니다.</div>
<% } else { %>
  <div style="color: red;">일치하는 정보가 없습니다.</div>
<% } %>
<% out.flush(); %>
