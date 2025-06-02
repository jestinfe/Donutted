<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.File" %>
<%@ page import="product.ProductDTO, product.ProductService" %>

<%
  // ✅ 1. 실제 Git 프로젝트 내부에 있는 upload 경로 지정
  File saveDir = new File("C:/Users/user/git/mall_prj/mall_prj/src/main/webapp/admin/common/upload");
  if (!saveDir.exists()) {
    saveDir.mkdirs();
  }

  int maxSize = 10 * 1024 * 1024;

  // ✅ 2. MultipartRequest로 파일과 폼 데이터 모두 처리
  MultipartRequest mr = new MultipartRequest(
    request,
    saveDir.getAbsolutePath(),
    maxSize,
    "UTF-8",
    new DefaultFileRenamePolicy()
  );

  // ✅ 3. 기본 파라미터 추출
  int productId = Integer.parseInt(mr.getParameter("product_id"));
  String name = mr.getParameter("product_name");
  int categoryId = Integer.parseInt(mr.getParameter("category_id"));
  int price = Integer.parseInt(mr.getParameter("price"));
  int stock = Integer.parseInt(mr.getParameter("stock"));

  // ✅ 4. 새 이미지 파일명 (없으면 null)
  String uploadedMainImg = mr.getFilesystemName("main_img");
  String uploadedDetailImg = mr.getFilesystemName("detail_img");

  // ✅ 5. 기존 값은 hidden input으로부터 가져오기
  String hiddenMainImg = mr.getParameter("thumdnailImg");
  String hiddenDetailImg = mr.getParameter("detailImg");

  // ✅ 6. 최종 저장할 이미지 결정
  String finalMainImg = (uploadedMainImg != null) ? uploadedMainImg : hiddenMainImg;
  String finalDetailImg = (uploadedDetailImg != null) ? uploadedDetailImg : hiddenDetailImg;

  // ✅ 7. DTO 구성 및 DB 수정
  ProductDTO dto = new ProductDTO();
  dto.setProductId(productId);
  dto.setName(name);
  dto.setCategoryId(categoryId);
  dto.setPrice(price);
  dto.setStock(stock);
  dto.setThumbnailImg(finalMainImg);
  dto.setDetailImg(finalDetailImg);

  ProductService service = new ProductService();
  service.modifyProduct(dto);
%>

<!-- ✅ 8. 수정 완료 메시지 후 목록 페이지 이동 -->
<script>
  alert("✅ 상품이 성공적으로 수정되었습니다.");
  location.href = "product_list.jsp"; // 필요시 menu.jsp 등으로 변경
</script>
