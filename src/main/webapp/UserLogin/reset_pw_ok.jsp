<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserDAO" %>
<%@ page import="util.CryptoUtil" %>

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

// 새 비밀번호 해시 처리
String hashedNewPw = CryptoUtil.hashSHA256(newPw);

// DB에서 현재 비밀번호 가져오기 (이미 해시된 값)
String currentPw = UserDAO.getInstance().getPasswordById(id);

// 동일한 비밀번호 사용 금지
if (currentPw != null && currentPw.equals(hashedNewPw)) {
  out.print("SAME");
  return;
}

// 비밀번호 업데이트
boolean success = UserDAO.getInstance().resetPassword(id, hashedNewPw);

out.print(success ? "OK" : "FAIL");
%>
