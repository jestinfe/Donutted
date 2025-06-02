<%@ page import="news.NewsService, news.BoardDTO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
request.setCharacterEncoding("UTF-8");

String boardIdStr = request.getParameter("board_id");
int boardId = 0;

try {
    if (boardIdStr != null && !boardIdStr.trim().isEmpty()) {
        boardId = Integer.parseInt(boardIdStr);
    } else {
        response.sendRedirect("news_notice_main.jsp");
        return;
    }
} catch (NumberFormatException e) {
    response.sendRedirect("news_notice_main.jsp");
    return;
}

// 조회수 증가 (세션 중복 방지)
NewsService service = new NewsService();
Boolean cntFlag = (Boolean) session.getAttribute("cntFlag");
if (cntFlag != null && cntFlag.booleanValue()) {   
    service.plusViewCount(boardId);
    session.setAttribute("cntFlag", false);
}

// 데이터 조회
BoardDTO dto = service.getOneNotice(boardId);
if (dto == null) {
    response.sendRedirect("news_notice_main.jsp");
    return;
}

request.setAttribute("dto", dto);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 상세보기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .notice-title {
            font-size: 36px;
            font-weight: bold;
            text-align: center;
            margin-top: 50px;
            margin-bottom: 40px;
        }
        .notice-meta {
            text-align: center;
            color: #777;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .back-btn {
            display: flex;
            justify-content: center;
            margin: 30px 0;
        }
        .notice-content {
            text-align: center;
            padding: 20px;
            font-size: 18px;
            word-break: break-all;
        }
    </style>
</head>
<body>

<!-- ✅ 공통 헤더 -->
<c:import url="/common/header.jsp" />

<main class="container">
    <div class="notice-title border rounded p-3 mb-2 text-center">
        ${dto.title}
        <div class="notice-meta">
            <br>
            <fmt:formatDate value="${dto.posted_at}" pattern="yyyy-MM-dd" />
            &nbsp;&nbsp; <i class="bi bi-eye"></i> ${dto.viewCount}
        </div>
    </div>

    <div class="notice-content">
        <c:out value="${dto.content}" escapeXml="false" />
    </div>

    <div class="back-btn">
        <a href="news_notice_main.jsp" class="btn btn-secondary">목록으로</a>
    </div>
</main>

<!-- ✅ 공통 푸터 -->
<c:import url="/common/footer.jsp" />

</body>
</html>
