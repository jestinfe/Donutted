package cart;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartService {
	public boolean addToCart(CartItemDTO ciDTO) {
		boolean flag = false;
		CartDAO cDAO = CartDAO.getInstance();
		try {
			cDAO.insertCartItem(ciDTO);
			flag = true;
			System.out.println("qty : "+ ciDTO.getQuantity());
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return flag;
		
	}//addTocart
	
	public Integer searchCartId(int userId) {
		Integer cartNum = 0;
		CartDAO cDAO = CartDAO.getInstance();
		System.out.println(userId);
		try {
			cartNum = cDAO.getCartIdByUser(userId);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return cartNum;
	}//searchCartId
	
	public int makeCartId(int userId) {
		int cartId = 0;
		CartDAO cDAO = CartDAO.getInstance();
		
		try {
			cartId = cDAO.createCartId(userId);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return cartId;
	}
	
	public List<CartItemDTO> showAllCartItem(int userId){
		List<CartItemDTO> list = new ArrayList<CartItemDTO>();
		CartDAO cDAO = CartDAO.getInstance();
		
		try {
			Integer cartId = cDAO.getCartIdByUser(userId);
			if(cartId != 0) {
			list = cDAO.selectAllCartItem(cartId);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
		
	}
	
	public boolean existsCart(int cartId, int productId) {
		boolean exists = false;
		CartDAO cDAO = CartDAO.getInstance();
		
		try {
			exists = cDAO.isItemInCart(cartId, productId);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return exists;
	}
	
	public boolean deleteCartItem(int cartId, int productId) {
		boolean flag= false;
		CartDAO cDAO = CartDAO.getInstance();
		System.out.println(productId);
		
		try {
			cDAO.deleteCart(productId, cartId);
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return flag;
	}
	public List<String> searchRemoved(int productId, int cartId){
		List<String> list = new ArrayList<>();
		CartDAO cDAO = CartDAO.getInstance();
		try {
			list = cDAO.searchRemovedItem(productId, cartId);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}
	
}
