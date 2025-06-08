<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, news.NewsService, news.BoardDTO, news.PseRangeDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 파라미터 처리
    String keyword = request.getParameter("keyword");
    String fieldText = request.getParameter("type");
    String pageParam = request.getParameter("currentPage");

    int currentPage = 1;
    if (pageParam != null && !pageParam.isEmpty()) {
        currentPage = Integer.parseInt(pageParam);
    }

    int pageScale = 10; // 한 페이지 글 수
    int startNum = (currentPage - 1) * pageScale + 1;
    int endNum = startNum + pageScale - 1;

    PseRangeDTO rDTO = new PseRangeDTO();
    rDTO.setField(fieldText);
    rDTO.setKeyword(keyword);
    rDTO.setStartNum(startNum);
    rDTO.setEndNum(endNum);

    NewsService service = new NewsService();
    List<BoardDTO> boardList = service.getNewsByType(rDTO, "공지");
    int totalCount = service.totalCount(rDTO, "공지");
    int totalPage = (int) Math.ceil((double) totalCount / pageScale);

    // JSP에 전달
    request.setAttribute("boardList", boardList);
    request.setAttribute("currentPage", currentPage);
    request.setAttribute("totalPage", totalPage);
    request.setAttribute("fieldText", fieldText);
    request.setAttribute("keyword", keyword);
    
    session.setAttribute("cntFlag", true);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>공지사항 | Donutted</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
   <!-- favicon 설정 -->
<link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>
  <style>
    .event-card { transition: transform 0.2s; cursor: pointer; }
    .event-card:hover { transform: scale(1.03); }
    
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

 /*  .notice-title-underline {
    position: absolute;
    bottom: 0;
    left: 8%; 
    transform: translateX(-50%);
    width: 130px;
    height: 3px;
    background: #2c3e50;
    border-radius: 2px;
    
}   */

 .custom-pink-header th {
    background-color: #fff0f5 !important;
    color: #333 !important;
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

  <c:import url="/common/header.jsp" />

  <main class="container" style="min-height: 600px; padding: 80px 20px;">
  
  <div style="line-height: 1; margin: 0; padding: 0;">
 	 <h3  class="notice-title-modern" style="font-weight:bold; font-size: 20px; margin-bottom: 0px; letter-spacing: -1px; ">Donutted 공지사항</h3>
     <h2 style="font-size: 60px; font-weight: bold; margin-top:0px; line-height: 0.5; " class="notice-title-modern" >
     Notice
     </h2>
	</div>
	
    <!-- 검색 필터 -->
    <form id="searchFrm" class="row g-2 mb-3 justify-content-end" action="news_notice_main.jsp" method="get">
      <div class="col-md-1">
        <select class="form-select" name="type" id="searchType" onchange="placeholder()">
          <option value="title" <%= "title".equals(fieldText) ? "selected" : "" %>>제목</option>
          <option value="content" <%= "content".equals(fieldText) ? "selected" : "" %>>내용</option>
        </select>
      </div>
      <div class="col-md-3">
        <input id="keywordInput" type="text" name="keyword" class="form-control" id="keywordInput" placeholder="검색어를 입력해주세요." value="<%= keyword != null ? keyword : "" %>">
      </div>
      <div class="col-md-1">
        <button type="submit" class="btn btn-dark">검색</button>
      </div>
    </form>

    <!-- 게시글 테이블 -->
    <table class="table table-hover">
      <thead class="custom-pink-header">
        <tr class="text-center">
          <th style="width:10%;">번호</th>
          <th style="width:70%;">제목</th>
          <th style="width:10%;">날짜</th>
          <th style="width:10%;">조회수</th>
        </tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${not empty boardList}">
            <c:forEach var="dto" items="${boardList}">
              <tr class="text-center" onclick="location.href='news_notice_view.jsp?board_id=${dto.board_id}'" style="cursor:pointer;">
                <td>${dto.board_id}</td>
                <td class="text-start">${dto.title}</td>
                <td>${dto.posted_at}</td>
                <td>${dto.viewCount}</td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr>
              <td colspan="4" class="text-center">등록된 공지사항이 없습니다.</td>
            </tr>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>

    <!-- 페이지네이션 -->
<%
  String safeFieldText = (fieldText != null) ? fieldText : "";
  String safeKeyword = (keyword != null) ? keyword : "";
%>
   <nav>
  <ul class="pagination justify-content-center">
    <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
      <a class="page-link" href="news_notice_main.jsp?currentPage=<%= currentPage - 1 %>&type=<%= safeFieldText %>&keyword=<%= safeKeyword %>">이전</a>
    </li>
    <c:forEach var="i" begin="1" end="${totalPage}">
      <li class="page-item ${i == currentPage ? 'active' : ''}">
        <a class="page-link" href="news_notice_main.jsp?currentPage=${i}&type=${safeFieldText}&keyword=${safeKeyword}">${i}</a>
      </li>
    </c:forEach>
    <li class="page-item <%= currentPage == totalPage ? "disabled" : "" %>">
      <a class="page-link" href="news_notice_main.jsp?currentPage=<%= currentPage + 1 %>&type=<%= safeFieldText %>&keyword=<%= safeKeyword %>">다음</a>
    </li>
  </ul>
</nav>

  </main>

  <c:import url="/common/footer.jsp" />

  <script>
    function placeholder() {
      const select = document.getElementById("searchType");
      const input = document.getElementById("keywordInput");
      input.placeholder = (select.value === "title") ? "제목을 입력해주세요." : "내용을 입력해주세요.";
    }
  </script>

</body>
</html>
