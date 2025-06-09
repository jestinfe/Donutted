<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="review.*, java.util.*" %>

<link rel="shortcut icon" href="http://localhost/mall_prj/admin/common/images/core/favicon.ico"/>

<%

  int productId = Integer.parseInt(request.getParameter("productId"));
  String ratingParam = request.getParameter("rating");
  int rating = 0;
  if (ratingParam != null && !ratingParam.isEmpty()) {
      rating = Integer.parseInt(ratingParam);
  }

  ReviewService service = new ReviewService();
  List<ReviewDTO> reviewList = service.getReviewsByProductIdAndRating(productId, rating);
  request.setAttribute("reviewList", reviewList);
%>

<c:choose>
  <c:when test="${empty reviewList}">
    <p class="text-center text-muted">등록된 리뷰가 없습니다.</p>
  </c:when>
  <c:otherwise>
   <c:forEach var="review" items="${reviewList}">
      <div class="border rounded p-3 mb-3">
        <!-- 별점 -->
        <div class="d-flex align-items-center mb-2">
          <div class="me-2">
            <c:forEach begin="1" end="5" var="i">
              <c:choose>
                <c:when test="${i <= review.rating}">
                  <span class="starRed">★</span>
                </c:when>
                <c:otherwise>
                  <span class="starGrey">★</span>
                </c:otherwise>
              </c:choose>
            </c:forEach>
          </div>
          <div class="text-muted small ms-auto">
            작성자: ${review.userId} | 
            <fmt:formatDate value="${review.updatedAt != null ? review.updatedAt : review.createdAt}" pattern="yyyy-MM-dd HH:mm" />
          </div>
        </div>

        <!-- 리뷰 내용 -->
        <p class="mb-2">${review.content}</p>

        <!-- 이미지 (있으면) -->
        <c:if test="${not empty review.imageUrl}">
          <div class="text-center">
          <img src="${pageContext.request.contextPath}/common/images/review/${review.imageUrl}" alt="리뷰 이미지" style="max-width:300px; height:auto; border-radius:5px;">

          </div>
        </c:if>
      </div>
    </c:forEach>
  </c:otherwise>
</c:choose>
