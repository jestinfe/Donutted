<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserService" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.sql.*, user.UserDAO" %>
<%
request.setCharacterEncoding("UTF-8");
String id = request.getParameter("id");
String newPw = request.getParameter("newPw");
String confirmPw = request.getParameter("confirmPw");

if (id == null || newPw == null || confirmPw == null) {
  out.print("ERROR");
  return;
}

if (!newPw.equals(confirmPw)) {
  out.print("MISMATCH");
  return;
}

// DB에서 현재 비밀번호 가져오기
String currentPw = UserDAO.getInstance().getPasswordById(id);

if (currentPw != null && currentPw.equals(newPw)) {
  out.print("SAME");
  return;
}

// 비밀번호 업데이트
boolean success = UserDAO.getInstance().resetPassword(id, newPw);
if (success) {
  out.print("OK");
} else {
  out.print("FAIL");
}
%>
