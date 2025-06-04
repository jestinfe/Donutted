<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="refund.RefundService" %>
<%@ page import="refund.RefundDTO" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
  request.setCharacterEncoding("UTF-8");

if (session.getAttribute("userId") ==null ) {
	  response.sendRedirect("/mall_prj/UserLogin/login.jsp");
	  return;
	}

  Integer userId = (Integer) session.getAttribute("userId");
  List<RefundDTO> refundList = new ArrayList<>();


  

   RefundService service = new RefundService();
   refundList = service.getUserRefunds(userId);
  
  request.setAttribute("refundList", refundList);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>마이페이지 - 환불 내역</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Pretendard&display=swap" rel="stylesheet">
  <style>
    body {
      font-family: 'Pretendard', sans-serif;
      background-color: #fffefc;
    }

    .refunds-container {
      margin-left: 260px;
      max-width: 1000px;
      padding: 40px 20px;
    }

    h3 {
      font-weight: 700;
      margin-bottom: 30px;
      border-left: 5px solid #ef84a5;
      padding-left: 10px;
    }

    .refund-table {
      background: #fff;
      border-radius: 10px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.05);
      overflow: hidden;
    }

    .refund-table thead {
      background-color: #fce7ef;
      font-weight: bold;
      color: #333;
    }

    .refund-table td, .refund-table th {
      vertical-align: middle;
      padding: 14px;
    }

    .badge-processing {
      background-color: #ffc107;
      color: #212529;
    }

    .badge-complete {
      background-color: #28a745;
    }

    .badge-denied {
      background-color: #dc3545;
    }
  </style>
</head>
<body>

<c:import url="/common/header.jsp" />
<c:import url="/common/mypage_sidebar.jsp" />

<div class="refunds-container">
  <h3>환불/반품 내역</h3>

  <table class="table table-bordered refund-table">
  <thead>
    <tr>
      <th>상품</th>
      <th>수량</th>
      <th>환불금액</th>
      <th>환불사유</th>
      <th>신청일</th>
      <th>처리일</th>
      <th>상태</th>
    </tr>
  </thead>
  <tbody>
    <c:choose>
      <c:when test="${not empty refundList}">
        <c:forEach var="r" items="${refundList}">
          <tr>
            <td>
              <div style="display: flex; align-items: center; gap: 10px;">
                <img src="${pageContext.request.contextPath}/admin/common/upload/${r.thumbnailUrl}" alt="${r.productName}" 
     style="width: 60px; height: 60px; object-fit: cover; border-radius: 6px;" 
     onerror="이미지"/>
                <span>${r.productName}</span>
              </div>
            </td>
            <td>${r.quantity}</td>
            <td>
              <fmt:formatNumber value="${r.unitPrice * r.quantity}" type="currency" currencySymbol="₩" />
            </td>
            <td>${r.refundReasonText}</td>
            <td><fmt:formatDate value="${r.requestedAt}" pattern="yyyy-MM-dd"/></td>
            <td>
              <c:choose>
                <c:when test="${r.processedAt != null}">
                  <fmt:formatDate value="${r.processedAt}" pattern="yyyy-MM-dd"/>
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </td>
            <td>
              <c:choose>
                <c:when test="${r.refundStatus == 'RS1'}">
                  <span class="badge badge-processing">처리중</span>
                </c:when>
                <c:when test="${r.refundStatus == 'RS2'}">
                  <span class="badge badge-complete">환불완료</span>
                </c:when>
                <c:otherwise>
                  <span class="badge badge-denied">반려됨</span>
                </c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <tr><td colspan="7" class="text-center">환불 내역이 없습니다.</td></tr>
      </c:otherwise>
    </c:choose>
  </tbody>
</table>

</div>

<c:import url="/common/footer.jsp" />
</body>
</html>
