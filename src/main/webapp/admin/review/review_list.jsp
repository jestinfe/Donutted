<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="review.*, order.*, user.*, java.util.*, util.RangeDTO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>

<head>
<title>리뷰 관리</title>
</head>
<%
  request.setCharacterEncoding("UTF-8");
  String keyword = request.getParameter("keyword");
  String sort = request.getParameter("sort");
  String pageParam = request.getParameter("currentPage");

  if (keyword == null) keyword = "";
  if (sort == null) sort = "desc";
  int currentPage = 1;
  try { currentPage = Integer.parseInt(pageParam); } catch (Exception e) {}

  int pageScale = 10;
  int startNum = (currentPage - 1) * pageScale + 1;
  int endNum = startNum + pageScale - 1;
  RangeDTO range = new RangeDTO(startNum, endNum);
  range.setCurrentPage(currentPage);
  range.setField("username");
  range.setKeyword(keyword);

  ReviewService reviewService = new ReviewService();
  OrderService orderService = new OrderService();
  UserService userService = new UserService();

  List<ReviewDTO> reviews = reviewService.getPagedReviews(keyword, sort, range);
  int totalCount = reviewService.countReviews(keyword);
  int totalPage = (int) Math.ceil((double) totalCount / pageScale);

  Map<Integer, OrderItemDTO> itemMap = new HashMap<>();
  Map<Integer, UserDTO> userMap = new HashMap<>();

  for (ReviewDTO r : reviews) {
    itemMap.put(r.getOrderItemId(), orderService.getOrderItemDetail(r.getOrderItemId()));
    userMap.put(r.getUserId(), userService.getUserById(r.getUserId()));
  }
%>

<div class="main">
  <h3>리뷰 관리 - 리뷰 목록</h3>

  <!-- 검색 영역 -->
  <form class="row g-2 mb-3" method="get">
    <input type="hidden" name="currentPage" value="1">
    <div class="col-md-2">
      <select class="form-select" name="sort">
        <option value="desc" <%= "desc".equals(sort) ? "selected" : "" %>>최신순</option>
        <option value="asc" <%= "asc".equals(sort) ? "selected" : "" %>>오래된순</option>
      </select>
    </div>
    <div class="col-md-6">
      <input type="text" name="keyword" class="form-control" placeholder="작성자 ID" value="<%= keyword %>">
    </div>
    <div class="col-md-2">
      <button class="btn btn-primary">검색</button>
    </div>
  </form>

  <!-- 테이블 -->
  <table class="table table-bordered text-center align-middle">
    <thead class="table-light">
      <tr>
        <th>번호</th>
        <th>내용</th>
        <th>작성일</th>
        <th>작성자ID</th>
        <th>별점</th>
      </tr>
    </thead>
    <tbody>
      <%
        int index = startNum;
        for (ReviewDTO r : reviews) {
            OrderItemDTO item = itemMap.get(r.getOrderItemId());
            UserDTO user = userMap.get(r.getUserId());
      %>
      <tr onclick="location.href='review_detail.jsp?review_id=<%= r.getReviewId() %>'" style="cursor:pointer">
        <td><%= index++ %></td>
        <td><%= r.getContent() %></td>
        <td><%= r.getCreatedAt() %></td>
        <td><%= user != null ? user.getUsername() : "탈퇴자" %></td>
        <td>
          <%
            for (int i = 1; i <= 5; i++) {
                if (i <= r.getRating()) out.print("★");
                else out.print("☆");
            }
          %>
        </td>
      </tr>
      <%
        }
        if (reviews.isEmpty()) {
      %>
      <tr><td colspan="5">검색 결과가 없습니다.</td></tr>
      <%
        }
      %>
    </tbody>
  </table>

  <!-- 페이지네이션 -->
  <div class="text-center mt-4">
    <nav>
  <ul class="pagination justify-content-center">
    <c:forEach var="i" begin="1" end="${totalPage}">
      <li class="page-item ${i == currentPage ? 'active' : ''}">
        <a class="page-link"
           href="review_list.jsp?currentPage=${i}&keyword=${param.keyword}&sort=${param.sort}">
          ${i}
        </a>
      </li>
    </c:forEach>
  </ul>
</nav>
  </div>
</div>