package util;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@AllArgsConstructor
@NoArgsConstructor
public class RangeDTO {
    private String field, keyword;
    private int currentPage = 1, startNum, endNum;
    private String sort;


    // startNum, endNum 전용 생성자
    public RangeDTO(int startNum, int endNum) {
        this.startNum = startNum;
        this.endNum = endNum;
    }
}

