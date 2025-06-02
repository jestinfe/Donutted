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
	
	  
	  
	  
	//1대1문의 insert
	public void insertInquiry(InquiryDTO inDTO) throws SQLException {
	    String sql = "INSERT INTO inquiry(inquiry_id, user_id, title, content, inquiry_status, created_at) " +
	                 "VALUES (inquiry_seq.nextval, ?, ?, ?, ?, SYSDATE)";

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

	
	
}//class
