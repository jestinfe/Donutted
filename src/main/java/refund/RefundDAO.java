package refund;

import refund.RefundDTO;
import util.DbConnection;
import util.RangeDTO;

import java.sql.*;
import java.util.*;

public class RefundDAO {
    private static RefundDAO rDAO;
    private DbConnection db;

    private RefundDAO() {
        db = DbConnection.getInstance();
    }

    public static RefundDAO getInstance() {
        if (rDAO == null) {
            rDAO = new RefundDAO();
        }
        return rDAO;
    }

    // 환불 상태 변경
    public int updateRefundStatus(int refundId, String newStatus) throws SQLException {
        String sql = "UPDATE refund SET refund_status = ?, processed_at = SYSDATE WHERE refund_id = ?";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, refundId);
            return pstmt.executeUpdate();
        }
    }

    // 환불 전체 목록 조회
    public List<RefundDTO> getAllRefunds() throws SQLException {
        List<RefundDTO> list = new ArrayList<>();
        
        String sql = "SELECT r.refund_id, r.order_item_id, r.requested_at, r.processed_at, " +
                     "r.refund_status, r.refund_reason, " +
                     "sc.description AS refund_reason_text, " +
                     "p.name AS product_name " +
                     "FROM refund r " +
                     "LEFT JOIN status_code sc ON r.refund_reason = sc.code AND sc.category = 'REFUND_REASON' " +
                     "LEFT JOIN order_item oi ON r.order_item_id = oi.order_item_id " +
                     "LEFT JOIN product p ON oi.product_id = p.product_id " +
                     "ORDER BY r.requested_at DESC";

        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery()
        ) {
            while (rs.next()) {
                RefundDTO dto = new RefundDTO();
                dto.setRefundId(rs.getInt("refund_id"));
                dto.setOrderItemId(rs.getInt("order_item_id"));
                dto.setRequestedAt(rs.getDate("requested_at"));
                dto.setProcessedAt(rs.getDate("processed_at"));
                dto.setRefundStatus(rs.getString("refund_status"));
                dto.setRefundReason(rs.getString("refund_reason")); // RR1, RR2 등
                dto.setRefundReasonText(rs.getString("refund_reason_text")); // 실제 설명
                dto.setProductName(rs.getString("product_name"));
                list.add(dto);
            }
        }

        return list;
    }


    
 // 환불 신청
    public int insertRefund(RefundDTO dto) throws SQLException {
        String sql = "INSERT INTO refund (order_item_id, requested_at, refund_status, refund_reason) VALUES (?, SYSDATE, ?, ?)";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setInt(1, dto.getOrderItemId());
            pstmt.setString(2, dto.getRefundStatus());  // "RS1"
            pstmt.setString(3, dto.getRefundReason());
            return pstmt.executeUpdate();
        }
    }


    // 환불 취소 (신청 중인 환불만 삭제 가능)
    public int deleteRefund(int refundId, int userId) throws SQLException {
        String sql = "DELETE FROM refund WHERE refund_id = ? AND refund_status = 'RS1' AND order_item_id IN "
                   + "(SELECT order_item_id FROM order_item oi JOIN orders o ON oi.order_id = o.order_id WHERE o.user_id = ?)";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setInt(1, refundId);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate();
        }
    }

    // 환불 상세 조회
    public RefundDTO selectById(int refundId) throws SQLException {
        RefundDTO dto = null;
        String sql = "SELECT * FROM refund WHERE refund_id = ?";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setInt(1, refundId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    dto = new RefundDTO();
                    dto.setRefundId(rs.getInt("refund_id"));
                    dto.setOrderItemId(rs.getInt("order_item_id"));
                    dto.setRequestedAt(rs.getDate("requested_at"));
                    dto.setProcessedAt(rs.getDate("processed_at"));
                    dto.setRefundStatus(rs.getString("refund_status"));
                }
            }
        }
        return dto;
    }

    public List<RefundDTO> selectByUserId(int userId) throws SQLException {
        List<RefundDTO> list = new ArrayList<>();
        String sql = "SELECT r.*, " +
                     "       oi.quantity, oi.unit_price, " +
                     "       p.name AS product_name, p.thumbnail_url, " +
                     "       sc.description AS refund_reason_text " +
                     "FROM refund r " +
                     "JOIN order_item oi ON r.order_item_id = oi.order_item_id " +
                     "JOIN orders o ON oi.order_id = o.order_id " +
                     "JOIN product p ON oi.product_id = p.product_id " +
                     "LEFT JOIN status_code sc ON r.refund_reason = sc.code AND sc.category = 'REFUND_REASON' " +
                     "WHERE o.user_id = ? " +
                     "ORDER BY r.requested_at DESC";

        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    RefundDTO dto = new RefundDTO();
                    dto.setRefundId(rs.getInt("refund_id"));
                    dto.setOrderItemId(rs.getInt("order_item_id"));
                    dto.setRequestedAt(rs.getDate("requested_at"));
                    dto.setProcessedAt(rs.getDate("processed_at"));
                    dto.setRefundStatus(rs.getString("refund_status"));
                    dto.setRefundReason(rs.getString("refund_reason"));
                    dto.setProductName(rs.getString("product_name"));
                    dto.setThumbnailUrl(rs.getString("thumbnail_url"));
                    dto.setRefundReasonText(rs.getString("refund_reason_text"));
                    dto.setQuantity(rs.getInt("quantity"));           // ✅ 추가
                    dto.setUnitPrice(rs.getDouble("unit_price"));     // ✅ 추가
                    list.add(dto);
                }
            }
        }
        return list;
    }



    public boolean isRefundRequested(int orderItemId) throws SQLException {
        String sql = "SELECT 1 FROM refund WHERE order_item_id = ?";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setInt(1, orderItemId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
    }
    
    public List<RefundDTO> searchRefunds(String userId, String status, String fromDate, String toDate) throws SQLException {
        List<RefundDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("""
            SELECT r.refund_id, r.order_item_id, r.requested_at, r.processed_at,
                   r.refund_status, r.refund_reason,
                   oi.quantity, oi.unit_price,
                   p.name AS product_name,
                   u.user_id,
                   sc.description AS refund_reason_text
              FROM refund r
              JOIN order_item oi ON r.order_item_id = oi.order_item_id
              JOIN product p ON oi.product_id = p.product_id
              JOIN orders o ON oi.order_id = o.order_id
              JOIN users u ON o.user_id = u.user_id
              LEFT JOIN status_code sc ON r.refund_reason = sc.code AND sc.category = 'REFUND_REASON'
             WHERE 1=1
        """);

        if (userId != null && !userId.trim().isEmpty()) {
            sql.append(" AND u.user_id = ? ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND r.refund_status = ? ");
        }
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append(" AND r.requested_at >= TO_DATE(?, 'YYYY-MM-DD') ");
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append(" AND r.requested_at <= TO_DATE(?, 'YYYY-MM-DD') ");
        }

        sql.append(" ORDER BY r.requested_at DESC ");

        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql.toString())
        ) {
            int idx = 1;
            if (userId != null && !userId.trim().isEmpty()) {
                pstmt.setInt(idx++, Integer.parseInt(userId));
            }
            if (status != null && !status.trim().isEmpty()) {
                pstmt.setString(idx++, status);
            }
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                pstmt.setString(idx++, fromDate);
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                pstmt.setString(idx++, toDate);
            }

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                RefundDTO dto = new RefundDTO();
                dto.setRefundId(rs.getInt("refund_id"));
                dto.setOrderItemId(rs.getInt("order_item_id"));
                dto.setRequestedAt(rs.getDate("requested_at"));
                dto.setProcessedAt(rs.getDate("processed_at"));
                dto.setRefundStatus(rs.getString("refund_status"));
                dto.setRefundReason(rs.getString("refund_reason"));
                dto.setRefundReasonText(rs.getString("refund_reason_text"));
                dto.setProductName(rs.getString("product_name"));
                dto.setUserId(rs.getInt("user_id"));
                dto.setQuantity(rs.getInt("quantity"));           // ✅ 수량
                dto.setUnitPrice(rs.getDouble("unit_price"));     // ✅ 단가
                list.add(dto);
            }
        }

        return list;
    }



    // 환불 사유 설명을 코드로부터 조회 (간단히 switch문으로도 가능)
    private String getRefundReasonText(String reasonCode) {
        Map<String, String> reasonMap = new HashMap<>();
        reasonMap.put("RR1", "상품이 마음에 들지 않음");
        reasonMap.put("RR2", "옵션 변경 요청");
        reasonMap.put("RR3", "박스 분실");
        reasonMap.put("RR4", "주소 오류");
        reasonMap.put("RR5", "구성품 누락");
        reasonMap.put("RR6", "상품 설명과 다름");
        reasonMap.put("RR7", "오배송");
        reasonMap.put("RR8", "상품 파손/고장");
        return reasonMap.getOrDefault(reasonCode, reasonCode);
    }
    
    public int getRefundSearchCount(String userId, String status, String fromDate, String toDate) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) ")
           .append("FROM refund r ")
           .append("JOIN order_item oi ON r.order_item_id = oi.order_item_id ")
           .append("JOIN orders o ON oi.order_id = o.order_id ")
           .append("JOIN users u ON o.user_id = u.user_id ")
           .append("WHERE 1=1 ");

        if (userId != null && !userId.trim().isEmpty()) {
            sql.append("AND u.user_id = ? ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND r.refund_status = ? ");
        }
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append("AND r.requested_at >= TO_DATE(?, 'YYYY-MM-DD') ");
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append("AND r.requested_at <= TO_DATE(?, 'YYYY-MM-DD') ");
        }

        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql.toString())
        ) {
            int idx = 1;
            if (userId != null && !userId.trim().isEmpty()) {
                pstmt.setInt(idx++, Integer.parseInt(userId));
            }
            if (status != null && !status.trim().isEmpty()) {
                pstmt.setString(idx++, status);
            }
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                pstmt.setString(idx++, fromDate);
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                pstmt.setString(idx++, toDate);
            }

            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }

    public List<RefundDTO> searchRefunds(String userId, String status, String fromDate, String toDate, RangeDTO range) throws SQLException {
        List<RefundDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM ( ");
        sql.append("  SELECT rownum rnum, a.* FROM ( ");
        sql.append("""
            SELECT r.refund_id, r.order_item_id, r.requested_at, r.processed_at,
                   r.refund_status, r.refund_reason,
                   oi.quantity, oi.unit_price,
                   p.name AS product_name,
                   u.user_id,
                   sc.description AS refund_reason_text
              FROM refund r
              JOIN order_item oi ON r.order_item_id = oi.order_item_id
              JOIN product p ON oi.product_id = p.product_id
              JOIN orders o ON oi.order_id = o.order_id
              JOIN users u ON o.user_id = u.user_id
              LEFT JOIN status_code sc ON r.refund_reason = sc.code AND sc.category = 'REFUND_REASON'
             WHERE 1=1
        """);

        if (userId != null && !userId.trim().isEmpty()) {
            sql.append("AND u.user_id = ? ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND r.refund_status = ? ");
        }
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append("AND r.requested_at >= TO_DATE(?, 'YYYY-MM-DD') ");
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append("AND r.requested_at <= TO_DATE(?, 'YYYY-MM-DD') ");
        }

        sql.append("    ORDER BY r.requested_at DESC ");
        sql.append("  ) a ");
        sql.append("  WHERE rownum <= ? ");
        sql.append(") WHERE rnum >= ?");

        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql.toString())
        ) {
            int idx = 1;
            if (userId != null && !userId.trim().isEmpty()) {
                pstmt.setInt(idx++, Integer.parseInt(userId));
            }
            if (status != null && !status.trim().isEmpty()) {
                pstmt.setString(idx++, status);
            }
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                pstmt.setString(idx++, fromDate);
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                pstmt.setString(idx++, toDate);
            }

            pstmt.setInt(idx++, range.getEndNum());
            pstmt.setInt(idx++, range.getStartNum());

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                RefundDTO dto = new RefundDTO();
                dto.setRefundId(rs.getInt("refund_id"));
                dto.setOrderItemId(rs.getInt("order_item_id"));
                dto.setRequestedAt(rs.getDate("requested_at"));
                dto.setProcessedAt(rs.getDate("processed_at"));
                dto.setRefundStatus(rs.getString("refund_status"));
                dto.setRefundReason(rs.getString("refund_reason"));
                dto.setRefundReasonText(rs.getString("refund_reason_text"));
                dto.setProductName(rs.getString("product_name"));
                dto.setUserId(rs.getInt("user_id"));
                dto.setQuantity(rs.getInt("quantity"));           // ✅ 누락되어 있던 필드
                dto.setUnitPrice(rs.getDouble("unit_price"));     // ✅ 누락되어 있던 필드
                list.add(dto);
            }
        }

        return list;
    }


    
}
