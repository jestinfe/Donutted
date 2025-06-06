package refund;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@ToString
public class RefundDTO {
    private int refundId;
    private int orderItemId;
    private Date requestedAt;
    private Date processedAt;
    private String refundStatus; // RS1, RS2, RS3
    private String refundReason; // 사용자 선택 사유 (예: "단순 변심")

    // 조회용 추가 필드
    private String productName;
    private String thumbnailUrl;
    private String refundReasonText;
    private int userId;
    private int quantity;
    private double unitPrice;
    


}
