package order;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderItemDTO {
	 private int orderItemId;
	    private int orderId;
	    private int productId;
	    private int quantity;
	    private int unitPrice;

	    // 조회용 추가 필드
	    private String productName;
	    private String thumbnailUrl;
	    
	    private Date createdAt;
	    
	    private boolean reviewed;
	    

public boolean isReviewed() {
    return reviewed;
}
}