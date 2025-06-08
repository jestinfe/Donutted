<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserService" %>
<%@ page import="user.UserDTO" %>
<%@ include file="/common/login_chk.jsp" %>

<%
  request.setCharacterEncoding("UTF-8");
  int userId = Integer.parseInt(request.getParameter("user_id"));
  
  String email = request.getParameter("email");
  String phone1 = request.getParameter("phone1");
  String phone2 = request.getParameter("phone2");
  String phone3 = request.getParameter("phone3");

  String zipcode = request.getParameter("zipcode");
  String addr1 = request.getParameter("addr1");
  String addr2 = request.getParameter("addr2");

//☑️ 전화번호 자리수 및 숫자 유효성 검사 (무조건 010-XXXX-XXXX)
boolean validPhone = "010".equals(phone1) &&
                    phone2 != null && phone2.matches("\\d{4}") &&
                    phone3 != null && phone3.matches("\\d{4}");


  if (!validPhone) {
%>
<script>
  alert("전화번호 형식이 올바르지 않습니다. 다시 확인해주세요.");
  history.back();
</script>
<%
    return;
  }

  String phone = phone1 + "-" + phone2 + "-" + phone3;

  UserDTO dto = new UserDTO();
  dto.setUserId(userId);
  dto.setEmail(email);
  dto.setPhone(phone);
  dto.setZipcode(zipcode);
  dto.setAddress1(addr1);
  dto.setAddress2(addr2);

  UserService service = new UserService();
  boolean result = service.updateUser(dto);

  if (result) {
    UserDTO updatedUser = service.getUserById(userId);
    session.setAttribute("user", updatedUser);
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
