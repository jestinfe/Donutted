<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserService" %>
<%@ page import="java.util.Arrays" %>
<%
request.setCharacterEncoding("UTF-8");

String id = request.getParameter("id");
String newPw = request.getParameter("newPw");
String confirmPw = request.getParameter("confirmPw");

System.out.println("=== [DEBUG] reset_pw_ok.jsp ===");
System.out.println("id: " + id);
System.out.println("newPw: " + newPw);
System.out.println("confirmPw: " + confirmPw);

if (id != null && newPw != null && confirmPw != null) {
  System.out.println("equals? " + newPw.equals(confirmPw));
  System.out.println("newPw.length(): " + newPw.length());
  System.out.println("confirmPw.length(): " + confirmPw.length());
  System.out.println("newPw.char[]: " + Arrays.toString(newPw.toCharArray()));
  System.out.println("confirmPw.char[]: " + Arrays.toString(confirmPw.toCharArray()));

  if (!newPw.equals(confirmPw)) {
    out.print("MISMATCH");
  } else {
    UserService userService = new UserService(); // ✅ 일반 클래스
    boolean updated = userService.resetPassword(id, newPw);
    out.print(updated ? "OK" : "FAIL");
  }
} else {
  System.out.println("❌ 입력값이 하나 이상 null입니다.");
  out.print("FAIL");
}
%>
