<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>
<%@ include file="../common/external_file.jsp" %>

<head>
<title>관리자 faq 등록</title>
</head>
<div class="main">
  <h3>FAQ (등록)</h3>
  <form action="faq_process.jsp" method="post" onsubmit="return validateForm()">
    <div class="mb-3">
      <label class="form-label">제목 :</label>
      <input type="text" name="title" class="form-control" placeholder="질문을 입력해주세요.">
    </div>
    <div class="mb-3">
      <label class="form-label">내용:</label>
      <textarea name="content" class="form-control" rows="6" placeholder="답변을 입력해주세요."></textarea>
    </div>

    <!-- 관리자 로그인 없이 사용하기 위한 기본 admin_id 설정 -->
    <input type="hidden" name="admin_id" value="anonymous_admin">

    <button type="submit" class="btn btn-success">등록하기</button>
    <a href="faq_list.jsp" class="btn btn-secondary">뒤로</a>
  </form>
</div>

<script>
  function validateForm() {
    const title = document.querySelector("input[name='title']").value.trim();
    const content = document.querySelector("textarea[name='content']").value.trim();

    if (!title) {
      alert("제목을 입력해주세요.");
      return false;
    }
    if (!content) {
      alert("내용을 입력해주세요.");
      return false;
    }
    return true;
  }
</script>
