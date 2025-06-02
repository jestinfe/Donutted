<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserService" %>

<%
  request.setCharacterEncoding("UTF-8");

  String id = request.getParameter("id");
  String email = request.getParameter("email");
  String tel = request.getParameter("tel");

  System.out.println("=== [DEBUG] find_pw_ok.jsp 진입 ===");
  System.out.println("id: " + id);
  System.out.println("email: " + email);
  System.out.println("tel: " + tel);

  boolean verified = false;

  if (id != null && email != null && tel != null &&
      !id.trim().isEmpty() && !email.trim().isEmpty() && !tel.trim().isEmpty()) {

    // UserService 단일 인스턴스 사용
    UserService service = new UserService();

    System.out.println(">>> [DEBUG] Service 메서드 호출 직전 <<<");
    verified = service.isValidUserForPasswordReset(id.trim(), email.trim(), tel.trim());
    System.out.println(">>> [DEBUG] verified: " + verified);

  } else {
    System.out.println(">>> [DEBUG] 입력 파라미터 중 null 또는 공백 있음 <<<");
  }

  if (verified) {
    out.print("OK");
  } else {
    out.print("FAIL");
  }
%>
