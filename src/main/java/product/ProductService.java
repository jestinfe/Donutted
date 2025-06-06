package product;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductService {
	private ProductDAO dao = ProductDAO.getInstance();
	
	public List<ProductDTO> getFilteredProducts(String keyword, String dateOrder, String priceOrder) {
		List<ProductDTO> list = new ArrayList<>();
		try {
			list = dao.selectFilteredProducts(keyword, dateOrder, priceOrder);
		} catch (SQLException e) {
			e.printStackTrace(); // 실무에선 로깅 처리 권장
		}//end catch
		return list;
	}//getAllProducts

	 // 1. 전체 상품 조회 (정렬 포함)
    public List<ProductDTO> getAllProducts(String sort) {
        List<ProductDTO> list = new ArrayList<>();
        try {
            list = dao.selectAllProducts(sort);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. 카테고리별 상품 조회 (정렬 포함)
    public List<ProductDTO> getProductsByCategory(int categoryId, String sort) {
        List<ProductDTO> list = new ArrayList<>();
        try {
            list = dao.selectProductsByCategory(categoryId, sort);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. 상품 1개 상세 조회
    public ProductDTO getProductById(int productId) {
        ProductDTO dto = null;
        try {
            dto = dao.selectProductById(productId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dto;
    }

    // 4. 상품 등록
    public boolean addProduct(ProductDTO dto) {
        boolean flag = false;
        try {
            int result = dao.insertProduct(dto);
            flag = result == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return flag;
    }

    // 5. 상품 수정
    public boolean modifyProduct(ProductDTO dto) {
        boolean flag = false;
        try {
            int result = dao.updateProduct(dto);
            flag = result == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return flag;
    }

   
}