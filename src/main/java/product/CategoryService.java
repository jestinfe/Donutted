package product;

import java.util.ArrayList;
import java.util.List;

public class CategoryService {
	private CategoryDAO dao = CategoryDAO.getInstance();

	
	public List<CategoryDTO> getAllCategories() {
		List<CategoryDTO> list = new ArrayList<>();
		try {
			list = dao.selectAllCategories();
		} catch (Exception e) {
			e.printStackTrace();
		}//end catch
		return list;
	}//getAllCategories
}//class