<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  request.setCharacterEncoding("UTF-8");

  String qnaId = request.getParameter("qna_id");
  String reply = request.getParameter("reply");

  // TODO: DB에 답변 저장 처리 로직 수행
  // 예시: new QnaDAO().insertReply(qnaId, reply);

  response.sendRedirect("qna_list.jsp"); // 혹은 qna_detail.jsp?qna_id=xxx
%>
