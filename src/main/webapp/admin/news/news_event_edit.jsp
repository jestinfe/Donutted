<%@page import="news.BoardDTO"%>
<%@page import="news.NewsService"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
  	String contextPath = request.getContextPath();

	String paramId = request.getParameter("board_id");
	int boardId = Integer.parseInt(paramId);
	
	NewsService service = new NewsService();
	BoardDTO board = service.getOneEvent(boardId);
	
	String profileImg = board.getThumbnail_url();
	String eventImage = board.getDetail_image_url();
	
	request.setAttribute("dto", board);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>이벤트 수정</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .container { margin-top: 30px; }
    .preview-img { width: 250px; height: auto; border: 1px solid #ccc; padding: 5px; }
    .form-section { padding-left: 50px; flex-grow: 1; }
    .form-label { font-weight: bold; }
  </style>
  <script>
    $(function(){
      // 썸네일 선택 및 미리보기
      $("#btnImg").click(function(){
        $("#profileImg").click();
      });
      $("#profileImg").change(function(evt){
        const file = evt.target.files[0];
        const reader = new FileReader();
        reader.onload = function(e) {
          $("#img").prop("src", e.target.result);
        };
        if (file) {
          reader.readAsDataURL(file);
          $("#imgName").val(file.name);
        }
      });

      // 상세설명 이미지 미리보기
      $("#detailImageInput").change(function(evt){
        const file = evt.target.files[0];
        const reader = new FileReader();
        reader.onload = function(e) {
          $("#detailImgPreview").prop("src", e.target.result);
        };
        if (file) {
          reader.readAsDataURL(file);
        }
      });
      
      //수정하기
      $('#modify').click(function(){
      const originalTitle = "<%= board.getTitle().replaceAll("\"", "\\\"") %>";
      const currentTitle = $("#title").val().trim();
   	   
   	   
      if (originalTitle === currentTitle &&
 			!$("#profileImg").val() && !$("#detailImageInput").val()) {
    	   	alert("수정 사항이 존재하지 않습니다.");
    	   	return false;
      }
   	   
   	   // 변경된 내용이 있다면 submit 진행
   	   $('#writeFrm').attr('action', '<%= contextPath %>/admin/news/news_event_edit_process.jsp');
   	   $("#writeFrm").submit();
      })
      
      $('#delete').click(function(){

    	  const board_id = <%= board.getBoard_id() %>;
   	   if (confirm("정말 삭제하시겠습니까?")) {
   		   $('#writeFrm').attr('action', '<%= contextPath %>/admin/news/news_event_delete_process.jsp?board_id=' +board_id);
   		   
   		   $("#writeFrm").submit();
   		   
   			} else {
				alert("삭제가 취소되었습니다.");
   		    
				return;
   	   		}
      });
   	   
    });//ready
  </script>
</head>
<body>

<div class="container">
  <h3 class="mb-4">이벤트 수정</h3>

  <form action="<%= contextPath %>/admin/news/news_event_edit_process.jsp" method="post" name="writeFrm" id="writeFrm" enctype="multipart/form-data" >
	<input type="hidden" name="board_id" value="<%= board.getBoard_id() %>">
    <input type="hidden" name="imgName" value="<%= board.getThumbnail_url() %>">
	<input type="hidden" name="detailImgName" value="<%= board.getDetail_image_url() %>">
    <div class="d-flex">
    
      <!-- 왼쪽: 썸네일 이미지 미리보기 -->
      <div>
        <img src="${pageContext.request.contextPath}/admin/common/images/news/<%= profileImg %>"
         id="img" class="preview-img mb-2" alt="썸네일 이미지"
         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/admin/common/images/default/loading.gif';">    
    	 <%-- <img src="${pageContext.request.contextPath}/admin/common/images/default/loading.jpg"
	     data-src="${pageContext.request.contextPath}/admin/common/images/news/<%= profileImg %>"
	     id="img" class="preview-img mb-2" alt="썸네일 이미지"
	     onload="this.src=this.getAttribute('data-src')"
	     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/admin/common/images/default/error.png';"> --%>  
        <br>
        <input type="button" value="썸네일 선택" id="btnImg" class="btn btn-info btn-sm" style="margin-left: 75px;"/>
        <!-- <input type="hidden" name="imgName" id="imgName"/> -->
        <input type="file" name="profileImg" id="profileImg" style="display:none"/>
      </div>

      <!-- 오른쪽: 입력 폼 -->
      <div class="form-section">
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

        <!-- 이벤트 제목 -->
        <div class="form-group mb-3">
          <label class="form-label">이벤트 제목</label>
          <input type="text" name="title" id="title" value="<%= board.getTitle() %>" class="form-control" placeholder="제목을 입력해주세요." >
        </div>

        <!-- 상세설명 이미지 업로드 & 미리보기 -->
        <div class="form-group mb-4">
          <label class="form-label">상세설명 이미지</label>
          <br>
         	<img src="${pageContext.request.contextPath}/admin/common/images/news/<%= eventImage %>"
            id="detailImgPreview" class="preview-img mb-2" alt="상세 설명 이미지"
            onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/admin/common/images/default/loading.gif';">
      		 <%-- <img src="${pageContext.request.contextPath}/admin/common/images/default/loading.jpg"
		     data-src="${pageContext.request.contextPath}/admin/common/images/news/<%= eventImage %>"
		     id="detailImgPreview" class="preview-img mb-2" alt="상세 설명 이미지"
		     onload="this.src=this.getAttribute('data-src')"
		     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/admin/common/images/default/error.png';">  --%>
          <input type="file" name="eventImage" id="detailImageInput" class="form-control-file">
        </div>

        <!-- 버튼 그룹 -->
        <div class="form-group d-flex justify-content-end gap-2">
          <button type="button" id="modify" formaction="news_event_edit_process.jsp" class="btn btn-warning">수정</button>
          <button type="button" id="delete" formaction="news_event_delete_process.jsp" class="btn btn-danger">삭제</button>
          <a href="javascript:history.back();" class="btn btn-secondary">뒤로</a>
        </div>
      </div>
    </div>
  </form>
</div>
</body>
</html>