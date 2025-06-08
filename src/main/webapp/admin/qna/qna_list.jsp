<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="inquiry.InquiryDTO, inquiry.InquiryService, java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="../common/external_file.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    // 검색 파라미터 받기
    String userIdParam = request.getParameter("user_id");
    String dateParam = request.getParameter("date");
    String statusParam = request.getParameter("status");

    int currentPage = 1;
    int pageSize = 15;

    if (request.getParameter("page") != null) {
        currentPage = Integer.parseInt(request.getParameter("page"));
    }

    int offset = (currentPage - 1) * pageSize;

    // DAO 호출 - 검색 조건 사용
    List<InquiryDTO> pagedList = InquiryService.getInstance().getPagedInquiriesWithFilter(offset, pageSize, userIdParam, dateParam, statusParam);
int totalInquiries = InquiryService.getInstance().getTotalInquiriesCountWithFilter(userIdParam, dateParam, statusParam);

    int totalPages = (int) Math.ceil((double) totalInquiries / pageSize);

    request.setAttribute("inquiryList", pagedList);
    request.setAttribute("currentPage", currentPage);
    request.setAttribute("totalPages", totalPages);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>관리자 - 1:1 문의 목록</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
 <style>
body {
  font-family: 'Segoe UI', sans-serif;
  background-color: #fff;
  margin: 0;
  padding: 0;
  min-width: 1280px;
  overflow-x: hidden;
}

.main {
  padding: 40px;
  width: 95%;  /* 가로 시원하게 */
  max-width: 1600px; /* 최대폭 조금 더 키우기 */
  margin: auto;
}

table {
  width: 100%;    /* main 내부에서 꽉 차게 */
  min-width: 1200px; /* 최소 너비 확보 */
}

.custom-search-btn {
  font-size: 14px;
  padding: 6px 16px;
  border-radius: 8px;
  font-weight: 500;
  line-height: 1.2;
  white-space: nowrap;      
  display: inline-block;    
}

</style>

</head>
<body>

<jsp:include page="../common/external_file.jsp" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />

<div class="main">
  <h3 class="mb-4">전체 1:1 문의 목록</h3>

<form method="get" class="d-flex mb-4 align-items-center gap-2">
    <input type="text" name="user_id" class="form-control form-control-sm" placeholder="회원번호" value="${param.user_id}">
    <input type="date" name="date" class="form-control form-control-sm" value="${param.date}">
    <select name="status" class="form-select form-select-sm">
      <option value="">전체상태</option>
      <option value="WAIT" ${param.status == 'WAIT' ? 'selected' : ''}>답변대기</option>
      <option value="DONE" ${param.status == 'DONE' ? 'selected' : ''}>답변완료</option>
    </select>
	<button type="submit" class="btn btn-primary custom-search-btn">검색</button>
	
</form>


  <table class="table table-hover text-center align-middle">
    <thead class="table-light">
      <tr>
        <th>번호</th>
        <th>회원번호</th>
        <th>제목</th>
        <th>작성일</th>
        <th>상태</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="dto" items="${inquiryList}">
        <tr onclick="location.href='qna_detail.jsp?inquiry_id=${dto.inquiryId}'" style="cursor: pointer;">
          <td>${dto.inquiryId}</td>
          <td>${dto.userId}</td>
          <td>${dto.title}</td>
          <td><fmt:formatDate value="${dto.createdAt}" pattern="yyyy-MM-dd" /></td>
          <td>
            <c:choose>
              <c:when test="${dto.replyContent != null and fn:trim(dto.replyContent) != ''}">
                <span class="badge bg-success">답변완료</span>
              </c:when>
              <c:otherwise>
                <span class="badge bg-warning text-dark">답변대기</span>
              </c:otherwise>
            </c:choose>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>

  <div class="d-flex justify-content-center mt-4">
    <nav>
      <ul class="pagination">
        <c:forEach var="i" begin="1" end="${totalPages}">
          <li class="page-item ${i == currentPage ? 'active' : ''}">
           <a class="page-link"
   href="?page=${i}&user_id=${param.user_id}&date=${param.date}&status=${param.status}">
   ${i}
</a>
          </li>
        </c:forEach>
      </ul>
    </nav>
  </div>
</div>

</body>
</html>
