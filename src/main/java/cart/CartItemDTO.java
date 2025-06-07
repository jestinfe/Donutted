package cart;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * cartItemId = 장바구니 넘버 cartId = 개개인당 할당된 장바구니 ex) user 1001 - 100, 1002 - 101
 */
@Getter
@Setter
@ToString
public class CartItemDTO {

	private Date added_at;

	private int userId, cartItemId, cartId, productId, quantity;
	private String productName;
	private int price, stockQuantity;
	private String thumbnailImg;
	

}
