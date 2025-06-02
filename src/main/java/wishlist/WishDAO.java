package wishlist;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.sist.dao.DbConnection;

public class WishDAO {
	private static WishDAO wDAO;
	
	private WishDAO() {
		
	}
	
	public static WishDAO getInstance() {
		if(wDAO == null) {
			wDAO = new WishDAO();
		}
		
		return wDAO;
	}
	
	public void insertWishItem(WishListDTO wlDTO)throws SQLException {
		Connection conn = null;
		PreparedStatement pstmt = null;
		DbConnection dbConn = DbConnection.getInstance();
		try {
			conn = dbConn.getDbConn();
			String insertWish = "insert into wishlist(wishlist_id, user_id, product_id, added_at) values(wish_seq.nextval, ?, ?, sysdate)";
			pstmt=conn.prepareStatement(insertWish);
			pstmt.setInt(1, wlDTO.getUserId());
			pstmt.setInt(2, wlDTO.getProductId());
			
			
			pstmt.executeUpdate();
			
			
		}finally {
			dbConn.dbClose(null, pstmt, conn);
		}
		
	}//insertWish
	
	public int deleteWishItem(WishListDTO wlDTO, int productId)throws SQLException{
		int cnt = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		DbConnection dbConn = DbConnection.getInstance();
		try {
			conn = dbConn.getDbConn();
			String insertWish = "delete from wishlist where user_id = ? and product_id = ? ";
			pstmt=conn.prepareStatement(insertWish);
			pstmt.setInt(1, wlDTO.getUserId());
			pstmt.setInt(2, productId);
			
			cnt = pstmt.executeUpdate();
			System.out.println("프로덕트아이디 : "+productId);
			
		}finally {
			dbConn.dbClose(null, pstmt, conn);
		}
		
		return cnt;
	}//delete
	
	public List<WishListDTO> selectAllWishList(int userId)throws SQLException{
		List<WishListDTO> list = new ArrayList<WishListDTO>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		DbConnection dbConn = DbConnection.getInstance();
		ResultSet rs = null;
		try {
			conn=dbConn.getDbConn();
			StringBuilder selectQuery = new StringBuilder();
			selectQuery
			.append(" select p.thumbnail_url, p.name, p.price, p.product_id ")
			.append(" from wishlist wl ")
			.append(" join product p on p.product_id = wl.product_id ")
			.append(" where wl.user_id = ? ");
			
			pstmt = conn.prepareStatement(selectQuery.toString());
			pstmt.setInt(1, userId);
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				WishListDTO wlDTO = new WishListDTO();
				wlDTO.setThumbnailUrl(rs.getString("thumbnail_url"));
				wlDTO.setName(rs.getString("name"));
				wlDTO.setPrice(rs.getInt("price"));
				wlDTO.setProductId(rs.getInt("product_id"));
				list.add(wlDTO);
			}
		}finally {
			dbConn.dbClose(rs, pstmt, conn);
		}
		
		return list;
	}
	
	public boolean wishExist(int userId, int productId)throws SQLException{
		boolean flag = false;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbConn = DbConnection.getInstance();
		try {
			conn=dbConn.getDbConn();
			String sql = "SELECT COUNT(*) FROM wishlist WHERE user_id=? AND product_id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, userId);
			pstmt.setInt(2, productId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				flag = rs.getInt(1)>0;
			
			}
			
		}finally {
			dbConn.dbClose(rs, pstmt, conn);
		}
		return flag;
	}
	
}
