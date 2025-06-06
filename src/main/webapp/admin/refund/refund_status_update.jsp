<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="refund.RefundService, refund.RefundDTO, java.util.HashMap, java.util.Map" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
if (!"POST".equalsIgnoreCase(request.getMethod())) {
    response.sendRedirect("refund_list.jsp?error=invalid_method");
    return;
  }

  request.setCharacterEncoding("UTF-8");
  String refundIdStr = request.getParameter("refund_id");
  String newStatus = request.getParameter("status");

  boolean success = false;
  String message = "";
  String statusText = "";

  Map<String, String> statusMap = new HashMap<>();
  statusMap.put("RS1", "환불 요청 중");
  statusMap.put("RS2", "환불 승인");
  statusMap.put("RS3", "환불 미승인");

  try {
    int refundId = Integer.parseInt(refundIdStr);
    RefundService service = new RefundService();
    RefundDTO current = service.getRefundById(refundId); // ✅ 현재 상태 확인

    if (current == null) {
      message = "해당 환불 정보를 찾을 수 없습니다.";
    } else if (!"RS1".equals(current.getRefundStatus())) {
      // ✅ 이미 처리된 경우
      statusText = statusMap.getOrDefault(current.getRefundStatus(), current.getRefundStatus());
      message = "이미 '" + statusText + "' 상태로 처리된 환불은 변경할 수 없습니다.";
    } else {
      int updated = service.changeRefundStatus(refundId, newStatus);
      success = updated > 0;
      statusText = statusMap.getOrDefault(newStatus, newStatus);
      message = success
              ? "환불 상태가 '" + statusText + "'으로 변경되었습니다."
              : "환불 상태 변경에 실패했습니다.";
    }

  } catch (Exception e) {
    e.printStackTrace();
    message = "예외가 발생했습니다: " + e.getMessage();
  }
%>

<div class="main">
  <h3>환불 상태 변경 결과</h3>
  <div class="alert <%= success ? "alert-success" : "alert-danger" %>">
    <%= message %>
  </div>
  <a href="refund_list.jsp" class="btn btn-dark mt-3">← 환불 목록으로 돌아가기</a>
</div>
