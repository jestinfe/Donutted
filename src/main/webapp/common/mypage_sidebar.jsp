<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String uri = request.getRequestURI();
  String path = uri.substring(uri.lastIndexOf("/") + 1);
%>

<div class="mypage-sidebar-fixed">
  <h4>My Page</h4>
  <ul>
    <li>
      <a href="../mypage_order/my_orders.jsp">My 쇼핑</a>
      <ul class="submenu">
        <li class='<%= path.equals("my_orders.jsp") ? "active" : "" %>'>
          <a href="../mypage_order/my_orders.jsp">주문목록/배송조회</a>
        </li>
        <li class='<%= path.equals("my_refunds.jsp") ? "active" : "" %>'>
          <a href="../mypage_refund/my_refunds.jsp">환불 내역</a>
        </li>
      </ul>
    </li>
    <li>
      <a href="../mypage_inquiry/my_inquiry.jsp">My 활동</a>
      <ul class="submenu">
        <li class='<%= path.equals("my_inquiry.jsp") ? "active" : "" %>'>
          <a href="../mypage_inquiry/my_inquiry.jsp">문의하기</a>
        </li>
        <li class='<%= path.equals("my_reviews.jsp") ? "active" : "" %>'>
          <a href="../mypage_review/my_reviews.jsp">리뷰관리</a>
        </li>
      </ul>
    </li>
    <li>
      <a href="../mypage_info/my_page.jsp">My 정보</a>
      <ul class="submenu">
        <li class='<%= path.equals("my_page.jsp") ? "active" : "" %>'>
          <a href="../mypage_info/my_page.jsp">내 정보 조회</a>
        </li>
        <li class='<%= path.equals("withdraw.jsp") ? "active" : "" %>'>
          <a href="../mypage_info/withdraw.jsp">회원 탈퇴</a>
        </li>
      </ul>
    </li>
  </ul>
</div>


<style>
.mypage-sidebar-fixed {
  position: fixed;
  top: 120px;
  left: 20px; /* 살짝 띄움 */
  width: 240px;
  background-color: #fff;
  padding: 20px;
  border-right: 1px solid #eee;
  box-shadow: 2px 0 6px rgba(0, 0, 0, 0.05);
  z-index: 1000;
  border-radius: 16px;
}

.mypage-sidebar-fixed h4 {
  font-size: 20px;
  font-weight: bold;
  color: #2d3748;
  text-align: center;
  padding-bottom: 10px;
  margin-bottom: 20px;
   border-bottom: 1px solid #f5b5c5; /* 구분선 연핑크 */
}

.mypage-sidebar-fixed ul {
  list-style: none;
  padding-left: 0;
  margin: 0;
}

.mypage-sidebar-fixed > ul > li > a {
  font-size: 12px;
  font-weight: 700;
  color: #000000;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  padding: 8px 0;
  margin: 16px 0 8px 0;
  display: block;
  border-bottom: 1px solid #f8dbe5;
  background: none;
  cursor: default;
  pointer-events: none;
}

.mypage-sidebar-fixed li {
  background: #fdf5f8;
  margin-bottom: 8px;
  padding: 10px 14px;
  font-size: 14px;
  font-weight: 500;
  border-radius: 8px;
  transition: background-color 0.2s;
  color: #4a4a4a;
}

.mypage-sidebar-fixed li:hover {
  background-color: #ffe4ed;
  color: #222;
}

.mypage-sidebar-fixed a {
  display: block;
  color: inherit;
  text-decoration: none;
}

.submenu {
  padding-left: 0;
  margin: 10px 0 20px 0;
}

.submenu li {
  background: #fff0f5;
  font-weight: normal;
  font-size: 14px;
  margin-bottom: 6px;
  padding: 10px 14px;
  border-radius: 10px;
  transition: background-color 0.2s;
  color: #222;
}

.submenu li:hover {
  background-color: #fcd6df;
  color: #000;
}

.submenu li.active {
  background-color: #f9a8c2;
  color: #fff;
  box-shadow: 0 4px 12px rgba(244, 114, 182, 0.4);
}

.submenu li.active a {
  color: #fff;
}

.submenu a {
  padding: 0;
  color: inherit;
  font-weight: 400;
}


</style>
