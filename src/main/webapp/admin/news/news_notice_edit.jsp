<%@page import="news.BoardDTO"%>
<%@page import="news.NewsService"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>
<%
  String contextPath = request.getContextPath();

  String paramId = request.getParameter("board_id");
  int boardId = Integer.parseInt(paramId);
  
  NewsService service = new NewsService();
  BoardDTO board = service.getOneNotice(boardId);
  if (board == null) {
		%>
		    <script>
		        alert("해당 공지사항을 찾을 수 없습니다.");
		        history.back();
		    </script>
		<%
		    return;
		}
  
  request.setAttribute("dto", board);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 수정</title>
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
    display: flex;
    justify-content: flex-start;
  }

  #writeWrap {
  background: #ffffff;
  border-radius: 10px;
  padding: 40px;
  box-shadow: 0 0 12px rgba(0, 0, 0, 0.05);
  margin-left: 40px;
  width: 100%;              /* 화면 폭에 맞춰 확장 */
  max-width: 1000px;        /* 최대 폭 제한 */
  box-sizing: border-box;   /* 패딩 포함 폭 계산 */
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

  .btn {
    border-radius: 6px;
    padding: 8px 20px;
    margin-right: 3px;
  }

  .btn-warning {
    background-color: #ffc107;
    border-color: #ffc107;
    color: #000;
  }

  .btn-danger {
    background-color: #dc3545;
    border-color: #dc3545;
    color: #fff;
  }

  .btn-secondary {
    background-color: #6c757d;
    border-color: #6c757d;
    color: #fff;
  }

  .btn-container {
    text-align: left;
    margin-top: 20px;
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
         //['insert', ['picture']],
       ]
   });
   
   $('#modify').click(function(){
	   let originalTitle = "<%= board.getTitle() == null ? "" : board.getTitle().replaceAll("\"", "\\\\\"") %>";
	   let originalContent = `<%= board.getContent() == null ? "" : board.getContent().replaceAll("`", "\\`").replaceAll("\"", "\\\"") %>`;
	
	   let currentTitle = $("#title").val().trim();
	   let currentContent = $('#summernote').summernote('code').trim();
	
	   if (currentTitle === "") {
	     alert("제목을 입력해주세요.");
	     $("#title").focus();
	     return false;
	   }
	
	   let plainText = currentContent
	     .replace(/<br\s*\/?>/gi, "")
	     .replace(/&nbsp;/gi, "")
	     .replace(/<[^>]*>/g, "")
	     .replace(/\u00a0/g, "")
	     .trim();
	
	   if (plainText === "") {
	     alert("내용을 입력해주세요.");
	     return false;
	   }
	
	   if (originalTitle.trim() === currentTitle && originalContent.trim() === currentContent) {
	     alert("수정 사항이 존재하지 않습니다.");
	     return false;
	   }
	
	   $('#writeFrm').attr('action', '<%= contextPath %>/admin/news/news_notice_edit_process.jsp');
	   $("#writeFrm").submit();
   });
   
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
 <div id="writeWrap">
    <form action="<%= contextPath %>/admin/news/news_notice_edit_process.jsp" method="post" id="writeFrm">
      <h3><strong>공지사항 수정</strong></h3>

	 <!-- 반드시 board_id 전달 -->
  <input type="hidden" name="board_id" value="<%= board.getBoard_id() %>">

 <!-- 메타 정보 테이블 -->
       <table class="table table-bordered mb-4" style="max-width: 1000px;">
	  <tr>
	    <th style="width:120px;">번호</th>
	    <td style="width:150px;">${dto.board_id}</td>
	    <th style="width:120px;">작성일</th>
	    <td style="width:250px;">${dto.posted_at}</td>
	    <th style="width:120px;">조회수</th>
	    <td style="width:150px;">${dto.viewCount}</td>
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
