<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="product.ProductDTO, product.ProductService" %>

<%
request.setCharacterEncoding("UTF-8"); // 한글 인코딩 설정
%>

<jsp:useBean id="pDTO" class="product.ProductDTO" scope="page"/>
<jsp:setProperty name="pDTO" property="*"/>

<%
    // 필수 입력 유효성 검사 (빈 문자열, null 체크)
    if (pDTO.getName() == null || pDTO.getName().trim().isEmpty() ||
        pDTO.getPrice() <= 0 ||
        pDTO.getStock() < 0 ||
        pDTO.getThumbnailImg() == null || pDTO.getThumbnailImg().trim().isEmpty() ||
        pDTO.getDetailImg() == null || pDTO.getDetailImg().trim().isEmpty()) {
%>
        <script>
            alert("모든 필수 항목을 입력해주세요. (상품명, 가격, 재고, 이미지 포함)");
            history.back();
        </script>
<%
        return;
    }

    // 상품 등록 처리
    ProductService service = new ProductService();
    boolean result = service.addProduct(pDTO);
%>

<% if (result) { %>
    <script>
        alert("상품 등록 성공!");
        location.href = "product_list.jsp";
    </script>
<% } else { %>
    <script>
        alert("상품 등록 실패!");
        history.back();
    </script>
<% } %>
