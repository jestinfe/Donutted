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
  <title>FAQ | Donutted</title>
  <style>
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
      font-family: '맑은 고딕', sans-serif;
      background-color: #f9fafc; 
    }

    .wrapper {
      display: flex;
      flex-direction: column;
      min-height: 100vh;
    }

    main.container {
      flex: 1;
      max-width: 1200px;
      margin: 60px auto;
      background: #ffffff; 
      padding: 40px;
      border-radius: 16px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }

    .faq-question {
      font-size: 20px;
      font-weight: bold;
      cursor: pointer;
      padding: 12px 18px;
      background: #f8d7e3; 
      border: none;
      margin-bottom: 5px;
      border-radius: 8px;
      position: relative;
      transition: background 0.2s;
    }

    .faq-question:hover {
      background: #f4c6d7; 
    }

    .faq-question .arrow {
      position: absolute;
      right: 18px;
      transition: transform 0.3s ease;
      font-size: 16px;
    }

    .faq-answer {
      font-size: 18px;
      display: none;
      padding: 14px 18px;
      background: #fdf2f7; 
      border-left: 4px solid #e89ab5;
      border-radius: 0 0 8px 8px;
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
    <h2 style="font-size: 26px; font-weight: bold; color: #c94f7c; margin-bottom: 20px;">
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

    if (answerDiv.style.display === "block") {
      answerDiv.style.display = "none";
      arrow.textContent = "▶";
    } else {
      answerDiv.style.display = "block";
      arrow.textContent = "▼";
    }
  }
</script>

</body>
</html>
