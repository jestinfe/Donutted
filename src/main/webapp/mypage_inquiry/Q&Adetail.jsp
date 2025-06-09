<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../common/external_file.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>Q&A 안내 | Donutted</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Pretendard&display=swap" rel="stylesheet">
  <style>
    html, body {
      height: 100%;
      margin: 0;
      font-family: 'Pretendard', 'Segoe UI', sans-serif;
      background: #fff;
      display: flex;
      flex-direction: column;
    }

    .d-flex {
      flex: 1;
      display: flex;
      position: relative;
      margin-top: 60px;
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

   .notice-box {
  padding: 40px 60px;
  padding-left: 260px; /* 사이드바 간격 확보 */
  width: 100%;
  box-sizing: border-box;
}

.card-style {
  background: #fff7fa;
  border: 1px solid #f3c6d3;
  border-radius: 12px;
  padding: 30px;
  width: 100%;
  box-shadow: 0 0 10px rgba(243, 167, 187, 0.2);
}


    .card-style h2 {
      font-weight: bold;
      color: #ef84a5;
      margin-bottom: 25px;
    }

    .card-style ul {
      padding-left: 20px;
    }

    .card-style li {
      margin-bottom: 12px;
      line-height: 1.8;
    }

    .btn-back {
      margin-top: 30px;
      background-color: #f3a7bb;
      color: white;
      border: none;
      padding: 10px 25px;
      font-weight: bold;
      border-radius: 5px;
    }

    .btn-back:hover {
      background-color: #f18aa7;
    }

    .footer-fixed {
      margin-top: auto;
    }
  </style>
</head>
<body>

  <!-- ✅ 헤더 -->
  <c:import url="/common/header.jsp" />

  <!-- ✅ 본문 + 사이드바 -->
  <div class="d-flex">
    <c:import url="/common/mypage_sidebar.jsp" />

    <div class="notice-box">
      <div class="card-style">
        <h2>Q&A 이용 안내사항</h2>
        <ul>
          <li>📦 <strong>상품 수령 후 7일이 지나면 환불이 어려울 수 있습니다.</strong></li>
          <li>🕐 배송된 상품은 수령 즉시 상태를 확인해 주세요.</li>
          <li>🥯 <strong>도넛 및 음료는 신선식품</strong>으로 가급적 빠른 섭취를 권장드립니다.</li>
          <li>🧊 보관 상태에 따라 변질 가능성이 있으니 주의해 주세요.</li>
          <li>🔁 <strong>단순 변심에 의한 환불은 어렵습니다.</strong></li>
          <li>🚚 제품 하자 또는 배송 오류 시에만 교환 또는 환불이 가능합니다.</li>
          <li>💳 환불 처리는 영업일 기준 <strong>3~5일 소요</strong>됩니다 (주말·공휴일 제외).</li>
          <li>🏠 주소 오기입, 수취인 부재 등 고객 사유로 인한 반송 시 <strong>재배송 비용이 발생</strong>할 수 있습니다.</li>
          <li>💬 1:1 문의는 <strong>평균 1~2일 내에 순차적으로 답변</strong>드립니다.</li>
          <li>❗ <strong>욕설, 비방, 허위 내용 등 부적절한 문의는 사전 고지 없이 삭제</strong>될 수 있습니다.</li>
          <li>📞 문의 관련 궁금하신 점은 고객센터(☎ 010-9955-2185)를 통해 문의해 주세요.</li>
        </ul>
        <div class="text-center">
          <button class="btn-back" onclick="history.back()">← 뒤로가기</button>
        </div>
      </div>
    </div>
  </div>

  <!-- ✅ 푸터 -->
  <div class="footer-fixed">
    <c:import url="/common/footer.jsp" />
  </div>

</body>
</html>
