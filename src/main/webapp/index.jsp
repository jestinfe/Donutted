<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:import url="common/header.jsp" />
  <!-- 메인 영역 시작 -->
  <main>
  
<!-- 배너 영역 -->
<div class="slider">
  <img src="<c:url value='/common/images/slider_1.png'/>" class="active" alt="배너1">
  <img src="<c:url value='/common/images/slider_2.png'/>" alt="배너2">
  <img src="<c:url value='/common/images/slider_3.png'/>" alt="배너3">
  <img src="<c:url value='/common/images/slider_4.png'/>" alt="배너4">
  <img src="<c:url value='/common/images/slider_5.png'/>" alt="배너5">
  <img src="<c:url value='/common/images/slider_6.png'/>" alt="배너6">
  <img src="<c:url value='/common/images/slider_7.png'/>" alt="배너7">
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
    html, body {
      height: 100%;
      margin: 0;
      padding: 0;
      display: flex;
      flex-direction: column;
    }
    main {
      flex: 1;
    }
    
   .slider {
    position: relative;
    width: 100%;
    height: 780px !important;
    overflow: hidden;
    box-shadow: 0px 0px 30px rgb(0, 0, 0, 0.3);
  }

  .slider img {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: auto; !important;
    object-fit: cover;
    opacity: 0;
    transition: transform 1s ease-in-out; /*화면비율*/
  }

  .slider img.active {
    opacity: 1;
    z-index: 1;
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

#instagram_section {
  margin-top: 80px;
  margin-bottom: 80px !important; /* 중요도 높임 */
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
      <img src="<c:url value='/common/images/insta_1.png'/>" alt="insta1">
      <img src="<c:url value='/common/images/insta_2.png'/>" alt="insta2">
      <img src="<c:url value='/common/images/insta_3.png'/>" alt="insta3">
      <img src="<c:url value='/common/images/insta_4.png'/>" alt="insta4">
      <img src="<c:url value='/common/images/insta_5.png'/>" alt="insta5">
      <img src="<c:url value='/common/images/insta_6.png'/>" alt="insta6">
      <img src="<c:url value='/common/images/insta_7.png'/>" alt="insta7">
      <img src="<c:url value='/common/images/insta_8.png'/>" alt="insta8">
      <img src="<c:url value='/common/images/insta_9.png'/>" alt="insta9">
      <img src="<c:url value='/common/images/insta_10.png'/>" alt="insta10">
      <img src="<c:url value='/common/images/insta_11.png'/>" alt="insta11">
      <!-- 반복 효과 위해 이미지 한번 더 -->
      <img src="<c:url value='/common/images/insta_1.png'/>" alt="insta1-dup">
      <img src="<c:url value='/common/images/insta_2.png'/>" alt="insta2-dup">
      <img src="<c:url value='/common/images/insta_3.png'/>" alt="insta3-dup">
      <img src="<c:url value='/common/images/insta_4.png'/>" alt="insta4-dup">
      <img src="<c:url value='/common/images/insta_5.png'/>" alt="insta5-dup">
      <img src="<c:url value='/common/images/insta_6.png'/>" alt="insta6-dup">
      <img src="<c:url value='/common/images/insta_7.png'/>" alt="insta7-dup">
      <img src="<c:url value='/common/images/insta_8.png'/>" alt="insta8-dup">
      <img src="<c:url value='/common/images/insta_9.png'/>" alt="insta9-dup">
      <img src="<c:url value='/common/images/insta_10.png'/>" alt="insta10-dup">
      <img src="<c:url value='/common/images/insta_11.png'/>" alt="insta11-dup">
    </div>
  </div>
</section>

  </main>
  <!-- 메인 영역 끝 -->

<c:import url="common/footer.jsp" />
