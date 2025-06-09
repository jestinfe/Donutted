<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="inquiry.InquiryDTO, inquiry.InquiryService" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="../common/external_file.jsp" %>

<%
  Integer loginUserId = (Integer) session.getAttribute("userId");
  if (loginUserId == null) {
%>
  <script>
    alert("로그인이 필요합니다.");
    location.href = "../UserLogin/login.jsp";
  </script>
<%
    return;
  }

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

  if (dto == null || dto.getUserId() != loginUserId) {
%>
  <script>
    alert("잘못된 접근입니다.");
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
  <title>1:1 문의 상세 | Donutted</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <style>
    body {
    font-family: 'Segoe UI', sans-serif;
    background-color: #f9f9f9;
    margin: 0;
    padding: 0;
    min-width: 1280px; /* ✅ 전체 최소 너비 고정 */
    overflow-x: auto; /* ✅ 만약 더 작으면 가로 스크롤 생김 */
}

  .main-container {
    max-width: 1280px;
    min-width: 1280px; /* ✅ main 전체 고정 */
    margin: 60px auto;
    padding-left: 260px; /* ✅ 사이드바 고려 */
    box-sizing: border-box;
}

  .sidebar {
    position: fixed;
    top: 120px;
    left: 0;
    width: 240px;
    height: auto;
    z-index: 10;
    background-color: #f8d7da;
    padding: 20px;
}

   .detail-box {
    flex: 1;
    min-width: 760px;
    box-sizing: border-box;
    background-color: #ffffff;
    padding: 40px;
    border: 1px solid #ddd;
    border-radius: 8px;
}

    h4 {
      font-size: 22px;
      font-weight: bold;
      margin-bottom: 30px;
      border-bottom: 2px solid #555;
      padding-bottom: 10px;
      color: #333;
    }

    .item {
      margin-bottom: 25px;
    }

    .item label {
      font-weight: bold;
      display: block;
      margin-bottom: 6px;
      color: #444;
    }

    .content-box {
      padding: 14px 16px;
      background-color: #f8f8f8;
      border: 1px solid #ccc;
      font-size: 15px;
      line-height: 1.6;
      white-space: pre-wrap;
      word-break: break-word;
      border-radius: 6px;
    }

    .btn-back {
      margin-top: 30px;
      padding: 10px 24px;
      background-color: #555;
      color: #fff;
      border: none;
      font-weight: bold;
      border-radius: 6px;
    }

    .btn-back:hover {
      background-color: #333;
    }

    @media (max-width: 992px) {
      .main-container {
        flex-direction: column;
      }

      .sidebar {
        width: 100%;
      }

      .detail-box {
        margin-top: 20px;
      }
    }
  </style>
</head>
<body>
  <!-- ✅ header -->
  <c:import url="/common/header.jsp" />

  <div style="display:flex; max-width:1280px; margin:auto; padding:60px 20px;">
    <!-- ✅ 사이드바 - 바깥에서 직접 포함 -->
    <div style="width:240px; flex-shrink:0;">
      <c:import url="/common/mypage_sidebar.jsp" />
    </div>

    <!-- ✅ 메인 컨텐츠 -->
    <div style="flex:1; background:#fff; padding:40px; border:1px solid #ddd; border-radius:8px;">
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
              <span style="color: #888;">아직 답변이 등록되지 않았습니다.</span>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <div class="text-center mt-4">
        <button class="btn-back" onclick="location.href='my_inquiry.jsp'">목록으로</button>
      </div>
    </div>
  </div>

  <!-- ✅ footer -->
  <c:import url="/common/footer.jsp" />
</body>

</html>
