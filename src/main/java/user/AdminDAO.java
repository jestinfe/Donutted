package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import util.DbConnection;

public class AdminDAO {
    private static AdminDAO aDAO;
    private DbConnection db;

    private AdminDAO() {
        db = DbConnection.getInstance();
    }

    public static AdminDAO getInstance() {
        if (aDAO == null) {
            aDAO = new AdminDAO();
        }
        return aDAO;
    }

    /** 관리자 로그인 검증 */
    public boolean isValidAdmin(String adminId, String adminPass) throws SQLException {
        String sql = "SELECT * FROM admin WHERE ADMIN_ID = ? AND ADMIN_PASS = ?";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setString(1, adminId.trim());
            pstmt.setString(2, adminPass.trim());
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();  // 한 명이라도 있으면 로그인 성공
            }
        }
    }

    /** 관리자 정보 가져오기 (옵션) */
    public AdminDTO selectByAdminId(String adminId) throws SQLException {
        String sql = "SELECT * FROM admin WHERE ADMIN_ID = ?";
        AdminDTO dto = null;

        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setString(1, adminId.trim());
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    dto = new AdminDTO();
                    dto.setAdminId(rs.getString("ADMIN_ID"));
                    dto.setAdminPass(rs.getString("ADMIN_PASS"));
                }
            }
        }
        return dto;
    }
}
