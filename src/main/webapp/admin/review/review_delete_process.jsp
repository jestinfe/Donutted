<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="review.*" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>


<%
  request.setCharacterEncoding("UTF-8");

  int reviewId = Integer.parseInt(request.getParameter("review_id"));
  int result = 0;

  try {
      ReviewService service = new ReviewService();
      result = service.deleteReview(reviewId);
  } catch (Exception e) {
      e.printStackTrace();
  }
%>

<div class="main text-center">
  <h3 class="mb-4">
    노티드 : <br><br>
    <%= result > 0 ? "관리자가 리뷰를 삭제했습니다." : "리뷰 삭제에 실패했습니다." %>
  </h3>
  
  <a href="review_list.jsp" class="btn btn-primary">확인</a>
</div>
