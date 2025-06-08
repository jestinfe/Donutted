package news;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.sist.dao.DbConnection;
import util.RangeDTO;

public class NewsDAO {

    private static NewsDAO nDAO;

    private NewsDAO() {}

    public static NewsDAO getInstance() {
        if (nDAO == null) {
            nDAO = new NewsDAO();
        }
        return nDAO;
    }

    public int TotalBoardCount(PseRangeDTO prDTO, String type) throws SQLException {
        int cnt = 0;
        DbConnection db = DbConnection.getInstance();
        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection con = null;

        try {
            con = db.getDbConn();
            StringBuilder sql = new StringBuilder();
            sql.append(" SELECT COUNT(board_id) cnt FROM board WHERE type = ? ");

            if (prDTO.getKeyword() != null && !"".equals(prDTO.getKeyword())) {
                // 컬럼명을 그대로 사용
            	sql.append(" AND instr(LOWER(").append(prDTO.getField()).append("), LOWER(?)) != 0 ");
            }

            pstmt = con.prepareStatement(sql.toString());
            pstmt.setString(1, type);

            if (prDTO.getKeyword() != null && !"".equals(prDTO.getKeyword())) {
                pstmt.setString(2, prDTO.getKeyword());
            }

            rs = pstmt.executeQuery();
            if (rs.next()) {
                cnt = rs.getInt("cnt");
            }
        } finally {
            db.dbClose(rs, pstmt, con);
        }

        return cnt;
    }

    
    //게시글 전부 가져오기+페이징
    public List<BoardDTO> selectNewsByType(PseRangeDTO prDTO, String type) throws SQLException {
        List<BoardDTO> list = new ArrayList<>();
        DbConnection db = DbConnection.getInstance();

        ResultSet rs = null;
        PreparedStatement pstmt = null;
        Connection con = null;

        try {
            con = db.getDbConn();
            StringBuilder sql = new StringBuilder();
            sql.append(" SELECT board_id, title, posted_at, viewCount, admin_id ")
               .append(" FROM ( ")
               .append("   SELECT board_id, title, posted_at, viewCount, admin_id, ")
               .append("          ROW_NUMBER() OVER (ORDER BY posted_at DESC) rnum ")
               .append("   FROM board ")
               .append("   WHERE type = ? ");
            
            if (prDTO.getKeyword() != null && !"".equals(prDTO.getKeyword())) {
            	sql.append(" AND instr(LOWER(").append(prDTO.getField()).append("), LOWER(?)) != 0 ");
            }


            sql.append(" ) WHERE rnum BETWEEN ? AND ? ");
           
            pstmt = con.prepareStatement(sql.toString());

            int bindIdx = 1;
            pstmt.setString(bindIdx++, type);

            if (prDTO.getKeyword() != null && !"".equals(prDTO.getKeyword())) {
                pstmt.setString(bindIdx++, prDTO.getKeyword());
            }

            pstmt.setInt(bindIdx++, prDTO.getStartNum());
            pstmt.setInt(bindIdx++, prDTO.getEndNum());

            rs = pstmt.executeQuery();

            while (rs.next()) {
                BoardDTO dto = new BoardDTO();
                dto.setBoard_id(rs.getInt("board_id"));
                dto.setTitle(rs.getString("title"));
                dto.setPosted_at(rs.getDate("posted_at"));
                dto.setViewCount(rs.getInt("viewCount"));
                dto.setAdmin_id(rs.getString("admin_id"));
                list.add(dto);
            }
        } finally {
            db.dbClose(rs, pstmt, con);
        }

        return list;
    }


    //공지사항 게시글 하나 선택
    public BoardDTO selectOneNotice(int board_id) throws SQLException {
        BoardDTO bDTO = null;
        
        DbConnection db=DbConnection.getInstance();
         
         ResultSet rs=null;
         PreparedStatement pstmt=null;
         Connection con=null;

        try {
              con=db.getDbConn();
              
               StringBuilder selectOneBoard=new StringBuilder();
               selectOneBoard
               .append("   select    board_id,title,content,posted_at,viewCount  ")
               .append("   from    board   ")
               .append("   where    board_id=?   ");
               
               pstmt=con.prepareStatement(selectOneBoard.toString());
               //바인드 변수에 값 할당
            pstmt.setInt(1, board_id);
            rs=pstmt.executeQuery();
                if (rs.next()) {
                   bDTO = new BoardDTO();
                   bDTO.setBoard_id(rs.getInt("board_id"));
                   bDTO.setTitle(rs.getString("title"));
                   bDTO.setContent(rs.getString("content"));
                   bDTO.setPosted_at(rs.getDate("posted_at"));
                   bDTO.setViewCount(rs.getInt("viewCount"));
                   }//end if
           
                } finally {
                   db.dbClose(rs, pstmt, con);
            }//end finally
        
        return bDTO;
    }//selectOneNotice
    
    //이벤트 게시글 하나 선택
    public BoardDTO selectOneEvent(int board_id) throws SQLException {
       BoardDTO bDTO = null;
       
       DbConnection db=DbConnection.getInstance();
       
       ResultSet rs=null;
       PreparedStatement pstmt=null;
       Connection con=null;
       
       try {
          con=db.getDbConn();
          
          StringBuilder selectOneBoard=new StringBuilder();
          selectOneBoard
          .append("   select    board_id,title,thumbnail_url,detail_image_url,posted_at,viewCount   ")
          .append("   from    board   ")
          .append("   where    board_id=?   ");
          
          pstmt=con.prepareStatement(selectOneBoard.toString());
          //바인드 변수에 값 할당
          pstmt.setInt(1, board_id);
          rs=pstmt.executeQuery();
          if (rs.next()) {
             bDTO = new BoardDTO();
             bDTO.setBoard_id(rs.getInt("board_id"));
             bDTO.setTitle(rs.getString("title"));
             bDTO.setThumbnail_url(rs.getString("thumbnail_url"));
             bDTO.setDetail_image_url(rs.getString("detail_image_url"));
             bDTO.setPosted_at(rs.getDate("posted_at"));
             bDTO.setViewCount(rs.getInt("viewCount"));
          }//end if
          
       } finally {
          db.dbClose(rs, pstmt, con);
       }//end finally
       
       return bDTO;
    }//selectOneNotice
    
    //이벤트 게시글 전체 조회
    public List<BoardDTO> selectAllEvent(String type) throws SQLException {
    	
    	List<BoardDTO> list=new ArrayList<BoardDTO>();
    	
    	DbConnection db=DbConnection.getInstance();
    	
    	ResultSet rs=null;
    	PreparedStatement pstmt=null;
    	Connection con=null;
    	
    	try {
    		con=db.getDbConn();
    		
    		StringBuilder selectAllBoard=new StringBuilder();
    		selectAllBoard
    		.append("   select    board_id,title,thumbnail_url,detail_image_url,posted_at,viewCount   ")
    		.append("   from    board   ")
    		.append("   WHERE type = ? ")
    		.append("   order by board_id DESC ")
    		;
    		
    		pstmt=con.prepareStatement(selectAllBoard.toString());
            //바인드 변수에 값 할당
    		pstmt.setString(1, type);
    		rs=pstmt.executeQuery();
    		
    		 while (rs.next()) {
    			BoardDTO bDTO = new BoardDTO();
    			bDTO.setBoard_id(rs.getInt("board_id"));
    			bDTO.setTitle(rs.getString("title"));
    			bDTO.setThumbnail_url(rs.getString("thumbnail_url"));
    			bDTO.setDetail_image_url(rs.getString("detail_image_url"));
    			bDTO.setPosted_at(rs.getDate("posted_at"));
    			bDTO.setViewCount(rs.getInt("viewCount"));
    			
    			list.add(bDTO);     
    	                
    		}//end while
    		
    	} finally {
    		db.dbClose(rs, pstmt, con);
    	}//end finally
    	
    	return list;
    }//selectOneNotice

    //공지사항 게시글 추가
    public void insertNotice(BoardDTO bDTO) throws SQLException {
        
       DbConnection db = DbConnection.getInstance();
       
        PreparedStatement pstmt=null;
      Connection con=null;
      
      try {
      con = db.getDbConn();
      StringBuilder insertNews=new StringBuilder();
      insertNews
      .append("   insert into board(board_id, type, title, content, admin_id )	")
      .append("   values( board_seq.nextval,'공지',?,?,?	)   ");
      
      pstmt=con.prepareStatement(insertNews.toString());
      
            pstmt.setString(1, bDTO.getTitle());
            pstmt.setString(2, bDTO.getContent());
            pstmt.setString(3, bDTO.getAdmin_id());
            
            pstmt.executeUpdate();

        } finally {
           db.dbClose(null, pstmt, con);
        }//end finally
    }//insertNotice
    
    //이벤트 게시글 추가
    public void insertEvent(BoardDTO bDTO) throws SQLException {
       
       DbConnection db = DbConnection.getInstance();
       
       PreparedStatement pstmt=null;
       Connection con=null;
       
       try {
          con = db.getDbConn();
          StringBuilder insertNews=new StringBuilder();
          insertNews
          .append("   insert into board(board_id, type ,title, thumbnail_url, detail_image_url,viewCount,admin_id )")
          .append("   values( board_seq.nextval,'이벤트',?,?,?,?,?  )   ");
          
          pstmt=con.prepareStatement(insertNews.toString());
          
          pstmt.setString(1, bDTO.getTitle());
          pstmt.setString(2, bDTO.getThumbnail_url());
          pstmt.setString(3, bDTO.getDetail_image_url());
          pstmt.setInt(4, bDTO.getViewCount());
          pstmt.setString(5, bDTO.getAdmin_id());
          
           pstmt.executeUpdate();
          
       } finally {
          db.dbClose(null, pstmt, con);
       }//end finally
    }//insertNews

    //공지사항 게시글 수정
    public int updateNotice(BoardDTO bDTO) throws SQLException {
        int row = 0;
        DbConnection db = DbConnection.getInstance();

        PreparedStatement pstmt=null;
      Connection con=null;
        try {
           con=db.getDbConn();
           
           StringBuilder updateNotice=new StringBuilder();
           updateNotice
           .append("   update board   ")
           .append("   set title=?, content=?   ")
           .append("   where board_id=?   ");
           
           pstmt=con.prepareStatement(updateNotice.toString());
           
            pstmt.setString(1, bDTO.getTitle());
            pstmt.setString(2, bDTO.getContent());
            pstmt.setInt(3, bDTO.getBoard_id());

            row = pstmt.executeUpdate();
        } finally {
           db.dbClose(null, pstmt, con);
        }//end finally
        return row;
    }//updateNotice
    
    //이벤트 게시글 수정
    public int updateEvent(BoardDTO bDTO) throws SQLException {
       int row = 0;
       DbConnection db = DbConnection.getInstance();
       
       PreparedStatement pstmt=null;
       Connection con=null;
       try {
          con=db.getDbConn();
          
          StringBuilder updateNotice=new StringBuilder();
          updateNotice
          .append("   update board   ")
          .append("   set title=?, thumbnail_url=?, detail_image_url=?   ")
          .append("   where board_id=?   ");
          
          pstmt=con.prepareStatement(updateNotice.toString());
          
          pstmt.setString(1, bDTO.getTitle());
          pstmt.setString(2, bDTO.getThumbnail_url());
          pstmt.setString(3, bDTO.getDetail_image_url());
          pstmt.setInt(4, bDTO.getBoard_id());
          
          
          row = pstmt.executeUpdate();
       } finally {
          db.dbClose(null, pstmt, con);
       }//end finally
       return row;
    }//updateEvent
    
    //게시글 삭제하기
    public int deleteNews(BoardDTO bDTO) throws SQLException {
        int row = 0;
        DbConnection db = DbConnection.getInstance();

        PreparedStatement pstmt=null;
      Connection con=null;

        try {
           con=db.getDbConn();
           
           StringBuilder deleteNews=new StringBuilder();
           deleteNews
           .append("   delete from board   ")
           .append("   where board_id=?   ")
           ;
           
           pstmt=con.prepareStatement(deleteNews.toString());
           
           pstmt.setInt(1, bDTO.getBoard_id());
           row=pstmt.executeUpdate();
           
        } finally {
           db.dbClose(null, pstmt, con);
        }//end finally
        return row;
    }//deleteNews

    public int updateCount(int board_id) throws SQLException {
        int row = 0;
        
        DbConnection db = DbConnection.getInstance();
        
        PreparedStatement pstmt=null;
        Connection con=null;
      
        try {
           con=db.getDbConn();
           
           StringBuilder updateCount=new StringBuilder();
           updateCount
           .append("   update board set viewCount= viewCount+1   ")
           .append("   where board_id=?   ");
           
           pstmt=con.prepareStatement(updateCount.toString());
           
           pstmt.setInt(1, board_id);
           
           row=pstmt.executeUpdate();
        }finally {
           db.dbClose(null, pstmt, con);
        }
        return row;
    }//updateCount
    
    public List<BoardDTO> selectEventByKeyword(String keyword) throws SQLException {
    	List<BoardDTO> list=new ArrayList<BoardDTO>();
    	
    	DbConnection db=DbConnection.getInstance();
    	
    	ResultSet rs=null;
    	PreparedStatement pstmt=null;
    	Connection con=null;
    	
    	try {
    		con=db.getDbConn();
    		
    		 String sql = "SELECT board_id, title, thumbnail_url, detail_image_url, posted_at, viewCount " +
	                     "FROM board " +
	                     "WHERE type = '이벤트' AND LOWER(title) LIKE '%' || LOWER(?) || '%' " +
	                     "ORDER BY board_id DESC";
    		
    		pstmt=con.prepareStatement(sql);
            //바인드 변수에 값 할당
    		pstmt.setString(1, keyword);
    		rs=pstmt.executeQuery();
    		
    		 while (rs.next()) {
    			BoardDTO bDTO = new BoardDTO();
    			bDTO.setBoard_id(rs.getInt("board_id"));
    			bDTO.setTitle(rs.getString("title"));
    			bDTO.setThumbnail_url(rs.getString("thumbnail_url"));
    			bDTO.setDetail_image_url(rs.getString("detail_image_url"));
    			bDTO.setPosted_at(rs.getDate("posted_at"));
    			bDTO.setViewCount(rs.getInt("viewCount"));
    			
    			list.add(bDTO);     
    	                
    		}//end while
    		
    	} finally {
    		db.dbClose(rs, pstmt, con);
    	}//end finally
    	
    	return list;
    			
    }//selectEventByKeyword
    
    //이벤트 게시글 이전 글 이동
    public BoardDTO selectPrevEvent(int board_id) throws SQLException {
    	      
    	BoardDTO bDTO = null;
    	       
    	DbConnection db=DbConnection.getInstance();

		ResultSet rs=null;
		PreparedStatement pstmt=null;
		Connection con=null;
    	       
    	try {
    	         
    		con=db.getDbConn();
    	          
    	    StringBuilder selectPrevEvent=new StringBuilder();
    	    selectPrevEvent
    	    .append("   select    board_id,title   ")
    	    .append("   from   (")
    	    .append("   select    board_id,title   ")
    	    .append("   from   board	")
    	    .append("   where    board_id > ? AND type='이벤트'   ")
    	    .append("	order by board_id ASC	")
    	    .append("	)	")
    	    .append("	where rowNum = 1")
    	    ;
    	          
    	    pstmt=con.prepareStatement(selectPrevEvent.toString());
    	    //바인드 변수에 값 할당
    	    pstmt.setInt(1, board_id);
    	    
    	    rs=pstmt.executeQuery();
    	      if (rs.next()) {
    	         bDTO = new BoardDTO();
    	         bDTO.setBoard_id(rs.getInt("board_id"));
    	         bDTO.setTitle(rs.getString("title"));
             }//end if
    	          
    	 } finally {
    	    db.dbClose(rs, pstmt, con);
    	 }//end finally
    	 return bDTO;
    }//selectPrevEvent
    
    //이벤트 게시글 다음 글 이동
    public BoardDTO selectNextEvent(int board_id) throws SQLException {
    	
    	BoardDTO bDTO = null;
    	
    	DbConnection db=DbConnection.getInstance();
    	
    	ResultSet rs=null;
    	PreparedStatement pstmt=null;
    	Connection con=null;
    	
    	try {
    		
    		con=db.getDbConn();
    		
    		StringBuilder selectPrevEvent=new StringBuilder();
    		selectPrevEvent
    		.append("   select    board_id,title   ")
    		.append("   from   (")
    		.append("   select    board_id,title   ")
    		.append("   from   board	")
    		.append("   where    board_id < ? AND type='이벤트'   ")
    		.append("	order by board_id DESC	")
    		.append("	)	")
    		.append("	where rowNum = 1")
    		;
    		
    		pstmt=con.prepareStatement(selectPrevEvent.toString());
    		//바인드 변수에 값 할당
    		pstmt.setInt(1, board_id);
    		
    		rs=pstmt.executeQuery();
    		if (rs.next()) {
    			bDTO = new BoardDTO();
    			bDTO.setBoard_id(rs.getInt("board_id"));
    			bDTO.setTitle(rs.getString("title"));
    		}//end if
    		
    	} finally {
    		db.dbClose(rs, pstmt, con);
    	}//end finally
    	return bDTO;
    }//selectNextEvent
    

}//class