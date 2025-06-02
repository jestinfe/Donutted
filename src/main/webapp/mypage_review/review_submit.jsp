<%@ page import="com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.File, review.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
  request.setCharacterEncoding("UTF-8");

  String savePath = "C:/Users/user/git/mall_prj/mall_prj/src/main/webapp/common/images/review"; // 수정된 경로
  int maxSize = 10 * 1024 * 1024; // 10MB

  File dir = new File(savePath);
  if (!dir.exists()) dir.mkdirs();

  MultipartRequest mr = new MultipartRequest(
    request,
    savePath,
    maxSize,
    "UTF-8",
    new DefaultFileRenamePolicy()
  );

  String orderItemParam = mr.getParameter("order_item_id");
  String ratingParam = mr.getParameter("rating");
  String content = mr.getParameter("content");
  String fileName = mr.getFilesystemName("image"); // 파일명만 저장
  String imageUrl = fileName != null ? fileName : null; // DB에는 파일명만 저장

  Integer userIdObj = (Integer) session.getAttribute("userId");
  int userId = userIdObj;

  if (orderItemParam == null || ratingParam == null || content == null || content.trim().isEmpty()) {
%>
  <script>
    alert("입력값이 누락되었습니다.");
    history.back();
  </script>
<%
    return;
  }

  int orderItemId = Integer.parseInt(orderItemParam);
  int rating = Integer.parseInt(ratingParam);

  ReviewDTO dto = new ReviewDTO();
  dto.setOrderItemId(orderItemId);
  dto.setUserId(userId);
  dto.setRating(rating);
  dto.setContent(content);
  dto.setImageUrl(imageUrl);

  ReviewService service = new ReviewService();
  int result = service.writeReview(dto);
%>

<script>
<%
  if (result > 0) {
%>
    alert("리뷰가 등록되었습니다!");
    if (window.opener) {
      window.opener.location.reload(); // 부모창 새로고침
      window.close(); // 팝업 닫기
    } else {
      location.href = "my_reviews.jsp";
    }
<%
  } else {
%>
    alert("리뷰 등록에 실패했습니다.");
    history.back();
<%
  }
%>
</script>
