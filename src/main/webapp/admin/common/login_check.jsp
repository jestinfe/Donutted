<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
    
<%
Boolean isAdminLoggedIn = (Boolean) session.getAttribute("adminLogin");
if (isAdminLoggedIn == null || !isAdminLoggedIn) {
    response.sendRedirect("../login/admin_login.jsp");
    return;
}
%>