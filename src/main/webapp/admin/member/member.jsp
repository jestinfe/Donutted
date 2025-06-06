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
</head>
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

<style>
:root {
    --primary-color: #6366f1;
    --primary-dark: #4f46e5;
    --accent-color: #06b6d4;
    --text-muted: #64748b;
    --border-color: #e2e8f0;
    --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
    --success-color: #10b981;
    --danger-color: #ef4444;
}

.main {
    padding: 2rem;
    background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
    min-height: 100vh;
}

/* Page Header */
.page-header {
    background: white;
    border-radius: 16px;
    padding: 2rem;
    margin-bottom: 2rem;
    box-shadow: var(--card-shadow);
    border: 1px solid var(--border-color);
}

.page-header h3 {
    color: #1e293b;
    font-weight: 700;
    font-size: 2rem;
    margin: 0;
    display: flex;
    align-items: center;
}

.page-header h3::before {
    content: '👥';
    margin-right: 1rem;
    font-size: 1.5rem;
}

/* Search Card */
.search-card {
    background: white;
    border-radius: 16px;
    padding: 2rem;
    margin-bottom: 2rem;
    box-shadow: var(--card-shadow);
    border: 1px solid var(--border-color);
}

.search-form {
    display: grid;
    grid-template-columns: auto auto auto 1fr auto;
    gap: 1rem;
    align-items: end;
}

.form-group {
    display: flex;
    flex-direction: column;
}

.form-label {
    font-weight: 600;
    color: #374151;
    margin-bottom: 0.5rem;
    font-size: 0.9rem;
}

.form-control, .form-select {
    border: 2px solid var(--border-color) !important;
    border-radius: 12px !important;
    padding: 0.75rem 1rem !important;
    font-size: 0.9rem !important;
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
    border-radius: 12px !important;
    font-weight: 600 !important;
    padding: 0.75rem 1.5rem !important;
    transition: all 0.3s ease !important;
    border: none !important;
    font-size: 0.9rem !important;
}

.btn-dark {
    background: linear-gradient(135deg, var(--primary-color), var(--primary-dark)) !important;
    color: white !important;
}

.btn-dark:hover {
    transform: translateY(-2px) !important;
    box-shadow: 0 8px 25px rgba(99, 102, 241, 0.3) !important;
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
    margin-top: 2rem;
}

.form-check-input {
    border-radius: 6px !important;
    border: 2px solid var(--border-color) !important;
    width: 18px !important;
    height: 18px !important;
}

.form-check-input:checked {
    background-color: var(--primary-color) !important;
    border-color: var(--primary-color) !important;
}

.form-check-label {
    font-weight: 500;
    color: #374151;
}

/* Table Card */
.table-card {
    background: white;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: var(--card-shadow);
    border: 1px solid var(--border-color);
    margin-bottom: 2rem;
}

.table-header {
    background: linear-gradient(135deg, #f8fafc, #f1f5f9);
    padding: 1.5rem 2rem;
    border-bottom: 1px solid var(--border-color);
}

.table-header h4 {
    margin: 0;
    color: #1e293b;
    font-weight: 700;
    font-size: 1.25rem;
    display: flex;
    align-items: center;
}

.table-header h4::before {
    content: '📋';
    margin-right: 0.75rem;
}

.table-responsive {
    overflow-x: auto;
    min-height: 450px;
}

.table {
    margin: 0 !important;
    border-collapse: separate !important;
    border-spacing: 0 !important;
}

.table thead th {
    background: #f8fafc !important;
    color: #374151 !important;
    font-weight: 700 !important;
    padding: 1.25rem 1.5rem !important;
    border: none !important;
    font-size: 0.9rem !important;
    text-transform: uppercase !important;
    letter-spacing: 0.05em !important;
    border-bottom: 2px solid var(--border-color) !important;
}

.table tbody tr {
    transition: all 0.3s ease !important;
    cursor: pointer !important;
    border: none !important;
}

.table tbody tr:hover {
    background: #f8fafc !important;
    transform: translateY(-1px) !important;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05) !important;
}

.table tbody td {
    padding: 1.25rem 1.5rem !important;
    border-top: 1px solid #f1f5f9 !important;
    border-left: none !important;
    border-right: none !important;
    border-bottom: none !important;
    vertical-align: middle !important;
    color: #374151 !important;
    font-size: 0.9rem !important;
}

.status-badge {
    padding: 0.4rem 0.8rem;
    border-radius: 20px;
    font-size: 0.8rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.05em;
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

/* Empty rows styling */
.table tbody tr[style*="border: none"] td {
    border: none !important;
    background: transparent !important;
}

.table tbody tr[style*="border: none"]:hover {
    background: transparent !important;
    transform: none !important;
    box-shadow: none !important;
    cursor: default !important;
}

/* Pagination */
.pagination-wrapper {
    padding: 2rem;
    background: white;
    border-top: 1px solid var(--border-color);
    border-radius: 0 0 16px 16px;
}

.pagination {
    justify-content: center !important;
    gap: 0.5rem !important;
    margin: 0 !important;
}

.page-item .page-link {
    border: 2px solid var(--border-color) !important;
    color: var(--text-muted) !important;
    border-radius: 10px !important;
    padding: 0.75rem 1rem !important;
    font-weight: 600 !important;
    transition: all 0.3s ease !important;
    margin: 0 !important;
    text-decoration: none !important;
}

.page-item:not(.active) .page-link:hover {
    background: var(--primary-color) !important;
    color: white !important;
    border-color: var(--primary-color) !important;
    transform: translateY(-2px) !important;
}

.page-item.active .page-link {
    background: linear-gradient(135deg, var(--primary-color), var(--primary-dark)) !important;
    border-color: var(--primary-color) !important;
    color: white !important;
    box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3) !important;
}

/* Responsive Design */
@media (max-width: 1200px) {
    .search-form {
        grid-template-columns: 1fr;
        gap: 1.5rem;
    }
    
    .form-check {
        margin-top: 0;
    }
}

@media (max-width: 768px) {
    .main {
        padding: 1rem;
    }
    
    .page-header, .search-card, .table-card {
        padding: 1.5rem;
    }
    
    .page-header h3 {
        font-size: 1.5rem;
    }
}

/* Loading Animation */
.loading {
    display: inline-block;
    width: 20px;
    height: 20px;
    border: 3px solid #f3f3f3;
    border-top: 3px solid var(--primary-color);
    border-radius: 50%;
    animation: spin 1s linear infinite;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}
</style>

<div class="main">
    <!-- Page Header -->
    <div class="page-header">
        <h3>회원 관리 - 회원목록</h3>
    </div>

    <!-- Search Filters -->
    <div class="search-card">
        <form class="search-form" method="get" action="member.jsp">
            <div class="form-group">
                <label class="form-label">검색 필드</label>
                <select class="form-select form-select-sm" name="searchField" style="width: 120px;">
                    <option value="username" <%= "username".equals(searchField) ? "selected" : "" %>>아이디</option>
                    <option value="name" <%= "name".equals(searchField) ? "selected" : "" %>>이름</option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">검색어</label>
                <input type="text" class="form-control form-control-sm" name="searchKeyword"
                       value="<%= searchKeyword != null ? searchKeyword : "" %>" 
                       placeholder="검색어를 입력하세요" style="width: 200px;">
            </div>

            <div class="form-group">
                <label class="form-label">정렬 방식</label>
                <select class="form-select form-select-sm" name="sort" style="width: 160px;">
                    <option value="desc" <%= "desc".equals(sort) ? "selected" : "" %>>가입일: 최신순</option>
                    <option value="asc" <%= "asc".equals(sort) ? "selected" : "" %>>가입일: 오래된순</option>
                </select>
            </div>

            <div class="form-group">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" name="includeWithdraw" id="chkWithdraw"
                           <%= "on".equals(includeWithdraw) ? "checked" : "" %>>
                    <label class="form-check-label" for="chkWithdraw">
                        탈퇴회원 포함
                    </label>
                </div>
            </div>

            <div class="form-group" style="display: flex; gap: 0.5rem;">
                <button type="submit" class="btn btn-dark btn-sm px-3">🔍 검색</button>
                <button type="button" class="btn btn-outline-secondary btn-sm px-3"
                        onclick="location.href='member.jsp'">🔄 초기화</button>
            </div>
        </form>
    </div>

    <!-- Members Table -->
    <div class="table-card">
        <div class="table-header">
            <h4>회원 목록</h4>
        </div>
        
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
        <div class="pagination-wrapper">
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
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Add loading state to search form
    const searchForm = document.querySelector('.search-form');
    if (searchForm) {
        searchForm.addEventListener('submit', function() {
            const submitBtn = this.querySelector('button[type="submit"]');
            if (submitBtn) {
                submitBtn.innerHTML = '<span class="loading"></span> 검색 중...';
                submitBtn.disabled = true;
            }
        });
    }

    // Enhanced table row interactions
    document.querySelectorAll('tbody tr[onclick]').forEach(row => {
        row.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-2px)';
        });
        
        row.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });

    // Smooth scroll for pagination
    document.querySelectorAll('.page-link').forEach(link => {
        link.addEventListener('click', function(e) {
            // Add smooth loading effect
            const loadingOverlay = document.createElement('div');
            loadingOverlay.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(255, 255, 255, 0.8);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 9999;
            `;
            loadingOverlay.innerHTML = '<div class="loading" style="width: 40px; height: 40px;"></div>';
            document.body.appendChild(loadingOverlay);
        });
    });
});
</script>