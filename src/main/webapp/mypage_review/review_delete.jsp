<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="review.*" %>
<%@ include file="/common/login_chk.jsp" %>

<link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>

<%

  int reviewId = Integer.parseInt(request.getParameter("review_id"));
  int result = new ReviewService().deleteReview(reviewId);
%>

<script>
  alert("<%= result > 0 ? "리뷰가 삭제되었습니다." : "삭제에 실패했습니다." %>");
  location.href = "my_reviews.jsp";
</script>
