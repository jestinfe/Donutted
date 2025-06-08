<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="news.BoardDTO, news.BoardService" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>


<%
    List<BoardDTO> faqList = null;
    try {
        BoardService service = BoardService.getInstance();
        faqList = service.getFAQList();
        request.setAttribute("faqList", faqList);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>


<head><title>관리자 FAQ </title></head>
<div class="main">
  <h3>FAQ</h3>

  <div class="d-flex justify-content-end mb-3">
    <button class="btn btn-outline-primary" onclick="location.href='faq_add.jsp'">등록하기</button>
  </div>

  <ul class="list-group">
    <c:forEach var="faq" items="${faqList}">
      <li class="list-group-item d-flex justify-content-between">
        <span>Q. ${faq.question}</span>
        <button class="btn btn-sm btn-light" onclick="location.href='faq_detail.jsp?board_id=${faq.board_id}'">▼</button>
      </li>
    </c:forEach>
  </ul>

 
</div>
