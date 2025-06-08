<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.File, java.util.*, com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="product.ProductDTO, product.ProductService, product.CategoryDTO, product.CategoryService" %>
<%@ include file="../common/external_file.jsp" %>
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/sidebar.jsp" %>
<%@ include file="../common/login_check.jsp" %>

<%
request.setCharacterEncoding("UTF-8");
String savePath = "C:/dev/workspace/mall_prj/src/main/webapp/admin/common/images/products";
int maxSize = 50 * 1024 * 1024;
MultipartRequest mr = new MultipartRequest(request, savePath, maxSize, "UTF-8", new DefaultFileRenamePolicy());

int productId = Integer.parseInt(mr.getParameter("product_id"));
String name = mr.getParameter("name");
int categoryId = Integer.parseInt(mr.getParameter("category_id"));
int price = Integer.parseInt(mr.getParameter("price"));
int stock = Integer.parseInt(mr.getParameter("stock"));

ProductService service = new ProductService();
ProductDTO dto = service.getProductById(productId);

dto.setName(name);
dto.setCategoryId(categoryId);
dto.setPrice(price);
dto.setStock(stock);

String[] fields = {
  "thumbnailImg", "detailImg", "thumbnailHover",
  "productImg1", "productImg2", "productImg3", "productImg4",
  "detailImg2", "detailImg3", "detailImg4"
};

for (String field : fields) {
    String fileParam = field + "File";
    String deleteParam = "delete_" + field;
    String fileName = mr.getFilesystemName(fileParam);
    boolean delete = "true".equals(mr.getParameter(deleteParam));

    if (delete) {
        ProductDTO.class.getMethod("set" + capitalize(field), String.class).invoke(dto, (String) null);
    } else if (fileName != null) {
        ProductDTO.class.getMethod("set" + capitalize(field), String.class).invoke(dto, fileName);
    }
}

boolean result = service.modifyProduct(dto);
%>
<script>
  alert("<%= result ? "상품이 수정되었습니다." : "수정에 실패했습니다." %>");
  location.href = "product_list.jsp";
</script>

<%!
  private String capitalize(String str) {
    return str.substring(0,1).toUpperCase() + str.substring(1);
  }
%>