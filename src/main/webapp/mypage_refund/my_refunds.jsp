<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="refund.RefundService" %>
<%@ page import="refund.RefundDTO" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/common/login_chk.jsp" %>

<link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>

<%
  request.setCharacterEncoding("UTF-8");


  Integer userId = (Integer) session.getAttribute("userId");
  List<RefundDTO> refundList = new ArrayList<>();

  RefundService service = new RefundService();
  refundList = service.getUserRefunds(userId);

  request.setAttribute("refundList", refundList);
%>
<style>
    :root {
      --primary-color: #2c3e50;
      --secondary-color: #34495e;
      --accent-color: #e74c3c;
      --success-color: #27ae60;
      --warning-color: #f39c12;
      --light-bg: #f8f9fa;
      --white: #ffffff;
      --gray-100: #f1f3f4;
      --gray-200: #e9ecef;
      --gray-300: #dee2e6;
      --gray-700: #495057;
      --gray-800: #343a40;
      --shadow-sm: 0 2px 4px rgba(0,0,0,0.06);
      --shadow-md: 0 4px 12px rgba(0,0,0,0.1);
      --shadow-lg: 0 8px 25px rgba(0,0,0,0.15);
    }

    body {
      font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
      margin: 0;
      color: var(--gray-800);
      min-height: 100vh;
    }

    .content-wrapper {
      margin-left: 240px;
      padding: 40px 30px;
      min-height: 100vh;
    }

    .refunds-container {
      max-width: 1200px;
      margin: 0 auto;
    }

    .page-header {
      background: var(--white);
      padding: 30px 40px;
      border-radius: 12px;
      box-shadow: var(--shadow-sm);
      margin-bottom: 30px;
      border-left: 4px solid var(--primary-color);
    }

    .page-header h3 {
      margin: 0;
      color: var(--primary-color);
      font-weight: 700;
      font-size: 1.5rem;
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .page-header h3::before {
      content: '📋';
      font-size: 1.2rem;
    }

    .refund-table-wrapper {
      background: var(--white);
      border-radius: 12px;
      box-shadow: var(--shadow-md);
      overflow: hidden;
      border: 1px solid var(--gray-200);
    }

    .refund-table {
      margin: 0;
      border: none;
    }

    .refund-table thead {
      background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
    }

    .refund-table thead th {
      color: var(--white);
      font-weight: 600;
      font-size: 0.9rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      padding: 18px 16px;
      border: none;
      text-align: center;
    }

    .refund-table tbody td {
      padding: 20px 16px;
      border-bottom: 1px solid var(--gray-200);
      vertical-align: middle;
      font-size: 0.95rem;
    }

    .refund-table tbody tr:last-child td {
      border-bottom: none;
    }

    .refund-table tbody tr:hover {
      background-color: var(--gray-100);
      transition: background-color 0.2s ease;
    }

    .product-cell {
      display: flex;
      align-items: center;
      gap: 15px;
      min-width: 250px;
    }

    .product-image {
      width: 60px;
      height: 60px;
      object-fit: cover;
      border-radius: 8px;
      border: 2px solid var(--gray-200);
      flex-shrink: 0;
    }

    .product-name {
      font-weight: 500;
      color: var(--gray-800);
      line-height: 1.4;
    }

    .quantity-cell {
      text-align: center;
      font-weight: 600;
      color: var(--primary-color);
    }

    .price-cell {
      text-align: right;
      font-weight: 600;
      color: var(--gray-800);
      font-size: 1rem;
    }

    .reason-cell {
      max-width: 200px;
      line-height: 1.4;
      color: var(--gray-700);
    }

    .date-cell {
      text-align: center;
      color: var(--gray-700);
      font-size: 0.9rem;
    }

    .status-cell {
      text-align: center;
    }

    .status-badge {
      display: inline-flex;
      align-items: center;
      padding: 6px 14px;
      border-radius: 20px;
      font-size: 0.8rem;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      gap: 6px;
    }

    .status-badge::before {
      content: '';
      width: 6px;
      height: 6px;
      border-radius: 50%;
    }

    .status-processing {
      background-color: rgba(243, 156, 18, 0.1);
      color: var(--warning-color);
      border: 1px solid rgba(243, 156, 18, 0.3);
    }

    .status-processing::before {
      background-color: var(--warning-color);
    }

    .status-complete {
      background-color: rgba(39, 174, 96, 0.1);
      color: var(--success-color);
      border: 1px solid rgba(39, 174, 96, 0.3);
    }

    .status-complete::before {
      background-color: var(--success-color);
    }

    .status-denied {
      background-color: rgba(231, 76, 60, 0.1);
      color: var(--accent-color);
      border: 1px solid rgba(231, 76, 60, 0.3);
    }

    .status-denied::before {
      background-color: var(--accent-color);
    }

    .empty-state {
      text-align: center;
      padding: 60px 20px;
      color: var(--gray-700);
    }

    .empty-state::before {
      content: '📦';
      font-size: 3rem;
      display: block;
      margin-bottom: 20px;
      opacity: 0.5;
    }

    .empty-state-text {
      font-size: 1.1rem;
      margin: 0;
    }

    @media (max-width: 1024px) {
      .content-wrapper {
        margin-left: 0;
        padding: 20px 15px;
      }

      .page-header {
        padding: 20px 25px;
      }

      .refund-table-wrapper {
        overflow-x: auto;
      }

      .refund-table {
        min-width: 800px;
      }
    }

    @media (max-width: 768px) {
      .page-header h3 {
        font-size: 1.3rem;
      }

      .product-cell {
        min-width: 200px;
        gap: 10px;
      }

      .product-image {
        width: 50px;
        height: 50px;
      }

      .refund-table thead th,
      .refund-table tbody td {
        padding: 12px 10px;
        font-size: 0.85rem;
      }
    }
</style>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>환불 내역 | Donutted</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link href="https://fonts.googleapis.com/css2?family=Pretendard&display=swap" rel="stylesheet">
  <style>
    body {
      font-family: 'Pretendard', sans-serif;
      background-color: #fffefc;
      margin: 0;
    }

    .content-wrapper {
      margin-left: 240px;
      display: flex;
      justify-content: center;
      padding: 40px 20px;
    }

    .refunds-container {
      width: 100%;
      max-width: 1000px;
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

    @media (max-width: 768px) {
      .content-wrapper {
        margin-left: 0;
        padding: 20px 10px;
      }

      .refunds-container {
        max-width: 100%;
      }
    }
  </style>
</head>
<body>

<c:import url="/common/header.jsp" />
<c:import url="/common/mypage_sidebar.jsp" />

<div class="content-wrapper">
  <div class="refunds-container">
   <div class="page-header">
	  <h3>환불 내역</h3>
	</div>

    <div class="refund-table-wrapper">
  <table class="table refund-table">
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
  <div class="product-cell">
    <img src="${pageContext.request.contextPath}/admin/common/images/products/${r.thumbnailUrl}" 
         alt="${r.productName}"
         class="product-image"
         onerror="this.src='/images/no_image.png';" />
    <span class="product-name">${r.productName}</span>
  </div>
</td>
<td class="quantity-cell">${r.quantity}</td>
<td class="price-cell">
  <fmt:formatNumber value="${r.unitPrice * r.quantity}" type="currency" currencySymbol="₩" />
</td>
<td class="reason-cell">${r.refundReasonText}</td>
<td class="date-cell"><fmt:formatDate value="${r.requestedAt}" pattern="yyyy-MM-dd"/></td>
<td class="date-cell">
  <c:choose>
    <c:when test="${r.processedAt != null}">
      <fmt:formatDate value="${r.processedAt}" pattern="yyyy-MM-dd"/>
    </c:when>
    <c:otherwise>-</c:otherwise>
  </c:choose>
</td>
<td class="status-cell">
  <c:choose>
    <c:when test="${r.refundStatus == 'RS1'}">
      <span class="status-badge status-processing">처리중</span>
    </c:when>
    <c:when test="${r.refundStatus == 'RS2'}">
      <span class="status-badge status-complete">환불완료</span>
    </c:when>
    <c:otherwise>
      <span class="status-badge status-denied">반려됨</span>
    </c:otherwise>
  </c:choose>
</td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr><td colspan="7" class="empty-state">
  <p class="empty-state-text">환불 내역이 없습니다.</p>
</td></tr>
          </c:otherwise>
        </c:choose>
      </tbody>
      </table>
</div>
  </div>
</div>

<c:import url="/common/footer.jsp" />
</body>
</html>
