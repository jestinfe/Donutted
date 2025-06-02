package review;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class ReviewDTO {
	private int reviewId;
    private int orderItemId;
    private int userId;
    private int rating;
    private String content;
    private Date createdAt;
    private Date updatedAt;
    private String imageUrl;
}
