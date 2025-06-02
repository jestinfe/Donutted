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

	
	public List<ProductDTO> selectAllProducts() throws SQLException {
	    List<ProductDTO> list = new ArrayList<ProductDTO>();

	    DbConnection db = DbConnection.getInstance();

	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        con = db.getDbConn();
	        StringBuilder selectAllProducts = new StringBuilder();
	        selectAllProducts
	        .append(" SELECT * ")
	        .append(" FROM product ")
	        .append(" ORDER BY CASE WHEN stock_quantity = 0 THEN 1 ELSE 0 END, created_at DESC ");

	        pstmt = con.prepareStatement(selectAllProducts.toString());
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            list.add(extractProduct(rs));
	        }
	    } finally {
	        db.dbClose(rs, pstmt, con);
	    }

	    return list;
	}//selectAllProducts

	
	
	
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
	
	public List<ProductDTO> selectProductsByCategory(int categoryId) throws SQLException {
	    List<ProductDTO> list = new ArrayList<>();
	    DbConnection db = DbConnection.getInstance();

	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        con = db.getDbConn();
	        StringBuilder selectProductsByCategory = new StringBuilder();
	        selectProductsByCategory.append(" SELECT * FROM product ")
	            .append(" WHERE category_id = ? ")
	            .append(" ORDER BY CASE WHEN stock_quantity = 0 THEN 1 ELSE 0 END, created_at DESC");

	        pstmt = con.prepareStatement(selectProductsByCategory.toString());
	        pstmt.setInt(1, categoryId);

	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            list.add(extractProduct(rs));
	        }
	    } finally {
	        db.dbClose(rs, pstmt, con);
	    }

	    return list;
	}//selectProductsByCategory


	
	
	public int insertProduct(ProductDTO pDTO) throws SQLException {
		int result = 0;
		DbConnection db = DbConnection.getInstance();

		Connection con = null;
		PreparedStatement pstmt = null;


		try {
			con = db.getDbConn();
			StringBuilder insertProduct = new StringBuilder();
			insertProduct.append("	insert into product (product_id, name, price, stock_quantity, category_id, ")
			   .append("	created_at, updated_at, code, thumbnail_url, detail_url) ")
			   .append("	values (product_seq.nextval, ?, ?, ?, ?, sysdate, sysdate, ?, ?, ?)"	);

			pstmt = con.prepareStatement(insertProduct.toString());
			pstmt.setString(1, pDTO.getName());
			pstmt.setInt(2, pDTO.getPrice());
			pstmt.setInt(3, pDTO.getStock());
			pstmt.setInt(4, pDTO.getCategoryId());
			pstmt.setString(5, pDTO.getCode());
			pstmt.setString(6, pDTO.getThumbnailImg());
			pstmt.setString(7, pDTO.getDetailImg());

			result = pstmt.executeUpdate();
		} finally {
			db.dbClose(null, pstmt, con);
		}//end finally
		return result;
	}//insertProduct
	
	public int updateProduct(ProductDTO pDTO) throws SQLException {
		int result = 0;
		DbConnection db = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = db.getDbConn();
			StringBuilder updateProduct = new StringBuilder();
			updateProduct.append("	update product set	")
			   .append("	name = ?, price = ?, stock_quantity = ?, category_id = ?,	")
			   .append("	updated_at = sysdate, code = ?, thumbnail_url = ?, detail_url = ?	")
			   .append("	where product_id = ?	");

			pstmt = con.prepareStatement(updateProduct.toString());
			pstmt.setString(1, pDTO.getName());
			pstmt.setInt(2, pDTO.getPrice());
			pstmt.setInt(3, pDTO.getStock());
			pstmt.setInt(4, pDTO.getCategoryId());
			pstmt.setString(5, pDTO.getCode());
			pstmt.setString(6, pDTO.getThumbnailImg());
			pstmt.setString(7, pDTO.getDetailImg());
			pstmt.setInt(8, pDTO.getProductId());

			result = pstmt.executeUpdate();
		} finally {
			db.dbClose(null, pstmt, con);
		}//end finally
		return result;
	}//updateProduct
	
	public int deleteProduct(int productId) throws SQLException {
		int result = 0;
		DbConnection db = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = db.getDbConn();
			StringBuilder deleteProduct = new StringBuilder();
			deleteProduct
			.append("	delete from product	")
			.append("	where product_id = ?	");
			pstmt = con.prepareStatement(deleteProduct.toString());
			pstmt.setInt(1, productId);

			result = pstmt.executeUpdate();
		} finally {
			db.dbClose(null, pstmt, con);
		}//end finally
		return result;
	}//deleteProduct
	
	
	
	
	// ▶ 공통 ResultSet → DTO 변환 메서드
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
			return dto;
		}//extractProduct
}//class
