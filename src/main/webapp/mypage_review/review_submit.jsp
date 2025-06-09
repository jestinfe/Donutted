<%@ page import="com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.File, review.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/common/login_chk.jsp" %>

<link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>

<%
  request.setCharacterEncoding("UTF-8");
  String savePath = "C:/dev/workspace/mall_prj/src/main/webapp/common/images/review";
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

  if (orderItemParam == null || ratingParam.equals("0") || content == null || content.trim().isEmpty()) {
%>
  <script>
    alert("만족도와 리뷰글은 필수 입력입니다.");
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
      window.opener.location.href = "http://localhost/mall_prj/mypage_order/my_orders.jsp";
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
