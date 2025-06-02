<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserService, user.UserDTO, java.util.*, util.RangeDTO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>

<%
  String includeWithdraw = request.getParameter("includeWithdraw");
  String searchField = request.getParameter("searchField");
  String searchKeyword = request.getParameter("searchKeyword");
  String sort = request.getParameter("sort");
  if (sort == null || (!sort.equals("asc") && !sort.equals("desc"))) {
    sort = "desc"; // 기본 정렬: 최신순
  }

  int currentPage = 1;
  try {
    currentPage = Integer.parseInt(request.getParameter("currentPage"));
  } catch (Exception e) {}

  int pageScale = 10;
  int startNum = (currentPage - 1) * pageScale + 1;
  int endNum = startNum + pageScale - 1;

  RangeDTO range = new RangeDTO(startNum, endNum);
  range.setCurrentPage(currentPage);
  range.setField(searchField);
  range.setKeyword(searchKeyword);
  range.setSort(sort);

  boolean activeOnly = !"on".equals(includeWithdraw);
  boolean isSearch = searchField != null && searchKeyword != null && !searchKeyword.trim().isEmpty();

  UserService service = new UserService();
  List<UserDTO> userList = null;
  int totalCount = 0;

  if (isSearch) {
    userList = service.getUsersBySearch(range, activeOnly);
    totalCount = service.getSearchUserCount(range, activeOnly);
  } else {
    userList = service.getUsersByRange(range, activeOnly);
    totalCount = service.getUserCount(activeOnly);
  }

  int totalPage = (int) Math.ceil((double) totalCount / pageScale);

  request.setAttribute("userList", userList);
  request.setAttribute("totalPage", totalPage);
  request.setAttribute("currentPage", currentPage);
  request.setAttribute("includeWithdraw", includeWithdraw);
  request.setAttribute("searchField", searchField);
  request.setAttribute("searchKeyword", searchKeyword);
  request.setAttribute("sort", sort);
%>

<div class="main">
  <h3>회원 관리 - 회원목록</h3>

  <!-- 🔍 검색 필터 -->
  <form class="row g-2 flex-nowrap mb-4 align-items-end" method="get" action="member.jsp" style="overflow-x: auto;">
  <div class="col-auto">
    <select class="form-select form-select-sm" name="searchField" style="width: 90px;">
      <option value="username" <%= "username".equals(searchField) ? "selected" : "" %>>아이디</option>
      <option value="name" <%= "name".equals(searchField) ? "selected" : "" %>>이름</option>
    </select>
  </div>

  <div class="col-auto">
    <input type="text" class="form-control form-control-sm" name="searchKeyword"
           value="<%= searchKeyword != null ? searchKeyword : "" %>" placeholder="검색어 입력" style="width: 180px;">
  </div>

  <div class="col-auto">
    <select class="form-select form-select-sm" name="sort" style="width: 140px;">
      <option value="desc" <%= "desc".equals(sort) ? "selected" : "" %>>가입일: 최신순</option>
      <option value="asc" <%= "asc".equals(sort) ? "selected" : "" %>>가입일: 오래된순</option>
    </select>
  </div>

  <div class="col-auto d-flex align-items-center">
    <div class="form-check mt-1">
      <input class="form-check-input" type="checkbox" name="includeWithdraw" id="chkWithdraw"
             <%= "on".equals(includeWithdraw) ? "checked" : "" %>>
      <label class="form-check-label" for="chkWithdraw" style="font-size: 0.85rem;">
        탈퇴회원 포함
      </label>
    </div>
  </div>

  <div class="col-auto d-flex justify-content-end">
    <button type="submit" class="btn btn-dark btn-sm px-3 me-1">검색</button>
    <button type="button" class="btn btn-outline-secondary btn-sm px-3"
            onclick="location.href='member.jsp'">초기화</button>
  </div>
</form>


  <!-- 회원 테이블 -->
  <div class="table-responsive" style="min-height: 450px;">
    <table class="table table-bordered text-center align-middle">
      <thead class="table-light">
        <tr>
          <th>번호</th>
          <th>회원명</th>
          <th>아이디</th>
          <th>핸드폰</th>
          <th>가입일시</th>
          <th>탈퇴여부</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="user" items="${userList}" varStatus="status">
          <tr onclick="location.href='member_detail.jsp?user_id=${user.userId}'" style="cursor:pointer">
            <td>${(currentPage - 1) * 10 + status.index + 1}</td>
            <td>${user.name}</td>
            <td>${user.username}</td>
            <td>${user.phone}</td>
            <td><fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd" /></td>
            <td>
              <c:choose>
                <c:when test="${user.userStatus eq 'U2'}">Y</c:when>
                <c:otherwise>N</c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>

        <!-- 빈 줄 채우기 -->
        <c:if test="${fn:length(userList) < 10}">
          <c:forEach begin="${fn:length(userList) + 1}" end="10" var="i">
            <tr style="border: none;"><td colspan="6" style="height: 42px; border: none;"></td></tr>
          </c:forEach>
        </c:if>
      </tbody>
    </table>
  </div>

  <!-- 페이지네이션 -->
  <div class="text-center mt-4">
    <nav>
      <ul class="pagination justify-content-center">
        <c:set var="withdrawParam" value="${includeWithdraw == null ? '' : 'on'}" />
        <c:forEach var="i" begin="1" end="${totalPage}">
          <li class="page-item ${i == currentPage ? 'active' : ''}">
            <a class="page-link"
               href="member.jsp?currentPage=${i}&includeWithdraw=${withdrawParam}&searchField=${searchField}&searchKeyword=${searchKeyword}&sort=${sort}">
              ${i}
            </a>
          </li>
        </c:forEach>
      </ul>
    </nav>
  </div>
</div>
