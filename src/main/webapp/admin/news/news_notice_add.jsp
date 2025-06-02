<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
  <title>공지사항 작성</title>
<!-- summernote -->
<!-- include libraries(jQuery, bootstrap) -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<!-- include summernote css/js -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote.min.js"></script>
<!-- summernote -->
<style>

</style>
<script type="text/javascript">
$(function(){
   $('#summernote').summernote({
	   placeholder: '내용을 입력해주세요.',
       tabsize: 2,
       height: 120,
       toolbar: [
         ['style', ['style']],
         ['font', ['bold', 'underline', 'clear']],
         ['color', ['color']],
         ['para', ['ul', 'ol', 'paragraph']],
         ['table', ['table']],
        // ['insert', ['picture']],
       ]
   });
   
});//ready
</script>
</head>

<body>
<div class="main">
 <div id="writeWrap" style="width:800px;">
    <form action="news_notice_add_process.jsp" method="post" id="writeFrm">

      <h3><strong>공지사항 작성</strong></h3>

      <div class="form-group mb-3">
        <label for="title">제목</label>
        <input type="text" name="title" id="title" class="form-control" placeholder="제목을 입력해주세요.">
      </div>

      <div class="form-group mb-3">
        <label for="summernote">내용</label>
        <textarea id="summernote" name="summernote"></textarea>
      </div>

      <div style="text-align: right;">
        <button type="submit" class="btn btn-primary">등록</button>
        <a href="javascript:history.back();" class="btn btn-secondary">뒤로</a>
      </div>

    </form>
  </div>
</div>
</body>
