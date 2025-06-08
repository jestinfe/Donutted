<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="news.BoardDTO, news.BoardService" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>



<%
request.setCharacterEncoding("UTF-8");

BoardService service = BoardService.getInstance();
String mode = request.getParameter("mode");

if ("update".equals(mode)) {
    // ✅ 수정 처리
    int boardId = Integer.parseInt(request.getParameter("board_id"));
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    BoardDTO dto = new BoardDTO();
    dto.setBoard_id(boardId);
    dto.setTitle(title);
    dto.setContent(content);
    dto.setQuestion(title);
    dto.setAnswer(content);

    boolean result = service.updateFAQ(dto);
    if (result) {
%>
        <script>alert('수정 완료!'); location.href='faq_list.jsp';</script>
<%
    } else {
%>
        <script>alert('수정 실패...'); history.back();</script>
<%
    }
    return;
} else if ("delete".equals(mode)) {
    // ✅ 삭제 처리
    int boardId = Integer.parseInt(request.getParameter("board_id"));
    boolean result = service.deleteFAQ(boardId);
    if (result) {
%>
        <script>alert('삭제 완료!'); location.href='faq_list.jsp';</script>
<%
    } else {
%>
        <script>alert('삭제 실패...'); history.back();</script>
<%
    }
    return;
}

// ✅ 기본 조회 화면 출력
int boardId = Integer.parseInt(request.getParameter("board_id"));
BoardDTO dto = service.getFAQDetail(boardId);
if (dto == null) {
%>
    <script>alert("존재하지 않는 FAQ입니다."); history.back();</script>
<%
    return;
}
%>

<div class="main">
  <h3>FAQ (조회/수정/삭제)</h3>
  <!-- ✅ 수정용 form -->
  <form method="post" action="faq_detail.jsp">
    <div class="mb-3">
      <label class="form-label">제목 :</label>
      <input type="text" name="title" class="form-control" value="<%= dto.getQuestion() %>">
    </div>
    <div class="mb-3">
      <label class="form-label">내용:</label>
      <textarea name="content" class="form-control" rows="5"><%= dto.getAnswer() %></textarea>
    </div>

    <input type="hidden" name="board_id" value="<%= dto.getBoard_id() %>">
    <input type="hidden" name="mode" value="update">

    <button type="submit" class="btn btn-success">수정</button>
    <button type="button" class="btn btn-danger" onclick="deleteFAQ(<%= dto.getBoard_id() %>)">삭제</button>
    <a class="btn btn-secondary" href="faq_list.jsp">뒤로</a>
  </form>
</div>

<!-- ✅ 삭제 요청용 form (자바스크립트로 전송) -->
<form id="deleteForm" method="post" action="faq_detail.jsp" style="display:none;">
  <input type="hidden" name="board_id" id="delBoardId">
  <input type="hidden" name="mode" value="delete">
</form>

<script>
  function deleteFAQ(boardId) {
    if (confirm("정말 삭제하시겠습니까?")) {
      document.getElementById("delBoardId").value = boardId;
      document.getElementById("deleteForm").submit();
    }
  }
</script>
