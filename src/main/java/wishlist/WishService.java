package wishlist;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class WishService {

	public boolean insertWish(WishListDTO wlDTO){
		boolean flag = false;
		WishDAO wDAO = WishDAO.getInstance();
		try {
			wDAO.insertWishItem(wlDTO);
			flag = true;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return flag;
	}//insert
	
	public List<WishListDTO> showWishList(int userId){
		List<WishListDTO> list = new ArrayList<WishListDTO>();
		WishDAO wDAO = WishDAO.getInstance();
		try {
			list = wDAO.selectAllWishList(userId);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}//showwishlist
	
	public boolean removeWishList(WishListDTO wlDTO, int productId) {
		boolean flag= false;
		WishDAO wDAO = WishDAO.getInstance();
		try {
			wDAO.deleteWishItem(wlDTO, productId);
			
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return flag;
	}
	
	public boolean existWishes(int userId, int productId) {
		boolean flag= false;
		WishDAO wDAO = WishDAO.getInstance();
		try {
			flag=wDAO.wishExist(userId, productId);
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return flag;
	}
	
}
