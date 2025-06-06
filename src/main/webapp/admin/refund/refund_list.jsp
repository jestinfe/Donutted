<%@page import="util.RangeDTO"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="refund.RefundService, refund.RefundDTO, java.util.List" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>


<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<head>
  <title>환불 관리</title>
</head>

<%
  String userId = request.getParameter("user_id");
  String status = request.getParameter("status");
  String fromDate = request.getParameter("from_date");
  String toDate = request.getParameter("to_date");

  int currentPage = 1;
  try {
    currentPage = Integer.parseInt(request.getParameter("currentPage"));
  } catch (Exception e) {}

  int pageScale = 10;
  int startNum = (currentPage - 1) * pageScale + 1;
  int endNum = startNum + pageScale - 1;

  RangeDTO range = new RangeDTO(startNum, endNum);
  range.setCurrentPage(currentPage);
  range.setField("user_id");
  range.setKeyword(userId);

  RefundService service = new RefundService();
  List<RefundDTO> list = service.searchRefunds(userId, status, fromDate, toDate, range);
  int totalCount = service.getRefundSearchCount(userId, status, fromDate, toDate);
  int totalPage = (int) Math.ceil((double) totalCount / pageScale);

  request.setAttribute("refunds", list);
  request.setAttribute("totalPage", totalPage);
  request.setAttribute("currentPage", currentPage);
%>

<script>
function confirmRefund(form) {
  const status = form.status.value;
  let message = '';

  if (status === 'RS2') message = '정말 환불을 승인하시겠습니까?';
  else if (status === 'RS3') message = '정말 환불을 미승인 처리하시겠습니까?';
  else return true;

  return confirm(message);
}
</script>

<div class="main">
  <h3 class="mb-4">주문관리 - 환불</h3>

  <!-- 검색 필터 -->
  <form class="row g-2 mb-4" method="get">
    <input type="hidden" name="currentPage" value="1" />
    <div class="col-md-2">
      <input type="text" name="user_id" class="form-control" value="<%= userId != null ? userId : "" %>" placeholder="주문자 ID">
    </div>
    <div class="col-md-2">
      <input type="date" name="from_date" class="form-control" value="<%= fromDate != null ? fromDate : "" %>">
    </div>
    <div class="col-md-2">
      <input type="date" name="to_date" class="form-control" value="<%= toDate != null ? toDate : "" %>">
    </div>
    <div class="col-md-2">
      <select name="status" class="form-select">
        <option value="">환불 상태</option>
        <option value="RS1" <%= "RS1".equals(status) ? "selected" : "" %>>환불 요청 중</option>
        <option value="RS2" <%= "RS2".equals(status) ? "selected" : "" %>>환불 승인</option>
        <option value="RS3" <%= "RS3".equals(status) ? "selected" : "" %>>환불 미승인</option>
      </select>
    </div>
    <div class="col-md-2">
      <button class="btn btn-dark w-100">검색</button>
    </div>
    <div class="col-md-2">
      <a href="refund_list.jsp" class="btn btn-secondary w-100">초기화</a>
    </div>
  </form>

  <!-- 환불 목록 -->
  <table class="table table-bordered text-center align-middle">
    <thead class="table-light">
      <tr>
        <th>환불ID</th>
        <th>주문자ID</th>
        <th>상품명</th>
        <th>신청일자</th>
        <th>환불사유</th>
        <th>금액</th> <!-- ✅ 추가 -->
        <th>상태</th>
        <th>처리</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="r" items="${refunds}" varStatus="status">
        <c:set var="locked" value="${r.refundStatus eq 'RS2' || r.refundStatus eq 'RS3'}" />
        <tr>
          <td>${r.refundId}</td>
          <td>${r.userId}</td>
          <td>${r.productName}</td>
          <td><fmt:formatDate value="${r.requestedAt}" pattern="yyyy-MM-dd" /></td>
          <td>${r.refundReasonText}</td>
          <td>
            <fmt:formatNumber value="${r.quantity * r.unitPrice}" type="number" />원
          </td> <!-- ✅ 금액 출력 -->
          <td>
            <c:choose>
              <c:when test="${r.refundStatus eq 'RS1'}">환불 요청 중</c:when>
              <c:when test="${r.refundStatus eq 'RS2'}">환불 승인</c:when>
              <c:when test="${r.refundStatus eq 'RS3'}">환불 미승인</c:when>
              <c:otherwise>알 수 없음</c:otherwise>
            </c:choose>
          </td>
          <td>
            <form method="post" action="refund_status_update.jsp" onsubmit="return confirmRefund(this);">
              <input type="hidden" name="refund_id" value="${r.refundId}" />
              <select name="status" class="form-select form-select-sm" <c:if test="${locked}">disabled</c:if>>
                <option value="RS1" ${r.refundStatus eq 'RS1' ? "selected" : ""}>환불 요청 중</option>
                <option value="RS2" ${r.refundStatus eq 'RS2' ? "selected" : ""}>환불 승인</option>
                <option value="RS3" ${r.refundStatus eq 'RS3' ? "selected" : ""}>환불 미승인</option>
              </select>
              <button type="submit" class="btn btn-sm btn-dark mt-1" <c:if test="${locked}">disabled</c:if>>
                변경
              </button>
            </form>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>

  <!-- 페이지네이션 -->
  <div class="text-center mt-4">
    <nav>
      <ul class="pagination justify-content-center">
        <c:forEach var="i" begin="1" end="${totalPage}">
          <li class="page-item ${i == currentPage ? 'active' : ''}">
            <a class="page-link"
               href="refund_list.jsp?currentPage=${i}&user_id=${param.user_id}&status=${param.status}&from_date=${param.from_date}&to_date=${param.to_date}">
              ${i}
            </a>
          </li>
        </c:forEach>
      </ul>
    </nav>
  </div>
</div>
