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

NewsService service = new NewsService();
Boolean cntFlag = (Boolean) session.getAttribute("cntFlag");
if (cntFlag != null && cntFlag.booleanValue()) {
    service.plusViewCount(boardId);
    session.setAttribute("cntFlag", false);
}

//게시글 정보 조회 + id 없는 값 입력시 null -> main 페이지로
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
  <title>${dto.title} > 공지사항 | Donutted</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
   <!-- favicon 설정 -->
<link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>
  <style>
    .notice-wrapper {
      max-width: 1000px;
      margin: 60px auto;
      padding: 20px 30px;
    }


    .notice-box {
	  background-color: #fff0f5; 
	  color: #2c2c2c;          
	  padding: 20px 20px;
	  border-radius: 7px;
	  font-weight: bold;
	  display: flex;
	  justify-content: space-between;
	  align-items: center;
	  font-size: 20px;
	
	  margin-left: -30px;
	  margin-right: -30px;
	  padding-left: 40px;
	  padding-right: 40px;
	}
	
    .notice-meta {
      font-size: 14px;
      color: #ccc;
      margin-top: 5px;
    }

    .notice-content {
      font-size: 17px;
      line-height: 1.8;
      padding: 40px 0;
      white-space: pre-line;
    }

    .back-btn {
      text-align: center;
      margin-top: 40px;
    }

    .back-btn a {
      padding: 8px 30px;
      border-radius: 20px;
      font-weight: 500;
    }
    
     .notice-title-modern {
    font-size: 4rem;
    font-weight: 300;
    color: #2c3e50;
    text-align: left;
    margin: 3rem 0;
    position: relative;
    letter-spacing: 4px;
    padding-bottom: 20px;
}

  </style>
</head>
<body>

<c:import url="/common/header.jsp" />

<div class="notice-wrapper">
 	<div style="line-height: 1; margin: 0; padding: 0;">
 	 <h3  class="notice-title-modern" style="font-weight:bold; font-size: 20px; margin-bottom: 0px; letter-spacing: -1px; ">Donutted 공지사항</h3>
     <h2 style="font-size: 60px; font-weight: bold; margin-top:0px; line-height: 0.5; " class="notice-title-modern" >
     Notice
     </h2>
	</div>

  <div class="notice-box">
    <span>${dto.title}</span>
    <span><fmt:formatDate value="${dto.posted_at}" pattern="yyyy-MM-dd" /> &nbsp; <i class="bi bi-eye"></i> ${dto.viewCount}</span>
  </div>

  <div class="notice-content">
    <c:out value="${dto.content}" escapeXml="false" />
  </div>
	<div class="border-top mt-4 pt-4"></div>
	<div style=" text-align: center;">
    <a href="news_notice_main.jsp" class="btn btn-secondary">목록으로</a>
    </div>
</div>
 

<c:import url="/common/footer.jsp" />

</body>
</html>
