<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="product.ProductDTO, product.ProductService" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>상품 목록</title>
</head>
<%
  request.setCharacterEncoding("UTF-8");

  String keyword = request.getParameter("keyword");
  String dateOrder = request.getParameter("dateOrder");
  String priceOrder = request.getParameter("priceOrder");

  ProductService service = new ProductService();
  List<ProductDTO> productList = service.getFilteredProducts(keyword, dateOrder, priceOrder);
  request.setAttribute("productList", productList);

  String contextPath = request.getContextPath();
%>

<div class="main container mt-4">
  <h3>상품 관리 - 상품 목록</h3>

  <!-- ✅ 검색 필터 -->
  <form class="row g-2 mb-3" method="get" action="product_list.jsp">
    <div class="col-md-3">
      <input type="text" name="keyword" class="form-control" placeholder="상품명"
             value="<c:out value='${param.keyword}'/>">
    </div>
    <div class="col-md-3">
      <select class="form-select" name="dateOrder">
        <option value="">날짜 정렬 선택</option>
        <option value="desc" ${param.dateOrder == 'desc' ? 'selected' : ''}>최신순</option>
        <option value="asc" ${param.dateOrder == 'asc' ? 'selected' : ''}>오래된순</option>
      </select>
    </div>
    <div class="col-md-3">
      <select class="form-select" name="priceOrder">
        <option value="">가격 정렬 선택</option>
        <option value="desc" ${param.priceOrder == 'desc' ? 'selected' : ''}>높은순</option>
        <option value="asc" ${param.priceOrder == 'asc' ? 'selected' : ''}>낮은순</option>
      </select>
    </div>
    <div class="col-md-3 d-flex">
    <button class="btn btn-dark w-50 me-2" type="submit">검색</button>
    <a href="product_list.jsp" class="btn btn-outline-secondary w-50">초기화</a>
  </div>
  </form>

  <!-- ✅ 상품 목록 테이블 -->
  <table class="table table-bordered text-center align-middle">
    <thead class="table-light">
      <tr>
        <th>번호</th>
        <th>이미지</th>
        <th>상품명</th>
        <th>등록일</th>
        <th>수정일</th>
        <th>가격</th>
        <th>재고</th>
      </tr>
    </thead>
    <tbody>
  <c:forEach var="prd" items="${productList}" varStatus="status">
    <tr onclick="location.href='product_edit.jsp?product_id=${prd.productId}'" 
        style="cursor:pointer; ${prd.stock == 0 ? 'background-color: #f0f0f0; color: red;' : ''}">
      <td>${status.index + 1}</td>
      <td><img src="${pageContext.request.contextPath}/admin/common/images/products/${prd.thumbnailImg}" width="40"
       onerror="this.onerror=null; this.src='<c:url value="/admin/common/images/default/error.png"/>';"></td>
      <td>${prd.name}</td>
      <td>${prd.redDate}</td>
      <td>${prd.modDate}</td>
      <td>${prd.price}원</td>
      <td>
        <c:choose>
          <c:when test="${prd.stock == 0}">
            <span style="color: red; font-weight: bold;">품절</span>
          </c:when>
          <c:otherwise>
            ${prd.stock}
          </c:otherwise>
        </c:choose>
      </td>
    </tr>
  </c:forEach>
  <c:if test="${empty productList}">
    <tr>
      <td colspan="7">검색된 상품이 없습니다.</td>
    </tr>
  </c:if>
</tbody>

  </table>
</div>
