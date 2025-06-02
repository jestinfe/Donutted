<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="product.ProductService" %>
<%@ page import="java.io.PrintWriter" %>

<%
  request.setCharacterEncoding("UTF-8");
  String contextPath = request.getContextPath();
  String productIdParam = request.getParameter("product_id");

  if (productIdParam == null) {
%>
    <script>
      alert("❌ 잘못된 접근입니다.");
      history.back();
    </script>
<%
    return;
  }

  int productId = Integer.parseInt(productIdParam);
  ProductService service = new ProductService();
  boolean result = service.removeProduct(productId);

  if (result) {
%>
    <script>
      alert("✅ 상품이 성공적으로 삭제되었습니다.");
      location.href = "<%= contextPath %>/admin/product_list.jsp";
    </script>
<%
  } else {
%>
    <script>
      alert("❌ 삭제에 실패했습니다. 다시 시도해주세요.");
      history.back();
    </script>
<%
  }
%>
