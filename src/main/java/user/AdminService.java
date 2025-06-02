package user;

import java.sql.SQLException;

public class AdminService {

    // DAO 싱글톤 인스턴스 주입
    private final AdminDAO adminDAO = AdminDAO.getInstance();

    /** 관리자 로그인 */
    public boolean login(String adminId, String adminPass) {
        try {
            return adminDAO.isValidAdmin(adminId, adminPass);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** 관리자 정보 조회 (선택 기능) */
    public AdminDTO getAdminById(String adminId) {
        try {
            return adminDAO.selectByAdminId(adminId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
