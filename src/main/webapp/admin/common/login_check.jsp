<%
Boolean isAdminLoggedIn = (Boolean) session.getAttribute("adminLogin");
if (isAdminLoggedIn == null || !isAdminLoggedIn) {
    response.sendRedirect("../login/admin_login.jsp");
    return;
}
%>