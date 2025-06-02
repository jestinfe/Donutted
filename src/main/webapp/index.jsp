<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:import url="common/header.jsp" />

<!-- 배너 영역 -->
<div class="slider">
  <img src="<c:url value='/common/images/main.jpg'/>" class="active" alt="배너1">
  <img src="<c:url value='/common/images/logo.png'/>" alt="배너2">
</div>

<script>
  let currentIndex = 0;
  const banners = document.querySelectorAll(".slider img");

  setInterval(() => {
    banners[currentIndex].classList.remove("active");
    currentIndex = (currentIndex + 1) % banners.length;
    banners[currentIndex].classList.add("active");
  }, 3500);
</script>


<!-- 카테고리 -->
<!-- <div class="category-menu container">
  <a href="#"><img src="https://cdn.imweb.me/upload/S2023090509034a75f0994/f6e09b64aaae6.png"><span>시그니처</span></a>
  <a href="#"><img src="https://cdn.imweb.me/upload/S2023090509034a75f0994/1cfc1d4b899aa.png"><span>크림도넛</span></a>
  <a href="#"><img src="https://cdn.imweb.me/upload/S2023090509034a75f0994/07f89bc734c25.png"><span>굿즈</span></a>
  <a href="#"><img src="https://cdn.imweb.me/upload/S2023090509034a75f0994/f7ecb255b5883.png"><span>음료</span></a>
</div> -->

<!-- 갤러리 -->
<!-- <main>
  <section id="gallery_section">
    <div class="container">
      <div class="gallery_row">
        <div class="item_gallary">
          <div class="item_container">
            <div class="img_wrap" style="background-image:url('https://cdn.imweb.me/upload/S2023090509034a75f0994/965ed88071abd.png');"></div>
            <div class="text_wrap">
              <div class="title">시그니처 도넛</div>
              <div class="body">달콤한 맛의 부드러운 디저트</div>
            </div>
          </div>
        </div>
        <div class="item_gallary">
          <div class="item_container">
            <div class="img_wrap" style="background-image:url('https://cdn.imweb.me/upload/S2023090509034a75f0994/f3d54ad34c71b.png');"></div>
            <div class="text_wrap">
              <div class="title">굿즈 &amp; 머그컵</div>
              <div class="body">귀엽고 실용적인 디자인 상품</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</main> -->

<c:import url="common/footer.jsp" />
