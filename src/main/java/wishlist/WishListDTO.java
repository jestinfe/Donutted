package wishlist;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class WishListDTO {
private Date added_at;
	
	private int userId, wishListId, productId, price;
	private String thumbnailUrl, name;
	
}
