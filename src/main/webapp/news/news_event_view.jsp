<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="news.BoardDTO, news.NewsService" %>
<%
  int board_id = Integer.parseInt(request.getParameter("board_id"));
  
  NewsService service = new NewsService();
  
  //이전 글, 다음 글로 이동
  BoardDTO prev = service.getPrevEvent(board_id);
  BoardDTO next = service.getNextEvent(board_id);
  request.setAttribute("prev", prev);
  request.setAttribute("next", next);
  
  //조회수 증가
  Boolean cntFlag=(Boolean)session.getAttribute("cntFlag");
  if (cntFlag != null && cntFlag.booleanValue()) {   
    service.plusViewCount(board_id);
    session.setAttribute("cntFlag", false);
	}
  
  //게시글 정보 조회 + id 없는 값 입력시 null -> main 페이지로
  BoardDTO dto = service.getOneEvent(board_id); 
  if (dto == null) {
	    response.sendRedirect("news_event_main.jsp");
	    return;
	}
  request.setAttribute("event", dto); // "event"라는 이름으로 view에 전달
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>${event.title} > 이벤트 | Donutted</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
   <!-- favicon 설정 -->
<link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>
  <style>
    .event-title { font-size: 22px; font-weight: bold; text-align: center; margin-top: 50px; }
    .event-meta { text-align: center; color: #777; margin-bottom: 20px; font-size: 14px; }
    .event-img { display: block; margin: 0 auto; max-width: 800px; height: auto; }
    .event-content { padding: 30px 50px; font-size: 16px; color: #333; }
    .back-btn { display: flex; justify-content: center; margin: 30px 0; }
    
    .hover-row {
    padding: 10px;
    border-radius: 4px;
    transition: background-color 0.2s;
  	}
  	.hover-row:hover {
    background-color: #f8f9fa; 
    cursor: pointer;
 	}
 	
 	
  </style>
</head>
<body>

<!-- ✅ 공통 헤더 -->
<c:import url="/common/header.jsp" />

<main class="container">
  <div style="font-size: 30px;" class="event-title border rounded p-3 mb-2 text-center">
    ${event.title}
    <div class="event-meta">
      <br>
      <fmt:formatDate value="${event.posted_at}" pattern="yyyy-MM-dd" />
      &nbsp;&nbsp; <i class="bi bi-eye"></i> ${event.viewCount}
    </div>
    <div class="border-top mt-5 pt-4"></div>
    <img src="${pageContext.request.contextPath}/admin/common/images/news/${event.thumbnail_url}" 
         class="card-img-top event-img" alt="이벤트 썸네일 이미지"
         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/admin/common/images/default/loading.gif';">
    <img src="${pageContext.request.contextPath}/admin/common/images/news/${event.detail_image_url}" 
         class="card-img-top event-img" alt="이벤트 상세설명 이미지"
         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/admin/common/images/default/loading.gif';">
  </div>
  
  <div class="border-top mt-5 pt-4">
  
  <!-- 이전 글, 다음 글로 이동 -->
    <!-- 이전 글 -->
    <div class="d-flex align-items-center py-2 hover-row">
      <i class="bi bi-chevron-up me-2 text-muted"></i>
      <c:choose>
        <c:when test="${not empty prev}">
          <a href="news_event_view.jsp?board_id=${prev.board_id}" class="text-dark text-decoration-none">
            ${prev.title}
          </a>
        </c:when>
        <c:otherwise>
          <span class="text-muted">이전 글 없음</span>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- 다음 글 -->
    <div class="d-flex align-items-center py-2 hover-row">
      <i class="bi bi-chevron-down me-2 text-muted"></i>
      <c:choose>
        <c:when test="${not empty next}">
          <a href="news_event_view.jsp?board_id=${next.board_id}" class="text-dark text-decoration-none">
            ${next.title}
          </a>
        </c:when>
        <c:otherwise>
          <span class="text-muted">다음 글 없음</span>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
  
  <div class="back-btn">
    <a href="news_event_main.jsp" class="btn btn-secondary">목록으로</a>
  </div>
</main>

<!-- ✅ 공통 푸터 -->
<c:import url="/common/footer.jsp" />

</body>
</html>
