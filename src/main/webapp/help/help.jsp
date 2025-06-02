<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="news.BoardDTO, news.BoardService, java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/common/external_file.jsp" %>

<%
  List<BoardDTO> faqList = null;
  try {
    faqList = BoardService.getInstance().getFAQList();
    request.setAttribute("faqList", faqList);
  } catch (Exception e) {
    e.printStackTrace();
  }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>FAQ</title>
  <style>
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
      font-family: '맑은 고딕', sans-serif;
      background-color: #f8f9fa; /* 기본 배경 흰색 */
    }

    .wrapper {
      display: flex;
      flex-direction: column;
      min-height: 100vh;
    }

    main.container {
  flex: 1;
  max-width: 2000px; /* ✅ 넓게 */
  margin: 60px auto;
  background: #ffe4ec;
  padding: 40px;
  border-radius: 20px;
  box-shadow: 0 4px 12px rgba(255, 192, 203, 0.4);
}

    .faq-question {
     font-size: 24px;
      font-weight: bold;
      cursor: pointer;
      padding: 14px 20px;
      background: #ffc1d8;
      border: none;
      margin-bottom: 0;
      border-radius: 12px;
      position: relative;
      transition: background 0.2s;
    }

    .faq-question:hover {
      background: #ffb3cd;
    }

    .faq-question .arrow {
      position: absolute;
      right: 20px;
      transition: transform 0.3s ease;
      font-size: 18px;
    }

    .faq-answer {
    font-size: 20px;
      display: none;
      padding: 16px 20px;
      background: #fff0f5;
      border-left: 4px solid #ff99bb;
      border-radius: 0 0 12px 12px;
      margin-bottom: 10px;
      color: #444;
    }

    footer {
      background-color: #f1f1f1;
      padding: 20px 0;
      text-align: center;
    }
  </style>
</head>
<body>

<div class="wrapper">
  <!-- ✅ 공통 헤더 -->
  <c:import url="/common/header.jsp" />

  <!-- ✅ 본문 -->
  <main class="container">
    <h2 style="font-size: 28px; font-weight: bold; color: #d63384; margin-bottom: 30px;">
      자주 묻는 질문 (FAQ)
    </h2>

    <div>
      <c:forEach var="faq" items="${faqList}">
        <div class="faq-item">
          <div class="faq-question" onclick="toggleAnswer(this)">
            Q. ${faq.question}
            <span class="arrow">▶</span>
          </div>
          <div class="faq-answer">
            A. ${faq.answer}
          </div>
        </div>
      </c:forEach>
    </div>
  </main>

  <!-- ✅ 고정 푸터 -->
  <footer>
    <c:import url="/common/footer.jsp" />
  </footer>
</div>

<script>
  function toggleAnswer(el) {
    const answerDiv = el.nextElementSibling;
    const arrow = el.querySelector(".arrow");
    const isVisible = answerDiv.style.display === "block";

    // 모든 답변 닫기
    document.querySelectorAll(".faq-answer").forEach(div => div.style.display = "none");
    document.querySelectorAll(".faq-question .arrow").forEach(a => a.textContent = "▶");

    // 현재 항목 열기
    if (!isVisible) {
      answerDiv.style.display = "block";
      arrow.textContent = "▼";
    }
  }
</script>

</body>
</html>
