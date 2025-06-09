package user;

import java.sql.*;
import java.util.*;

import util.CryptoUtil;
import util.DbConnection;
import util.RangeDTO;

public class UserDAO {
	private static UserDAO uDAO;
    private DbConnection db;

    private UserDAO() {
        db = DbConnection.getInstance();
    }

    public static UserDAO getInstance() {
        if (uDAO == null) {
            uDAO = new UserDAO();
        }
        return uDAO;
    }

    public UserDTO selectById(int userId) throws SQLException {
    	if (userId <= 0) {
            System.err.println("Invalid userId: " + userId);
            return null;
        }
        UserDTO dto = null;
        DbConnection db = DbConnection.getInstance();

        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    dto = new UserDTO();
                    dto.setUserId(rs.getInt("user_id"));
                    dto.setUsername(rs.getString("username"));
                    dto.setPassword(rs.getString("password"));
                    dto.setEmail(rs.getString("email"));
                    dto.setName(rs.getString("name"));
                    dto.setBirthdate(rs.getDate("birthdate"));
                    dto.setGender(rs.getString("gender"));
                    dto.setPhone(rs.getString("phone"));
                    dto.setZipcode(rs.getString("zipcode"));
                    dto.setAddress1(rs.getString("address1"));
                    dto.setAddress2(rs.getString("address2"));
                    dto.setUserStatus(rs.getString("user_status"));
                    dto.setCreatedAt(rs.getDate("created_at"));
                }
            }
        }
        return dto;
    }

    public int updateUser(UserDTO dto) throws SQLException {
        DbConnection db = DbConnection.getInstance();
        String sql = "UPDATE users SET password=?, email=?, name=?, birthdate=?, gender=?, phone=?, zipcode=?, address1=?, address2=? WHERE user_id=?";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setString(1, dto.getPassword());
            pstmt.setString(2, dto.getEmail());
            pstmt.setString(3, dto.getName());

            // 🔹 birthdate null 체크
            if (dto.getBirthdate() != null) {
                pstmt.setDate(4, new java.sql.Date(dto.getBirthdate().getTime()));
            } else {
                pstmt.setNull(4, java.sql.Types.DATE);
            }

            pstmt.setString(5, dto.getGender());
            pstmt.setString(6, dto.getPhone());
            pstmt.setString(7, dto.getZipcode());
            pstmt.setString(8, dto.getAddress1());
            pstmt.setString(9, dto.getAddress2());
            pstmt.setInt(10, dto.getUserId());
            return pstmt.executeUpdate();
        }
    }

    
    

    public int withdrawUser(int userId, String encryptedEmail, String updatedUsername) throws SQLException {
        DbConnection db = DbConnection.getInstance();
        String sql = """
            UPDATE users
               SET user_status = 'U2',
                   email = ?,
                   username = ?
             WHERE user_id = ?
        """;

        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setString(1, encryptedEmail);
            pstmt.setString(2, updatedUsername);
            pstmt.setInt(3, userId);
            return pstmt.executeUpdate();
        }
    }



    public List<UserDTO> selectUsers(RangeDTO range, String userStatus, boolean isSearch) throws SQLException {
        DbConnection db = DbConnection.getInstance();
        List<UserDTO> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM ( ")
           .append("  SELECT u.*, ROWNUM rnum ")
           .append("  FROM (SELECT * FROM users ");

        boolean hasWhere = false;
        if (userStatus != null) {
            sql.append("WHERE user_status = ? ");
            hasWhere = true;
        }

        if (isSearch) {
            sql.append(hasWhere ? "AND " : "WHERE ")
               .append(range.getField()).append(" LIKE ? ");
        }

        // 정렬 기준 적용
        sql.append(" ORDER BY created_at ");
        if ("asc".equalsIgnoreCase(range.getSort())) {
            sql.append("ASC ");
        } else {
            sql.append("DESC ");
        }

        sql.append(") u ")
           .append(" WHERE ROWNUM <= ? ")
           .append(") WHERE rnum >= ?");

        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql.toString())
        ) {
            int idx = 1;
            if (userStatus != null) pstmt.setString(idx++, userStatus);
            if (isSearch) pstmt.setString(idx++, "%" + range.getKeyword() + "%");
            pstmt.setInt(idx++, range.getEndNum());
            pstmt.setInt(idx, range.getStartNum());

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    UserDTO dto = new UserDTO();
                    dto.setUserId(rs.getInt("user_id"));
                    dto.setUsername(rs.getString("username"));
                    dto.setEmail(rs.getString("email"));
                    dto.setName(rs.getString("name"));
                    dto.setPhone(rs.getString("phone"));
                    dto.setUserStatus(rs.getString("user_status"));
                    dto.setCreatedAt(rs.getDate("created_at"));
                    list.add(dto);
                }
            }
        }
        return list;
    }


    public int countUsers(String field, String keyword, String userStatus) throws SQLException {
        DbConnection db = DbConnection.getInstance();
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users");
        List<Object> params = new ArrayList<>();

        boolean hasWhere = false;
        if (userStatus != null) {
            sql.append(" WHERE user_status = ?");
            params.add(userStatus);
            hasWhere = true;
        }

        if (field != null && keyword != null) {
            sql.append(hasWhere ? " AND " : " WHERE ")
               .append(field).append(" LIKE ?");
            params.add("%" + keyword + "%");
        }

        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql.toString())
        ) {
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public List<UserDTO> selectAllUsers() throws SQLException {
        DbConnection db = DbConnection.getInstance();
        List<UserDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM users";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery()
        ) {
            while (rs.next()) {
                UserDTO dto = new UserDTO();
                dto.setUserId(rs.getInt("user_id"));
                dto.setUsername(rs.getString("username"));
                dto.setEmail(rs.getString("email"));
                dto.setName(rs.getString("name"));
                dto.setPhone(rs.getString("phone"));
                dto.setUserStatus(rs.getString("user_status"));
                dto.setCreatedAt(rs.getDate("created_at"));
                list.add(dto);
            }
        }
        return list;
    }

    public Map<String, Integer> getWeeklyMonthlySummary() throws SQLException {
        DbConnection db = DbConnection.getInstance();
        Map<String, Integer> result = new HashMap<>();

        String sql = 
            "SELECT " +
            "  (SELECT COUNT(*) FROM orders WHERE order_date >= TRUNC(SYSDATE, 'IW')) AS weekly_orders, " +
            "  (SELECT COUNT(*) FROM orders WHERE order_date >= TRUNC(SYSDATE, 'MM')) AS monthly_orders, " +
            "  (SELECT NVL(SUM(total_price), 0) FROM orders WHERE order_date >= TRUNC(SYSDATE, 'IW')) AS weekly_sales, " +
            "  (SELECT NVL(SUM(total_price), 0) FROM orders WHERE order_date >= TRUNC(SYSDATE, 'MM')) AS monthly_sales " +
            "FROM dual";

        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery()
        ) {
            if (rs.next()) {
                result.put("weekly_orders", rs.getInt("weekly_orders"));
                result.put("monthly_orders", rs.getInt("monthly_orders"));
                result.put("weekly_sales", rs.getInt("weekly_sales"));
                result.put("monthly_sales", rs.getInt("monthly_sales"));
            }
        }

        return result;
    }
    
    public boolean isUsernameExists(String username) throws SQLException {
        String sql = "SELECT username FROM users WHERE username = ?";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
    }  
    
    public int insertUser(UserDTO dto) throws SQLException {
        String sql = "INSERT INTO users (username, password, email, name, birthdate, gender, phone, zipcode, address1, address2, user_status, created_at) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'U1', SYSDATE)";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setString(1, dto.getUsername());
            pstmt.setString(2, dto.getPassword());
            pstmt.setString(3, dto.getEmail());
            pstmt.setString(4, dto.getName());
            pstmt.setDate(5, dto.getBirthdate());
            pstmt.setString(6, dto.getGender());
            pstmt.setString(7, dto.getPhone());
            pstmt.setString(8, dto.getZipcode());
            pstmt.setString(9, dto.getAddress1());
            pstmt.setString(10, dto.getAddress2());
            return pstmt.executeUpdate();
        }
    }

    public boolean isValidLogin(String username, String password) throws SQLException {
        String sql = "SELECT user_id FROM users WHERE username = ? AND password = ?";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
    }


    public String findUsernameByNameAndPhone(String name, String phone) throws SQLException {
        String sql = "SELECT username FROM users WHERE name = ? AND phone = ?";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setString(1, name);
            pstmt.setString(2, phone);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getString("username") : null;
            }
        }
    }
    
    public boolean isValidUserForPasswordReset(String username, String email, String phone) throws SQLException {
        String sql = "SELECT user_id FROM users WHERE username = ? AND email = ? AND phone = ?";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setString(1, username);
            pstmt.setString(2, email);
            pstmt.setString(3, phone);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
    }
    public String getPasswordById(String username) throws SQLException {
        String sql = "SELECT password FROM users WHERE username = ?";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("password");
                }
            }
        }
        return null;
    }
    
    public boolean resetPassword(String username, String hashedPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE username = ?";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            // 여기에서 hashSHA256 절대 다시 하지 말고 그대로 저장
            pstmt.setString(1, hashedPassword);
            pstmt.setString(2, username);
            return pstmt.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    public UserDTO selectByUsernameAndPassword(String username, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ? AND user_status = 'U1'";
        UserDTO dto = null;

        try (
            Connection con = DbConnection.getInstance().getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                dto = new UserDTO();
                dto.setUserId(rs.getInt("user_id"));              
                dto.setUsername(rs.getString("username"));
                dto.setPassword(rs.getString("password"));
                dto.setEmail(rs.getString("email"));
                dto.setName(rs.getString("name"));
                dto.setPhone(rs.getString("phone"));
            }
        }
        return dto;
    }


    
}
