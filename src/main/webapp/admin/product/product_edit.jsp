<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="product.ProductDTO, product.ProductService" %>
<%@ page import="product.CategoryDTO, product.CategoryService" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>

<%
String paramId = request.getParameter("product_id");
if (paramId == null) {
%>
<div class="main">
  <h4 style="color: red;">❗ 오류: product_id 파라미터가 없습니다.</h4>
  <button class="btn btn-secondary mt-3" onclick="history.back()">돌아가기</button>
</div>
<%
  return;
}

int productId = Integer.parseInt(paramId);
ProductService service = new ProductService();
ProductDTO product = service.getProductById(productId);
String contextPath = request.getContextPath();
CategoryService categoryService = new CategoryService();
java.util.List<CategoryDTO> categoryList = categoryService.getAllCategories();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>상품 수정</title>
</head>
<body>
<div class="main container mt-4">
  <h3>상품 관리 - 상품 정보 수정</h3>
  <form action="product_edit_process.jsp" method="post" enctype="multipart/form-data" class="card p-4">
    <input type="hidden" name="product_id" value="<%= product.getProductId() %>">

    <div class="row mb-3">
      <label class="col-sm-2 col-form-label">상품명</label>
      <div class="col-sm-10">
        <input type="text" class="form-control" name="name" value="<%= product.getName() %>" required>
      </div>
    </div>

    <div class="row mb-3">
      <label class="col-sm-2 col-form-label">카테고리</label>
      <div class="col-sm-10">
        <select class="form-select" name="category_id">
          <% for (CategoryDTO cat : categoryList) { %>
            <option value="<%= cat.getCategoryId() %>" <%= product.getCategoryId() == cat.getCategoryId() ? "selected" : "" %>>
              <%= cat.getCategoryName() %>
            </option>
          <% } %>
        </select>
      </div>
    </div>

    <div class="row mb-3">
      <label class="col-sm-2 col-form-label">가격</label>
      <div class="col-sm-4">
        <input type="number" class="form-control" name="price" value="<%= product.getPrice() %>" required>
      </div>
      <label class="col-sm-2 col-form-label">재고량</label>
      <div class="col-sm-4">
        <input type="number" class="form-control" name="stock" value="<%= product.getStock() %>" required>
      </div>
    </div>

    <h5>상품 이미지</h5>
<%
String[] fields = {
  "thumbnailImg", "detailImg", "thumbnailHover",
  "productImg1", "productImg2", "productImg3", "productImg4",
  "detailImg2", "detailImg3", "detailImg4"
};
String[] labels = {
  "썸네일 이미지", "상세설명 이미지", "썸네일 마우스오버",
  "추가 이미지 1", "추가 이미지 2", "추가 이미지 3", "추가 이미지 4",
  "상세 이미지 2", "상세 이미지 3", "상세 이미지 4"
};
for (int i = 0; i < fields.length; i++) {
	  String field = fields[i];
	  String label = labels[i];
	  String value = (String) ProductDTO.class.getMethod("get" + field.substring(0,1).toUpperCase() + field.substring(1)).invoke(product);
	  boolean hasImage = (value != null && !value.trim().isEmpty() && !value.equalsIgnoreCase("null"));
	%>
	  <div class="mb-3">
	    <label class="form-label"><%= label %></label><br>

	   <img id="preview_<%= field %>" 
     src="<%= hasImage ? (contextPath + "/admin/common/images/products/" + value) : "" %>" 
     width="100" class="mb-2"
     style="<%= hasImage ? "" : "display:none;" %>"
     onerror="this.onerror=null; this.src='<%= contextPath %>/admin/common/images/default/error.png';">


	    <span id="noimg_<%= field %>" class="text-muted" style="<%= hasImage ? "display:none;" : "" %>">이미지 없음</span><br>

	    <% if (i >= 2 && hasImage) { %>
	      <div class="form-check mt-2">
	        <input class="form-check-input" type="checkbox" name="delete_<%= field %>" value="true" id="delete_<%= field %>">
	        <label class="form-check-label" for="delete_<%= field %>">기존 이미지 삭제</label>
	      </div>
	    <% } %>

	    <input type="file" name="<%= field %>File" id="<%= field %>File" class="form-control d-none" accept="image/*"
	           onchange="previewImage(this, 'preview_<%= field %>')">
	    <button type="button" class="btn btn-outline-primary btn-sm mt-2"
	            onclick="document.getElementById('<%= field %>File').click();">이미지 선택</button>
	  </div>
	<% } %>

    <div class="text-end">
      <button class="btn btn-success me-2" type="submit">수정 완료</button>
      <button class="btn btn-secondary" type="button" onclick="history.back()">뒤로</button>
    </div>
  </form>
</div>

<script>
function previewImage(input, previewId) {
  const file = input.files[0];
  if (!file) return;
  const reader = new FileReader();
  reader.onload = function(e) {
    const img = document.getElementById(previewId);
    img.src = e.target.result;
    img.style.display = "inline-block";

    const span = document.getElementById("noimg_" + previewId.replace("preview_", ""));
    if (span) span.style.display = "none";
  };
  reader.readAsDataURL(file);
}
</script>

</body>
</html>