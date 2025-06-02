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

  <script type="text/javascript">
    // ✅ 이미지 미리보기 + 업로드
    function setupImageUpload(fileInputId, previewImgId, hiddenInputId, defaultImgSrc) {
      $("#" + fileInputId).change(function (evt) {
        const file = evt.target.files[0];
        if (!file) return;

        // 미리보기
        const reader = new FileReader();
        reader.onload = function (e) {
          $("#" + previewImgId).attr("src", e.target.result);
        };
        reader.readAsDataURL(file);

        // AJAX 업로드
        const formData = new FormData();
        formData.append("productImg", file);

        $.ajax({
          url: "product_image_upload.jsp",
          type: "post",
          data: formData,
          processData: false,
          contentType: false,
          dataType: "json",
          success: function (json) {
            if (json.resultFlag) {
              $("#" + hiddenInputId).val(json.fileName);
            } else {
              alert("업로드 실패: " + json.error);
              $("#" + previewImgId).attr("src", defaultImgSrc);
              $("#" + hiddenInputId).val("");
              resetFileInput(fileInputId); // 에러 시 파일 선택 초기화
            }
          }
        });
      });
    }

    // ✅ 파일 선택 초기화
    function resetFileInput(fileInputId) {
      const oldInput = document.getElementById(fileInputId);
      const newInput = oldInput.cloneNode(true);
      oldInput.parentNode.replaceChild(newInput, oldInput);
    }

    // ✅ 이미지 + hidden input 초기화
    function resetImageUpload(fileInputId, previewImgId, hiddenInputId, defaultImgSrc) {
      resetFileInput(fileInputId);
      $("#" + previewImgId).attr("src", defaultImgSrc);
      $("#" + hiddenInputId).val("");
    }

    // ✅ 초기화 버튼 동작
    function cancelUpload() {
      resetImageUpload("main_img_file", "main_img_preview", "main_img_name", "${contextPath}/admin/common/upload/default.jpg");
      resetImageUpload("detail_img_file", "detail_img_preview", "detail_img_name", "${contextPath}/admin/common/upload/default_detail.jpg");
    }

    $(function () {
      setupImageUpload("main_img_file", "main_img_preview", "main_img_name", "${contextPath}/admin/common/upload/default.jpg");
      setupImageUpload("detail_img_file", "detail_img_preview", "detail_img_name", "${contextPath}/admin/common/upload/default_detail.jpg");

      $("#btnSubmit").click(function () {
        if (!$("#main_img_name").val() || !$("#detail_img_name").val()) {
          alert("이미지를 모두 업로드해주세요.");
          return;
        }
        if (confirm("상품을 등록하시겠습니까?")) {
          $("#productForm").submit();
        }
      });

      $("#btnCancel").click(function () {
        cancelUpload();
      });
    });
  </script>
</head>

<body>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>

<div class="main container mt-4">
  <h3>상품 관리 - 상품 등록</h3>

  <form id="productForm" method="post" action="product_add_process.jsp" class="card p-4">
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
    <div class="row mb-3">
      <label class="col-sm-2 col-form-label">기본 이미지</label>
      <div class="col-sm-10">
        <img id="main_img_preview" src="${contextPath}/admin/common/upload/default.jpg" width="100" class="mb-2">
        <input type="file" class="form-control" id="main_img_file">
        <input type="hidden" name="thumbnailImg" id="main_img_name">
      </div>
    </div>

    <div class="row mb-3">
      <label class="col-sm-2 col-form-label">상세 설명 이미지</label>
      <div class="col-sm-10">
        <img id="detail_img_preview" src="${contextPath}/admin/common/upload/default.jpg" width="100" class="mb-2">
        <input type="file" class="form-control" id="detail_img_file">
        <input type="hidden" name="detailImg" id="detail_img_name">
      </div>
    </div>

    <div class="text-end">
      <button type="button" class="btn btn-success" id="btnSubmit">등록하기</button>
      <button type="button" class="btn btn-secondary" id="btnCancel">취소</button>
    </div>
  </form>
</div>
</body>
</html>
