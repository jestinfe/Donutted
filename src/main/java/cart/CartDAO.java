package cart;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.DbConnection;

public class CartDAO {
	private static CartDAO cDAO;

	private CartDAO() {

	}

	public static CartDAO getInstance() {
		if (cDAO == null) {
			cDAO = new CartDAO();
		}
		return cDAO;
	}// getInstance

	public Integer getCartIdByUser(int userId) throws SQLException {

		DbConnection dbConn = DbConnection.getInstance();
		PreparedStatement pstmt = null;
		Connection conn = null;
		ResultSet rs = null;

		try {
			conn = dbConn.getDbConn();
			String selectCartId = "select cart_id from cart where user_id = ? ";
			pstmt = conn.prepareStatement(selectCartId);
			pstmt.setInt(1, userId);

			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt("cart_id");
			} else {
				return null;
			}

		} finally {
			dbConn.dbClose(rs, pstmt, conn);
		}

	}// getCartIdByUser

	public int createCartId(int userId) throws SQLException {
		DbConnection dbConn = DbConnection.getInstance();
		PreparedStatement pstmt = null;
		Connection conn = null;
		ResultSet rs = null;
		try {
			conn = dbConn.getDbConn();
			String createCart = "insert into cart(cart_id, user_id) values(cart_seq.nextval, ?) ";
			pstmt = conn.prepareStatement(createCart);

			pstmt.setInt(1, userId);
			pstmt.executeUpdate();

			String currvalSql = "SELECT CART_SEQ.CURRVAL FROM DUAL";
			pstmt = conn.prepareStatement(currvalSql);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				return rs.getInt(1); // 생성된 CART_ID 반환
			} else {
				throw new SQLException("CART_ID 생성 실패");
			}

		} finally {
			dbConn.dbClose(null, pstmt, conn);
		}
	}// createCartId

	public void insertCartItem(CartItemDTO ciDTO) throws SQLException {
		DbConnection dbConn = DbConnection.getInstance();
		PreparedStatement pstmt = null;
		Connection conn = null;

		try {
			conn = dbConn.getDbConn();
			StringBuilder insertCart = new StringBuilder();
			insertCart.append("insert into cart_item(CART_ITEM_ID, CART_ID, PRODUCT_ID, QUANTITY, ADDED_AT)")
					.append(" values(cart_seq.nextval, ?, ?, ?, sysdate )");

			pstmt = conn.prepareStatement(insertCart.toString());
			pstmt.setInt(1, ciDTO.getCartId());
			pstmt.setInt(2, ciDTO.getProductId());
			pstmt.setInt(3, ciDTO.getQuantity());

			pstmt.executeUpdate();

		} finally {
			dbConn.dbClose(null, pstmt, conn);

		}

	}// insertcartItem

	public List<CartItemDTO> selectAllCartItem(int cartId) throws SQLException {
		List<CartItemDTO> list = new ArrayList<CartItemDTO>();
		DbConnection dbConn = DbConnection.getInstance();
		PreparedStatement pstmt = null;
		Connection conn = null;
		ResultSet rs = null;

		try {
			conn = dbConn.getDbConn();
			StringBuilder selectCart = new StringBuilder();
			selectCart.append("select p.product_id, p.THUMBNAIL_URL, p.name, ci.quantity, p.price, p.stock_quantity ")
					.append(" from cart_item ci ").append(" join  product p ON ci.product_id = p.product_id ")
					.append(" where ci.cart_id = ? ");

			pstmt = conn.prepareStatement(selectCart.toString());
			pstmt.setInt(1, cartId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				CartItemDTO ciDTO = new CartItemDTO();
				ciDTO.setProductId(rs.getInt("product_id"));
				ciDTO.setThumbnailImg(rs.getString("THUMBNAIL_URL"));
				ciDTO.setProductName(rs.getString("name"));
				ciDTO.setQuantity(rs.getInt("quantity"));
				ciDTO.setPrice(rs.getInt("price"));
				ciDTO.setStockQuantity(rs.getInt("stock_quantity"));
				list.add(ciDTO);
			}
		} finally {
			dbConn.dbClose(rs, pstmt, conn);
		}

		return list;
	}

	public boolean isItemInCart(int cartId, int productId) throws SQLException {
		DbConnection dbConn = DbConnection.getInstance();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		boolean exists = false;

		try {
			conn = dbConn.getDbConn();
			String sql = "SELECT COUNT(*) FROM cart_item WHERE cart_id = ? AND product_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cartId);
			pstmt.setInt(2, productId);
			rs = pstmt.executeQuery();
			if (rs.next() && rs.getInt(1) > 0) {
				exists = true;
			}
		} finally {
			dbConn.dbClose(rs, pstmt, conn);
		}

		return exists;

	}

	public int deleteCart(int productId, int cartId) throws SQLException {
		int cnt = 0;
		DbConnection dbConn = DbConnection.getInstance();
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			conn = dbConn.getDbConn();
			String deleteSql = "delete from cart_item where cart_id = ? and product_id = ?";
			pstmt = conn.prepareStatement(deleteSql);
			pstmt.setInt(1, cartId);
			pstmt.setInt(2, productId);

			cnt = pstmt.executeUpdate();

		} finally {
			dbConn.dbClose(null, pstmt, conn);

		}
		return cnt;
	}

	public List<String> searchRemovedItem(int productId, int cartId) throws SQLException {
		List<String> list = new ArrayList<>();
		String name = "";
		CartItemDTO ciDTO = null;
		DbConnection dbConn = DbConnection.getInstance();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = dbConn.getDbConn();
			String searchQuery = "select p.name from cart_item ci join product p on p.product_id = ci.product_id where p.product_id= ? and ci.cart_id = ? ";
			pstmt = conn.prepareStatement(searchQuery);
			pstmt.setInt(1, productId);
			pstmt.setInt(2, cartId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				ciDTO = new CartItemDTO();
				ciDTO.setProductName(rs.getString("name"));
				name = ciDTO.getProductName();
				list.add(name);
			}
		} finally {
			dbConn.dbClose(rs, pstmt, conn);
		}

		return list;
	}// search

	public int cartItemCnt(int cartId) throws SQLException {
		DbConnection dbConn = DbConnection.getInstance();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int cartCnt = 0;

		try {
			conn = dbConn.getDbConn();
			String sql = "SELECT COUNT(*) FROM cart_item WHERE cart_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, cartId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				cartCnt = rs.getInt(1);
			}
		} finally {
			dbConn.dbClose(rs, pstmt, conn);
		}

		return cartCnt;

	}// cartItemCnt

	public int updateQuantity(int cartId, int productId, int quantity) throws SQLException {
		DbConnection dbConn = DbConnection.getInstance();
		Connection conn = null;
		PreparedStatement pstmt = null;
		int cnt = 0;
		try {
			conn=dbConn.getDbConn();
			String updateSql="update cart_item set quantity= ? where cart_id=? and product_id=?";
			pstmt=conn.prepareStatement(updateSql);
			pstmt.setInt(1, quantity);
			pstmt.setInt(2, cartId);
			pstmt.setInt(3, productId);
			cnt = pstmt.executeUpdate();
		}finally {
			dbConn.dbClose(null, pstmt, conn);
		}
		return cnt;
	}//updateQuantity
	
	public int updateMinusQuantity(int cartId, int productId, int quantity) throws SQLException {
		DbConnection dbConn = DbConnection.getInstance();
		Connection conn = null;
		PreparedStatement pstmt = null;
		int cnt=0;
		try {
			conn=dbConn.getDbConn();
			String updateSql="update cart_item set quantity=quantity-1 where cart_id=? and product_id=?";
			pstmt=conn.prepareStatement(updateSql);
			pstmt.setInt(1, cartId);
			pstmt.setInt(2, productId);
			cnt = pstmt.executeUpdate();
		}finally {
			dbConn.dbClose(null, pstmt, conn);
		}
		return cnt;
	}
	public void clearCart(Connection conn, int cartId) throws SQLException {
	       String sql = "DELETE FROM cart_item WHERE cart_id = ?";
	       try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
	           pstmt.setInt(1, cartId);
	           pstmt.executeUpdate();
	       }
	   }
	public void plusQuantity(int cartId, int productId, int qty) throws SQLException{
		
		DbConnection dbConn = DbConnection.getInstance();
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = dbConn.getDbConn();
			String updateSql ="update cart_item set quantity = quantity+? where cart_id=? and product_id=?";
			pstmt=conn.prepareStatement(updateSql);
			pstmt.setInt(1, qty);
			pstmt.setInt(2, cartId);
			pstmt.setInt(3, productId);
			pstmt.executeUpdate();
		}finally {
			dbConn.dbClose(null, pstmt, conn);
		}
		
	}
	public Integer getStockQuantity(int productId)throws SQLException{
		
		DbConnection dbConn = DbConnection.getInstance();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = dbConn.getDbConn();
			String sql = "select stock_quantity from product where product_id = ?";
			pstmt=conn.prepareStatement(sql);
			pstmt.setInt(1, productId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt("stock_quantity");
			}
		}finally {
			dbConn.dbClose(rs, pstmt, conn);
		}
		
		return null;
	}
	public void clearSelectedCartItems(Connection conn, int cartId, List<Integer> selectedProductIds) throws SQLException {
	    if (selectedProductIds == null || selectedProductIds.isEmpty()) return;

	    StringBuilder sql = new StringBuilder();
	    sql.append("DELETE FROM cart_item WHERE cart_id = ? AND product_id IN (");

	    for (int i = 0; i < selectedProductIds.size(); i++) {
	        sql.append("?");
	        if (i < selectedProductIds.size() - 1) {
	            sql.append(", ");
	        }
	    }
	    sql.append(")");

	    try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
	        pstmt.setInt(1, cartId);
	        for (int i = 0; i < selectedProductIds.size(); i++) {
	            pstmt.setInt(i + 2, selectedProductIds.get(i));
	        }
	        pstmt.executeUpdate();
	    }
	}

}
