package news;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PseRangeDTO {
	private String field, keyword;//검색 필드, 키워드
	private int currentPage=1, startNum, endNum;//현재 페이지, 시작번호, 끝번호
	private String keywordLower;

	private String[] fieldText= {"제목","내용"};
	
	public String getKeywordLower() {
	    return keyword != null ? keyword.toLowerCase() : null;
	}
}//class