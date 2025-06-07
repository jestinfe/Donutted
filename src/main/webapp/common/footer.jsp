<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
      .slider {
        position: relative;
        width: 100%;
        height: 600px; 
        overflow: hidden;
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

      #instagram_section {
        margin-top: 80px;
        margin-bottom: 80px;
        background-color: #ffe4e1;
        padding: 40px 20px;
        border-radius: 12px;
        max-width: 1280px;
        margin-left: auto;
        margin-right: auto;
      }

      #instagram_section h3 {
        font-size: 24px;
        color: #d63384;
        margin-bottom: 24px;
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
        0% {
          transform: translateX(0);
        }
        100% {
          transform: translateX(-50%);
        }
      }

      /* 푸터 스타일 */
      .tms-footer {
        background: #fff0f5 url('<c:url value="/common/images/footer_cloud.png"/>') no-repeat center bottom;
        background-size: cover;
        padding: 30px 16px 180px;
        font-family: 'Pretendard', sans-serif;
        position: relative;
      }

      .tms-footer-inner {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        max-width: 1280px;
        margin: 0 auto;
        gap: 20px;
      }

      .tms-footer h3 {
        font-size: 14px;
        margin-bottom: 8px;
        font-weight: bold;
      }

      .tms-footer ul li {
        font-size: 12px;
        margin-bottom: 4px;
        line-height: 1.6;
      }

      .tms-footer a {
        text-decoration: none;
        color: #333;
      }

      .tms-footer-bottom {
        margin-top: 30px;
        text-align: center;
        font-size: 11px;
        border-top: 1px solid #ddd;
        padding-top: 12px;
      }

      .tms-footer-bottom a {
        margin: 0 10px;
        text-decoration: none;
        color: #333;
      }
</style>

<footer class="tms-footer">
  <div class="tms-footer-inner">
    <!-- Left -->
    <div>
      <h3>COMPANY INFORMATION</h3>
      <ul>
        <li>쌍용교육 센터</li>
        <li>서울특별시 강남구 역삼동 테헤란로 132 한독약품빌딩 8층</li>        
        <li>전화번호 : 02-3482-4632</li>
        <li>대표이사 : 박선은</li>
      </ul>
    </div>
    
    <!-- Middle -->
    <div>
      <h3>Knotted America Inc.</h3>
      <ul>
        <li>#104 &amp; #105 1411 W Sunset Blvd</li>
        <li>Los Angeles, CA 90026, USA</li>
        <li>+1-213-316-6296</li>
        <li style="font-size: 11px; color: #777;">This information will be updated more later</li>
      </ul>
    </div>

    <!-- Right -->
    <div>
      <h3>SOCIAL</h3>
      <ul>
        <li>
          <a href="https://www.instagram.com/cafeknotted_kr/" target="_blank">📷 Instagram 바로가기</a>
        </li>
        <li>
          <a href="https://search.naver.com/search.naver?query=노티드" target="_blank">🔍 Naver (노티드 검색)</a>
        </li>
      </ul>

      <h3 style="margin-top: 24px;">HELP</h3>
      <ul>
        <li>고객센터: 1800-6067</li>
        <li>운영시간: 평일 9시~12시, 13시~17시 (주말/공휴일 제외)</li>
      </ul>
    </div>
  </div>

  <div class="tms-footer-bottom">
    <a href="#">이용약관</a>
    <a href="#">개인정보처리방침</a>
    <span>Copyright © 2023 Knotted. All Rights Reserved.</span>
  </div>
</footer>

<!-- ✅ slider 없는 페이지에서도 안전하게 동작 -->
<script>
  const slides = document.querySelectorAll('.slider img');
  if (slides.length > 0) {
    let current = 0;
    setInterval(() => {
      slides[current].classList.remove('active');
      current = (current + 1) % slides.length;
      slides[current].classList.add('active');
    }, 4000);
  }
</script>
