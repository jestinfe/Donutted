package review;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import util.RangeDTO;

public class ReviewService {
    private ReviewDAO dao = ReviewDAO.getInstance();

    public int writeReview(ReviewDTO dto) throws SQLException {
        return dao.insertReview(dto);
    }

    public ReviewDTO getReviewByOrderItemId(int orderItemId) throws SQLException {
        return dao.selectByOrderItemId(orderItemId);
    }

    public List<ReviewDTO> getUserReviews(int userId) throws SQLException {
        return dao.selectByUserId(userId);
    }

    public int deleteReview(int reviewId) throws SQLException {
        return dao.deleteReview(reviewId);
    }
    
    public int updateReview(ReviewDTO dto) throws SQLException {
        return dao.updateReview(dto);
    }
    
    public List<Integer> getWritableOrderItemIdsByUser(int userId) throws SQLException {
        return dao.selectWritableOrderItemIdsByUser(userId);
    }
    
    public List<ReviewDTO> getAllReviews(String keyword, String sortOrder) throws SQLException {
        return dao.selectAllReviews(keyword, sortOrder);
    }


    public ReviewDTO getReviewById(int reviewId) throws SQLException {
        return dao.selectByReviewId(reviewId);
    }
    
    public List<ReviewDTO> getPagedReviews(String keyword, String sort, RangeDTO range) throws SQLException {
        return dao.selectPagedReviews(keyword, sort, range);
    }

    public int countReviews(String keyword) throws SQLException {
        return dao.countReviews(keyword);
    }
    
 // 리뷰 목록 조회 (평점 필터링 포함)
    public List<ReviewDTO> getReviewsByProductIdAndRating(int productId, int rating) throws SQLException {
        return dao.selectReviewsByProductIdAndRating(productId, rating);
    }

 
    public int countReviewsByProductIdAndRating(int productId, int rating) throws SQLException {
        return dao.countReviewsByProductIdAndRating(productId, rating);
    }

    // 평균 평점
    public double getAverageRatingByProductId(int productId) throws SQLException {
        return dao.getAverageRatingByProductId(productId);
    }

 
    
    



}
