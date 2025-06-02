package inquiry;

import java.sql.SQLException;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

public class InquiryService {

	private static InquiryService instance = new InquiryService();

	private InquiryService() {
	}

	public static InquiryService getInstance() {
		return instance;
	}

	public void addInquiry(InquiryDTO dto) throws SQLException {
		InquiryDAO dao = new InquiryDAO();
		dao.insertInquiry(dto);
	}

	public List<InquiryDTO> getUserInquiries(int userId) throws SQLException {
		InquiryDAO dao = new InquiryDAO();
		return dao.selectInquiry(userId);
	}
	public InquiryDTO getInquiryById(int inquiryId) {
	    try {
	        InquiryDAO dao = new InquiryDAO();
	        return dao.selectInquiryById(inquiryId);
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return null;
	    }
	}
	// 관리자 전체 조회
	public List<InquiryDTO> getAllInquiries() throws SQLException {
	    InquiryDAO dao = new InquiryDAO();
	    return dao.selectAllInquiries();
	}

	public void deleteInquiry(int inquiryId) throws SQLException {
	    InquiryDAO dao = new InquiryDAO();
	    dao.deleteInquiry(inquiryId);
	}

	public void updateReply(int inquiryId, String replyContent) throws SQLException {
	    InquiryDAO dao = new InquiryDAO();
	    dao.updateInquiryReply(inquiryId, replyContent);
	}
	
	
	
	public List<InquiryDTO> getPagedInquiries(int offset, int pageSize) {
	    try {
	        return new InquiryDAO().selectPagedInquiries(offset, pageSize);
	        // 또는 InquiryDAO.getInstance().selectPagedInquiries(offset, pageSize);
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return Collections.emptyList();
	    }
	}

	public int getTotalInquiriesCount() {
	    try {
	        return new InquiryDAO().countTotalInquiries();
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return 0;
	    }
	}
	
	public List<InquiryDTO> getUserPagedInquiries(int userId, int offset, int pageSize) {
	    try {
	        return new InquiryDAO().selectUserPagedInquiries(userId, offset, pageSize);
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return Collections.emptyList();
	    }
	}

	public int getUserInquiriesCount(int userId) {
	    try {
	        return new InquiryDAO().countUserInquiries(userId);
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return 0;
	    }
	}

	
	

}
	
