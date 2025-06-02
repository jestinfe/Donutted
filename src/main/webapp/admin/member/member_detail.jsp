<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserService" %>
<%@ page import="user.UserDTO" %>

<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>


<%
  int userId = Integer.parseInt(request.getParameter("user_id"));
  UserService service = new UserService();
  UserDTO user = service.getUserById(userId);
%>

<div class="main">
  <h3>회원 관리 - 회원 정보 조회</h3>

  <!-- 에러 메시지 -->
  <%
    if ("true".equals(request.getParameter("error"))) {
  %>
    <div class="alert alert-danger text-center" role="alert">
      ❌ 회원 탈퇴 처리 중 오류가 발생했습니다.
    </div>
  <%
    }
  %>

  <!-- 기본정보 -->
  <div class="card p-4 mb-4">
    <h5>기본정보</h5>
    <div class="row mb-3">
      <label class="col-sm-2 col-form-label">회원명</label>
      <div class="col-sm-4">
        <input type="text" readonly class="form-control" value="<%= user.getName() %>">
      </div>

      <label class="col-sm-2 col-form-label">아이디</label>
      <div class="col-sm-4">
        <input type="text" readonly class="form-control" value="<%= user.getUsername() %>">
      </div>
    </div>

    <div class="row mb-3">
      <label class="col-sm-2 col-form-label">E-Mail</label>
      <div class="col-sm-4">
        <input type="text" readonly class="form-control" value="<%= user.getEmail() %>">
      </div>

      <label class="col-sm-2 col-form-label">휴대전화</label>
      <div class="col-sm-4">
        <input type="text" readonly class="form-control" value="<%= user.getPhone() %>">
      </div>
    </div>

    <div class="row mb-3">
      <label class="col-sm-2 col-form-label">생년월일</label>
      <div class="col-sm-4">
        <input type="date" readonly class="form-control" value="<%= user.getBirthdate() != null ? user.getBirthdate().toString() : "" %>">
      </div>

      <label class="col-sm-2 col-form-label">성별</label>
      <div class="col-sm-4 d-flex align-items-center">
        <div class="form-check me-3">
          <input class="form-check-input" type="radio" name="gender" <%= "M".equals(user.getGender()) ? "checked" : "" %> disabled>
          <label class="form-check-label">남자</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" type="radio" name="gender" <%= "F".equals(user.getGender()) ? "checked" : "" %> disabled>
          <label class="form-check-label">여자</label>
        </div>
      </div>
    </div>

    <div class="row mb-3">
      <label class="col-sm-2 col-form-label">주소</label>
      <div class="col-sm-10">
        <input type="text" readonly class="form-control" value="<%= user.getAddress1() != null ? user.getAddress1() : "" %> <%= user.getAddress2() != null ? user.getAddress2() : "" %>">
      </div>
    </div>
  </div>

  <!-- 버튼 -->
  <div class="d-flex justify-content-between">
    <button class="btn btn-secondary" onclick="history.back()">뒤로</button>
    <% if (!"U2".equals(user.getUserStatus())) { %>
      <button class="btn btn-danger" onclick="location.href='member_withdraw_confirm.jsp?user_id=<%= user.getUserId() %>&username=<%= user.getName() %>'">탈퇴 처리</button>
    <% } %>
  </div>
</div>
