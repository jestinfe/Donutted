package product;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ProductDTO {
	private int productId,price,stock,categoryId;
	private String name, code, thumbnailImg, detailImg;
	private Date redDate, modDate;
	
	private String thumbnailHover;
	private String productImg1,productImg2,productImg3,productImg4;
	private String detailImg2,detailImg3,detailImg4;
}
