<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

  <style>
    .tms-footer {
  background: #fff0f5;
  padding: 30px 16px 20px; /* 기존보다 전체적으로 축소 */
  font-family: 'Pretendard', sans-serif;
}


.tms-footer-inner {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  max-width: 1280px;
  margin: 0 auto;
  gap: 16px; /* gap 줄임 */
}

.tms-footer h3 {
  font-size: 14px; /* 좀 더 콤팩트하게 */
  margin-bottom: 8px;
  font-weight: bold;
}

.tms-footer ul li {
  font-size: 12px; 
  margin-bottom: 4px;
}

.tms-footer-bottom {
  margin-top: 20px;
  font-size: 11px;
}


  </style>


<footer class="tms-footer">
  <div class="tms-footer-inner">
    <div>
      <h3>COMPANY INFORMATION</h3>
      <ul>
        <li>주식회사 더블드래곤</li>
        <li>서울특별시 강남구 역삼동 테헤란로 132 한독약품빌딩 8층</li>
        <li>사업자등록번호 : 248-81-00620</li>
        <li>통신판매업신고번호 : 2020-서울강남-02297</li>
        <li>대표이사 : 박선은</li>
      </ul>
    </div>
    <div>
      <h3>donutted America Inc.</h3>
      <ul>
        <li>#104 &amp; #105 1411 W Sunset Blvd</li>
        <li>Los Angeles, CA 90026, USA</li>
        <li>+1-213-316-6296</li>
      </ul>
      
    </div>
    <div>
      <h3>SOCIAL</h3>
      <ul>
        <li><a href="https://www.instagram.com/cafeknotted_kr/">Instagram</a></li>
        <li><a href="https://pf.kakao.com/_AUDFj">Kakaotalk Channel</a></li>
      </ul>
      <h3 style="margin-top: 24px;">HELP</h3>
      <ul>
        <li>고객센터: 1800-6067</li>
        <li>운영시간: 평일 9시~12시 / 13시~17시</li>
      </ul>
    </div>
  </div>
  <div class="tms-footer-bottom">
    <a href="#">이용약관</a>
    <a href="#">개인정보처리방침</a>
    <span>Copyright © 2023 Donutted. All Rights Reserved.</span>
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


