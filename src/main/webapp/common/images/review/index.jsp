<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<c:import url="http://localhost/mybatis_prj/common/jsp/external_file.jsp"/>
<style type="text/css">
 #container{ min-height: 600px; margin-top: 30px; margin-left: 20px}
</style>
 
<script type="text/javascript">
$(function(){

});//ready


</script>
</head>
<body>
<header data-bs-theme="dark">
<c:import url="http://localhost/mybatis_prj/common/jsp/header.jsp"/>
</header>
<main>
<div id="container">
<div id="mybatisTitle">
<%
	String[] linkName = {"컬럼하나 한 행 조회", "컬럼 여러개 한 행 조회", "컬럼 여러개 한 행 조회",
			"컬럼여러개 여러행 조회", "&lt; 조회", "&gt;조회", "like 조회",
			"subquery", "union"};
	String[] link = {"day0604/scsr", "day0604/scmr", "day0605/mcsr", "day0605/mcmr",
			"day0605/lt", "day0605/gt", "day0609/like",
			"day0609/subquery", "day0609/union"};
%>
<table class="table table-hover">
<tr>
<% for (int i = 0; i < linkName.length; i++) { %>
<td><a href="index.jsp?url=<%=link[i]%>"><%=linkName[i] %></a></td>
<% } // end for %>

</tr>
</table>
</div>
<div id="mybatisContainer">
<c:if test="${not empty param.url}">
<c:import url="${param.url }.jsp"/>
</c:if>
</div>

</div>
</main>
<footer class="text-body-secondary py-5">
<c:import url="http://localhost/mybatis_prj/common/jsp/footer.jsp"/>
</footer>


</body>
</html>