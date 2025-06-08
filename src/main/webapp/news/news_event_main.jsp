<%@page import="news.BoardDTO"%>
<%@page import="java.util.List"%>
<%@page import="news.NewsService"%>
<%@page import="news.PseRangeDTO"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
 
<%
request.setCharacterEncoding("UTF-8");

String boardType = request.getParameter("type");   

if (boardType == null || boardType.isEmpty()) {
     boardType = "이벤트"; // 기본값: 이벤트
 }

 NewsService service = new NewsService();

String keyword = request.getParameter("keyword");


List<BoardDTO> eventList;

if (keyword != null && !keyword.trim().isEmpty()) {
    eventList = service.searchEventByKeyword(keyword);  // 검색 메서드 호출
} else {
    eventList = service.getAllEvent(boardType);  // 전체 출력
}


 request.setAttribute("eventList", eventList);
    
    //조회수 증가
    session.setAttribute("cntFlag", true);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>이벤트 | Donutted</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
 <!-- favicon 설정 -->
<link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>
<style>
  .event-card {
    height: 650px;
    transition: transform 0.2s;
    cursor: pointer;
  }
  .event-card:hover {
    transform: scale(1.03);
  } 
  .event-img {
    width: 100%;              /* 카드 너비에 꽉 차게 */
  height: 550px;            /* 원하는 카드 높이와 맞춤 */
  object-fit: cover;        /* 비율 유지하며 꽉 채움 */
  display: block;           /* 여백 제거 */
  border-top-left-radius: 0.5rem;
  border-top-right-radius: 0.5rem;
  }
  
  .event-title-modern {
    font-size: 4rem;
    font-weight: 300;
    color: #2c3e50;
    text-align: center;
    margin: 3rem 0;
    position: relative;
    letter-spacing: 4px;
    padding-bottom: 20px;
}

.event-title-underline {
    position: absolute;
    bottom: 0;
    left: 50%;
    transform: translateX(-50%);
    width: 80px;
    height: 3px;
    background: #2c3e50;
    border-radius: 2px;
    
}
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(function() {
    $('#searchFrm').on('submit', function(e) {
      const keyword = $('#keywordInput').val().trim();

      if (keyword == null || keyword === "") {
        alert('검색어를 입력해주세요.');
        e.preventDefault(); // 서버로 전송 중지
      }
    });
  });
</script> 
</head>

<body>
  <!-- ✅ 공통 헤더 -->
  <c:import url="/common/header.jsp" />

  <!-- ✅ 본문 영역 -->
  <main class="container" style="min-height: 600px; padding: 80px 20px;">
    <h2 style="font-size: 50px; font-weight: bold; margin-bottom: 70px;" class="event-title-modern" >
    Event
    <div class="event-title-underline"></div>
    </h2>
       
    <!-- TODO: 실제 컨텐츠 작성 영역 -->
    <div class="container">
	   <!-- 검색 필터 -->
	  <form id="searchFrm" class="row g-2 mb-3 d-flex justify-content-end col-auto" action="news_event_main.jsp" method="get">
	    <div class="col-md-2" style="min-width: 270px;">
	      <input type="text" name="keyword" class="form-control" id="keywordInput" placeholder="제목을 입력해주세요." value="<%= keyword != null ? keyword : "" %>">
	    </div>
	    <div class="col-md-1">
	      <button type="submit" class="btn btn-dark" >검색</button>
	    </div>
	  </form>

   <!-- 등록된 카드 반복 영역 -->
   <c:choose>
   <c:when test="${not empty eventList}">
	  
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4 ">
	<c:forEach var="event" items="${eventList}">
  <div class="col">
    <a href="news_event_view.jsp?board_id=${event.board_id}" class="text-decoration-none text-dark">
      <div class="card event-card shadow-sm rounded-3">
        <img src="${pageContext.request.contextPath}/admin/common/images/news/${event.thumbnail_url}" class="card-img-top event-img" alt="이벤트 이미지"
        onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/admin/common/images/default/loading.gif';">
        
        <%-- <img src="${pageContext.request.contextPath}/admin/common/images/default/loading.jpg"
	     id="img" class="preview-img mb-2" alt="썸네일 이미지"
	     data-src="${pageContext.request.contextPath}/admin/common/images/news/${event.thumbnail_url}"
	     onload="this.src=this.getAttribute('data-src')"
	     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/admin/common/images/default/error.png';">  --%>
        
        <div class="card-body">
          <h6 class="card-title">${event.title}</h6>
          <p class="card-text text-muted mb-0">
            <fmt:formatDate value="${event.posted_at}" pattern="yyyy-MM-dd"/>
          </p>
        </div>
      </div>
    </a>
  </div>
	</c:forEach>
  </div>
</c:when>


<c:otherwise>
      <div>
      	<img src="${pageContext.request.contextPath}/admin/common/images/default/event_none.png"
      	style="margin-left: 60px;"/>
      	<div class="text-center">
      		<a href="news_event_main.jsp" class="btn btn-secondary">목록으로</a>
      	</div>
      </div>
</c:otherwise>

</c:choose> 

    
    </div>

  </main>

  <!-- ✅ 공통 푸터 -->
  <c:import url="/common/footer.jsp" />



</body>
</html>
