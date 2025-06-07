<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.io.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="news.NewsDAO, news.BoardDTO" %>
<%@ include file="../common/login_check.jsp" %>

<%
request.setCharacterEncoding("UTF-8");

String title = "";
String content = "";
String thumbnailName = "";
String detailImageName = "";

try {
    // 1. 저장 경로 설정
   	File saveDir = new File("C:/Users/user/git/mall_prj/src/main/webapp/admin/common/images/news");
    if (!saveDir.exists()) saveDir.mkdirs();

    // 2. 업로드 크기 제한 (600MB)
    int maxSize = 1024 * 1024 * 600;
    int limitSize = 1024 * 10; // 10KB

    // 3. MultipartRequest 객체 생성
    MultipartRequest mr = new MultipartRequest(request, saveDir.getAbsolutePath(), maxSize, "UTF-8", new DefaultFileRenamePolicy());

    // 4. 파라미터 값 추출
    title = mr.getParameter("title");
    content = mr.getParameter("content"); // content 폼 추가해야 함

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
     
     //썸네일 이미지 입력값 검증
    if (thumbnailName == null || thumbnailName.trim().isEmpty()) {
    %>
    <script>
    alert('썸네일 이미지를 등록해주세요.');
    history.back();
    </script>
    <%
        return;
    }
     
     //상세설명 이미지 입력값 검증
    if (detailImageName == null || detailImageName.trim().isEmpty()) {
    %>
    <script>
    alert('상세설명 이미지를 등록해주세요.');
    history.back();
    </script>
    <%
        return;
    }
  
    
} catch(Exception e) {
    e.printStackTrace();
}
    


// DTO에 값 세팅
BoardDTO bDTO = new BoardDTO();
bDTO.setTitle(title);
bDTO.setContent(content); // content 추가해야 함
bDTO.setThumbnail_url(thumbnailName); // 서버 저장 파일명
bDTO.setDetail_image_url(detailImageName); // 서버 저장 파일명

// DAO 호출
NewsDAO dao = NewsDAO.getInstance();
dao.insertEvent(bDTO);
%>

<script>
    alert('이벤트가 등록되었습니다!');
    location.href = 'news_event_list.jsp';
</script>
