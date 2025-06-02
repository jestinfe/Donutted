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
    height: 550px;
    object-fit: cover;
  }
</style>
</head>

<body>
  <!-- ✅ 공통 헤더 -->
  <c:import url="/common/header.jsp" />

  <!-- ✅ 본문 영역 -->
  <main class="container" style="min-height: 600px; padding: 80px 20px;">
    <h2 style="font-size: 50px; font-weight: bold; margin-bottom: 80px;" class="text-center" >Event</h2>
    
    <!-- 검색 필터 -->
  <form class="row g-2 mb-3 d-flex justify-content-end" action="news_event_main.jsp" method="get">
   
    <%-- <div class="col-md-1" style="min-width: 130px;">
      <select class="form-select" name="type" id="searchType" onchange="placeholder()">
        <option value="title" <%= "title".equals(fieldText) ? "selected" : "" %>>제목</option>
      <!--   <option value="posted_at">날짜</option> -->
      </select>
    </div> --%>
    
    <div class="col-md-2" style="min-width: 270px;">
      <input type="text" name="keyword" class="form-control" id="keywordInput" placeholder="제목을 입력해주세요." value="<%= keyword != null ? keyword : "" %>">
    </div>
    <div class="col-md-1">
      <button type="submit" class="btn btn-dark" >검색</button>
    </div>
  </form>
  
    <script>
function placeholder(){
	  const select = document.getElementById("searchType");
	  const input = document.getElementById("keywordInput");

	  const value = select.value;

	  if (value === "title") {
	    input.placeholder = "제목을 입력해주세요.";
	  } else if (value === "posted_at") {
	    input.placeholder = "날짜를 입력해주세요.";
	  }
}


</script>
       
    <!-- TODO: 실제 컨텐츠 작성 영역 -->
    <!-- <p style="color: #555;"><strong>공지사항 &amp; 이벤트</strong></p> -->
    <div class="container">
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4 ">

   <!-- 등록된 카드 반복 영역 -->
   <c:choose>
   <c:when test="${not empty eventList}">
<c:forEach var="event" items="${eventList}">
  <div class="col">
    <a href="news_event_view.jsp?board_id=${event.board_id}" class="text-decoration-none text-dark">
      <div class="card event-card shadow-sm rounded-3">
        <img src="${pageContext.request.contextPath}/admin/common/images_pse/${event.thumbnail_url}" class="card-img-top event-img" alt="이벤트 이미지">
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
</c:when>
<c:otherwise>
            
     <strong class="text-center">등록된 이벤트가 없습니다.</strong>
            
          </c:otherwise>
   </c:choose>

  </div>
    
    </div>

  </main>

  <!-- ✅ 공통 푸터 -->
  <c:import url="/common/footer.jsp" />



</body>
</html>
