package news;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class NewsService {

    

    // 한 화면에 보여줄 게시물 수
    public int pageScale() {
       int pageScale=5;
       
        return pageScale;
    }

    // 전체 페이지 수
    public int totalPage(int totalCount, int pageScale) {
       int totalPage=1;
       
       totalPage=(int) Math.ceil((double) totalCount / pageScale);
        
       return totalPage;
    }

    // 시작 번호 구하기
    public int startNum(int pageScale, PseRangeDTO prDTO) {
        int startNum=1;
        
        startNum= prDTO.getCurrentPage()*pageScale-pageScale+1;
        prDTO.setStartNum(startNum);
       
       return startNum;
    }

    // 끝 번호
    public int endNum(int pageScale, PseRangeDTO prDTO) {
       int endNum=1;
       
       endNum=prDTO.getStartNum()+pageScale-1;
       prDTO.setEndNum(endNum);
       
        return endNum;
    }

    public List<BoardDTO> getNewsByType(PseRangeDTO prDTO, String type) {
        List<BoardDTO> list = new ArrayList<>();
        NewsDAO nDAO = NewsDAO.getInstance();
        try {
            list = nDAO.selectNewsByType(prDTO, type);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int totalCount(PseRangeDTO prDTO, String type) {
        int cnt = 0;
        NewsDAO nDAO = NewsDAO.getInstance();
        try {
            cnt = nDAO.TotalBoardCount(prDTO, type);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cnt;
    }

    // 공지사항 게시글 상세보기
    public BoardDTO getOneNotice(int board_id) {
       BoardDTO bDTO=null;
       
       NewsDAO nDAO=NewsDAO.getInstance();
        try {
           bDTO=nDAO.selectOneNotice(board_id);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bDTO;
    }
    
    // 이벤트 게시글 상세보기
    public BoardDTO getOneEvent(int board_id) {
       BoardDTO bDTO=null;
       
       NewsDAO nDAO=NewsDAO.getInstance();
       try {
          bDTO=nDAO.selectOneEvent(board_id);
       } catch (SQLException e) {
          e.printStackTrace();
       }
       return bDTO;
    }
    
    // 이벤트 게시글 전체 가져오기
    public List<BoardDTO> getAllEvent(String type) {
    	List<BoardDTO> list = new ArrayList<>();
    	
    	NewsDAO nDAO=NewsDAO.getInstance();
    	try {
    		list=nDAO.selectAllEvent(type);
    	} catch (SQLException e) {
    		e.printStackTrace();
    	}
    	return list;
    }

    // 공지사항 추가
    public boolean addNotice(BoardDTO bDTO) {
       boolean flag=false;
       
       NewsDAO nDAO=NewsDAO.getInstance();
       try {
          nDAO.insertNotice(bDTO);
          flag=true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
       return flag;
    }//addNotice
    
    // 이벤트 추가
    public boolean addEvent(BoardDTO bDTO) {
       boolean flag=false;
       
       NewsDAO nDAO=NewsDAO.getInstance();
       try {
          nDAO.insertEvent(bDTO);
          flag=true;
       } catch (SQLException e) {
          e.printStackTrace();
       }
       return flag;
    }//addNotice

    // 공지사항 수정
    public boolean modifyNotice(BoardDTO bDTO) {
       boolean flag=false;
       
       NewsDAO nDAO=NewsDAO.getInstance();
        try {
           flag=nDAO.updateNotice(bDTO) == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return flag;
    }//modifyNotice
    
    // 이벤트 수정
    public boolean modifyEvent(BoardDTO bDTO) {
       boolean flag=false;
       
       NewsDAO nDAO=NewsDAO.getInstance();
       try {
          flag=nDAO.updateEvent(bDTO) == 1;
       } catch (SQLException e) {
          e.printStackTrace();
       }
       return flag;
    }//modifyEvent

    // 뉴스 삭제
    public boolean removeNews(BoardDTO bDTO) {
       boolean flag=false;
       
       NewsDAO nDAO=NewsDAO.getInstance();
        
       try {
          flag=nDAO.deleteNews(bDTO) == 1;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return flag;
    }//removeNews

    // 조회수 증가
    public void plusViewCount(int board_id) {
       
       NewsDAO nDAO=NewsDAO.getInstance();
        try {
           nDAO.updateCount(board_id);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }//plusViewCount
    
    public List<BoardDTO> searchEventByKeyword(String keyword) {
    	List<BoardDTO> list = new ArrayList<>();
    	
    	NewsDAO nDAO=NewsDAO.getInstance();
    	try {
    		list=nDAO.selectEventByKeyword(keyword);
    	} catch (SQLException e) {
    		e.printStackTrace();
    	}
    	return list;
    }//searchEventByKeyword
    
 	//이벤트 게시글 이전 글 이동
    public BoardDTO getPrevEvent(int board_id) {
       BoardDTO bDTO=null;
       
       NewsDAO nDAO=NewsDAO.getInstance();
       try {
          bDTO=nDAO.selectPrevEvent(board_id);
       } catch (SQLException e) {
          e.printStackTrace();
       }
       return bDTO;
    }//getPrevEvent
    
    //이벤트 게시글 다음 글 이동
    public BoardDTO getNextEvent(int board_id) {
    	BoardDTO bDTO=null;
    	
    	NewsDAO nDAO=NewsDAO.getInstance();
    	try {
    		bDTO=nDAO.selectNextEvent(board_id);
    	} catch (SQLException e) {
    		e.printStackTrace();
    	}
    	return bDTO;
    }//getNextEvent
    
  
} // class
