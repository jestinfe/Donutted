<%@page import="java.util.List"%>
<%@ page import="news.NewsService, news.BoardDTO, news.PseRangeDTO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String keyword = request.getParameter("keyword");
    String fieldText = request.getParameter("type"); // title, content
    String pageParam = request.getParameter("currentPage");
    String boardType = request.getParameter("boardType"); // 공지/이벤트 구분
	

    if (fieldText == null || fieldText.isEmpty()) {
        fieldText = "title";
    }
    if (keyword == null || "null".equals(keyword) || keyword.trim().isEmpty()) {
        keyword = "";
    }
    
    if (boardType == null || boardType.isEmpty()) {
        boardType = "이벤트"; // 기본값: 이벤트
    }

    int currentPage = 1;
    if (pageParam != null && !pageParam.isEmpty()) {
        currentPage = Integer.parseInt(pageParam);
    }

    int pageScale = 10;
    int startNum = (currentPage - 1) * pageScale + 1;
    int endNum = startNum + pageScale - 1;

    PseRangeDTO rDTO = new PseRangeDTO();
    rDTO.setField(fieldText);
    rDTO.setKeyword(keyword);
    rDTO.setStartNum(startNum);
    rDTO.setEndNum(endNum);

    NewsService service = new NewsService();
    List<BoardDTO> newsList = service.getNewsByType(rDTO, boardType);
    int totalCount = service.totalCount(rDTO, boardType);
    int totalPage = (int) Math.ceil((double) totalCount / pageScale);

    request.setAttribute("newsList", newsList);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title><%= boardType %> 목록</title>
<script>
$(function(){
	$('#searchFrm').on('submit', function(e) {
	  const keyword = $('#keywordInput').val().trim();

	  if (keyword == null || keyword.trim() == "") {
	      alert('검색어를 입력해주세요.');
	      e.preventDefault(); // 제출 중단
	  }//end if
	});
});//ready
</script>
</head>

<div class="main">
  <h3><%= boardType %> 목록</h3>

  <!-- 검색 필터 -->
  <form id="searchFrm" class="row gx-2 gy-2 align-items-end mb-3" action="news_event_list.jsp" method="get">
    <input type="hidden" name="boardType" value="<%= boardType %>">
    
    <%-- <div class="col-auto">
      <select id="searchType" name="type" class="form-select" style="width: 120px;" onchange="placeholder()">
        <option value="title" <%= "title".equals(fieldText) ? "selected" : "" %>>제목</option>
        <option value="content" <%= "content".equals(fieldText) ? "selected" : "" %>>내용</option>
      </select>
    </div> --%>
    
    <div class="col-auto">
      <input type="text" id="keywordInput" name="keyword" class="form-control" style="width: 240px;" placeholder="제목을 입력해주세요." 
      value="<%= keyword != null ? keyword : "" %>">
    </div>
    <div class="col-auto">
      <button type="submit" id="searchBtn" class="btn btn-dark">검색</button>
    </div>
    <div class="col-auto">
      <a href="news_event_list.jsp" class="btn btn-secondary">초기화</a>
    </div>
    <div class="col-auto">
      <a href="news_event_add.jsp?boardType=<%= boardType %>" class="btn btn-primary">이벤트 작성</a>
    </div>
  </form>

  <!-- 목록 테이블 -->
<table class="table table-bordered text-center align-middle table-hover"  style="table-layout: fixed; width: 100%;">
  <thead class="table-light">
    <tr>
	    <th style="width: 10%;">번호</th>
		<th style="width: 60%;">제목</th>
		<th style="width: 20%;">작성일</th>
		<th style="width: 10%;">조회수</th>
      <!-- <th>썸네일</th> 추가 -->
    </tr>
  </thead>
  <tbody>
    <c:choose>
      <c:when test="${not empty newsList}">
        <c:forEach var="dto" items="${newsList}">
          <tr onclick="location.href='news_event_edit.jsp?board_id=${dto.board_id}&boardType=<%= boardType %>'" style="cursor:pointer;">
            <td>${dto.board_id}</td>
            <%-- <td>
              <c:if test="${not empty dto.thumbnail_url}">
                <img src="<c:url value='/admin/common/images/news/${dto.thumbnail_url}'/>" alt="썸네일" style="width:80px; height:auto;">
              </c:if>
              <c:if test="${empty dto.thumbnail_url}">
                <span style="color:gray;">이미지 없음</span>
              </c:if>
            </td> --%>
            <td>${dto.title}</td>
            <td>${dto.posted_at}</td>
            <td>${dto.viewCount}</td>
          </tr>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <tr>
          <td colspan="4" style="text-align: center;">등록된 <%= boardType %>가 없습니다.</td>
        </tr>
      </c:otherwise>
    </c:choose>
  </tbody>
</table>

  <!-- 페이징 -->
  <nav>
    <ul class="pagination justify-content-center">
      <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
        <a class="page-link" href="news_event_list.jsp?currentPage=<%= currentPage - 1 %>&type=<%= fieldText %>&keyword=<%= keyword %>">이전</a>
      </li>
      <% for (int i = 1; i <= totalPage; i++) { %>
        <li class="page-item <%= currentPage == i ? "active" : "" %>">
          <a class="page-link" href="news_event_list.jsp?currentPage=<%= i %>&type=<%= fieldText %>&keyword=<%= keyword %>"><%= i %></a>
        </li>
      <% } %>
      <li class="page-item <%= currentPage == totalPage ? "disabled" : "" %>">
        <a class="page-link" href="news_event_list.jsp?currentPage=<%= currentPage + 1 %>&type=<%= fieldText %>&keyword=<%= keyword %>">다음</a>
      </li>
    </ul>
  </nav>
</div>
