<%@page import="news.BoardDTO"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>
<%
BoardDTO bDTO=new BoardDTO();
request.setAttribute("bDTO", bDTO);
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>이벤트 작성</title>
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

@media (max-width: 900px) {
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
  $(function(){

     // 썸네일 선택
     $("#btnImg").click(function(){
       $("#profileImg").click();
     });
     
     // 썸네일 미리보기
     let originalThumbnailSrc = $("#img").attr("src");
     let originalThumbnailName = $("#imgName").val();
     
     $("#profileImg").change(function(evt){
       const file = evt.target.files[0];
       
       if (file) {
         const reader = new FileReader();
         reader.onload = function(e) {
           $("#img").prop("src", e.target.result);
         };
         
         reader.readAsDataURL(file);
         $("#imgName").val(file.name);
       } else {
    	// 사용자가 파일 선택 후 취소한 경우 기존 이미지 복원
    	 $("#img").prop("src", originalThumbnailSrc);
    	 $("#imgName").val(originalThumbnailName);
       }
     });

     // 상세설명 이미지 미리보기
     let originalDetailSrc = $("#detailImgPreview").attr("src");
	 let originalDetailName = $("#DetailImgName").val();

     $("#detailImageInput").change(function(evt){
       const file = evt.target.files[0];
       
       if (file) {
         const reader = new FileReader();
         reader.onload = function(e) {
           $("#detailImgPreview").prop("src", e.target.result);
         };
         reader.readAsDataURL(file);
         $("#DetailImgName").val(file.name);
       } else {
    	 $("#detailImgPreview").prop("src", originalDetailSrc);
    	 $("#DetailImgName").val(originalDetailName);
       }
     });

  
     // 등록 버튼 클릭 → form submit
     $("#btn").click(function(){

    	 if ($("#title").val().trim() === "") {
    		    alert("제목을 입력해주세요.");
    		    return;
    		  }

    		  if (!$("#profileImg")[0].files[0]) {
    		    alert("썸네일 이미지를 등록해주세요.");
    		    return;
    		  }

    		  if (!$("#detailImageInput")[0].files[0]) {
    		    alert("상세설명 이미지를 등록해주세요.");
    		    return;
    		  }
     	    
       $("#frm").submit();
     });
   });

  </script>
</head>
<body>
<div class="container">
  <div id="writeWrap">
    <h3 class="mb-4">이벤트 작성</h3>

    <form action="news_event_add_process.jsp" method="post" name="frm" id="frm" enctype="multipart/form-data">
      <div class="flex-wrap-responsive">
        <!-- 썸네일 미리보기 -->
        <div class="thumbnail-wrap">
          <img src="${pageContext.request.contextPath}/admin/common/images/default/no_img.png"
               id="img" class="preview-img mb-2" alt="썸네일 이미지">
          <input type="button" value="썸네일 선택" id="btnImg" name="btnImg" class="btn btn-info btn-sm" style="margin-left: 75px;"/>
          <input type="hidden" name="imgName" id="imgName"/>
          <input type="file" name="profileImg" id="profileImg" style="display:none"/>
        </div>

        <!-- 오른쪽 입력 폼 -->
        <div class="form-section">
          <table class="table table-bordered mb-4" style="max-width: 900px;">
            <tr>
              <th style="width:120px;">작성일</th>
              <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %></td>
            </tr>
          </table>

          <div class="form-group mb-3">
            <label for="title" class="form-label">이벤트 제목</label>
            <input type="text" id="title" name="title" class="form-control" placeholder="이벤트 제목 입력">
          </div>

          <div class="form-group mb-4">
            <label class="form-label">상세설명 이미지</label><br>
            <img src="${pageContext.request.contextPath}/admin/common/images/default/no_img.png"
                 id="detailImgPreview" class="preview-img mb-2" alt="상세 설명 이미지">
            <input type="hidden" name="DetailImgName" id="DetailImgName"/>
            <input type="file" name="eventImage" id="detailImageInput" class="form-control-file">
          </div>

          <div class="form-group text-end" style="max-width:900px;">
            <button type="button" id="btn" name="btn" class="btn btn-primary me-1">등록</button>
            <a href="javascript:history.back();" class="btn btn-secondary">뒤로</a>
          </div>
        </div>
      </div>
    </form>
  </div>
</div>

</body>
</html>
