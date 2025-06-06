<%@ page contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<style>
 * { margin:0; padding:0; box-sizing:border-box; }
  /* body 스타일에서 margin 관련 속성을 제거하거나 0으로 명시 */
  body { 
    font-family:'Pretendard',sans-serif; 
    background:#fff; 
    color:#212121; 
    margin: 0; /* 이 줄을 추가하여 혹시 모를 기본 마진 재설정을 막음 */
    padding: 0; /* 이 줄을 추가하여 혹시 모를 기본 패딩 재설정을 막음 */
  }
  a { text-decoration:none; color:inherit; }
  ul { list-style:none; }
  .container { width:100%; max-width:1280px; margin:0 auto; padding:0 20px; }
  #doz_header_wrap { background:#fff; border-bottom:1px solid #e7e7e7; position:sticky; top:0; z-index:1000; }

  header {
    background: #fff;
    border-bottom: 1px solid #eee;
    z-index: 1000;
    position: relative;
  }

  .header-wrapper {
    max-width: 1280px;
    margin: 0 auto;
    padding: 0 40px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 100px;
    gap: 40px;
    position: relative;
    z-index: 1001;
  }

  .logo {
    display: flex;
    align-items: center;
  }

  .logo img {
    height: 98px;
    max-height: 98px;
  }

  .nav {
    flex: 1;
    display: flex;
    justify-content: center;
  }

  .nav ul {
    display: flex;
    gap: 36px;
    align-items: center;
  }

  .nav li {
    position: relative;
  }

  .nav a {
    font-size: 18px;
    font-weight: 700;
    color: #212121;
  }

  .nav li ul {
    display: none;
    position: absolute;
    top: 100%;
    left: 0;
    background: white;
    padding: 10px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    border-radius: 4px;
    list-style: none;
    z-index: 1002;
  }

  .nav li:hover ul {
    display: block;
  }

  .user-menu {
    display: flex;
    align-items: center;
    gap: 14px;
    font-size: 14px;
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
</style>

<header>
  <div class="header-wrapper">
    <div class="logo">
      <a href="http://localhost/mall_prj/index.jsp">
        <img src="http://localhost/mall_prj/admin/common/images/core/logo.png" alt="Logo">
      </a>
    </div>

    <nav class="nav">
      <ul>
        <li>
          <a href="<c:url value='/brand/brand.jsp?section=about'/>">BRAND</a>
          <ul>
            <li><a href="<c:url value='/brand/brand.jsp?section=about'/>">About</a></li>
            <li><a href="<c:url value='/brand/brand.jsp?section=location'/>">Location</a></li>
          </ul>
        </li>
        <li><a href="<c:url value='/product/menu.jsp'/>">MENU</a></li>
        <li>
          <a href="<c:url value='/news/news_event_main.jsp'/>">NEWS</a>
          <ul>
            <li><a href="<c:url value='/news/news_event_main.jsp'/>">Event</a></li>
            <li><a href="<c:url value='/news/news_notice_main.jsp'/>">Notice</a></li>
          </ul>
        </li>
        <li><a href="<c:url value='/help/help.jsp'/>">HELP</a></li>
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
</header>