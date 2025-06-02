<%@page import="news.NewsService"%>
<%@page import="news.BoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>

<%
request.setCharacterEncoding("UTF-8");

int board_id = Integer.parseInt(request.getParameter("board_id"));

BoardDTO bDTO = new BoardDTO();
bDTO.setBoard_id(board_id);

NewsService ns=new NewsService();
boolean result = ns.removeNews(bDTO);

%>

<script>
  <% if (result) { %>
    alert("삭제되었습니다.");
    location.href = "news_notice_list.jsp";
  <% } else { %>
    alert("삭제에 실패했습니다. 다시 시도해주세요.");
    history.back();
  <% } %>
</script>