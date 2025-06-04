<%@ page import="news.BoardDTO, news.BoardService" %>
<%
request.setCharacterEncoding("UTF-8");

String title = request.getParameter("title");
String content = request.getParameter("content");
String admin_id = request.getParameter("admin_id");

BoardDTO dto = new BoardDTO();
dto.setType("FAQ");
dto.setTitle(title);
dto.setContent(content);
dto.setQuestion(title);
dto.setAnswer(content);
dto.setAdmin_id(admin_id);

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
}//end
%>

