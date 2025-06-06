<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""%>

<style>
  .topbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #fff;
  padding: 10px 20px;
  border-bottom: 1px solid #ccc;

  /* 추가 */
  position: sticky;
  top: 0;
  z-index: 1000;
}

  .topbar a.shop-btn {
    display: inline-block;
    padding: 6px 12px;
    background-color: #f0f4ff;
    color: #0052cc;
    border-radius: 5px;
    font-size: 14px;
    text-decoration: none;
    margin-right: 10px;
  }
  .topbar a.shop-btn:hover {
    background-color: #dbe7ff;
  }
</style>

<div class="topbar">
  <h4>
    <a href="../dashboard/dashboard.jsp" style="color: inherit; text-decoration: none;">관리자 페이지</a>
  </h4>
  <div>
    <a href="/mall_prj/index.jsp" class="shop-btn">🛍 쇼핑몰 이동</a>
    <a href="../login/admin_logout.jsp">로그아웃</a>
  </div>
</div>
