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
  left: 0;
  width: 240px;
  background-color: #f9f9f9;
  padding: 20px;
  border-right: 1px solid #eee;
  box-shadow: 2px 0 6px rgba(0, 0, 0, 0.05);
  z-index: 1000;
}

.mypage-sidebar-fixed h4 {
  font-size: 18px;
  font-weight: bold;
  color: #fff;
  background-color: #ef84a5;
  padding: 12px;
  text-align: center;
  border-radius: 10px;
  margin-bottom: 20px;
}

.mypage-sidebar-fixed ul {
  list-style: none;
  padding-left: 0;
  margin: 0;
}

.mypage-sidebar-fixed li {
  background: #f4f4f4;
  margin-bottom: 10px;
  padding: 12px 16px;
  font-size: 15px;
  font-weight: 500;
  border-radius: 8px;
  transition: background-color 0.2s;
  word-break: keep-all;
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
  padding-left: 10px;
  margin-top: 8px;
}

.submenu li {
  background: #fdf0f4;
  font-weight: normal;
  font-size: 14px;
  margin-bottom: 6px;
  padding: 8px 12px;
  border-radius: 6px;
  transition: background-color 0.2s;
  color: #222;
}

.submenu li:hover {
  background-color: #ffdce7;
  color: #000;
}

.submenu li.active {
  background-color: #ef84a5;
  color: #fff;
}

.submenu li.active a {
  color: #fff;
}

.submenu a {
  padding: 0;
  color: #222;
  font-weight: 400;
}

.submenu a:hover {
  text-decoration: underline;
}
</style>
