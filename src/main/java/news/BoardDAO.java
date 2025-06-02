package news;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.sist.dao.DbConnection;

public class BoardDAO {

	public void insertFAQ(BoardDTO dto) throws SQLException {
		String sql = "INSERT INTO board (board_id, type, title, content, question, answer, posted_at, admin_id) "
		           + "VALUES (board_seq.NEXTVAL, ?, ?, ?, ?, ?, SYSDATE, ?)";


	    try (Connection con = DbConnection.getInstance().getDbConn();
	         PreparedStatement pstmt = con.prepareStatement(sql)) {

//	        if (dto.getAdmin_id() == null || dto.getAdmin_id().isEmpty()) {
//	            throw new SQLException("admin_id가 누락되었습니다.");
//	        }

	    	pstmt.setString(1, dto.getType());
	    	pstmt.setString(2, dto.getTitle());
	    	pstmt.setString(3, dto.getContent());
	    	pstmt.setString(4, dto.getQuestion());
	    	pstmt.setString(5, dto.getAnswer());
	    	pstmt.setString(6, dto.getAdmin_id());


	        pstmt.executeUpdate();
	    }
	}

    
    public List<BoardDTO> selectFAQList() throws SQLException {
        List<BoardDTO> list = new ArrayList<>();

        String sql = "SELECT board_id, title, question, answer, posted_at FROM board WHERE type = 'FAQ' ORDER BY board_id DESC";

        try (Connection con = DbConnection.getInstance().getDbConn();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                BoardDTO dto = new BoardDTO();
                dto.setBoard_id(rs.getInt("board_id"));
                dto.setTitle(rs.getString("title"));         // 보통 question과 동일
                dto.setQuestion(rs.getString("question"));
                dto.setAnswer(rs.getString("answer"));
                dto.setPosted_at(rs.getDate("posted_at"));
                list.add(dto);
            }
        }

        return list;
    }

    public BoardDTO selectFAQById(int boardId) throws SQLException {
        String sql = "SELECT board_id, title, question, answer, posted_at FROM board WHERE board_id = ? AND type = 'FAQ'";
        BoardDTO dto = null;

        try (Connection con = DbConnection.getInstance().getDbConn();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setInt(1, boardId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                dto = new BoardDTO();
                dto.setBoard_id(rs.getInt("board_id"));
                dto.setTitle(rs.getString("title"));
                dto.setQuestion(rs.getString("question"));
                dto.setAnswer(rs.getString("answer"));
                dto.setPosted_at(rs.getDate("posted_at"));
            }
        }

        return dto;
    }
    
    public int updateFAQ(BoardDTO dto) throws SQLException {
        String sql = "UPDATE board SET title = ?, content = ?, question = ?, answer = ? WHERE board_id = ?";
        try (Connection con = DbConnection.getInstance().getDbConn();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setString(1, dto.getTitle());
            pstmt.setString(2, dto.getContent());
            pstmt.setString(3, dto.getQuestion());
            pstmt.setString(4, dto.getAnswer());
            pstmt.setInt(5, dto.getBoard_id());

            return pstmt.executeUpdate();
        }
    }

    public int deleteFAQ(int boardId) throws SQLException {
        String sql = "DELETE FROM board WHERE board_id = ?";
        try (Connection con = DbConnection.getInstance().getDbConn();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setInt(1, boardId);
            return pstmt.executeUpdate();
        }
    }


}
