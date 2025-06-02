<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="news.NewsDAO, news.BoardDTO" %>

<%
    request.setCharacterEncoding("UTF-8");

    String title = request.getParameter("title");
    String content = request.getParameter("summernote");
	System.out.println(title);
	System.out.println(content);
    // 제목과 내용 입력값 검증
    if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
%>
<script>
    alert('제목과 내용을 모두 입력해주세요.');
    history.back();
</script>
<%
        return;
    }

   
    //String adminId = "admin";

    // DTO 생성 후 값 세팅
    BoardDTO bDTO = new BoardDTO();
    bDTO.setTitle(title);
    bDTO.setContent(content);
    //bDTO.setAdmin_id(adminId);

    // DAO 호출 (공지사항 등록)
    NewsDAO dao = NewsDAO.getInstance();
    dao.insertNotice(bDTO);
%>

<script>
    alert('공지사항이 등록되었습니다!');
    location.href = 'news_notice_list.jsp';
</script>
