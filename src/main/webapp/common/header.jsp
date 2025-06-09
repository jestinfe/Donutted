<%@ page contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

  <link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<style>
  * { margin:0; padding:0; box-sizing:border-box; }
  body { 
    font-family:'Pretendard',sans-serif; 
    background:#fff; 
    color:#212121; 
    margin: 0;
    padding: 0;
  }
  a { text-decoration:none; color:inherit; }
  ul { list-style:none; }
  .container { width:100%; max-width:1280px; margin:0 auto; padding:0 20px; }

  header {
    background: #fff;
    border-bottom: 1px solid #e0e0e0;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    z-index: 1000;
    position: sticky;
    top: 0;
  }

  .header-wrapper {
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 30px;
    display: flex;
    align-items: center;
    height: 80px;
    position: relative;
    z-index: 1001;
  }

  .logo {
    display: flex;
    align-items: center;
    flex-shrink: 0;
  }

  .logo img {
    height: 60px;
    max-height: 60px;
    width: auto;
  }

  .nav {
    display: flex;
    justify-content: center;
    align-items: center;
    flex: 1;
    margin: 0 60px;
    padding-top: 15px
  }

  .nav ul {
    display: flex;
    gap: 80px;
    align-items: center;
    justify-content: center;
  }

  .nav li {
    position: relative;
  }

  .nav > ul > li > a {
    font-size: 16px;
    font-weight: 600;
    color: #333;
    padding: 10px 0;
    transition: color 0.3s ease;
    position: relative;
    display: block;
  }

  .nav > ul > li > a:hover {
    color: #EF84A5;
  }

  .nav > ul > li > a::after {
    content: '';
    position: absolute;
    width: 0;
    height: 2px;
    bottom: -5px;
    left: 50%;
    background-color: #EF84A5;
    transition: all 0.3s ease;
    transform: translateX(-50%);
  }

  .nav > ul > li > a:hover::after {
    width: 100%;
  }

  /* 드롭다운 메뉴 스타일 */
  .dropdown-overlay {
    position: fixed;
    top: 80px;
    left: 0;
    right: 0;
    width: 100%;
    background: rgba(255,255,255,0.98);
    backdrop-filter: blur(10px);
    border-bottom: 1px solid #e0e0e0;
    box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    z-index: 999;
    opacity: 0;
    visibility: hidden;
    transform: translateY(-10px);
    transition: all 0.3s ease;
  }

  .dropdown-overlay.active {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
  }

  .dropdown-content {
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px 0;
    display: flex;
    justify-content: center;
    align-items: flex-start;
    gap: 5px;
    transform: translateX(-60px);
  }

  .dropdown-section {
    min-width: 120px;
    text-align: center;
  }

  .dropdown-section h3 {
    display: none;
  }

  .dropdown-section ul {
    display: flex;
    flex-direction: column;
    gap: 12px;
    margin-top: 0;
    text-align: center;
  }

  .dropdown-section li a {
    font-size: 15px;
    color: #666;
    padding: 8px 12px;
    transition: all 0.3s ease;
    display: block;
    border-radius: 6px;
    white-space: nowrap;
  }

  .dropdown-section li a:hover {
    color: #EF84A5;
    background: #f8f9fa;
    transform: translateX(2px);
  }

  .user-menu {
    display: flex;
    align-items: center;
    gap: 15px;
    font-size: 14px;
    flex-shrink: 0;
  }

  .user-menu a {
    color: #666;
    font-weight: 500;
    padding: 8px 12px;
    border-radius: 20px;
    transition: all 0.3s ease;
    white-space: nowrap;
  }

  .user-menu a:hover {
    background: #f8f9fa;
    color: #EF84A5;
  }

  .slider {
    position: relative;
    width: 100%;
    overflow: hidden;
    margin-top: 0;
    z-index: 1;
  }

  .slider img {
    width: 100%;
    height: auto;
    display: none;
    position: static;
  }

  .slider img.active {
    display: block;
  }

  /* 반응형 */
  @media (max-width: 1200px) {
    .nav ul {
      gap: 60px;
    }
    
    .dropdown-content {
      gap: 5px;
    }
    
    .nav {
      margin: 0 40px;
    }
  }

  @media (max-width: 1024px) {
    .header-wrapper {
      padding: 0 20px;
    }
    
    .nav {
      margin: 0 30px;
    }
    
    .nav ul {
      gap: 40px;
    }
    
    .dropdown-content {
      padding: 20px 0;
      gap: 5px;
    }
  }

  @media (max-width: 768px) {
    .header-wrapper {
      height: 70px;
    }
    
    .logo img {
      height: 50px;
    }
    
    .nav {
      margin: 0 20px;
    }
    
    .nav ul {
      gap: 25px;
    }
    
    .nav > ul > li > a {
      font-size: 14px;
    }
    
    .dropdown-content {
      gap: 0px;
    }
    
    .user-menu {
      gap: 10px;
    }
    
    .user-menu a {
      font-size: 12px;
      padding: 6px 8px;
    }
  }

  @media (max-width: 640px) {
    .header-wrapper {
      padding: 0 15px;
    }
    
    .nav {
      margin: 0 15px;
    }
    
    .nav ul {
      gap: 20px;
    }
    
    .dropdown-content {
      gap: 0px;
      padding: 15px;
    }
    
    .dropdown-section {
      min-width: 80px;
    }
    
    .user-menu {
      gap: 8px;
    }
    
    .user-menu a {
      font-size: 11px;
      padding: 5px 8px;
    }
  }

  @media (max-width: 480px) {
    .nav ul {
      gap: 15px;
    }
    
    .nav > ul > li > a {
      font-size: 13px;
    }
    
    .user-menu a {
      font-size: 10px;
      padding: 4px 6px;
    }
  }
</style>

<header>
  <div class="header-wrapper">
    <div class="logo">
      <a href="http://localhost/mall_prj/index.jsp">
        <img src="http://localhost/mall_prj/admin/common/images/core/logo.png" style="display:block; background:transparent;"  alt="Logo">
      </a>
    </div>

    <nav class="nav">
      <ul>
        <li>
          <a href="<c:url value='/brand/brand.jsp?section=about'/>">BRAND</a>
        </li>
        <li>
          <a href="<c:url value='/product/menu.jsp'/>">MENU</a>
        </li>
        <li>
          <a href="<c:url value='/news/news_event_main.jsp'/>">NEWS</a>
        </li>
        <li>
          <a href="<c:url value='/help/help.jsp'/>">HELP</a>
        </li>
      </ul>
    </nav>

    <div class="user-menu">
      <a href="<c:url value='${empty sessionScope.loginId ? "/UserLogin/login.jsp" : "/mypage_order/my_orders.jsp"}'/>">마이페이지</a>
      <a href="<c:url value='${empty sessionScope.loginId ? "/UserLogin/login.jsp" : "/cart/cart.jsp"}'/>">장바구니</a>
      <a href="<c:url value='${empty sessionScope.loginId ? "/UserLogin/login.jsp" : "/wishlist/wishlist.jsp"}'/>">찜</a>
      <c:choose>
        <c:when test="${empty sessionScope.loginId}">
          <a href="<c:url value='/UserLogin/login.jsp'/>">Login</a>
        </c:when>
        <c:otherwise>
          <a href="<c:url value='/UserLogin/logout.jsp'/>">Logout</a>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <!-- 통합 드롭다운 오버레이 -->
  <div class="dropdown-overlay" id="dropdownOverlay">
    <div class="dropdown-content">
      <div class="dropdown-section">
        <ul>
          <li><a href="<c:url value='/brand/brand.jsp?section=about'/>">About</a></li>
          <li><a href="<c:url value='/brand/brand.jsp?section=location'/>">Location</a></li>
        </ul>
      </div>
      <div class="dropdown-section">
        <ul>
          <li><a href="<c:url value='/product/menu.jsp'/>">All Menu</a></li>
        </ul>
      </div>
      <div class="dropdown-section">
        <ul>
          <li><a href="<c:url value='/news/news_event_main.jsp'/>">Event</a></li>
          <li><a href="<c:url value='/news/news_notice_main.jsp'/>">Notice</a></li>
        </ul>
      </div>
      <div class="dropdown-section">
        <ul>
          <li><a href="<c:url value='/help/help.jsp'/>">FAQ</a></li>
        </ul>
      </div>
    </div>
  </div>
</header>

<script>
document.addEventListener('DOMContentLoaded', function() {
  const nav = document.querySelector('.nav');
  const dropdownOverlay = document.getElementById('dropdownOverlay');
  let hoverTimeout;

  // 네비게이션 영역에 마우스가 들어왔을 때
  nav.addEventListener('mouseenter', function() {
    clearTimeout(hoverTimeout);
    dropdownOverlay.classList.add('active');
  });

  // 네비게이션 영역에서 마우스가 나갔을 때
  nav.addEventListener('mouseleave', function() {
    hoverTimeout = setTimeout(() => {
      dropdownOverlay.classList.remove('active');
    }, 100);
  });

  // 드롭다운 오버레이에 마우스가 들어왔을 때
  dropdownOverlay.addEventListener('mouseenter', function() {
    clearTimeout(hoverTimeout);
    dropdownOverlay.classList.add('active');
  });

  // 드롭다운 오버레이에서 마우스가 나갔을 때
  dropdownOverlay.addEventListener('mouseleave', function() {
    dropdownOverlay.classList.remove('active');
  });
});
</script>