<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="inquiry.InquiryDTO, inquiry.InquiryService" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
  String idParam = request.getParameter("inquiry_id");
  if (idParam == null) {
%>
  <script>
    alert("잘못된 접근입니다.");
    history.back();
  </script>
<%
    return;
  }

  int inquiryId = Integer.parseInt(idParam);
  InquiryDTO dto = InquiryService.getInstance().getInquiryById(inquiryId);
  if (dto == null) {
%>
  <script>
    alert("해당 문의 내역이 존재하지 않습니다.");
    history.back();
  </script>
<%
    return;
  }

  request.setAttribute("dto", dto); // JSTL에서 출력할 수 있도록 설정
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>1:1 문의 상세</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      padding: 40px;
    }
    .detail-box {
      max-width: 700px;
      margin: auto;
    }
    .detail-box h4 {
      margin-bottom: 30px;
      font-weight: bold;
    }
    .detail-box .item {
      margin-bottom: 20px;
    }
    .item label {
      font-weight: bold;
      display: block;
      margin-bottom: 5px;
    }
    .item .content-box {
      padding: 15px;
      border: 1px solid #ccc;
      border-radius: 5px;
      background: #fafafa;
    }
    .btn-back {
      margin-top: 30px;
      background-color: #f3a7bb;
      color: white;
      border: none;
      padding: 10px 20px;
      font-weight: bold;
    }
    .btn-back:hover {
      background-color: #f18aa7;
    }
  </style>
</head>
<body>
<!-- ✅ header.jsp 포함 -->
<c:import url="/common/header.jsp" />

<div class="d-flex mt-5">
  <!-- ✅ 사이드바 -->
  <c:import url="/common/mypage_sidebar.jsp" />

  <div class="detail-box">
    <h4>1:1 문의 상세</h4>

    <div class="item">
      <label>제목</label>
      <div class="content-box">${dto.title}</div>
    </div>

    <div class="item">
      <label>내용</label>
      <div class="content-box">${dto.content}</div>
    </div>

    <div class="item">
      <label>작성일자</label>
      <div class="content-box">
        <fmt:formatDate value="${dto.createdAt}" pattern="yyyy-MM-dd HH:mm" />
      </div>
    </div>

    <div class="item">
      <label>답변</label>
      <div class="content-box">
        <c:choose>
          <c:when test="${not empty dto.replyContent}">
            ${dto.replyContent}
          </c:when>
          <c:otherwise>
            
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <div class="text-center">
      <button class="btn-back" onclick="location.href='my_inquiry.jsp'">목록으로</button>
    </div>
  </div>
</div>

<!-- ✅ footer.jsp 포함 -->
<c:import url="/common/footer.jsp" />
</body>
</html>
