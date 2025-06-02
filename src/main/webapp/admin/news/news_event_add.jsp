<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>이벤트 작성</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .container { margin-top: 30px; }
    .preview-img { width: 250px; height: auto; border: 1px solid #ccc; padding: 5px; }
    .form-section { padding-left: 50px; flex-grow: 1; }
    .form-label { font-weight: bold; }
  </style>
  <script>
  $(function(){
     // 썸네일 선택
     $("#btnImg").click(function(){
       $("#profileImg").click();
     });

     // 썸네일 미리보기
     $("#profileImg").change(function(evt){
       const file = evt.target.files[0];
       if (file) {
         const reader = new FileReader();
         reader.onload = function(e) {
           $("#img").prop("src", e.target.result);
         };
         reader.readAsDataURL(file);
         $("#imgName").val(file.name);
       }
     });

     // 상세설명 이미지 미리보기
     $("#detailImageInput").change(function(evt){
       const file = evt.target.files[0];
       if (file) {
         const reader = new FileReader();
         reader.onload = function(e) {
           $("#detailImgPreview").prop("src", e.target.result);
         };
         reader.readAsDataURL(file);
         $("#DetailImgName").val(file.name);
       }
     });

     // 등록 버튼 클릭 → form submit
     $("#btn").click(function(){
       $("#frm").submit();
     });
   });

  </script>
</head>
<body>
<div class="container">
  <h3 class="mb-4">이벤트 작성</h3>

 

  <form action="news_event_add_process.jsp" method="post" name="frm" id="frm" enctype="multipart/form-data">
    <div class="d-flex">
      <!-- 왼쪽: 이미지 미리보기 -->
      <div>
        <img src="${pageContext.request.contextPath}/admin/common/images_pse/default/no_img.png"
             id="img" class="preview-img mb-2" alt="썸네일 이미지">
        <br>
        <input type="button" value="썸네일 선택" id="btnImg" name="btnImg" class="btn btn-info btn-sm" style="margin-left: 75px;"/>
        <input type="hidden" name="imgName" id="imgName"/>
        <input type="file" name="profileImg" id="profileImg" style="display:none"/>
      </div>

      <!-- 오른쪽: 입력 폼 -->
      <div class="form-section">
      
       <!-- 메타 정보 테이블 (번호, 작성자, 작성일) -->
     <table class="table table-bordered mb-4" style="max-width: 900px;">
       <tr>
         <th style="width:120px;">작성일</th>
         <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %></td>
       </tr>
     </table>
  
        <div class="form-group mb-3">
          <label for="title">이벤트 제목</label>
          <input type="text" id="title" name="title" class="form-control" placeholder="이벤트 제목 입력">
        </div>

        <div class="form-group mb-4">
          <label class="form-label">상세설명 이미지</label>
          <br>
          <img src="${pageContext.request.contextPath}/admin/common/images_pse/default/no_img.png"
               id="detailImgPreview" class="preview-img mb-2" alt="상세 설명 이미지">
          <input type="hidden" name="DetailImgName" id="DetailImgName"/>
          <input type="file" name="eventImage" id="detailImageInput" class="form-control-file">
        </div>

        <div class="form-group d-flex justify-content-end gap-2">
          <button type="button" id="btn" name="btn" class="btn btn-primary">등록</button>
          <a href="javascript:history.back();" class="btn btn-secondary">뒤로</a>
        </div>
      </div>
    </div>
  </form>
</div>
</body>
</html>
