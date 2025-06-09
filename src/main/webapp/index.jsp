<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>Donutted</title>
  <link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>
  <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css"/>
  <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>

  <style>
    /* —————————————————— Slider —————————————————— */
    .slider {
      position: relative;
      width: 100%;
      height: 780px;
      overflow: hidden;
      box-shadow: 0 0 30px rgba(0, 0, 0, 0.3);
    }
    .slider img {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      object-fit: cover;
      opacity: 0;
      transition: opacity 1s ease-in-out;
    }
    .slider img.active {
      opacity: 1;
      z-index: 1;
    }

    /* ————————————— Instagram Slider ————————————— */
    #instagram_section {
      margin: 10px auto 80px;
      max-width: 1280px;
      background: url('<c:url value="/common/images/instagram_bg.png"/>')
                  no-repeat center/cover;
      padding: 40px 20px;
      border-radius: 12px;
      box-shadow: 0 0 20px rgba(0,0,0,0.1);
    }
    #instagram_section h3 {
      font-size: 36px;
      color: #d63384;
      text-align: center;
      margin-bottom: 20px;
      position: relative;
      text-transform: uppercase;
      letter-spacing: 2px;
    }
    #instagram_section h3::after {
      content: "";
      display: block;
      width: 80px;
      height: 4px;
      background: #d63384;
      margin: 10px auto 0;
      border-radius: 2px;
    }
    .instagram-slider-container {
      overflow: hidden;
      width: 100%;
      position: relative;
    }
    .instagram-slider {
      display: flex;
      width: calc(200px * 20);
      animation: scroll 20s linear infinite;
    }
    .instagram-slider img {
      width: 200px;
      height: 200px;
      object-fit: cover;
      flex-shrink: 0;
      margin-right: 10px;
      border-radius: 10px;
    }
    @keyframes scroll {
      0% { transform: translateX(0); }
      100% { transform: translateX(-50%); }
    }

    /* ————————— Kakao Channel Button ————————— */
    .kakao-channel-box {
      text-align: center;
      margin-bottom: 30px;
    }
    .kakao-channel-btn {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      background-color: #fee500;
      color: #3c1e1e;
      font-weight: bold;
      padding: 12px 20px;
      border-radius: 30px;
      text-decoration: none;
      font-size: 16px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.15);
      transition: background-color .3s, transform .2s;
    }
    .kakao-channel-btn:hover {
      background-color: #ffd900;
      transform: translateY(-2px);
    }
    .rabbit-icon {
      width: 32px;
      height: 32px;
    }

    /* —————————— Brand Story —————————— */
    #brand_story_section {
      background-color: #fff5f8;
      text-align: center;
      padding: 60px 20px 20px;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    #brand_story_section h3 {
      font-size: 28px;
      color: #d63384;
      margin-bottom: 20px;
    }
    #brand_story_section p {
      font-size: 18px;
      line-height: 1.6;
      color: #333;
      max-width: 800px;
      margin: 0 auto;
    }
    
    .nav { 
    padding-bottom: 15px
  	}
  </style>
</head>

<body>
  <!-- 공통 헤더 -->
  <c:import url="common/header.jsp" />

  <!-- 메인 컨텐츠 -->
  <main>
    <!-- 배너 슬라이더 -->
    <div class="slider">
      <img src="<c:url value='/common/images/slider_1.png'/>" class="active" alt="배너1">
      <img src="<c:url value='/common/images/slider_2.png'/>" alt="배너2">
      <img src="<c:url value='/common/images/slider_3.png'/>" alt="배너3">
      <img src="<c:url value='/common/images/slider_4.png'/>" alt="배너4">
      <img src="<c:url value='/common/images/slider_5.png'/>" alt="배너5">
      <img src="<c:url value='/common/images/slider_6.png'/>" alt="배너6">
      <img src="<c:url value='/common/images/slider_7.png'/>" alt="배너7">
    </div>

    <!-- Brand Story -->
    <section id="brand_story_section">
      <h3>🍩 Welcome Donutted 🍩</h3>
      <p>
        Donutted는 세상에서 가장 사랑스러운 도넛과 커피를 만드는 브랜드입니다.<br>
        매일 아침 신선한 재료로 구워내는 다양한 도넛과 풍미 깊은 커피로 고객님께 행복을 선사합니다. ☕️🍩✨
      </p>
    </section>

    <!-- Instagram 영역 -->
    <section id="instagram_section">
      <h3>📸 Instagram 💕</h3>
      <div class="kakao-channel-box">
        <a href="https://pf.kakao.com/_AUDFj" target="_blank" class="kakao-channel-btn">
          <img src="<c:url value='/common/images/kakao.png'/>" alt="카카오톡 아이콘" class="rabbit-icon">
          카카오톡 채널 추가하기
        </a>
      </div>

      <div class="instagram-slider-container">
        <div class="instagram-slider">
          <c:forEach var="i" begin="1" end="16">
            <img src="<c:url value='/common/images/insta_${i}.png'/>" alt="insta${i}">
          </c:forEach>
          <!-- 복제 이미지 -->
          <c:forEach var="i" begin="1" end="16">
            <img src="<c:url value='/common/images/insta_${i}.png'/>" alt="insta${i}-dup">
          </c:forEach>
        </div>
      </div>
    </section>
  </main>

  <!-- 공통 푸터 -->
  <c:import url="common/footer.jsp" />

  <!-- 슬라이더 스크립트 -->
  <script>
    (function() {
      const banners = document.querySelectorAll('.slider img');
      let idx = 0;
      setInterval(() => {
        banners[idx].classList.remove('active');
        idx = (idx + 1) % banners.length;
        banners[idx].classList.add('active');
      }, 3500);
    })();
  </script>
</body>
</html>
