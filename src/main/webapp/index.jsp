<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:import url="common/header.jsp" />

<!-- 배너 영역 -->
<div class="slider">
  <img src="<c:url value='/common/images/main.jpg'/>" class="active" alt="배너1">
  <img src="<c:url value='/common/images/main2.png'/>" alt="배너2">
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

<style>
  .slider img {
    display: none;
    width: 100%;
    height: auto;
  }

  .slider img.active {
    display: block;
  }

  /* Instagram 슬라이더 스타일 */
  .instagram-slider-container {
    overflow: hidden;
    width: 100%;
    position: relative;
    margin-top: 50px;
  }

  .instagram-slider {
    display: flex;
    width: calc(200px * 20); /* 넉넉하게 반복 효과 위해 10장 x 2 */
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
</style>


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

<!-- Instagram 영역 -->
<section id="instagram_section">
  <h3 style="text-align:center; margin-bottom:20px;">Instagram</h3>
  
  <div class="instagram-slider-container">
    <div class="instagram-slider">
      <img src="<c:url value='/common/images/insta1.jpg'/>" alt="insta1">
      <img src="<c:url value='/common/images/insta2.jpg'/>" alt="insta2">
      <img src="<c:url value='/common/images/insta3.jpg'/>" alt="insta3">
      <img src="<c:url value='/common/images/insta4.jpg'/>" alt="insta4">
      <img src="<c:url value='/common/images/insta5.jpg'/>" alt="insta5">
      <img src="<c:url value='/common/images/insta6.jpg'/>" alt="insta6">
      <img src="<c:url value='/common/images/insta7.jpg'/>" alt="insta7">
      <img src="<c:url value='/common/images/insta8.jpg'/>" alt="insta8">
      <img src="<c:url value='/common/images/insta9.jpg'/>" alt="insta9">
      <img src="<c:url value='/common/images/insta10.jpg'/>" alt="insta10">
      <!-- 반복 효과 위해 이미지 한번 더 -->
      <img src="<c:url value='/common/images/insta1.jpg'/>" alt="insta1-dup">
      <img src="<c:url value='/common/images/insta2.jpg'/>" alt="insta2-dup">
      <img src="<c:url value='/common/images/insta3.jpg'/>" alt="insta3-dup">
      <img src="<c:url value='/common/images/insta4.jpg'/>" alt="insta4-dup">
      <img src="<c:url value='/common/images/insta5.jpg'/>" alt="insta5-dup">
      <img src="<c:url value='/common/images/insta6.jpg'/>" alt="insta6-dup">
      <img src="<c:url value='/common/images/insta7.jpg'/>" alt="insta7-dup">
      <img src="<c:url value='/common/images/insta8.jpg'/>" alt="insta8-dup">
      <img src="<c:url value='/common/images/insta9.jpg'/>" alt="insta9-dup">
      <img src="<c:url value='/common/images/insta10.jpg'/>" alt="insta10-dup">
    </div>
  </div>
</section>

<c:import url="common/footer.jsp" />
