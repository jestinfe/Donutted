<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<style>

  .submenu {
    display: none;
    padding-left: 15px;
    background-color: #2a2a2a;
  }
  .submenu a {
    font-size: 14px;
    color: #bbb;
    display: block;
    padding: 8px 20px;
    text-decoration: none;
  }
  .submenu a:hover {
    color: #fff;
  }
</style>

<script>
  function toggleSubMenu(id) {
    const sub = document.getElementById(id);
    sub.style.display = (sub.style.display === "block") ? "none" : "block";
  }
</script>

<div class="sidebar">
  <a href="../dashboard/dashboard.jsp">대시보드</a>
  <a href="../member/member.jsp">회원 관리</a>

  <a href="#" onclick="toggleSubMenu('productSubmenu')">상품 관리 ▼</a>
  <div class="submenu" id="productSubmenu">
    <a href="../product/product_add.jsp">- 상품 등록</a>
    <a href="../product/product_list.jsp">- 상품 목록</a>
  </div>

  <a href="#" onclick="toggleSubMenu('orderSubmenu')">주문 관리 ▼</a>
  <div class="submenu" id="orderSubmenu">
    <a href="../order/order_list.jsp">- 주문 목록</a>
    <a href="../refund/refund_list.jsp">- 환불 내역</a>
  </div>

  <a href="#" onclick="toggleSubMenu('reviewSubmenu')">리뷰 관리 ▼</a>
  <div class="submenu" id="reviewSubmenu">
    <a href="../review/review_list.jsp">- 리뷰 목록</a>
  </div>

  <a href="#" onclick="toggleSubMenu('qnaSubmenu')">문의 관리 ▼</a>
  <div class="submenu" id="qnaSubmenu">
    <a href="../qna/qna_list.jsp">- 1:1 문의</a>
    <a href="../faq/faq_list.jsp">- FAQ</a>
  </div>

  <a href="#" onclick="toggleSubMenu('boardSubmenu')">게시판 관리 ▼</a>
<div class="submenu" id="boardSubmenu">
  <a href="../news/news_notice_list.jsp">- 공지사항 목록</a>
  <a href="../news/news_event_list.jsp">- 이벤트 목록</a>
</div>


  <a href="../login/admin_logout.jsp">로그아웃</a>
</div>
