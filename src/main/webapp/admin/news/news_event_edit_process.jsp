<%@page import="news.NewsDAO"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.io.File"%>
<%@page import="java.text.*"%>
<%@page import="java.util.Date"%>
<%@page import="news.NewsService"%>
<%@page import="news.BoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>
<%@ include file="../common/login_check.jsp" %>

<%
request.setCharacterEncoding("UTF-8");

String title = "";
/* String content = ""; */
String thumbnailName = "";
String detailImageName = "";



try {
    // 1. 저장 경로 설정
    File saveDir = new File("C:/dev/workspace/mall_prj/src/main/webapp/admin/common/images/news");
    if (!saveDir.exists()) saveDir.mkdirs();

    // 2. 업로드 크기 제한 (600MB)
    int maxSize = 1024 * 1024 * 600;
    int limitSize = 1024 * 10; // 10KB

    // 3. MultipartRequest 객체 생성
    MultipartRequest mr = new MultipartRequest(request, saveDir.getAbsolutePath(), maxSize, "UTF-8", new DefaultFileRenamePolicy());

    // 4. 파라미터 값 추출
    title = mr.getParameter("title");
    /* content = mr.getParameter("content"); */ // content 폼 추가해야 함

    int boardId = Integer.parseInt(mr.getParameter("board_id"));
    
    thumbnailName = mr.getFilesystemName("profileImg");
    detailImageName = mr.getFilesystemName("eventImage");

    // 5. 파일 크기 검사
    if (thumbnailName != null) {
        File thumbnailFile = new File(saveDir, thumbnailName);
        if (thumbnailFile.length() > maxSize) {
            thumbnailFile.delete();
            %>
            <script>alert("썸네일 이미지 용량 초과! 600MB 이하만 가능합니다."); history.back();</script>
            <%
            return;
        }
    }

    if (detailImageName != null) {
        File detailFile = new File(saveDir, detailImageName);
        if (detailFile.length() > maxSize) {
            detailFile.delete();
            %>
            <script>alert("상세 이미지 용량 초과! 600MB 이하만 가능합니다."); history.back();</script>
            <%
            return;
        }
    }

  	
    if (thumbnailName == null) {
        thumbnailName = mr.getParameter("imgName"); // hidden input에서 기존 파일명 받아오기
    }
    if (detailImageName == null) {
        detailImageName = mr.getParameter("detailImgName"); // 새로운 hidden input 추가 필요
    }
  
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
    
// admin_id는 임시로 1
String adminId = "admin";

// DTO에 값 세팅
BoardDTO bDTO = new BoardDTO();
bDTO.setBoard_id(boardId);
bDTO.setTitle(title);
/* bDTO.setContent(content);  */// content 추가해야 함
bDTO.setAdmin_id(adminId);
bDTO.setThumbnail_url(thumbnailName); // 서버 저장 파일명
bDTO.setDetail_image_url(detailImageName); // 서버 저장 파일명

// DAO 호출
NewsDAO dao = NewsDAO.getInstance();
dao.updateEvent(bDTO);

} catch(Exception e) {
    e.printStackTrace();
    %>
    <script>
      alert('에러가 발생했습니다. 관리자에게 문의하세요.');
      history.back();
    </script>
<%
    return; // 응답 중단!
}

    
%>

<script>
    alert("이벤트가 성공적으로 수정되었습니다.");
    location.href = "news_event_list.jsp";
    /* alert("수정에 실패했습니다. 다시 시도해주세요.");
    history.back(); */
</script>