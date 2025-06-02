package inquiry;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class InquiryDTO {
    private int inquiryId;
    private int userId;
    private String title;
    private String content;
    private String inquiryStatus;
    private Date createdAt;
    private String replyContent;
    private Date repliedAt;
    private Integer adminId;
    private String username;
}
