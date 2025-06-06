package dashboard;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

import util.DbConnection;

public class DashBoardDAO {
	
    private static DashBoardDAO instance;
    private final DbConnection db;

    private DashBoardDAO() {
        db = DbConnection.getInstance();
    }

    public static DashBoardDAO getInstance() {
        if (instance == null) {
            instance = new DashBoardDAO();
        }
        return instance;
    }

    public List<DailySummaryDTO> getDailySummary() throws SQLException {
        List<DailySummaryDTO> list = new ArrayList<>();
        DbConnection db = DbConnection.getInstance();

        String sql = """
            SELECT
              d.stat_date,
              NVL(s.total_orders, 0) AS total_orders,
              NVL(s.total_sales, 0) AS total_sales,
              NVL(s.order_canceled, 0) AS order_canceled,
              NVL(s.order_completed, 0) AS order_completed,
              NVL(s.before_shipping, 0) AS before_shipping,
              NVL(s.shipping, 0) AS shipping,
              NVL(s.shipping_done, 0) AS shipping_done,
              NVL(s.refund_requested, 0) AS refund_requested,
              NVL(s.refund_approved, 0) AS refund_approved,
              NVL(s.refund_rejected, 0) AS refund_rejected,
              NVL(s.total_refund_amount, 0) AS total_refund_amount,
              NVL(s.canceled_amount, 0) AS canceled_amount        -- ✅ 주문취소 금액 추가
            FROM (
              SELECT TRUNC(SYSDATE) - LEVEL + 1 AS stat_date
              FROM dual
              CONNECT BY LEVEL <= 7
            ) d
            LEFT JOIN vw_daily_summary s
            ON d.stat_date = s.stat_date
            ORDER BY d.stat_date DESC
        """;

        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery()
        ) {
            while (rs.next()) {
                DailySummaryDTO dto = new DailySummaryDTO();
                dto.setStatDate(rs.getDate("stat_date"));
                dto.setTotalOrders(rs.getInt("total_orders"));
                dto.setTotalSales(rs.getInt("total_sales"));
                dto.setOrderCanceled(rs.getInt("order_canceled"));
                dto.setOrderCompleted(rs.getInt("order_completed"));
                dto.setBeforeShipping(rs.getInt("before_shipping"));
                dto.setShipping(rs.getInt("shipping"));
                dto.setShippingDone(rs.getInt("shipping_done"));
                dto.setRefundRequested(rs.getInt("refund_requested"));
                dto.setRefundApproved(rs.getInt("refund_approved"));
                dto.setRefundRejected(rs.getInt("refund_rejected"));
                dto.setTotalRefundAmount(rs.getInt("total_refund_amount"));
                dto.setCanceledAmount(rs.getInt("canceled_amount"));  // ✅ 추가

                list.add(dto);
            }
        }

        Collections.reverse(list); // 최근 날짜가 뒤로 가게 정렬
        return list;
    }




    public Map<String, Integer> getWeeklyMonthlySummary() throws SQLException {
        DbConnection db = DbConnection.getInstance();
        Map<String, Integer> result = new HashMap<>();

        String sql = """
            SELECT
              SUM(CASE WHEN TRUNC(order_date, 'IW') = TRUNC(SYSDATE, 'IW') THEN total_price ELSE 0 END) AS weekly_sales,
              SUM(CASE WHEN TRUNC(order_date, 'MM') = TRUNC(SYSDATE, 'MM') THEN total_price ELSE 0 END) AS monthly_sales,
              COUNT(CASE WHEN TRUNC(order_date, 'IW') = TRUNC(SYSDATE, 'IW') THEN 1 END) AS weekly_orders,
              COUNT(CASE WHEN TRUNC(order_date, 'MM') = TRUNC(SYSDATE, 'MM') THEN 1 END) AS monthly_orders
            FROM orders
        """;

        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery()
        ) {
            if (rs.next()) {
                result.put("weekly_sales", rs.getInt("weekly_sales"));
                result.put("monthly_sales", rs.getInt("monthly_sales"));
                result.put("weekly_orders", rs.getInt("weekly_orders"));
                result.put("monthly_orders", rs.getInt("monthly_orders"));
            }
        }

        return result;
    }
}
