<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="inquiry.InquiryDTO, inquiry.InquiryService, java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
    int currentPage = 1;
    int pageSize = 15;

    if (request.getParameter("page") != null) {
        currentPage = Integer.parseInt(request.getParameter("page"));
    }

    int offset = (currentPage - 1) * pageSize;
    List<InquiryDTO> pagedList = InquiryService.getInstance().getPagedInquiries(offset, pageSize);
    int totalInquiries = InquiryService.getInstance().getTotalInquiriesCount();
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
    }
    .main {
      padding: 40px;
    }
  </style>
</head>
<body>

<jsp:include page="../common/external_file.jsp" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />
<%@ include file="../common/login_check.jsp" %>


<div class="main">
  <h3 class="mb-4">전체 1:1 문의 목록</h3>

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
      <c:forEach var="dto" items="${inquiryList}" varStatus="status">
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

  <!-- ✅ 페이징 -->
  <div class="d-flex justify-content-center mt-4">
    <nav>
      <ul class="pagination">
        <c:forEach var="i" begin="1" end="${totalPages}">
  <li class="page-item ${i == currentPage ? 'active' : ''}">
    <a class="page-link" href="?page=${i}">${i}</a>
  </li>
</c:forEach>

      </ul>
    </nav>
  </div>
</div>

</body>
</html>
