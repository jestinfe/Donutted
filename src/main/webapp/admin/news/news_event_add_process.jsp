<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.io.*"%>
<%@ page import="java.io.*, java.util.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="news.NewsDAO, news.BoardDTO" %>
<%@ include file="../common/login_check.jsp" %>

<%
request.setCharacterEncoding("UTF-8");

String title = "";
String content = "";
String thumbnailName = "";
String detailImageName = "";

// 설정
String savePath = application.getRealPath("/admin/common/images/news");
File saveDir = new File(savePath);
if (!saveDir.exists()) saveDir.mkdirs();

int maxSize = 10 * 1024 * 1024; // 10MB
String[] allowedExts = {"jpg", "jpeg", "png", "gif", "webp"};

Map<String, String> savedFiles = new HashMap<>();

try {
    MultipartRequest mr = new MultipartRequest(
        request,
        savePath,
        maxSize,
        "UTF-8",
        new DefaultFileRenamePolicy()
    );

    // 2️⃣ 파라미터 받기
    title = mr.getParameter("title");
    content = mr.getParameter("content");

    // 3️⃣ 필수 검증
    if (title == null || title.trim().isEmpty()) {
%>
<script>
    alert("제목을 입력해주세요.");
    history.back();
</script>
<%
        return;
    }

    String[] fileFields = {"profileImg", "eventImage"};

    // 4️⃣ 파일 처리
    for (String fieldName : fileFields) {
        File file = mr.getFile(fieldName);
        if (file != null) {
            String originalName = mr.getOriginalFileName(fieldName);
            String ext = originalName.substring(originalName.lastIndexOf('.') + 1).toLowerCase();

            if (!Arrays.asList(allowedExts).contains(ext)) {
                file.delete();
%>
<script>
    alert("허용되지 않은 확장자입니다: <%= ext %>");
    history.back();
</script>
<%
                return;
            }

            // UUID로 파일명 변경
            String uuidName = UUID.randomUUID().toString() + "." + ext;
            File newFile = new File(savePath, uuidName);
            boolean renamed = file.renameTo(newFile);

            if (!renamed) {
                // rename 실패 시 수동 copy → 대부분 발생 안 함 (윈도우일 경우 대비)
                try (InputStream in = new FileInputStream(file);
                     OutputStream os = new FileOutputStream(newFile)) {
                    byte[] buf = new byte[1024];
                    int len;
                    while ((len = in.read(buf)) > 0) {
                        os.write(buf, 0, len);
                    }
                }
                file.delete();
            }

            savedFiles.put(fieldName, uuidName);

        } else {
%>
<script>
    alert("<%= fieldName.equals("profileImg") ? "썸네일" : "상세 설명" %> 이미지를 등록해주세요.");
    history.back();
</script>
<%
            return;
        }
    }

} catch (Exception e) {
    e.printStackTrace();
%>
<script>
    alert("업로드 실패: <%= e.getMessage() %>");
    history.back();
</script>
<%
    return;
}

// 5️⃣ DTO 구성
BoardDTO bDTO = new BoardDTO();
bDTO.setTitle(title);
bDTO.setContent(content);
bDTO.setThumbnail_url(savedFiles.get("profileImg"));      // 서버 저장 파일명만 저장
bDTO.setDetail_image_url(savedFiles.get("eventImage"));   // 서버 저장 파일명만 저장

// 6️⃣ DAO 호출
NewsDAO dao = NewsDAO.getInstance();
dao.insertEvent(bDTO);

%>
<script>
    alert("이벤트가 등록되었습니다!");
    location.href = "news_event_list.jsp";
</script>