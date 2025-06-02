<%@ page import="user.AdminService" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
  request.setCharacterEncoding("UTF-8");

  String adminId = request.getParameter("adminId");
  String adminPass = request.getParameter("adminPass");

  boolean loginSuccess = false;

  try {
      System.out.println("입력 adminId: [" + adminId + "]");
      System.out.println("입력 adminPass: [" + adminPass + "]");

      AdminService service = new AdminService();
      loginSuccess = service.login(adminId, adminPass);

      System.out.println("로그인 성공 여부: " + loginSuccess);
  } catch (Exception e) {
      System.out.println("🚨 로그인 처리 중 예외 발생:");
      e.printStackTrace();
  }

  if (loginSuccess) {
      session.setAttribute("adminLogin", true);        // 로그인 상태 플래그
      session.setAttribute("adminId", adminId);        // 로그인 아이디 저장
      response.sendRedirect("../dashboard/dashboard.jsp");          // 관리자 메인 페이지
  } else {
%>
    <script>
      alert("로그인 실패: 관리자 정보를 확인하세요.");
      history.back();
    </script>
<%
  }
%>
