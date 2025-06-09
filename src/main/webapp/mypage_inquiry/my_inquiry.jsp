<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="inquiry.InquiryDTO, inquiry.InquiryService, java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="../common/external_file.jsp" %>
<%
Integer userId = (Integer) session.getAttribute("userId");
if (userId == null) {
    out.println("<script>");
    out.println("alert('로그인이 필요합니다.');");
    out.println("location.href='../UserLogin/login.jsp';");
    out.println("</script>");
    return;
}

int pageSize = 10;
int currentPage = 1;
if (request.getParameter("page") != null) {
    currentPage = Integer.parseInt(request.getParameter("page"));
}
int offset = (currentPage - 1) * pageSize;

InquiryService service = InquiryService.getInstance();
List<InquiryDTO> inquiryList = service.getUserPagedInquiries(userId, offset, pageSize);
int totalCount = service.getUserInquiriesCount(userId);
int totalPages = (int) Math.ceil((double) totalCount / pageSize);

request.setAttribute("inquiryList", inquiryList);
request.setAttribute("currentPage", currentPage);
request.setAttribute("totalPages", totalPages);
//잉
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>마이페이지 - Q/A 내역 | Donutted</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Pretendard&display=swap" rel="stylesheet">
  <style>
    html, body {
      height: 100%;
      margin: 0;
      font-family: 'Segoe UI', sans-serif;
      background: #fff;
      display: flex;
      flex-direction: column;
    }

    .main-container {
      display: flex;
      flex: 1;
      margin-top: 0px;
      min-width: 1000px;
      justify-content: center;
    }

    h3 {
      font-weight: 700;
      margin-bottom: 30px;
      border-left: 5px solid #f18aa7;
      padding-left: 10px;
      color: #f18aa7;
      position: relative;
    }

    .mypage-sidebar {
      position: fixed;
      top: 120px;
      left: 0;
      width: 200px;
      background-color: #f8d7da;
      padding: 20px;
      height: auto;
      z-index: 10;
    }

    .mypage-sidebar h4 {
      color: white;
      background-color: #ef84a5;
      padding: 10px;
      text-align: center;
    }

    .mypage-sidebar ul {
      list-style: none;
      padding: 0;
    }

    .mypage-sidebar li {
      background: white;
      margin-bottom: 5px;
      padding: 10px;
      font-weight: bold;
    }

    .qna-wrapper {
      flex: 1;
      max-width: 1200px;
      margin-left: 220px;
      margin-right: 20px;
      padding: 30px;
      min-width: 780px;
      box-sizing: border-box;
    }

    table {
      width: 100%;
      border-top: 2px solid #333;
      text-align: center;
    }

    thead th {
      background: #f8f9fa;
      font-weight: bold;
      border-bottom: 1px solid #ccc;
      padding: 12px;
    }

    tbody td {
      border-bottom: 1px solid #eee;
      padding: 12px;
    }

    tbody tr.notice {
      background-color: #fef3f7;
      font-weight: bold;
    }

    .qna-btn {
      background-color: #f3a7bb;
      color: white;
      border: none;
      padding: 10px 20px;
      font-weight: bold;
      border-radius: 30px; /* 둥글둥글하게 */
      transition: background-color 0.3s ease;
    }

    .qna-btn:hover {
      background-color: #f18aa7;
    }

    .footer-fixed {
      margin-top: auto;
    }

    .table-responsive-wrapper {
      overflow-x: auto;
      width: 100%;
    }
  </style>
</head>
<body>

  <!-- ✅ header.jsp 포함 -->
  <c:import url="/common/header.jsp" />

  <!-- ✅ 본문 + 사이드바 -->
  <div class="main-container">
    <!-- ✅ 사이드바 -->
    <c:import url="/common/mypage_sidebar.jsp" />

    <!-- ✅ 본문 Q/A 내역 -->
    <div class="qna-wrapper">
      <h3>
        나의 Q/A 내역 ( <%= totalCount %> 건 )
      </h3>

      <div style="overflow-x: auto;">
        <table>
          <thead>
            <tr>
              <th>번호</th>
              <th>제목</th>
              <th>작성 날짜</th>
              <th>답변 상태</th>
            </tr>
          </thead>
          <tbody>
            <tr class="notice" style="cursor: pointer;" onclick="location.href='Q&Adetail.jsp'">
              <td>[공지]</td>
              <td>※필독※ Q/A 게시글 등록시 참고사항</td>
              <td></td>
              <td></td>
            </tr>

            <c:forEach var="dto" items="${inquiryList}" varStatus="status">
              <tr>
                <td>${(currentPage - 1) * 10 + status.count}</td>
                <td>${dto.title}</td>
                <td><fmt:formatDate value="${dto.createdAt}" pattern="yyyy.MM.dd"/></td>
                <td>
                  <c:choose>
                    <c:when test="${dto.replyContent != null and fn:trim(dto.replyContent) != ''}">
                      <button class="btn btn-success btn-sm" onclick="location.href='inquiry_detail.jsp?inquiry_id=${dto.inquiryId}'">답변완료</button>
                    </c:when>
                    <c:otherwise>
                      <button class="btn btn-dark btn-sm" onclick="location.href='inquiry_detail.jsp?inquiry_id=${dto.inquiryId}'">답변대기</button>
                    </c:otherwise>
                  </c:choose>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>

        <!-- ✅ Q/A 작성하기 버튼 → 테이블 아래 위치 -->
        <div class="text-center mt-3">
          <button class="qna-btn" onclick="location.href='inquiry_add.jsp'">Q/A 작성하기</button>
        </div>
      </div>

      <!-- ✅ 페이지네이션 → 테이블 밖에서 중앙 배치 -->
      <div class="text-center mt-4">
        <nav class="d-inline-block">
          <ul class="pagination mb-2 justify-content-center">
            <c:forEach var="i" begin="1" end="${totalPages}">
              <li class="page-item ${i == currentPage ? 'active' : ''}">
                <a class="page-link" href="?page=${i}">${i}</a>
              </li>
            </c:forEach>
          </ul>
        </nav>
      </div>
    </div>
  </div>

  <!-- ✅ footer.jsp 포함 -->
  <div class="footer-fixed">
    <c:import url="/common/footer.jsp" />
  </div>

</body>
</html>
