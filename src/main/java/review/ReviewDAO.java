package review;

import java.sql.*;
import java.util.*;

import util.DbConnection;
import util.RangeDTO;

public class ReviewDAO {
    private static ReviewDAO rDAO;
    private DbConnection db;

    private ReviewDAO() {
        db = DbConnection.getInstance();
    }

    public static ReviewDAO getInstance() {
        if (rDAO == null) {
            rDAO = new ReviewDAO();
        }
        return rDAO;
    }

    // 리뷰 등록
    public int insertReview(ReviewDTO dto) throws SQLException {
        String sql = "INSERT INTO review (order_item_id, user_id, rating, content, image_url) VALUES (?, ?, ?, ?, ?)";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setInt(1, dto.getOrderItemId());
            pstmt.setInt(2, dto.getUserId());
            pstmt.setInt(3, dto.getRating());
            pstmt.setString(4, dto.getContent());
            pstmt.setString(5, dto.getImageUrl());
            return pstmt.executeUpdate();
        }
    }

    // 특정 order_item_id에 대한 리뷰 조회
    public ReviewDTO selectByOrderItemId(int orderItemId) throws SQLException {
        String sql = "SELECT * FROM review WHERE order_item_id = ?";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setInt(1, orderItemId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    ReviewDTO dto = new ReviewDTO();
                    dto.setReviewId(rs.getInt("review_id"));
                    dto.setOrderItemId(rs.getInt("order_item_id"));
                    dto.setUserId(rs.getInt("user_id"));
                    dto.setRating(rs.getInt("rating"));
                    dto.setContent(rs.getString("content"));
                    dto.setCreatedAt(rs.getDate("created_at"));
                    dto.setUpdatedAt(rs.getDate("updated_at"));
                    dto.setImageUrl(rs.getString("image_url"));
                    return dto;
                }
            }
        }
        return null;
    }

    // 회원별 리뷰 목록
    public List<ReviewDTO> selectByUserId(int userId) throws SQLException {
        List<ReviewDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM review WHERE user_id = ? ORDER BY created_at DESC";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ReviewDTO dto = new ReviewDTO();
                    dto.setReviewId(rs.getInt("review_id"));
                    dto.setOrderItemId(rs.getInt("order_item_id"));
                    dto.setUserId(rs.getInt("user_id"));
                    dto.setRating(rs.getInt("rating"));
                    dto.setContent(rs.getString("content"));
                    dto.setCreatedAt(rs.getDate("created_at"));
                    dto.setUpdatedAt(rs.getDate("updated_at"));
                    dto.setImageUrl(rs.getString("image_url"));
                    list.add(dto);
                }
            }
        }
        return list;
    }

    // 리뷰 삭제
    public int deleteReview(int reviewId) throws SQLException {
        String sql = "DELETE FROM review WHERE review_id = ?";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setInt(1, reviewId);
            return pstmt.executeUpdate();
        }
    }
    
 // 리뷰 수정
    public int updateReview(ReviewDTO dto) throws SQLException {
        String sql = "UPDATE review SET rating = ?, content = ?, image_url = ?, updated_at = SYSDATE WHERE review_id = ?";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setInt(1, dto.getRating());
            pstmt.setString(2, dto.getContent());
            pstmt.setString(3, dto.getImageUrl());
            pstmt.setInt(4, dto.getReviewId());
            return pstmt.executeUpdate();
        }
    }
    
    

    public List<ReviewDTO> selectAllReviews(String keyword, String sortOrder) throws SQLException {
        List<ReviewDTO> list = new ArrayList<>();
        String sql = """
            SELECT r.*
            FROM review r
            JOIN users u ON r.user_id = u.user_id
            WHERE u.username LIKE ?
            ORDER BY r.created_at """ + (sortOrder.equalsIgnoreCase("asc") ? "ASC" : "DESC");

        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setString(1, "%" + keyword + "%");
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ReviewDTO dto = new ReviewDTO();
                    dto.setReviewId(rs.getInt("review_id"));
                    dto.setOrderItemId(rs.getInt("order_item_id"));
                    dto.setUserId(rs.getInt("user_id"));
                    dto.setRating(rs.getInt("rating"));
                    dto.setContent(rs.getString("content"));
                    dto.setCreatedAt(rs.getDate("created_at"));
                    dto.setUpdatedAt(rs.getDate("updated_at"));
                    dto.setImageUrl(rs.getString("image_url"));
                    list.add(dto);
                }
            }
        }
        return list;
    }

 // 리뷰 ID로 단일 조회
    public ReviewDTO selectByReviewId(int reviewId) throws SQLException {
        String sql = "SELECT * FROM review WHERE review_id = ?";
        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setInt(1, reviewId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    ReviewDTO dto = new ReviewDTO();
                    dto.setReviewId(rs.getInt("review_id"));
                    dto.setOrderItemId(rs.getInt("order_item_id"));
                    dto.setUserId(rs.getInt("user_id"));
                    dto.setRating(rs.getInt("rating"));
                    dto.setContent(rs.getString("content"));
                    dto.setCreatedAt(rs.getDate("created_at"));
                    dto.setUpdatedAt(rs.getDate("updated_at"));
                    dto.setImageUrl(rs.getString("image_url"));
                    return dto;
                }
            }
        }
        return null;
    }

    public List<ReviewDTO> selectPagedReviews(String keyword, String sort, RangeDTO range) throws SQLException {
        List<ReviewDTO> list = new ArrayList<>();

        String orderBy = " DESC"; // 앞에 공백 필수!!!
        if ("asc".equalsIgnoreCase(sort)) {
            orderBy = " ASC";
        }

        String sql = """
            SELECT * FROM (
                SELECT r.*, ROWNUM rnum
                FROM (
                    SELECT r.*
                    FROM review r
                    JOIN users u ON r.user_id = u.user_id
                    WHERE u.username LIKE ?
                    ORDER BY r.created_at""" + orderBy + """
                ) r
                WHERE ROWNUM <= ?
            ) WHERE rnum >= ?
        """;
        System.out.println(sql);

        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setInt(2, range.getEndNum());
            pstmt.setInt(3, range.getStartNum());

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ReviewDTO dto = new ReviewDTO();
                    dto.setReviewId(rs.getInt("review_id"));
                    dto.setOrderItemId(rs.getInt("order_item_id"));
                    dto.setUserId(rs.getInt("user_id"));
                    dto.setRating(rs.getInt("rating"));
                    dto.setContent(rs.getString("content"));
                    dto.setCreatedAt(rs.getDate("created_at"));
                    dto.setUpdatedAt(rs.getDate("updated_at"));
                    dto.setImageUrl(rs.getString("image_url"));
                    list.add(dto);
                }
            }
        }

        return list;
    }


    public int countReviews(String keyword) throws SQLException {
        String sql = "SELECT COUNT(*) FROM review r JOIN users u ON r.user_id = u.user_id WHERE u.username LIKE ?";
        try (Connection con = db.getDbConn(); PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, "%" + keyword + "%");
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }
    
 // 상품별 & 평점별 리뷰 목록 조회
    public List<ReviewDTO> selectReviewsByProductIdAndRating(int productId, int rating) throws SQLException {
        List<ReviewDTO> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT r.*, u.user_id
            FROM review r
            JOIN order_item oi ON r.order_item_id = oi.order_item_id
            JOIN product p ON oi.product_id = p.product_id
            JOIN users u ON r.user_id = u.user_id
            WHERE p.product_id = ?
        """);

        // rating이 0보다 크면 평점 조건 추가
        if (rating > 0) {
            sql.append(" AND r.rating = ?");
        }

        sql.append(" ORDER BY r.created_at DESC");

        try (Connection con = db.getDbConn();
             PreparedStatement pstmt = con.prepareStatement(sql.toString())) {
            pstmt.setInt(1, productId);
            if (rating > 0) {
                pstmt.setInt(2, rating);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ReviewDTO dto = new ReviewDTO();
                    dto.setReviewId(rs.getInt("review_id"));
                    dto.setOrderItemId(rs.getInt("order_item_id"));
                    dto.setUserId(rs.getInt("user_id"));
                    dto.setRating(rs.getInt("rating"));
                    dto.setContent(rs.getString("content"));
                    dto.setImageUrl(rs.getString("image_url"));
                    dto.setCreatedAt(rs.getDate("created_at"));
                    dto.setUpdatedAt(rs.getDate("updated_at"));
                    list.add(dto);
                }
            }
        }

        return list;
    }//selectReviewsByProductIdAndRating

    
    
 // 특정 상품의 평균 평점 계산
    public double getAverageRatingByProductId(int productId) throws SQLException {
        double avg = 0.0;
        String sql = """
            SELECT AVG(rating) AS avg_rating
            FROM review r
            JOIN order_item oi ON r.order_item_id = oi.order_item_id
            WHERE oi.product_id = ?
        """;

        try (Connection con = db.getDbConn();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, productId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    avg = rs.getDouble("avg_rating");
                }
            }
        }
        return avg;
    }

 // 특정 상품 + 평점에 해당하는 리뷰 개수 반환
    public int countReviewsByProductIdAndRating(int productId, int rating) throws SQLException {
        String sql = """
            SELECT COUNT(*) AS count
            FROM review r
            JOIN order_item oi ON r.order_item_id = oi.order_item_id
            WHERE oi.product_id = ?
        """;

        // 평점 조건 추가
        if (rating > 0) {
            sql += " AND r.rating = ?";
        }

        try (Connection con = db.getDbConn();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, productId);
            if (rating > 0) {
                pstmt.setInt(2, rating);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count");
                }
            }
        }

        return 0;
    }
    
 // ReviewDAO.java
    public List<Integer> selectWritableOrderItemIdsByUser(int userId) throws SQLException {
        List<Integer> list = new ArrayList<>();

        String sql = """
            SELECT oi.order_item_id
            FROM order_item oi
            JOIN orders o ON oi.order_id = o.order_id
            WHERE o.user_id = ?
              AND o.order_status = 'O3'
              AND oi.order_item_id NOT IN (SELECT order_item_id FROM review)
            ORDER BY o.order_date DESC
        """;

        try (
            Connection con = db.getDbConn();
            PreparedStatement pstmt = con.prepareStatement(sql)
        ) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("order_item_id"));
                }
            }
        }
        return list;
    }






}
