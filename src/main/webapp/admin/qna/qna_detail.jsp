<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="inquiry.InquiryDTO, inquiry.InquiryService" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/external_file.jsp" %>

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
    alert("해당 문의를 찾을 수 없습니다.");
    history.back();
  </script>
<%
    return;
  }

  request.setAttribute("dto", dto);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>1:1 문의 상세 - 관리자</title>
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
    .main { padding: 40px; max-width: 800px; margin: auto; }
    .item { margin-bottom: 20px; }
    .label { font-weight: bold; margin-bottom: 5px; display: block; }
    .box { background: #f8f9fa; padding: 15px; border: 1px solid #ccc; border-radius: 5px; }
    textarea { width: 100%; height: 150px; padding: 10px; }
    .btn-save { background: #f8a7bb; color: white; font-weight: bold; }
     table {
    min-width: 1000px;        
  }
  </style>
</head>
<body>

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/sidebar.jsp" />
<%@ include file="../common/login_check.jsp" %>


<div class="main">
  <h4>1:1 문의 상세</h4>

  <%
    String loginId = (String) session.getAttribute("loginId");
  %>
 

  <div class="item">
    <span class="label">작성자</span>
    <div class="box">${dto.username}</div>
  </div>

  <div class="item">
    <span class="label">제목</span>
    <div class="box">${dto.title}</div>
  </div>

  <div class="item">
    <span class="label">내용</span>
    <div class="box">${dto.content}</div>
  </div>

  <div class="item">
    <span class="label">작성일자</span>
    <div class="box"><fmt:formatDate value="${dto.createdAt}" pattern="yyyy-MM-dd HH:mm" /></div>
  </div>

  <form action="qna_reply_ok.jsp" method="post">
    <input type="hidden" name="inquiry_id" value="${dto.inquiryId}" />

    <div class="item">
      <span class="label">답변 내용</span>
      <textarea name="reply_content">${dto.replyContent}</textarea>
    </div>

    <div class="text-end mt-3">
      <button type="submit" class="btn btn-save">답변 등록</button>
      <a href="qna_list.jsp" class="btn btn-secondary">목록</a>
      <a href="qna_delete.jsp?inquiry_id=${dto.inquiryId}"
         onclick="return confirm('정말 삭제하시겠습니까?');"
         class="btn btn-danger">삭제</a>
    </div>
  </form>
  
</div>


</body>
</html>
