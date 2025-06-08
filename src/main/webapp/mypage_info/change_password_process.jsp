<%@ page contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserService, user.UserDTO" %>
<%@ include file="/common/login_chk.jsp" %>
<%
request.setCharacterEncoding("UTF-8");

// 세션에서 로그인된 사용자 ID 가져오기
Integer userId = (Integer) session.getAttribute("userId");

// 입력값 받기
String currentPassword = request.getParameter("currentPassword");
String newPassword = request.getParameter("newPassword");
String confirmPassword = request.getParameter("confirmPassword");

// 입력값 유효성 검사
if (currentPassword == null || newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
    out.print("invalid_input");
    return;
}

// 현재 비밀번호와 새 비밀번호가 동일한지 확인
if (currentPassword.equals(newPassword)) {
    out.print("same_as_current");
    return;
}

// 사용자 정보 조회
UserService service = new UserService();
UserDTO user = service.getUserById(userId);
if (user == null) {
    out.print("user_not_found");
    return;
}

// 현재 비밀번호 검증
boolean validUser = service.isValidLogin(user.getUsername(), currentPassword);
if (!validUser) {
    out.print("invalid_password");
    return;
}

// 비밀번호 업데이트
boolean result = service.resetPassword(user.getUsername(), newPassword);
if (result) {
    out.print("success");
} else {
    out.print("fail");
}
%>
