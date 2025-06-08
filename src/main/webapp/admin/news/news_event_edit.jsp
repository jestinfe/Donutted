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
	if (board == null) {
		%>
		    <script>
		        alert("해당 이벤트를 찾을 수 없습니다.");
		        history.back();
		    </script>
		<%
		    return;
		}

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
  body {
    background-color: #f9f9f9;
  }

  .container {
    margin: 40px 20px 0 240px;
    max-width: calc(100% - 260px);
    padding-right: 20px;
  }

  #writeWrap {
    background: #ffffff;
    border-radius: 10px;
    padding: 40px;
    box-shadow: 0 0 12px rgba(0, 0, 0, 0.05);
    width: 100%;
    max-width: 1000px;
    box-sizing: border-box;
    margin-left: 0;
  }

  h3 {
    font-size: 24px;
    color: #2c3e50;
    font-weight: bold;
    margin-bottom: 30px;
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

  .form-label {
    font-weight: bold;
  }

  .preview-img {
    width: 100%;
    max-width: 250px;
    height: auto;
    border: 1px solid #ccc;
    padding: 5px;
    display: block;
  }

  .flex-wrap-responsive {
    display: flex;
    flex-wrap: wrap;
    gap: 1rem;
  }

  .thumbnail-wrap {
    max-width: 250px;
    flex: 0 0 auto;
  }

  .form-section {
    flex: 1;
    padding-left: 30px;
    min-width: 0;
  }

  #title {
    width: 100%;
    max-width: 100%;
  }

  @media (max-width: 900px) {
    #title {
      max-width: 100% !important;
    }

    .form-section {
      padding-left: 0 !important;
      margin-top: 20px;
    }

    .flex-wrap-responsive {
      flex-direction: column;
    }

    .form-group.text-end {
      text-align: center !important;
    }

    .form-group.text-end .btn {
      width: 100%;
      margin-bottom: 10px;
    }

    #writeWrap {
      margin-left: 0;
      padding: 20px;
    }
  }
</style>

  <script>
  $(function () {
	  // 썸네일 선택
	  $("#btnImg").click(function () {
	    $("#profileImg").click();
	  });

	  // 원본 썸네일 이미지 경로 저장
	  const originalThumbnailSrc = $("#img").attr("src");

	  // 썸네일 미리보기 및 취소 시 복원
	  $("#profileImg").change(function (evt) {
	    const file = evt.target.files[0];

	    if (file) {
	      const reader = new FileReader();
	      reader.onload = function (e) {
	        $("#img").prop("src", e.target.result);
	      };
	      reader.readAsDataURL(file);
	    } else {
	      // 취소했을 경우 원본 이미지로 복원
	      $("#img").prop("src", originalThumbnailSrc);
	    }
	  });

	  // 상세설명 이미지
	  const originalDetailSrc = $("#detailImgPreview").attr("src");

	  $("#detailImageInput").change(function (evt) {
	    const file = evt.target.files[0];

	    if (file) {
	      const reader = new FileReader();
	      reader.onload = function (e) {
	        $("#detailImgPreview").prop("src", e.target.result);
	      };
	      reader.readAsDataURL(file);
	    } else {
	      $("#detailImgPreview").prop("src", originalDetailSrc);
	    }
	  });

      $('#modify').click(function(){
    	  const currentTitle = $("#title").val().trim();
    	  const originalTitle = "<%= board.getTitle().replaceAll("\"", "\\\"") %>";

    	  const thumbnailSelected = $("#profileImg")[0].files.length > 0;
    	  const detailSelected = $("#detailImageInput")[0].files.length > 0;

    	  const originalThumbnailExists = "<%= profileImg %>" !== "";
    	  const originalDetailExists = "<%= eventImage %>" !== "";

    	  // 제목 검증
    	  if (currentTitle === "") {
    	    alert("제목을 입력해주세요.");
    	    return false;
    	  }

    	  /* // 썸네일 이미지 검증
    	  if (!thumbnailSelected && !originalThumbnailExists) {
    	    alert("썸네일 이미지를 등록해주세요.");
    	    return false;
    	  }

    	  // 상세설명 이미지 검증
    	  if (!detailSelected && !originalDetailExists) {
    	    alert("상세설명 이미지를 등록해주세요.");
    	    return false;
    	  } */

    	  // 수정 사항이 없는 경우
    	  if (
    	    originalTitle === currentTitle &&
    	    !thumbnailSelected &&
    	    !detailSelected
    	  ) {
    	    alert("수정 사항이 존재하지 않습니다.");
    	    return false;
    	  }

    	  // 정상 제출
    	  $('#writeFrm').attr('action', '<%= contextPath %>/admin/news/news_event_edit_process.jsp');
    	  $("#writeFrm").submit();
      });

      $('#delete').click(function(){
        const board_id = <%= board.getBoard_id() %>;
        if (confirm("정말 삭제하시겠습니까?")) {
          $('#writeFrm').attr('action', '<%= contextPath %>/admin/news/news_event_delete_process.jsp?board_id=' + board_id);
          $("#writeFrm").submit();
        } else {
          alert("삭제가 취소되었습니다.");
        }
      });
    });
  </script>
</head>
<body>

<div class="container">
  <div id="writeWrap">
  <h3 class="mb-4">이벤트 수정</h3>

  <form action="<%= contextPath %>/admin/news/news_event_edit_process.jsp" method="post" name="writeFrm" id="writeFrm" enctype="multipart/form-data">
    <input type="hidden" name="board_id" value="<%= board.getBoard_id() %>">
    <input type="hidden" name="imgName" value="<%= board.getThumbnail_url() %>">
    <input type="hidden" name="detailImgName" value="<%= board.getDetail_image_url() %>">

    <div class="flex-wrap-responsive">
      <!-- 왼쪽: 이미지 미리보기 -->
     <div class="thumbnail-wrap">
        <img src="${pageContext.request.contextPath}/admin/common/images/news/<%= profileImg %>"
             id="img" class="preview-img mb-2" alt="썸네일 이미지"
             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/admin/common/images/default/loading.gif';">
        <br>
        <input type="button" value="썸네일 선택" id="btnImg" class="btn btn-info btn-sm" style="margin-left: 75px;">
        <input type="file" name="profileImg" id="profileImg" style="display:none">
      </div>

      <!-- 오른쪽: 입력 폼 -->
      <div class="form-section">

        <!-- 정보 테이블 -->
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

        <div class="form-group mb-3" style="max-width: 900px;">
		  <label for="title" class="form-label">이벤트 제목</label>
		  <input type="text" name="title" id="title" value="<%= board.getTitle() %>" class="form-control" placeholder="제목을 입력해주세요.">
		</div>

        <div class="form-group mb-4">
          <label class="form-label">상세설명 이미지</label>
          <br>
          <img src="${pageContext.request.contextPath}/admin/common/images/news/<%= eventImage %>"
               id="detailImgPreview" class="preview-img mb-2" alt="상세 설명 이미지"
               onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/admin/common/images/default/loading.gif';">
          <input type="file" name="eventImage" id="detailImageInput" class="form-control-file">
        </div>

        <!-- 버튼 영역 -->
        <div class="form-group text-end" style="max-width:900px;">
		  <button type="button" id="modify" class="btn btn-warning me-1">수정</button>
		  <button type="button" id="delete" class="btn btn-danger me-1">삭제</button>
		  <a href="javascript:history.back();" class="btn btn-secondary">뒤로</a>
		</div>

      </div>
    </div>
  </form>
</div>
</div>
</body>
</html>
