package dashboard;

import java.sql.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class DailySummaryDTO {
    private Date statDate;
    private int totalOrders;
    private int totalSales;
    private int orderCompleted ;
    private int beforeShipping;
    private int shipping;
    private int shippingDone;

    private int refundRequested;
    private int refundApproved;
    private int refundRejected;


   
}
