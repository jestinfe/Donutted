package inquiry;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import kr.co.sist.dao.DbConnection;


///제주순희네해장국에 소주 지리겠노!!!!!!!!!!!!!!!
//쏴아릿쏴아릿쏴아릿쏴아릿쏴아릿쏴아릿쏴아릿쏴아릿쏴아릿쏴아릿쏴아릿쏴아릿쏴아릿쏴아릿쏴아릿쏴아릿쏴아릿쏴아릿쏴아릿쏴아릿쏴아릿
public class InquiryDAO {
	
	private static final InquiryDAO instance = new InquiryDAO();

	public static InquiryDAO getInstance() {
	    return instance;
	}

	  
	  
	//1대1문의 insert
	public void insertInquiry(InquiryDTO inDTO) throws SQLException {
		String sql = "INSERT INTO inquiry(user_id, title, content, inquiry_status, created_at) " +
	             "VALUES (?, ?, ?, ?, SYSDATE)";
	    Connection con = null;
	    PreparedStatement pstmt = null;

	    try {
	        con = DbConnection.getInstance().getDbConn();
	        pstmt = con.prepareStatement(sql);
	        pstmt.setInt(1, inDTO.getUserId());
	        pstmt.setString(2, inDTO.getTitle());
	        pstmt.setString(3, inDTO.getContent());
	        pstmt.setString(4, inDTO.getInquiryStatus()); 
	        pstmt.executeUpdate();
	    } finally {
	        if (pstmt != null) pstmt.close();
	        if (con != null) con.close();
	    }
	}

	
//1대1문의 보기
	public List<InquiryDTO> selectInquiry(int userId) throws SQLException {
	    List<InquiryDTO> list = new ArrayList<>();

	    String sql = "SELECT inquiry_id, user_id, title, content, reply_content, created_at "
	               + "FROM inquiry WHERE user_id = ? ORDER BY inquiry_id DESC";

	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        con = DbConnection.getInstance().getDbConn();
	        pstmt = con.prepareStatement(sql);
	        pstmt.setInt(1, userId);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            InquiryDTO dto = new InquiryDTO();
	            dto.setInquiryId(rs.getInt("inquiry_id"));
	            dto.setUserId(rs.getInt("user_id"));
	            dto.setTitle(rs.getString("title"));
	            dto.setContent(rs.getString("content"));
	            dto.setReplyContent(rs.getString("reply_content")); // ✅ 추가됨
	            dto.setCreatedAt(rs.getDate("created_at"));
	            list.add(dto);
	        }

	    } finally {
	        DbConnection.getInstance().dbClose(rs, pstmt, con);
	    }

	    return list;
	}

	public InquiryDTO selectInquiryById(int inquiryId) throws SQLException {
	    String sql = "SELECT * FROM inquiry WHERE inquiry_id = ?";
	    InquiryDTO dto = null;

	    try (Connection con = DbConnection.getInstance().getDbConn();
	         PreparedStatement pstmt = con.prepareStatement(sql)) {

	        pstmt.setInt(1, inquiryId);
	        ResultSet rs = pstmt.executeQuery();

	        if (rs.next()) {
	            dto = new InquiryDTO();
	            dto.setInquiryId(rs.getInt("inquiry_id"));
	            dto.setUserId(rs.getInt("user_id"));
	            dto.setTitle(rs.getString("title"));
	            dto.setContent(rs.getString("content"));
	            dto.setCreatedAt(rs.getDate("created_at"));
	            dto.setReplyContent(rs.getString("reply_content"));
	        }
	    }

	    return dto;
	}

	// 관리자 - 전체 1:1 문의 목록 조회
	public List<InquiryDTO> selectAllInquiries() throws SQLException {
	    List<InquiryDTO> list = new ArrayList<>();

	    String sql = "SELECT inquiry_id, user_id, title, content, reply_content, created_at FROM inquiry ORDER BY inquiry_id DESC";

	    try (Connection con = DbConnection.getInstance().getDbConn();
	         PreparedStatement pstmt = con.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {

	        while (rs.next()) {
	            InquiryDTO dto = new InquiryDTO();
	            dto.setInquiryId(rs.getInt("inquiry_id"));
	            dto.setUserId(rs.getInt("user_id"));
	            dto.setTitle(rs.getString("title"));
	            dto.setContent(rs.getString("content"));
	            dto.setReplyContent(rs.getString("reply_content"));
	            dto.setCreatedAt(rs.getDate("created_at"));
	            list.add(dto);
	        }

	    }

	    return list;
	}
	
	public void deleteInquiry(int inquiryId) throws SQLException {
	    String sql = "DELETE FROM inquiry WHERE inquiry_id = ?";

	    try (Connection con = DbConnection.getInstance().getDbConn();
	         PreparedStatement pstmt = con.prepareStatement(sql)) {

	        pstmt.setInt(1, inquiryId);
	        pstmt.executeUpdate();
	    }
	}
	public boolean updateInquiryReply(int inquiryId, String replyContent) throws SQLException {
	    String sql = "UPDATE inquiry SET reply_content = ?, replied_at = SYSDATE, admin_id = ?, inquiry_status = 'DONE' WHERE inquiry_id = ?";
	    
	    try (Connection con = DbConnection.getInstance().getDbConn();
	         PreparedStatement pstmt = con.prepareStatement(sql)) {
	        pstmt.setString(1, replyContent);
	        pstmt.setInt(2, 1); // 임시 admin_id 지정
	        pstmt.setInt(3, inquiryId);
	        
	        int affected = pstmt.executeUpdate();
	        System.out.println("✅ 업데이트된 행 수: " + affected);
	        return affected == 1;
	    }
	}

	public List<InquiryDTO> selectPagedInquiries(int offset, int pageSize) throws SQLException {
	    List<InquiryDTO> list = new ArrayList<>();
	    String sql = "SELECT inquiry_id, user_id, title, content, reply_content, created_at " +
	                 "FROM inquiry ORDER BY inquiry_id DESC " +
	                 "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

	    try (Connection con = DbConnection.getInstance().getDbConn();
	         PreparedStatement pstmt = con.prepareStatement(sql)) {

	        pstmt.setInt(1, offset);     // 몇 번째부터
	        pstmt.setInt(2, pageSize);   // 몇 개 가져올지

	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                InquiryDTO dto = new InquiryDTO();
	                dto.setInquiryId(rs.getInt("inquiry_id"));
	                dto.setUserId(rs.getInt("user_id"));
	                dto.setTitle(rs.getString("title"));
	                dto.setContent(rs.getString("content"));
	                dto.setReplyContent(rs.getString("reply_content"));
	                dto.setCreatedAt(rs.getDate("created_at"));
	                list.add(dto);
	            }
	        }
	    }

	    return list;
	}
	
	public int countTotalInquiries() throws SQLException {
	    String sql = "SELECT COUNT(*) FROM inquiry";

	    try (Connection con = DbConnection.getInstance().getDbConn();
	         PreparedStatement pstmt = con.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }
	    }

	    return 0;
	}
	public List<InquiryDTO> selectUserPagedInquiries(int userId, int offset, int pageSize) throws SQLException {
	    List<InquiryDTO> list = new ArrayList<>();
	    String sql = "SELECT inquiry_id, user_id, title, content, reply_content, created_at " +
	                 "FROM inquiry WHERE user_id = ? " +
	                 "ORDER BY inquiry_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

	    try (Connection con = DbConnection.getInstance().getDbConn();
	         PreparedStatement pstmt = con.prepareStatement(sql)) {

	        pstmt.setInt(1, userId);
	        pstmt.setInt(2, offset);
	        pstmt.setInt(3, pageSize);

	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                InquiryDTO dto = new InquiryDTO();
	                dto.setInquiryId(rs.getInt("inquiry_id"));
	                dto.setUserId(rs.getInt("user_id"));
	                dto.setTitle(rs.getString("title"));
	                dto.setContent(rs.getString("content"));
	                dto.setReplyContent(rs.getString("reply_content"));
	                dto.setCreatedAt(rs.getDate("created_at"));
	                list.add(dto);
	            }
	        }
	    }
	    return list;
	}

	public int countUserInquiries(int userId) throws SQLException {
	    String sql = "SELECT COUNT(*) FROM inquiry WHERE user_id = ?";
	    try (Connection con = DbConnection.getInstance().getDbConn();
	         PreparedStatement pstmt = con.prepareStatement(sql)) {
	        pstmt.setInt(1, userId);
	        ResultSet rs = pstmt.executeQuery();
	        if (rs.next()) {
	            return rs.getInt(1);
	        }
	    }
	    return 0;
	}
	public int countTodayInquiriesByUser(int userId) throws SQLException {
	    String sql = "SELECT COUNT(*) FROM inquiry WHERE user_id = ? AND TRUNC(created_at) = TRUNC(SYSDATE)";
	    
	    try (Connection con = DbConnection.getInstance().getDbConn();
	         PreparedStatement pstmt = con.prepareStatement(sql)) {
	        
	        pstmt.setInt(1, userId);
	        ResultSet rs = pstmt.executeQuery();
	        
	        if (rs.next()) {
	            return rs.getInt(1);
	        }
	    }

	    return 0;
	}
	public List<InquiryDTO> selectInquiriesWithFilter(String userId, String date, String status, int offset, int pageSize) throws SQLException {
	    List<InquiryDTO> list = new ArrayList<>();

	    StringBuilder sql = new StringBuilder("SELECT * FROM inquiry WHERE 1=1");
	    List<Object> params = new ArrayList<>();

	    if (userId != null && !userId.isEmpty()) {
	        sql.append(" AND user_id = ?");
	        params.add(Integer.parseInt(userId));
	    }

	    if (date != null && !date.isEmpty()) {
	        sql.append(" AND TRUNC(created_at) = TO_DATE(?, 'YYYY-MM-DD')");
	        params.add(date);
	    }

	    if (status != null && !status.isEmpty()) {
	        if (status.equals("WAIT")) {
	            sql.append(" AND (reply_content IS NULL OR TRIM(reply_content) = '')");
	        } else if (status.equals("DONE")) {
	            sql.append(" AND NVL(LENGTH(TRIM(reply_content)), 0) > 0");
	        }
	    }


	    sql.append(" ORDER BY inquiry_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

	    params.add(offset);
	    params.add(pageSize);

	    try (Connection con = DbConnection.getInstance().getDbConn();
	         PreparedStatement pstmt = con.prepareStatement(sql.toString())) {

	        // 파라미터 바인딩
	        for (int i = 0; i < params.size(); i++) {
	            Object param = params.get(i);
	            if (param instanceof Integer) {
	                pstmt.setInt(i + 1, (Integer) param);
	            } else {
	                pstmt.setString(i + 1, param.toString());
	            }
	        }

	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                InquiryDTO dto = new InquiryDTO();
	                dto.setInquiryId(rs.getInt("inquiry_id"));
	                dto.setUserId(rs.getInt("user_id"));
	                dto.setTitle(rs.getString("title"));
	                dto.setContent(rs.getString("content"));
	                dto.setReplyContent(rs.getString("reply_content"));
	                dto.setCreatedAt(rs.getDate("created_at"));
	                list.add(dto);
	            }
	        }

	    }

	    return list;
	}

	public int countInquiriesWithFilter(String userId, String date, String status) throws SQLException {
	    StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM inquiry WHERE 1=1");
	    List<Object> params = new ArrayList<>();

	    if (userId != null && !userId.isEmpty()) {
	        sql.append(" AND user_id = ?");
	        params.add(Integer.parseInt(userId));
	    }

	    if (date != null && !date.isEmpty()) {
	        sql.append(" AND TRUNC(created_at) = TO_DATE(?, 'YYYY-MM-DD')");
	        params.add(date);
	    }

	    if (status != null && !status.isEmpty()) {
	        if (status.equals("WAIT")) {
	            sql.append(" AND (reply_content IS NULL OR TRIM(reply_content) = '')");
	        } else if (status.equals("DONE")) {
	            sql.append(" AND reply_content IS NOT NULL AND TRIM(reply_content) != ''");
	        }
	    }

	    try (Connection con = DbConnection.getInstance().getDbConn();
	         PreparedStatement pstmt = con.prepareStatement(sql.toString())) {

	        for (int i = 0; i < params.size(); i++) {
	            Object param = params.get(i);
	            if (param instanceof Integer) {
	                pstmt.setInt(i + 1, (Integer) param);
	            } else {
	                pstmt.setString(i + 1, param.toString());
	            }
	        }

	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                return rs.getInt(1);
	            }
	        }
	    }

	    return 0;
	}

	// InquiryDAO.java
	public InquiryDTO selectById(int inquiryId) throws SQLException {
	    String sql = "SELECT i.*, u.username FROM inquiry i JOIN users u ON i.user_id = u.user_id WHERE i.inquiry_id = ?";

	    try (Connection conn = DbConnection.getInstance().getDbConn();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, inquiryId);

	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                InquiryDTO dto = new InquiryDTO();
	                dto.setInquiryId(rs.getInt("inquiry_id"));
	                dto.setUserId(rs.getInt("user_id"));
	                dto.setTitle(rs.getString("title"));
	                dto.setContent(rs.getString("content"));
	                dto.setCreatedAt(rs.getTimestamp("created_at"));
	                dto.setReplyContent(rs.getString("reply_content"));
	                dto.setUsername(rs.getString("username")); 
	                return dto;
	            }
	        }
	    }
	    return null;
	}

	
	
}//class
