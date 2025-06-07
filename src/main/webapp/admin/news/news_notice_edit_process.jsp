<%@page import="news.NewsService"%>
<%@page import="news.BoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>

<%
request.setCharacterEncoding("UTF-8");

int board_id = Integer.parseInt(request.getParameter("board_id"));
String title = request.getParameter("title");
String content = request.getParameter("content");

String plainContent = content
.replaceAll("(?i)<br[^>]*>", "")         // <br>, <br/> 제거 (대소문자 무시)
.replaceAll("&nbsp;", "")               // HTML 공백 제거
.replaceAll("<[^>]*>", "")              // 나머지 태그 제거
.replaceAll("\u00a0", "")               // non-breaking space 제거
.trim();

//제목 입력값 검증
if (title == null || title.trim().isEmpty()) {
%>
<script>
alert('제목을 입력해주세요.');
history.back();
</script>
<%
    return;
}

//내용 입력값 검증
if (plainContent.isEmpty()) {
%>
<script>
alert('내용을 입력해주세요.');
history.back();
</script>
<%
    return;
}

BoardDTO bDTO = new BoardDTO();
bDTO.setBoard_id(board_id);
bDTO.setTitle(title);
bDTO.setContent(content);

NewsService ns=new NewsService();
boolean result = ns.modifyNotice(bDTO);

%>

<script>
  <% if (result) { %>
    alert("공지사항이 성공적으로 수정되었습니다.");
    location.href = "news_notice_list.jsp";
  <% } else { %>
    alert("수정에 실패했습니다. 다시 시도해주세요.");
    history.back();
  <% } %>
</script>