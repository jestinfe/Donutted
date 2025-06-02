package news;

import java.util.List;

public class BoardService {
    private static BoardService instance;

    private BoardService() {}

    public static BoardService getInstance() {
        if (instance == null) {
            instance = new BoardService();
        }
        return instance;
    }

    public boolean registerFAQ(BoardDTO dto) {
        try {
            BoardDAO dao = new BoardDAO();
            dao.insertFAQ(dto);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // ✅ FAQ 목록 조회
    public List<BoardDTO> getFAQList() {
        try {
            BoardDAO dao = new BoardDAO();
            return dao.selectFAQList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
}
    
    public BoardDTO getFAQDetail(int boardId) {
        try {
            BoardDAO dao = new BoardDAO();
            return dao.selectFAQById(boardId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean updateFAQ(BoardDTO dto) {
        try {
            BoardDAO dao = new BoardDAO();
            return dao.updateFAQ(dto) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteFAQ(int boardId) {
        try {
            BoardDAO dao = new BoardDAO();
            return dao.deleteFAQ(boardId) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    
}//service
