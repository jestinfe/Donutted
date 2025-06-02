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
        
    	/* $("#profileImg").change(function(evt){
    	  	  const file = evt.target.files[0];
    	  	  if (!file) return;

    	  	  const ext = file.name.split(".").pop().toLowerCase();
    	  	  const allowed = ["jpg", "gif", "png", "bmp"];

    	  	  if (!allowed.includes(ext)) {
    	  	    alert("업로드 가능한 파일이 아닙니다.");
    	  	    resetFileInput("profileImg"); // 선택 초기화
    	  	    return;
    	  	  }

    	  	  const formData = new FormData();
    	  	  formData.append("profileImg", file);
    	});//change */
        
        
    	 // AJAX 업로드
        const formData = new FormData();
        formData.append("thumbnail_img", file);
        
        $.ajax({
            url: "news_event_add_process.jsp",
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
      
      
      // 상세설명 이미지 미리보기
      $("#detailImageInput").change(function(evt){
        const file = evt.target.files[0];
        const reader = new FileReader();
        reader.onload = function(e) {
          $("#detailImgPreview").prop("src", e.target.result);
        };
        if (file) {
          reader.readAsDataURL(file);
          $("#DetailImgName").val(file.name);
        }
        
      // AJAX 업로드
      const formData = new FormData();
      formData.append("detail_img", file);

      $.ajax({
        url: "news_event_add_process.jsp",
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
      });//ajax
        
      });//상세설명
      
      $("#btn").click(function(){
    		
    		$("#frm").submit();
  		
  	});//click
      
  		/* var blockExt=["jpg","gif","png","bmp"];
  		
  		var blockFlag=false;
  		
  	  // 썸네일 이미지 확장자 확인
  		var ext=$("#profileImg").val();
  		
  		var getExt= ext.substring(ext.lastIndexOf(".")+1);
  		
  		for (var i=0 ; i < blockExt.length ; i++ ) {
  			if (blockExt[i] == getExt.toLowerCase()) {
  				blockFlag=true;
  				break;
  			}//end if
  		}//end for
  		
  		if (!blockFlag) {
  			alert("업로드 가능한 파일이 아닙니다. jpg, gif, bmp, png만 가능합니다.");
  			return;
  		}//end if */
  
  	
    });//ready
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
