package refund;

import java.sql.SQLException;
import java.util.List;

import util.RangeDTO;

public class RefundService {
    private RefundDAO dao = RefundDAO.getInstance();

    /** ✅ 관리자: 환불 상태 변경 */
    public int changeRefundStatus(int refundId, String newStatus) throws SQLException {
    	if (refundId <= 0 || newStatus == null || newStatus.trim().isEmpty()) {
            throw new IllegalArgumentException("환불 ID 또는 상태값이 유효하지 않습니다.");
        }
    	return dao.updateRefundStatus(refundId, newStatus);
    }

    /** ✅ 관리자: 전체 환불 목록 조회 */
    public List<RefundDTO> getRefundList() throws SQLException {
        return dao.getAllRefunds();
    }

    /** ✅ 사용자: 환불 신청 */
    public int applyRefund(RefundDTO dto) throws SQLException {
        if (dto.getOrderItemId() <= 0 || dto.getRefundStatus() == null || dto.getRefundReason() == null) {
            throw new IllegalArgumentException("환불 신청에 필요한 정보가 부족합니다.");
        }
        return dao.insertRefund(dto);
    }

    /** ✅ 사용자: 환불 신청 중복 여부 체크 */
    public boolean isAlreadyRequested(int orderItemId) throws SQLException {
        return dao.isRefundRequested(orderItemId);
    }

    /** ✅ 사용자: 환불 취소 (신청 상태일 경우만 가능) */
    public int cancelRefund(int refundId, int userId) throws SQLException {
        return dao.deleteRefund(refundId, userId);
    }

    /** ✅ 사용자: 내 환불 내역 전체 조회 */
    public List<RefundDTO> getUserRefunds(int userId) throws SQLException {
        return dao.selectByUserId(userId); // 상품명 및 썸네일 포함
    }

    /** ✅ 사용자: 특정 환불 상세 조회 */
    public RefundDTO getRefundById(int refundId) throws SQLException {
        return dao.selectById(refundId);
    }
    
    public List<RefundDTO> searchRefunds(String userId, String status, String fromDate, String toDate) throws SQLException {
        return dao.searchRefunds(userId, status, fromDate, toDate);
    }

    public int getRefundSearchCount(String userId, String status, String fromDate, String toDate) throws SQLException {
        return dao.getRefundSearchCount(userId, status, fromDate, toDate);
    }
    
    public List<RefundDTO> searchRefunds(String userId, String status, String fromDate, String toDate, RangeDTO range) throws SQLException {
        return dao.searchRefunds(userId, status, fromDate, toDate, range);
    }


}
