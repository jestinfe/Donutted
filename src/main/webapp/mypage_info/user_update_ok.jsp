<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserService" %>
<%@ page import="user.UserDTO" %>

<%
  request.setCharacterEncoding("UTF-8");

  int userId = Integer.parseInt(request.getParameter("user_id"));
  String email = request.getParameter("email");
  String phone = request.getParameter("phone1") + "-" + request.getParameter("phone2") + "-" + request.getParameter("phone3");
  String zipcode = request.getParameter("zipcode");
  String addr1 = request.getParameter("addr1");
  String addr2 = request.getParameter("addr2");

  UserDTO dto = new UserDTO();
  dto.setUserId(userId);
  dto.setEmail(email);
  dto.setPhone(phone);
  dto.setZipcode(zipcode);
  dto.setAddress1(addr1);
  dto.setAddress2(addr2);

  UserService service = new UserService();
  boolean result = service.updateUser(dto);

  // 수정 성공 시 세션에 반영된 user 정보도 갱신
  if (result) {
    UserDTO updatedUser = service.getUserById(userId);
    session.setAttribute("user", updatedUser); // my_page.jsp에서 user 객체로 바로 사용 가능
  }
%>

<script>
  <% if (result) { %>
    alert("회원정보가 수정되었습니다.");
    location.href = "my_page.jsp"; // 세션에서 바로 새 정보 로딩됨
  <% } else { %>
    alert("수정 중 오류가 발생했습니다.");
    history.back();
  <% } %>
</script>
