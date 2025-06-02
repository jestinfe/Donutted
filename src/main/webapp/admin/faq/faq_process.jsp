<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="news.BoardDTO, news.BoardService" %>
<%@ include file="../common/login_check.jsp" %>

<%
request.setCharacterEncoding("UTF-8");

// 폼에서 넘어온 값 받기
String title = request.getParameter("title");
String content = request.getParameter("content");
String adminId = request.getParameter("admin_id"); // hidden으로 넘어온 값

// 필수값 검증 (안전장치)
if (adminId == null || adminId.trim().isEmpty()) {
    adminId = "anonymous_admin";
}

// DTO에 값 담기
BoardDTO dto = new BoardDTO();
dto.setType("FAQ");
dto.setTitle(title);
dto.setContent(content);
dto.setQuestion(title);   // 질문 = 제목
dto.setAnswer(content);   // 답변 = 내용
dto.setAdmin_id(adminId); // 관리자 ID 또는 기본값

// 등록 처리
boolean success = BoardService.getInstance().registerFAQ(dto);
if (success) {
    response.sendRedirect("faq_list.jsp");
} else {
%>
<script>
  alert("등록에 실패했습니다. 다시 시도해주세요.");
  history.back();
</script>
<%
}
%>
