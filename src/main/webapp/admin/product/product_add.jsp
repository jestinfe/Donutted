<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="product.CategoryDTO, product.CategoryService" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../common/login_check.jsp" %>

<%
  String contextPath = request.getContextPath();
  pageContext.setAttribute("contextPath", contextPath);

  CategoryService categoryService = new CategoryService();
  pageContext.setAttribute("categoryList", categoryService.getAllCategories());
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>상품 등록</title>
  <%@ include file="../common/external_file.jsp" %>
</head>
<body>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>

<div class="main container mt-4">
  <h3>상품 관리 - 상품 등록</h3>

  <form id="productForm" method="post" action="product_add_process.jsp" enctype="multipart/form-data" class="card p-4">
    <h5>상품 기본정보</h5>
    <div class="row mb-3">
      <label class="col-sm-2 col-form-label">상품명</label>
      <div class="col-sm-10">
        <input type="text" class="form-control" name="name" required>
      </div>
    </div>

    <div class="row mb-3">
      <label class="col-sm-2 col-form-label">카테고리</label>
      <div class="col-sm-10">
        <select class="form-select" name="categoryId" required>
          <c:forEach var="cat" items="${categoryList}">
            <option value="${cat.categoryId}">${cat.categoryName}</option>
          </c:forEach>
        </select>
      </div>
    </div>

    <div class="row mb-3">
      <label class="col-sm-2 col-form-label">가격</label>
      <div class="col-sm-4">
        <input type="number" class="form-control" name="price" required>
      </div>
      <label class="col-sm-2 col-form-label">재고량</label>
      <div class="col-sm-4">
        <input type="number" class="form-control" name="stock" required>
      </div>
    </div>

    <h5>상품 이미지</h5>

    <%
  String[] fileFields = {
    "thumbnailFile", "detailFile", "thumbnailHoverFile",
    "productImg1File", "productImg2File", "productImg3File", "productImg4File",
    "detailImg2File", "detailImg3File", "detailImg4File"
  };
  String[] fileLabels = {
    "썸네일 이미지", "상세설명 이미지", "썸네일 마우스오버 이미지",
    "추가 이미지 1", "추가 이미지 2", "추가 이미지 3", "추가 이미지 4",
    "상세 이미지 2", "상세 이미지 3", "상세 이미지 4"
  };
%>

<% for (int i = 0; i < fileFields.length; i++) { %>
  <div class="row mb-3">
    <label class="col-sm-2 col-form-label"><%= fileLabels[i] %></label>
    <div class="col-sm-10">
      <img id="<%= fileFields[i] %>_preview" src="" width="100" class="mb-2" style="display:none;">
      <input type="file" class="form-control"
             name="<%= fileFields[i] %>" id="<%= fileFields[i] %>"
             accept="image/*"
             onchange="previewImage(this, '<%= fileFields[i] %>_preview')">
    </div>
  </div>
<% } %>

    

    <div class="text-end">
      <button type="submit" class="btn btn-success">등록하기</button>
      <button type="reset" class="btn btn-secondary">취소</button>
    </div>
  </form>
</div>

<script>
  function previewImage(input, previewId) {
    const file = input.files[0];
    const preview = document.getElementById(previewId);

    if (!file || !file.type.startsWith("image/")) {
      preview.style.display = "none";
      input.value = "";
      return;
    }

    const reader = new FileReader();
    reader.onload = function (e) {
      preview.src = e.target.result;
      preview.style.display = "block";
    };
    reader.readAsDataURL(file);
  }
</script>
</body>
</html>
