<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>FAQ 상세</title>
  <style>
    .faq-detail {
      padding: 60px 20px;
      max-width: 800px;
      margin: 0 auto;
    }
    .faq-title {
      font-size: 28px;
      font-weight: bold;
      margin-bottom: 20px;
    }
    .faq-meta {
      font-size: 14px;
      color: #888;
      margin-bottom: 20px;
    }
    .faq-content {
      font-size: 16px;
      line-height: 1.6;
      white-space: pre-line;
    }
    .back-link {
      display: inline-block;
      margin-top: 30px;
      text-decoration: none;
      color: #0066cc;
      font-size: 15px;
    }
    .back-link:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>

  <!-- ✅ 공통 헤더 -->
  <c:import url="/common/header.jsp" />

  <!-- ✅ 본문 영역 -->
  <main class="faq-detail">
    <div class="faq-title">환불은 어떻게 하나요?</div>
    <div class="faq-meta">등록일: 2025-05-22</div>
    <hr>
    <div class="faq-content">
      상품 수령 후 7일 이내에 고객센터를 통해 환불 요청이 가능합니다. 
      단, 제품 포장이 훼손되었거나 사용 흔적이 있는 경우 환불이 제한될 수 있습니다.

      자세한 내용은 '교환 및 환불 정책'을 참고해주세요.
    </div>
    <a class="back-link" href="help.jsp">&larr; 목록으로 돌아가기</a>
  </main>

  <!-- ✅ 공통 푸터 -->
  <c:import url="/common/footer.jsp" />

</body>
</html>
