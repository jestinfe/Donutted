package news;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor

public class BoardDTO {
	private int board_id;
	private int viewCount;
	private String admin_id; 
	private String title;
	private String content; 
	private String type; 
	private String thumbnail_url; 
	private String detail_image_url; 
	private String image_url; 
	private String question; 
	private String answer; 
	private Date posted_at;
}
