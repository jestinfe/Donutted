<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="news.NewsDAO, news.BoardDTO" %>

<%
    request.setCharacterEncoding("UTF-8");

    String title = request.getParameter("title");
    String content = request.getParameter("summernote");
    
    String plainContent = content
    	    .replaceAll("(?i)<br[^>]*>", "")         // <br>, <br/> 제거 (대소문자 무시)
    	    .replaceAll("&nbsp;", "")               // HTML 공백 제거
    	    .replaceAll("<[^>]*>", "")              // 나머지 태그 제거
    	    .replaceAll("\u00a0", "")               // non-breaking space 제거
    	    .trim();
	
    // 제목 입력값 검증
    if (title == null || title.trim().isEmpty()) {
%>
<script>
    alert('제목을 입력해주세요.');
    history.back();
</script>
<%
        return;
    }//end if
    
    // 내용 입력값 검증
    if (plainContent.isEmpty()) {
%>
<script>
    alert('내용을 입력해주세요.');
    history.back();
</script>
<%
        return;
    }//end if

   

    // DTO 생성 후 값 세팅
    BoardDTO bDTO = new BoardDTO();
    bDTO.setTitle(title);
    bDTO.setContent(content);

    // DAO 호출 (공지사항 등록)
    NewsDAO dao = NewsDAO.getInstance();
    dao.insertNotice(bDTO);
%>

<script>
    alert('공지사항이 등록되었습니다!');
    location.href = 'news_notice_list.jsp';
</script>
