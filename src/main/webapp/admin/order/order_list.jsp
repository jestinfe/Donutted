<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.sql.Date" %>
<%@ page import="order.OrderService, order.OrderDTO" %>
<%@ page import="util.RangeDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>
<head>
  <title>주문관리 - 주문목록</title>
</head>

<%
    String searchName = request.getParameter("searchName");
    if (searchName != null && searchName.trim().isEmpty()) searchName = null;

    java.sql.Date searchDate = null;
    String searchDateParam = request.getParameter("searchDate");
    if (searchDateParam != null && !searchDateParam.trim().isEmpty()) {
        try {
            searchDate = java.sql.Date.valueOf(searchDateParam);
        } catch (IllegalArgumentException e) {
            searchDate = null;
        }
    }

    String searchStatus = request.getParameter("searchStatus");
    if (searchStatus != null && searchStatus.trim().isEmpty()) searchStatus = null;

    int currentPage = 1;
    try {
        currentPage = Integer.parseInt(request.getParameter("currentPage"));
        if (currentPage < 1) currentPage = 1;
    } catch (Exception e) {
        currentPage = 1;
    }

    int pageScale = 10;
    int startNum = (currentPage - 1) * pageScale + 1;
    int endNum = startNum + pageScale - 1;

    RangeDTO range = new RangeDTO(startNum, endNum);
    range.setCurrentPage(currentPage);

    OrderService orderService = new OrderService();
    int totalCount = orderService.getOrderCount(searchName, searchDate, searchStatus);
    List<OrderDTO> orderList = orderService.getOrdersByRange(range, searchName, searchDate, searchStatus);
    int totalPage = (int) Math.ceil((double) totalCount / pageScale);

    request.setAttribute("orderList", orderList);
    request.setAttribute("searchName", searchName);
    request.setAttribute("searchDate", searchDateParam);
    request.setAttribute("searchStatus", searchStatus);
    request.setAttribute("currentPage", currentPage);
    request.setAttribute("totalPage", totalPage);
    request.setAttribute("totalCount", totalCount);
    request.setAttribute("pageScale", pageScale);
%>

<div class="main">
  <h3>주문 관리 (전체 / 검색)</h3>

  <form class="row g-2 mb-3 align-items-end" method="get" action="order_list.jsp">
    <div class="col-md-2">
      <label class="form-label">회원명</label>
      <input type="text" name="searchName" class="form-control"
             placeholder="부분 검색" value="${fn:escapeXml(searchName)}">
    </div>
    <div class="col-md-2">
      <label class="form-label">주문일</label>
      <input type="date" name="searchDate" class="form-control" value="${searchDate}">
    </div>
    <div class="col-md-2">
      <label class="form-label">배송 상태</label>
      <select name="searchStatus" class="form-select">
        <option value="" ${empty searchStatus ? "selected" : ""}>전체</option>
        <option value="O1" ${searchStatus == 'O1' ? 'selected' : ''}>결제 완료 (O1)</option>
        <option value="O2" ${searchStatus == 'O2' ? 'selected' : ''}>배송 준비중 (O2)</option>
        <option value="O3" ${searchStatus == 'O3' ? 'selected' : ''}>배송 중 (O3)</option>
        <option value="O4" ${searchStatus == 'O4' ? 'selected' : ''}>배송 완료 (O4)</option>
        <option value="O0" ${searchStatus == 'O0' ? 'selected' : ''}>주문취소 (O0)</option>
      </select>
    </div>
    <div class="col-md-2">
  <a href="order_list.jsp" class="btn btn-outline-secondary w-100">초기화</a>
	</div>
    <div class="col-md-2 ms-auto">
      <button type="submit" class="btn btn-dark w-100">검색</button>
    </div>
  </form>

  <div class="table-responsive">
    <table class="table table-bordered text-center align-middle">
      <thead class="table-light">
        <tr>
          <th>번호</th>
          <th>주문ID</th>
          <th>회원ID</th>
          <th>회원명</th>
          <th>주문일시</th>
          <th>주문 총액</th>
          <th>배송 상태</th>
          <th>수령자</th>
          <th>상세 보기</th>
        </tr>
      </thead>
      <tbody>
        <c:if test="${fn:length(orderList) == 0}">
          <tr><td colspan="9">조회된 주문이 없습니다.</td></tr>
        </c:if>
        <c:forEach var="order" items="${orderList}" varStatus="sts">
          <tr>
            <td>${(currentPage - 1) * pageScale + sts.index + 1}</td>
            <td>${order.orderId}</td>
            <td>${order.userId}</td>
            <td>${order.userName}</td>
            <td><fmt:formatDate value="${order.orderDate}" pattern="yyyy-MM-dd" /></td>
            <td><fmt:formatNumber value="${order.totalPrice}" type="number" />원</td>
            <td>
              <c:choose>
                <c:when test="${order.orderStatus == 'O1'}">결제 완료</c:when>
                <c:when test="${order.orderStatus == 'O2'}">배송 준비중</c:when>
                <c:when test="${order.orderStatus == 'O3'}">배송 중</c:when>
                <c:when test="${order.orderStatus == 'O4'}">배송 완료</c:when>
                <c:when test="${order.orderStatus == 'O0'}"><span class="text-danger fw-bold">주문취소</span></c:when>
                <c:otherwise>${order.orderStatus}</c:otherwise>
              </c:choose>
            </td>
            <td>${order.receiverName}</td>
            <td>
              <a href="order_detail.jsp?order_id=${order.orderId}" class="btn btn-sm btn-outline-primary">상세 보기</a>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>

  <nav aria-label="Page navigation">
    <ul class="pagination justify-content-center">
      <c:set var="baseUrl" value="order_list.jsp?searchName=${fn:escapeXml(searchName)}&amp;searchDate=${searchDate}&amp;searchStatus=${searchStatus}" />
      <c:forEach var="i" begin="1" end="${totalPage}">
        <li class="page-item ${i == currentPage ? 'active' : ''}">
          <a class="page-link" href="${baseUrl}&amp;currentPage=${i}">${i}</a>
        </li>
      </c:forEach>
    </ul>
  </nav>
</div>
