<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>
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
  body {
    background-color: #f9f9f9;
  }

  .main {
    padding: 40px 0;
  }

 #writeWrap {
  background: #ffffff;
  border-radius: 10px;
  padding: 40px;
  box-shadow: 0 0 12px rgba(0, 0, 0, 0.05);
  width: 100%;
  max-width: 1000px;
  margin: 0 20px;             /* 좌우 마진만 줘서 반응형 대응 */
  box-sizing: border-box;
}

  h3 strong {
    font-size: 24px;
    color: #2c3e50;
    margin-bottom: 30px;
    display: block;
  }

  .table th {
    background-color: #f2f2f2;
    text-align: center;
    color: #333;
    vertical-align: middle;
  }

  .table td {
    background-color: #fff;
    vertical-align: middle;
  }

  .form-group label {
    font-weight: 600;
    color: #333;
  }

  .form-control {
    border-radius: 6px;
    box-shadow: none;
    border: 1px solid #ccc;
  }

  .note-editor {
    border-radius: 6px;
    border: 1px solid #ddd;
  }

  .btn-primary, .btn-secondary {
    border-radius: 6px;
    padding: 8px 20px;
  }

  .btn-primary {
    background-color: #007bff;
    border-color: #007bff;
  }

  .btn-secondary {
    background-color: #6c757d;
    border-color: #6c757d;
    margin-left: 3px;
  }
</style>
<script type="text/javascript">
$(function(){
   $('#summernote').summernote({
	   placeholder: '내용을 입력해주세요.',
       tabsize: 2,
       height: 350,
       toolbar: [
         ['style', ['style']],
         ['font', ['bold', 'underline', 'clear']],
         ['color', ['color']],
         ['para', ['ul', 'ol', 'paragraph']],
         ['table', ['table']],
        // ['insert', ['picture']],
       ]
   });
   
   // 등록 버튼 클릭 → form submit
   $("#btn").click(function(){

	   const title = $("#title").val().trim();
	   const content = $('#summernote').summernote('isEmpty') ? '' : $('#summernote').summernote('code');

	     if (title === "") {
	       alert("제목을 입력해주세요.");
	       $("#title").focus();
	       return false;
	     }

	     const plainText = content
	     .replace(/<br\s*\/?>/gi, "")
	     .replace(/&nbsp;/gi, "")
	     .replace(/<[^>]*>/g, "")
	     .replace(/\u00a0/g, "")
	     .trim();

	   if (plainText === "") {
	     alert("내용을 입력해주세요.");
	     return false;
	   }
   	    
     $("#writeFrm").submit();
   });
});//ready
</script>
</head>

<body>
<div class="main">
  <div class="container-fluid">
 <div id="writeWrap">
    <form action="news_notice_add_process.jsp" method="post" id="writeFrm" name="writeFrm">

      <h3><strong>공지사항 작성</strong></h3>

		<!-- 정보 테이블  -->
	     <table class="table table-bordered mb-4" style="max-width: 1000px;">
	       <tr>
	         <th style="width:120px;">작성일</th>
	         <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %></td>
	       </tr>
	     </table>

      <div class="form-group mb-3">
        <label for="title">제목</label>
        <input type="text" name="title" id="title" class="form-control" placeholder="제목을 입력해주세요.">
      </div>

      <div class="form-group mb-3">
        <label for="summernote">내용</label>
        <textarea id="summernote" name="summernote"></textarea>
      </div>

      <div style="text-align: right;">
        <button type="button" id="btn" name="btn" class="btn btn-primary">등록</button>
        <a href="javascript:history.back();" class="btn btn-secondary">뒤로</a>
      </div>

    </form>
  </div>
</div>
</div>
</body>
