package product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.sist.dao.DbConnection;

public class CategoryDAO {
	private static CategoryDAO cDAO;

	private CategoryDAO() {}

	public static CategoryDAO getInstance() {
		if (cDAO == null) {
			cDAO = new CategoryDAO();
		}//end if
		return cDAO;
	}//getInstance
	
	public List<CategoryDTO> selectAllCategories() throws SQLException {
		List<CategoryDTO> list = new ArrayList<>();
		DbConnection db = DbConnection.getInstance();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = db.getDbConn();
			StringBuilder selectAllCategories = new StringBuilder();
			selectAllCategories
			.append("	select category_id, name	")
			.append("	from category	");

			pstmt = con.prepareStatement(selectAllCategories.toString());
			rs = pstmt.executeQuery();

			while (rs.next()) {
				CategoryDTO cDTO = new CategoryDTO();
				cDTO.setCategoryId(rs.getInt("category_id"));
				cDTO.setCategoryName(rs.getString("name"));
				list.add(cDTO);
			}//end while
		} finally {
			db.dbClose(rs, pstmt, con);
		}//end finally
		return list;
	}//selectAllCategories
	
	
}//class
