package product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.sist.dao.DbConnection;

public class ProductDAO {
	private static ProductDAO pDAO;
	
	private ProductDAO() {
		
	}//ProductDAO
	
	public static ProductDAO getInstance() {
		if(pDAO==null) {
			pDAO=new ProductDAO();
		}//end if
		return pDAO;
	}//getInstance
	
	public List<ProductDTO> selectFilteredProducts(String keyword, String dateOrder, String priceOrder) throws SQLException {
	    List<ProductDTO> list = new ArrayList<>();

	    DbConnection db = DbConnection.getInstance();
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        con = db.getDbConn();
	        StringBuilder sql = new StringBuilder();
	        sql.append(" SELECT * FROM product WHERE 1=1 ");

	        // 조건: 상품명 검색 (대소문자 무시)
	        if (keyword != null && !keyword.trim().isEmpty()) {
	            sql.append(" AND LOWER(name) LIKE ? ");
	        }

	        // 정렬 조건
	        if (priceOrder != null && (priceOrder.equals("asc") || priceOrder.equals("desc"))) {
	            sql.append(" ORDER BY price ").append(priceOrder);
	        } else if (dateOrder != null && (dateOrder.equals("asc") || dateOrder.equals("desc"))) {
	            sql.append(" ORDER BY created_at ").append(dateOrder);
	        } else {
	            sql.append(" ORDER BY created_at DESC");
	        }

	        pstmt = con.prepareStatement(sql.toString());

	        // 파라미터 바인딩
	        int paramIndex = 1;
	        if (keyword != null && !keyword.trim().isEmpty()) {
	            pstmt.setString(paramIndex++, "%" + keyword.toLowerCase() + "%");
	        }

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            list.add(extractProduct(rs));
	        }

	    } finally {
	        db.dbClose(rs, pstmt, con);
	    }

	    return list;
	}//selectFilteredProducts

	
	

	
	
	
	public ProductDTO selectProductById(int productId) throws SQLException{
		ProductDTO pDTO = null;
		
		DbConnection db = DbConnection.getInstance();
		
		Connection con = null;
		PreparedStatement pstmt=null;
		ResultSet rs = null;
		try {
			con = db.getDbConn();
			StringBuilder selectProductById = new StringBuilder();
			selectProductById
			.append("	select  * from product	")
			.append("	where product_id = ?	")

			;
			
			pstmt = con.prepareStatement(selectProductById.toString());
			pstmt.setInt(1,productId);
			rs = pstmt.executeQuery(); 
			if (rs.next()) {
				pDTO = extractProduct(rs);
			}//end if
			}finally {
				db.dbClose(rs, pstmt, con);
			}
			return pDTO;
		}//selectProductById
	
	


	
	
	
	
	
	
	
	
	public List<ProductDTO> selectAllProducts(String sort) throws SQLException {
	    List<ProductDTO> list = new ArrayList<>();
	    DbConnection db = DbConnection.getInstance();
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        con = db.getDbConn();
	        StringBuilder sql = new StringBuilder("SELECT * FROM product WHERE 1=1 ");

	        sql.append(" ORDER BY CASE WHEN stock_quantity = 0 THEN 1 ELSE 0 END, ");

	        if (sort != null) {
	            switch (sort) {
	                case "name_asc": sql.append("name ASC"); break;
	                case "name_desc": sql.append("name DESC"); break;
	                case "price_asc": sql.append("price ASC"); break;
	                case "price_desc": sql.append("price DESC"); break;
	                case "latest":
	                default: sql.append("created_at DESC"); break;
	            }
	        } else {
	            sql.append("created_at DESC");
	        }

	        pstmt = con.prepareStatement(sql.toString());
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            list.add(extractProduct(rs));
	        }
	    } finally {
	        db.dbClose(rs, pstmt, con);
	    }
	    return list;
	}


	public List<ProductDTO> selectProductsByCategory(int categoryId, String sort) throws SQLException {
	    List<ProductDTO> list = new ArrayList<>();
	    DbConnection db = DbConnection.getInstance();
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        con = db.getDbConn();
	        StringBuilder sql = new StringBuilder("SELECT * FROM product WHERE category_id = ? ");

	        sql.append(" ORDER BY CASE WHEN stock_quantity = 0 THEN 1 ELSE 0 END, ");

	        if (sort != null) {
	            switch (sort) {
	                case "name_asc": sql.append("name ASC"); break;
	                case "name_desc": sql.append("name DESC"); break;
	                case "price_asc": sql.append("price ASC"); break;
	                case "price_desc": sql.append("price DESC"); break;
	                case "latest":
	                default: sql.append("created_at DESC"); break;
	            }
	        } else {
	            sql.append("created_at DESC");
	        }

	        pstmt = con.prepareStatement(sql.toString());
	        pstmt.setInt(1, categoryId);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            list.add(extractProduct(rs));
	        }
	    } finally {
	        db.dbClose(rs, pstmt, con);
	    }
	    return list;
	}


    public int insertProduct(ProductDTO pDTO) throws SQLException {
        int result = 0;
        DbConnection db = DbConnection.getInstance();
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = db.getDbConn();
            StringBuilder sql = new StringBuilder();
            sql.append("INSERT INTO product (")
               .append("product_id, name, price, stock_quantity, category_id, created_at, updated_at, ")
               .append("code, thumbnail_url, detail_url, ")
               .append("thumbnail_hover, product_img1, product_img2, product_img3, product_img4, ")
               .append("detail_url2, detail_url3, detail_url4")
               .append(") VALUES (product_seq.nextval, ?, ?, ?, ?, sysdate, sysdate, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

            pstmt = con.prepareStatement(sql.toString());
            pstmt.setString(1, pDTO.getName());
            pstmt.setInt(2, pDTO.getPrice());
            pstmt.setInt(3, pDTO.getStock());
            pstmt.setInt(4, pDTO.getCategoryId());
            pstmt.setString(5, pDTO.getCode());
            pstmt.setString(6, pDTO.getThumbnailImg());
            pstmt.setString(7, pDTO.getDetailImg());
            pstmt.setString(8, pDTO.getThumbnailHover());
            pstmt.setString(9, pDTO.getProductImg1());
            pstmt.setString(10, pDTO.getProductImg2());
            pstmt.setString(11, pDTO.getProductImg3());
            pstmt.setString(12, pDTO.getProductImg4());
            pstmt.setString(13, pDTO.getDetailImg2());
            pstmt.setString(14, pDTO.getDetailImg3());
            pstmt.setString(15, pDTO.getDetailImg4());

            result = pstmt.executeUpdate();
        } finally {
            db.dbClose(null, pstmt, con);
        }
        return result;
    }

    public int updateProduct(ProductDTO pDTO) throws SQLException {
        int result = 0;
        DbConnection db = DbConnection.getInstance();
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = db.getDbConn();
            StringBuilder sql = new StringBuilder();
            sql.append("UPDATE product SET ")
               .append("name = ?, price = ?, stock_quantity = ?, category_id = ?, updated_at = sysdate, ")
               .append("code = ?, thumbnail_url = ?, detail_url = ?, ")
               .append("thumbnail_hover = ?, product_img1 = ?, product_img2 = ?, product_img3 = ?, product_img4 = ?, ")
               .append("detail_url2 = ?, detail_url3 = ?, detail_url4 = ? ")
               .append("WHERE product_id = ?");

            pstmt = con.prepareStatement(sql.toString());
            pstmt.setString(1, pDTO.getName());
            pstmt.setInt(2, pDTO.getPrice());
            pstmt.setInt(3, pDTO.getStock());
            pstmt.setInt(4, pDTO.getCategoryId());
            pstmt.setString(5, pDTO.getCode());
            pstmt.setString(6, pDTO.getThumbnailImg());
            pstmt.setString(7, pDTO.getDetailImg());
            pstmt.setString(8, pDTO.getThumbnailHover());
            pstmt.setString(9, pDTO.getProductImg1());
            pstmt.setString(10, pDTO.getProductImg2());
            pstmt.setString(11, pDTO.getProductImg3());
            pstmt.setString(12, pDTO.getProductImg4());
            pstmt.setString(13, pDTO.getDetailImg2());
            pstmt.setString(14, pDTO.getDetailImg3());
            pstmt.setString(15, pDTO.getDetailImg4());
            pstmt.setInt(16, pDTO.getProductId());

            result = pstmt.executeUpdate();
        } finally {
            db.dbClose(null, pstmt, con);
        }
        return result;
    }

    private ProductDTO extractProduct(ResultSet rs) throws SQLException {
        ProductDTO dto = new ProductDTO();
        dto.setProductId(rs.getInt("PRODUCT_ID"));
        dto.setName(rs.getString("NAME"));
        dto.setPrice(rs.getInt("PRICE"));
        dto.setStock(rs.getInt("STOCK_QUANTITY"));
        dto.setCategoryId(rs.getInt("CATEGORY_ID"));
        dto.setRedDate(rs.getDate("CREATED_AT"));
        dto.setModDate(rs.getDate("UPDATED_AT"));
        dto.setCode(rs.getString("CODE"));
        dto.setThumbnailImg(rs.getString("THUMBNAIL_URL"));
        dto.setDetailImg(rs.getString("DETAIL_URL"));
        dto.setThumbnailHover(rs.getString("THUMBNAIL_HOVER"));
        dto.setProductImg1(rs.getString("PRODUCT_IMG1"));
        dto.setProductImg2(rs.getString("PRODUCT_IMG2"));
        dto.setProductImg3(rs.getString("PRODUCT_IMG3"));
        dto.setProductImg4(rs.getString("PRODUCT_IMG4"));
        dto.setDetailImg2(rs.getString("DETAIL_url2"));
        dto.setDetailImg3(rs.getString("DETAIL_url3"));
        dto.setDetailImg4(rs.getString("DETAIL_url4"));
        return dto;
    }
	
	
	
	
	
}//class
