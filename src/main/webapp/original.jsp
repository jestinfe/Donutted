<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>노티드샵</title>
  <link href="https://fonts.googleapis.com/css2?family=Pretendard&display=swap" rel="stylesheet">
  <style>
    * { margin:0; padding:0; box-sizing:border-box; }
    body { font-family:'Pretendard',sans-serif; background:#fff; color:#212121; }
    a { text-decoration:none; color:inherit; }
    ul { list-style:none; }
    .container { width:100%; max-width:1280px; margin:0 auto; padding:0 20px; }

    #doz_header_wrap { background:#fff; border-bottom:1px solid #e7e7e7; position:sticky; top:0; z-index:1000; }
    .inline-inside { display:flex; align-items:center; justify-content:space-between; height:90px; }
    .logo img { height:40px; }
    ._inline_menu_container { display:flex; gap:32px; align-items:center; }
    ._inline_menu_container li a {
      font-size:16px; font-weight:500; color:#212121; height:90px;
      display:flex; align-items:center; padding:0 4px; position:relative;
    }
    ._inline_menu_container li a:hover,
    ._inline_menu_container li.active a { color:#ffa2cb; }

    /* 슬라이더 */
    .slider { width:100%; height:480px; overflow:hidden; position:relative; margin-top:20px; }
    .slider img { width:100%; height:100%; object-fit:cover; position:absolute; top:0; left:0; opacity:0; transition:opacity 0.8s ease-in-out; }
    .slider img.active { opacity:1; z-index:1; }

    /* 메뉴 카테고리 */
    .category-menu { display:flex; justify-content:center; flex-wrap:wrap; gap:20px; padding:60px 0; background:#fffefc; }
    .category-menu a {
      display:flex; flex-direction:column; align-items:center;
      width:120px; padding:20px; background:#fff; border-radius:12px;
      box-shadow:0 4px 10px rgba(0,0,0,0.05); text-align:center; transition:transform 0.2s;
    }
    .category-menu a:hover { transform:translateY(-5px); }
    .category-menu img { width:60px; height:60px; margin-bottom:10px; }
    .category-menu span { font-size:14px; font-weight:500; }

    #gallery_section { padding:120px 0 56px; background:#fff; }
    .gallery_row { display:flex; flex-wrap:wrap; gap:40px; justify-content:center; }
    .item_gallary { flex:0 0 calc(50% - 20px); max-width:calc(50% - 20px); }
    .item_container { background:#f9f9f9; border-radius:10px; overflow:hidden; transition:transform .2s; }
    .item_container:hover { transform:translateY(-5px); box-shadow:0 4px 12px rgba(0,0,0,0.08); }
    .img_wrap { height:250px; background-size:cover; background-position:center; }
    .text_wrap { padding:24px 20px; text-align:center; }
    .title { font-size:20px; font-weight:700; margin-bottom:8px; }
    .body { font-size:16px; color:#ffa2cb; }

    .tms-footer { position:relative; background:#fff0f5; overflow:hidden; }
    .tms-footer-bg1 svg { width:100%; height:auto; display:block; position:absolute; top:0; left:0; z-index:0; }
    .tms-footer-inner { position:relative; padding:100px 20px 60px; display:flex; justify-content:space-between; flex-wrap:wrap; gap:40px; z-index:1; max-width:1280px; margin:0 auto; }
    .tms-footer h3 { font-size:18px; margin-bottom:16px; font-weight:bold; }
    .tms-footer ul { padding:0; margin:0; }
    .tms-footer ul li { margin-bottom:8px; font-size:14px; color:#333; }
    .tms-footer-bottom { display:flex; justify-content:center; flex-wrap:wrap; gap:24px; padding:24px 0 40px; font-size:13px; color:#555; }
    .tms-footer-bottom a { color:inherit; }
  </style>
</head>
<body>

<header class="tms-header" style="background: #fff; border-bottom: 1px solid #eee; height: 90px;">
  <div class="container" style="max-width: 1280px; margin: 0 auto; display: flex; align-items: center; justify-content: space-between; height: 100%; padding: 0 20px;">
    
    <!-- 로고 -->
    <a href="/" class="tms-header-logo">
      <img src="https://cdn.imweb.me/upload/S2023090509034a75f0994/965ed88071abd.png" style="height: 40px;" alt="Knotted 로고">
    </a>
    
    <!-- 메뉴 -->
    <nav>
      <ul style="list-style: none; display: flex; gap: 32px; margin: 0; padding: 0;">
        <li><a href="/brand" style="font-size: 16px; color: #212121;">BRAND</a></li>
        <li><a href="/menu" style="font-size: 16px; color: #212121;">MENU</a></li>
        <li><a href="/news" style="font-size: 16px; color: #212121;">NEWS</a></li>
        <li><a href="/help" style="font-size: 16px; color: #212121;">HELP</a></li>
      </ul>
    </nav>

    <!-- 로그인/장바구니 -->
    <div style="display: flex; gap: 16px;">
      <a href="/my_page" style="font-size: 14px; color: #212121;">마이페이지</a>
      <a href="/cart" style="font-size: 14px; color: #212121;">장바구니</a>
      <a href="/wishlist" style="font-size: 14px; color: #212121;">찜</a>
      <a href="#" onclick="SITE_MEMBER.openLogin()" style="font-size: 14px; color: #212121;">Login</a>
    </div>

  </div>
</header>

<!-- 슬라이더 -->
<div class="slider">
  <img src="https://cdn.imweb.me/upload/S2023090509034a75f0994/53178cfef3c30.png" class="active" alt="메인 배너1">
  <img src="https://cdn.imweb.me/upload/S2023090509034a75f0994/42bdcbffb35a7.png" alt="메인 배너2">
</div>

<!-- 카테고리 메뉴 -->
<div class="category-menu container">
  <a href="#"><img src="https://cdn.imweb.me/upload/S2023090509034a75f0994/f6e09b64aaae6.png"><span>시그니처</span></a>
  <a href="#"><img src="https://cdn.imweb.me/upload/S2023090509034a75f0994/1cfc1d4b899aa.png"><span>크림도넛</span></a>
  <a href="#"><img src="https://cdn.imweb.me/upload/S2023090509034a75f0994/07f89bc734c25.png"><span>굿즈</span></a>
  <a href="#"><img src="https://cdn.imweb.me/upload/S2023090509034a75f0994/f7ecb255b5883.png"><span>음료</span></a>
</div>

<main>
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
</main>

<footer class="tms-footer" style="background: #fff0f5; padding: 80px 20px 40px;">
  <div class="tms-footer-inner" style="max-width: 1280px; margin: 0 auto; display: flex; justify-content: space-between; flex-wrap: wrap; gap: 40px;">

    <!-- 회사 정보 -->
    <div>
      <h3>COMPANY INFORMATION</h3>
      <ul style="list-style: none; padding: 0;">
        <li>주식회사 지에프에프지</li>
        <li>서울특별시 강남구 도산대로 326</li>
        <li>사업자등록번호 : 248-81-00620</li>
        <li>통신판매업신고번호 : 2020-서울강남-02297</li>
        <li>대표이사 : 이준범</li>
      </ul>
    </div>

    <!-- 해외 지점 -->
    <div>
      <h3>Knotted America Inc.</h3>
      <ul style="list-style: none; padding: 0;">
        <li>#104 &amp; #105 1411 W Sunset Blvd</li>
        <li>Los Angeles, CA 90026, USA</li>
        <li>+1-213-316-6296</li>
      </ul>
    </div>

    <!-- 소셜 + 고객센터 -->
    <div>
      <h3>SOCIAL</h3>
      <ul style="list-style: none; padding: 0;">
        <li><a href="https://www.instagram.com/cafeknotted_kr/">Instagram</a></li>
        <li><a href="https://pf.kakao.com/_AUDFj">Kakaotalk Channel</a></li>
      </ul>
      <h3 style="margin-top: 24px;">HELP</h3>
      <ul style="list-style: none; padding: 0;">
        <li>고객센터: 1800-6067</li>
        <li>운영시간: 평일 9시~12시 / 13시~17시</li>
      </ul>
    </div>
  </div>

  <!-- 하단 바 -->
  <div class="tms-footer-bottom" style="text-align: center; margin-top: 40px; font-size: 13px; color: #555;">
    <a href="#" style="margin-right: 20px;">이용약관</a>
    <a href="#" style="margin-right: 20px;">개인정보처리방침</a>
    <span>Copyright © 2023 Knotted. All Rights Reserved.</span>
  </div>
</footer>


<script>
  // 슬라이더 자동 전환
  const slides = document.querySelectorAll('.slider img');
  let current = 0;

  setInterval(() => {
    slides[current].classList.remove('active');
    current = (current + 1) % slides.length;
    slides[current].classList.add('active');
  }, 4000);
</script>

</body>
</html>
