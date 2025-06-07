<%@page import="news.BoardDTO"%>
<%@page import="news.NewsService"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%
  String contextPath = request.getContextPath();

  String paramId = request.getParameter("board_id");
  int boardId = Integer.parseInt(paramId);
  
  NewsService service = new NewsService();
  BoardDTO board = service.getOneNotice(boardId);
  
  request.setAttribute("dto", board);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
 .btn-warning {
    color: #000;
  }
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
         //['insert', ['picture']],
       ]
   });
   
   $('#modify').click(function(){
	   // 원래 값 (서버에서 받아와 hidden input이나 data-* 속성에 저장) + null safe 코드 추가함
	   let originalTitle = "<%= board.getTitle() == null ? "" : board.getTitle().replaceAll("\"", "\\\\\"") %>";
   	   let originalContent = `<%= board.getContent() == null ? "" : board.getContent().replaceAll("`", "\\`") %>`;

	   // 현재 입력된 값
	   let currentTitle = $("#title").val().trim();
	   let currentContent = $("#summernote").val().trim();
	   
	   // 제목과 내용이 모두 변경되지 않은 경우
	   if (originalTitle.trim() === currentTitle && originalContent.trim() === currentContent) {
	      alert("수정 사항이 존재하지 않습니다.");
	      return false;
	   }
	   // 변경된 내용이 있다면 submit 진행
	   $('#writeFrm').attr('action', '<%= contextPath %>/admin/news/news_notice_edit_process.jsp');
	   $("#writeFrm").submit();
   })
   
   $('#delete').click(function(){

	   if (confirm("정말 삭제하시겠습니까?")) {
		   $('#writeFrm').attr('action', '<%= contextPath %>/admin/news/news_notice_delete_process.jsp');
		   $("#writeFrm").submit();
		} else {alert("삭제가 취소되었습니다.");
		    return;
	   }
	  
   })
});//ready
</script>
</head>

<body>
<div class="main">
 <div id="writeWrap" style="width:800px;">
    <form action="<%= contextPath %>/admin/news/news_notice_edit_process.jsp" method="post" id="writeFrm">
      <h3><strong>공지사항 수정</strong></h3>

	 <!-- 반드시 board_id 전달 -->
  <input type="hidden" name="board_id" value="<%= board.getBoard_id() %>">

 <!-- 메타 정보 테이블 -->
        <table class="table table-bordered mb-4" style="max-width: 900px;">
          <tr>
            <th style="width:100px;">번호</th>
            <td>${dto.board_id}</td>
            <th style="width:120px;">작성일</th>
            <td>${dto.posted_at}</td>
            <th style="width:120px;">조회수</th>
            <td>${dto.viewCount}</td>
          </tr>
        </table>

      <div class="form-group mb-3">
        <label for="title">제목</label>
        <input type="text" name="title" id="title" 
        value="<%= board.getTitle() %>" class="form-control" placeholder="제목을 입력해주세요.">
      </div>

      <div class="form-group mb-3">
        <label for="summernote">내용</label>
        <textarea id="summernote" name="content"><%= board.getContent() %></textarea>
      </div>

      <div style="text-align: right;">
        <button type="button" id="modify" formaction="news_notice_edit_process.jsp" class="btn btn-warning">수정</button>
    	<button type="button" id="delete" formaction="news_notice_delete_process.jsp" class="btn btn-danger">삭제</button>
   		<a href="javascript:history.back();" class="btn btn-secondary">뒤로</a>
      </div>

    </form>
  </div>
</div>
</body>
