package order;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SingleOrderDTO {
	private int productId,price,stock,categoryId;
	private String name, code, thumbnailImg, detailImg;
	private Date redDate, modDate;
	
}
