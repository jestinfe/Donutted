package product;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductService {
	private ProductDAO dao = ProductDAO.getInstance();

	// 1. 전체 상품 조회
	public List<ProductDTO> getAllProducts() {
		List<ProductDTO> list = new ArrayList<>();
		try {
			list = dao.selectAllProducts();
		} catch (SQLException e) {
			e.printStackTrace(); // 실무에선 로깅 처리 권장
		}//end catch
		return list;
	}//getAllProducts
	
	public List<ProductDTO> getFilteredProducts(String keyword, String dateOrder, String priceOrder) {
		List<ProductDTO> list = new ArrayList<>();
		try {
			list = dao.selectFilteredProducts(keyword, dateOrder, priceOrder);
		} catch (SQLException e) {
			e.printStackTrace(); // 실무에선 로깅 처리 권장
		}//end catch
		return list;
	}//getAllProducts

	// 2. 상품 1개 상세 조회
	public ProductDTO getProductById(int productId) {
		ProductDTO dto = null;
		try {
			dto = dao.selectProductById(productId);
		} catch (SQLException e) {
			e.printStackTrace();
		}//end catch
		return dto;
	}//getProductById


	// 4. 카테고리별 상품 조회
	public List<ProductDTO> getProductsByCategory(int categoryId) {
		List<ProductDTO> list = new ArrayList<>();
		try {
			list = dao.selectProductsByCategory(categoryId);
		} catch (SQLException e) {
			e.printStackTrace();
		}//end catch
		return list;
	}//getProductsByCategory

	// 5. 상품 등록
	public boolean addProduct(ProductDTO dto) {
		boolean flag = false;
		try {
			int result = dao.insertProduct(dto);
			flag = result == 1;
		} catch (SQLException e) {
			e.printStackTrace();
		}//end catch
		return flag;
	}//addProduct

	// 6. 상품 수정
	public boolean modifyProduct(ProductDTO dto) {
		boolean flag = false;
		try {
			int result = dao.updateProduct(dto);
			flag = result == 1;
		} catch (SQLException e) {
			e.printStackTrace();
		}//end catch
		return flag;
	}//modifyProduct

	// 7. 상품 삭제
	public boolean removeProduct(int productId) {
		boolean flag = false;
		try {
			int result = dao.deleteProduct(productId);
			flag = result == 1;
		} catch (SQLException e) {
			e.printStackTrace();
		}//end catch
		return flag;
	}//removeProduct
}//class

