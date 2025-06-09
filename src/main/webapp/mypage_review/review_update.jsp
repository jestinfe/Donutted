<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="review.*" %>
<%@ include file="/common/login_chk.jsp" %>

<link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>

<%
  request.setCharacterEncoding("UTF-8");
  String savePath = "C:/Users/user/git/mall_prj/mall_prj/src/main/webapp/common/images/review";

  int maxSize = 10 * 1024 * 1024;
  MultipartRequest mr = new MultipartRequest(request, savePath, maxSize, "UTF-8", new DefaultFileRenamePolicy());

  int reviewId = Integer.parseInt(mr.getParameter("review_id"));
  String ratingParam = mr.getParameter("rating");
  String content = mr.getParameter("content");
  String fileName = mr.getFilesystemName("image");
  String imageUrl = (fileName != null) ? fileName : null;

  String deleteImage = mr.getParameter("delete_image");

  ReviewService service = new ReviewService();
  ReviewDTO dto = service.getReviewById(reviewId);

  int rating = (ratingParam != null && !ratingParam.isEmpty()) ? Integer.parseInt(ratingParam) : dto.getRating();
  dto.setRating(rating);
  dto.setContent(content);

  if ("true".equals(deleteImage)) dto.setImageUrl(null);
  else if (imageUrl != null) dto.setImageUrl(imageUrl);

  int result = service.updateReview(dto);
%>

<script>
  alert("<%= result > 0 ? "리뷰가 수정되었습니다." : "수정에 실패했습니다." %>");
  if (window.opener) {
    window.opener.location.reload();
    window.close();
  } else {
    location.href = "my_reviews.jsp";
  }
</script>
