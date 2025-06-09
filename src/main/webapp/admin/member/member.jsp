<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="user.UserService, user.UserDTO, java.util.*, util.RangeDTO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>
<head>
  <title>회원관리 - 회원목록</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>

<%
  String includeWithdraw = request.getParameter("includeWithdraw");
  String searchField = request.getParameter("searchField");
  String searchKeyword = request.getParameter("searchKeyword");
  String sort = request.getParameter("sort");
  if (sort == null || (!sort.equals("asc") && !sort.equals("desc"))) {
    sort = "desc";
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

<style>
/* Core Variables */
:root {
  --primary-color: #6366f1;
  --primary-dark: #4f46e5;
  --text-muted: #64748b;
  --border-color: #e2e8f0;
  --success-color: #10b981;
  --danger-color: #ef4444;
}

/* Layout Structure */
.main {
  background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
  min-height: calc(100vh - 60px);
  padding: 1rem;
  transition: all 0.3s ease;
}

/* Search Form */
.search-card {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  border: 1px solid var(--border-color);
}

.search-form {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  align-items: end;
}

.form-group {
  display: flex;
  flex-direction: column;
}

.form-group.checkbox-group {
  justify-content: flex-end;
  padding-top: 1.5rem;
}

.form-group.button-group {
  flex-direction: row;
  gap: 0.5rem;
}

.form-label {
  font-weight: 600;
  color: #374151;
  margin-bottom: 0.5rem;
  font-size: 0.875rem;
}

.form-control, .form-select {
  border: 2px solid var(--border-color) !important;
  border-radius: 8px !important;
  padding: 0.625rem 0.875rem !important;
  font-size: 0.875rem !important;
  transition: all 0.3s ease !important;
  background: #fafafa !important;
  box-shadow: none !important;
}

.form-control:focus, .form-select:focus {
  border-color: var(--primary-color) !important;
  box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1) !important;
  outline: none !important;
  background: white !important;
}

.btn {
  border-radius: 8px !important;
  font-weight: 600 !important;
  padding: 0.625rem 1.25rem !important;
  transition: all 0.3s ease !important;
  border: none !important;
  font-size: 0.875rem !important;
  white-space: nowrap !important;
}

.btn-dark {
  background: linear-gradient(135deg, var(--primary-color), var(--primary-dark)) !important;
  color: white !important;
}

.btn-dark:hover {
  transform: translateY(-1px) !important;
  box-shadow: 0 6px 20px rgba(99, 102, 241, 0.3) !important;
}

.btn-outline-secondary {
  border: 2px solid var(--border-color) !important;
  color: var(--text-muted) !important;
  background: white !important;
}

.btn-outline-secondary:hover {
  background: #f8fafc !important;
  border-color: var(--text-muted) !important;
  color: #374151 !important;
}

.form-check {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.form-check-input {
  border-radius: 4px !important;
  border: 2px solid var(--border-color) !important;
  width: 16px !important;
  height: 16px !important;
}

.form-check-input:checked {
  background-color: var(--primary-color) !important;
  border-color: var(--primary-color) !important;
}

.form-check-label {
  font-weight: 500;
  color: #374151;
  font-size: 0.875rem;
}

/* Table */
.table-responsive {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
  border: 1px solid var(--border-color);
  margin-bottom: 1.5rem;
}

.table {
  margin: 0 !important;
  min-width: 600px;
}

.table thead th {
  background: #f8fafc !important;
  color: #374151 !important;
  font-weight: 700 !important;
  padding: 1rem 0.75rem !important;
  border: none !important;
  font-size: 0.8rem !important;
  border-bottom: 2px solid var(--border-color) !important;
  white-space: nowrap !important;
}

.table tbody tr {
  transition: all 0.3s ease !important;
  cursor: pointer !important;
}

.table tbody tr:hover {
  background: #f8fafc !important;
  transform: translateY(-1px) !important;
}

.table tbody td {
  padding: 1rem 0.75rem !important;
  border: none !important;
  border-top: 1px solid #f1f5f9 !important;
  color: #374151 !important;
  font-size: 0.875rem !important;
  white-space: nowrap !important;
}

.status-badge {
  padding: 0.3rem 0.6rem;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: 600;
  display: inline-block;
}

.status-active {
  background: #dcfce7;
  color: #166534;
}

.status-inactive {
  background: #fef2f2;
  color: #dc2626;
}

/* Pagination */
.pagination {
  justify-content: center !important;
  gap: 0.375rem !important;
  margin: 1.5rem 0 0 0 !important;
  flex-wrap: wrap !important;
}

.page-item .page-link {
  border: 2px solid var(--border-color) !important;
  color: var(--text-muted) !important;
  border-radius: 6px !important;
  padding: 0.5rem 0.75rem !important;
  font-weight: 600 !important;
  transition: all 0.3s ease !important;
  font-size: 0.875rem !important;
  text-decoration: none !important;
}

.page-item:not(.active) .page-link:hover {
  background: var(--primary-color) !important;
  color: white !important;
  border-color: var(--primary-color) !important;
}

.page-item.active .page-link {
  background: linear-gradient(135deg, var(--primary-color), var(--primary-dark)) !important;
  border-color: var(--primary-color) !important;
  color: white !important;
}

/* Responsive Design */
@media (max-width: 1200px) {
  .search-form {
    grid-template-columns: repeat(3, 1fr);
  }
  
  .form-group.button-group {
    grid-column: span 3;
    justify-content: center;
    margin-top: 1rem;
  }
  
  .form-group.checkbox-group {
    grid-column: span 3;
    justify-content: center;
    padding-top: 0;
    margin-top: 1rem;
  }
}

@media (max-width: 768px) {
  .main {
    padding: 0.5rem;
  }
  
  .search-card {
    padding: 1rem;
    border-radius: 8px;
    margin-bottom: 1rem;
  }
  
  .search-form {
    grid-template-columns: 1fr;
    gap: 1rem;
  }
  
  .form-group.button-group {
    grid-column: span 1;
    flex-direction: column;
  }
  
  .form-group.checkbox-group {
    grid-column: span 1;
    justify-content: flex-start;
  }
  
  .table thead th {
    padding: 0.75rem 0.5rem !important;
    font-size: 0.75rem !important;
  }
  
  .table tbody td {
    padding: 0.75rem 0.5rem !important;
    font-size: 0.8rem !important;
  }
  
  .table {
    min-width: 550px;
  }
  
  .page-item .page-link {
    padding: 0.4rem 0.6rem !important;
    font-size: 0.8rem !important;
  }
}

@media (max-width: 480px) {
  .main {
    padding: 0.25rem;
  }
  
  .search-card {
    padding: 0.75rem;
    margin-bottom: 0.75rem;
  }
  
  .table thead th {
    padding: 0.5rem 0.25rem !important;
    font-size: 0.7rem !important;
  }
  
  .table tbody td {
    padding: 0.5rem 0.25rem !important;
    font-size: 0.75rem !important;
  }
  
  .status-badge {
    padding: 0.2rem 0.4rem;
    font-size: 0.7rem;
  }
  
  .pagination {
    gap: 0.25rem !important;
  }
  
  .page-item .page-link {
    padding: 0.35rem 0.5rem !important;
    font-size: 0.75rem !important;
  }
}

/* Empty rows styling */
.table tbody tr[style*="border: none"] td {
  border: none !important;
  background: transparent !important;
}

.table tbody tr[style*="border: none"]:hover {
  background: transparent !important;
  transform: none !important;
  cursor: default !important;
}

/* Scrollbar styling */
.table-responsive::-webkit-scrollbar {
  height: 8px;
}

.table-responsive::-webkit-scrollbar-track {
  background: #f1f5f9;
  border-radius: 4px;
}

.table-responsive::-webkit-scrollbar-thumb {
  background: var(--border-color);
  border-radius: 4px;
}

.table-responsive::-webkit-scrollbar-thumb:hover {
  background: var(--text-muted);
}
</style>

<div class="main">
  <h3 class="mb-4">👥 회원 관리 - 회원목록</h3>

  <!-- Search Filters -->
  <div class="search-card">
    <form class="search-form" method="get" action="member.jsp">
      <div class="form-group">
        <label class="form-label">검색 필드</label>
        <select class="form-select" name="searchField">
          <option value="username" <%= "username".equals(searchField) ? "selected" : "" %>>아이디</option>
          <option value="name" <%= "name".equals(searchField) ? "selected" : "" %>>이름</option>
        </select>
      </div>

      <div class="form-group">
        <label class="form-label">검색어</label>
        <input type="text" class="form-control" name="searchKeyword"
               value="<%= searchKeyword != null ? searchKeyword : "" %>" 
               placeholder="검색어를 입력하세요">
      </div>

      <div class="form-group">
        <label class="form-label">정렬 방식</label>
        <select class="form-select" name="sort">
          <option value="desc" <%= "desc".equals(sort) ? "selected" : "" %>>가입일: 최신순</option>
          <option value="asc" <%= "asc".equals(sort) ? "selected" : "" %>>가입일: 오래된순</option>
        </select>
      </div>

      <div class="form-group checkbox-group">
        <div class="form-check">
          <input class="form-check-input" type="checkbox" name="includeWithdraw" id="chkWithdraw"
                 <%= "on".equals(includeWithdraw) ? "checked" : "" %>>
          <label class="form-check-label" for="chkWithdraw">
            탈퇴회원 포함
          </label>
        </div>
      </div>

      <div class="form-group button-group">
        <button type="submit" class="btn btn-dark">🔍 검색</button>
        <button type="button" class="btn btn-outline-secondary"
                onclick="location.href='member.jsp'">🔄 초기화</button>
      </div>
    </form>
  </div>

  <!-- Members Table -->
  <div class="table-responsive">
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
            <td><strong>${(currentPage - 1) * 10 + status.index + 1}</strong></td>
            <td>${user.name}</td>
            <td>${user.username}</td>
            <td>${user.phone}</td>
            <td><fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd" /></td>
            <td>
              <c:choose>
                <c:when test="${user.userStatus eq 'U2'}">
                  <span class="status-badge status-inactive">탈퇴</span>
                </c:when>
                <c:otherwise>
                  <span class="status-badge status-active">활성</span>
                </c:otherwise>
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

  <!-- Pagination -->
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

<script>
document.addEventListener('DOMContentLoaded', function() {
  // Enhanced table row interactions
  document.querySelectorAll('tbody tr[onclick]').forEach(row => {
    row.addEventListener('mouseenter', function() {
      if (window.innerWidth > 768) {
        this.style.transform = 'translateY(-1px)';
      }
    });
    
    row.addEventListener('mouseleave', function() {
      this.style.transform = 'translateY(0)';
    });
  });
});
</script>