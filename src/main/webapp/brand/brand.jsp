<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>브랜드 소개 | Donutted</title>
  <c:import url="../common/external_file.jsp"/>
  <style>
  
    .info-img {
    	text-align: center; /* 백업용 */
    }
    
	.info-img img {
	  max-width: 100%;
	  height: auto;
	}
	
	.border {
		max-width: 60%;
  		margin: 80px auto 50px auto; /* 가운데 정렬 */
		padding: 50px 30px 50px 30px;
		border: 1px solid;
		border-radius: 10px;
		background-color: #fff8f5;
		box-shadow: 0 5px 12px rgba(0,0,0,0.2);
	}
  </style>
</head>
<body>
<!-- ✅ 잘못된 파라미터일 경우 강제로 about으로 이동 -->
<c:if test="${not empty param.section and param.section ne 'about' and param.section ne 'location'}">
  <c:redirect url="?section=about" />
</c:if>

<!-- ✅ 공통 헤더 -->
<c:import url="/common/header.jsp" />

<!-- ✅ 본문 영역 -->
<main class="container" style="min-height: 600px;">

  <c:choose>
    <%-- 기본값 'about' 적용 --%>
    <c:when test="${empty param.section or param.section eq 'about'}">
    	<div class="info-img">
    	<img src="<c:url value='/admin/common/images/brand/brand_info_img.png'/>" alt="브랜드 정보">
    	</div>
      <%-- 
      <h2 style="font-size: 28px; font-weight: bold; margin-bottom: 40px; text-align: left;">About Donutted</h2>
      <div style="text-align: center; margin-bottom: 20px;">
        <strong style="font-size: 26px; color: #FF69B4;">달콤한 하루를 받으세요</strong>
      </div>
      <p style="font-size: 18px; line-height: 1.8; color: #555; text-align: center; max-width: 800px; margin: 0 auto;">
        <strong>Donutted</strong>는 부드럽고 감성적인 디저트를 추구하는 브랜드로,<br>
        행복한 순간을 더 달콤하게 만들어주는 다양한 메뉴와 감각적인 공간을 제공합니다.<br>
      </p>

      <div style="text-align: center; margin-top: 50px;">
        <img src="http://localhost/mall_prj/common/images/logo.png" alt="donutted 로고" style="width:25%;">
      </div>

      <div style="margin: 0 auto; padding: 0; max-width: 100vw; overflow: hidden;">
        <img src="<c:url value='/common/images/mid.png' />" alt="Mid Image" style="width: 100%; display: block;"><br>
        <img src="<c:url value='/common/images/btm.png' />" alt="Bottom Image" style="width: 100%; display: block;">
      </div>
       --%>
    </c:when>

    <c:when test="${param.section eq 'location'}">
      <div class="border">
	      <h2 style="font-size: 40px; font-weight: bold; margin-bottom: 40px; text-align: center;">Visit Us</h2>
	      <p style="font-size: 18px; line-height: 1.8; color: #555; text-align: center; max-width: 800px; margin: 0 auto;">
	        donutted 역삼 플래그십 스토어<br>
	        📍 서울특별시 강남구 역삼동 테헤란로 132 한독약품빌딩 8층<br>
	        ☎️ 1800-6067<br>
	        🕘 운영시간: 매일 9:00 ~ 18:00
	      </p>
	      <div style="text-align: center; margin-top: 50px;">
	        <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d6330.732002387768!2d127.02562245458282!3d37.49928500000001!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x357ca1c32408f9b7%3A0x4e3761a4f356d1eb!2z7IyN7Jqp6rWQ7Jyh7IS87YSw!5e0!3m2!1sko!2skr!4v1747113528629!5m2!1sko!2skr" width="100%" height="450" style="border:1; border-style: solid; border-color: gray;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
	      </div>
      </div>
    </c:when>
  </c:choose>

</main>

<!-- ✅ 공통 푸터 -->
<c:import url="/common/footer.jsp" />

</body>
</html>
