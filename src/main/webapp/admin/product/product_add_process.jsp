<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="product.ProductDTO, product.ProductService" %>

<%
request.setCharacterEncoding("UTF-8");

String savePath = "C:/dev/workspace/mall_prj/src/main/webapp/admin/common/images/products";
File saveDir = new File(savePath);
if (!saveDir.exists()) saveDir.mkdirs();

int maxSize = 50 * 1024 * 1024;
String[] allowedExts = {"jpg", "jpeg", "png", "gif", "webp"};

Map<String, String> savedFiles = new HashMap<>();

try {
    MultipartRequest mr = new MultipartRequest(
         request,
         savePath,
         maxSize,
         "UTF-8",
         new DefaultFileRenamePolicy()
    );

    String name = mr.getParameter("name");
    int price = Integer.parseInt(mr.getParameter("price"));
    int stock = Integer.parseInt(mr.getParameter("stock"));
    int categoryId = Integer.parseInt(mr.getParameter("categoryId"));

    // 필수 항목 유효성 검사
    if (name == null || name.trim().isEmpty()) {
        throw new Exception("상품명을 입력하세요.");
    }
    if (price <= 0) {
        throw new Exception("가격은 0보다 커야 합니다.");
    }
    if (stock < 0) {
        throw new Exception("재고는 0 이상이어야 합니다.");
    }
    if (mr.getFile("thumbnailFile") == null) {
        throw new Exception("대표 이미지(thumbnailFile)는 반드시 업로드해야 합니다.");
    }
    if (mr.getFile("detailFile") == null) {
        throw new Exception("상세 이미지(detailFile)는 반드시 업로드해야 합니다.");
    }


    String[] fileFields = {
        "thumbnailFile", "detailFile", "thumbnailHoverFile",
        "productImg1File", "productImg2File", "productImg3File", "productImg4File",
        "detailImg2File", "detailImg3File", "detailImg4File"
    };

    for (String fieldName : fileFields) {
        File file = mr.getFile(fieldName);
        if (file != null) {
            String originalName = mr.getOriginalFileName(fieldName);
            String ext = originalName.substring(originalName.lastIndexOf('.') + 1).toLowerCase();
            if (!Arrays.asList(allowedExts).contains(ext)) {
                file.delete();
                throw new Exception("허용되지 않은 확장자: " + ext);
            }
            String uuidName = UUID.randomUUID().toString() + "." + ext;
            File newFile = new File(savePath, uuidName);
            file.renameTo(newFile);
            savedFiles.put(fieldName, uuidName);
        } else {
            savedFiles.put(fieldName, null);  // 🔥 null 저장
        }
    }

    ProductDTO dto = new ProductDTO();
    dto.setName(name);
    dto.setPrice(price);
    dto.setStock(stock);
    dto.setCategoryId(categoryId);

    dto.setThumbnailImg(savedFiles.get("thumbnailFile"));
    dto.setDetailImg(savedFiles.get("detailFile"));
    dto.setThumbnailHover(savedFiles.get("thumbnailHoverFile"));
    dto.setProductImg1(savedFiles.get("productImg1File"));
    dto.setProductImg2(savedFiles.get("productImg2File"));
    dto.setProductImg3(savedFiles.get("productImg3File"));
    dto.setProductImg4(savedFiles.get("productImg4File"));
    dto.setDetailImg2(savedFiles.get("detailImg2File"));
    dto.setDetailImg3(savedFiles.get("detailImg3File"));
    dto.setDetailImg4(savedFiles.get("detailImg4File"));

    boolean result = new ProductService().addProduct(dto);

    if (result) {
%>
<script>
    alert("상품 등록 성공!");
    location.href = "product_list.jsp";
</script>
<%
    } else {
%>
<script>
    alert("DB 저장 실패");
    history.back();
</script>
<%
    }

} catch (Exception e) {
    e.printStackTrace();
%>
<script>
    alert("업로드 실패: <%= e.getMessage() %>");
    history.back();
</script>
<%
}
%>
