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

  String thumbnail = (product.getThumbnailImg() != null && !product.getThumbnailImg().trim().isEmpty())
      ? product.getThumbnailImg() : "default.jpg";

  String detailImg = (product.getDetailImg() != null && !product.getDetailImg().trim().isEmpty())
      ? product.getDetailImg() : "detail.jpg";
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title><%= product.getName() != null ? product.getName() : "상품 정보 수정" %></title>
</head>
<body>
<div class="main">
  <h3>상품 관리 - 상품 정보 수정</h3>

  <form action="<%= contextPath %>/admin/product/product_edit_process.jsp"
        method="post" enctype="multipart/form-data" class="card p-4"
        onsubmit="return confirm('정말 수정하시겠습니까?');">

    <!-- 필수 ID -->
    <input type="hidden" name="product_id" value="<%= product.getProductId() %>">

    <!-- 기존 이미지 파일명 전송 -->
    <input type="hidden" name="thumdnailImg" value="<%= product.getThumbnailImg() %>">
    <input type="hidden" name="detailImg" value="<%= product.getDetailImg() %>">

    <!-- 기본정보 -->
    <h5>상품 기본정보</h5>
    <div class="row mb-3">
      <label class="col-sm-2 col-form-label">상품명</label>
      <div class="col-sm-10">
        <input type="text" class="form-control" name="product_name" required
               value="<%= product.getName() != null ? product.getName() : "" %>">
      </div>
    </div>

    <div class="row mb-3">
      <label class="col-sm-2 col-form-label">카테고리</label>
      <div class="col-sm-10">
        <select class="form-select" name="category_id">
          <%
            for (CategoryDTO cat : categoryList) {
              boolean selected = (product.getCategoryId() == cat.getCategoryId());
          %>
            <option value="<%= cat.getCategoryId() %>" <%= selected ? "selected" : "" %>>
              <%= cat.getCategoryName() %>
            </option>
          <%
            }
          %>
        </select>
      </div>
    </div>

    <div class="row mb-3">
      <label class="col-sm-2 col-form-label">가격</label>
      <div class="col-sm-4">
        <input type="number" class="form-control" name="price" required value="<%= product.getPrice() %>">
      </div>
      <label class="col-sm-2 col-form-label">재고량</label>
      <div class="col-sm-4">
        <input type="number" class="form-control" name="stock" required value="<%= product.getStock() %>">
      </div>
    </div>

    <!-- 이미지 -->
    <h5>상품 이미지</h5>
    <div class="mb-3">
      <label class="form-label">기본 이미지</label><br>
      <img id="preview_main" src="<%= contextPath %>/admin/common/upload/<%= thumbnail %>" width="100" class="mb-2"><br>
      <input type="file" class="form-control" name="main_img" onchange="previewImage(this, 'preview_main')">
    </div>

    <div class="mb-4">
      <label class="form-label">상세설명 이미지</label><br>
      <img id="preview_detail" src="<%= contextPath %>/admin/common/upload/<%= detailImg %>" width="100" class="mb-2"><br>
      <input type="file" class="form-control" name="detail_img" onchange="previewImage(this, 'preview_detail')">
    </div>

    <!-- 버튼 -->
    <div class="d-flex justify-content-between">
      <div>
        <button class="btn btn-success me-2" type="submit">수정하기</button>
        <button class="btn btn-danger" type="button" onclick="deleteProduct(<%= product.getProductId() %>)">삭제하기</button>
      </div>
      <button class="btn btn-secondary" type="button" onclick="history.back()">뒤로</button>
    </div>
  </form>
</div>

<!-- 스크립트 -->
<script>
function previewImage(input, previewId) {
  const file = input.files[0];
  if (!file) return;
  const reader = new FileReader();
  reader.onload = function(e) {
    document.getElementById(previewId).src = e.target.result;
  };
  reader.readAsDataURL(file);
}

function deleteProduct(productId) {
  if (confirm("정말 삭제하시겠습니까?")) {
    location.href = "<%= contextPath %>/admin/product/product_delete_process.jsp?product_id=" + productId;
  }
}
</script>
</body>
</html>
