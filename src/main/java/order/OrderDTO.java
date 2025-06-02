package order;

import java.sql.Date;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderDTO {
    private int orderId;
    private int userId;
    private Date orderDate;
    private String orderStatus;
    private String userName;        // ← 새로 추가
    private String orderStatusDesc; // ← 새로 추가
    private double totalPrice;
    private String receiverName;
    private String receiverPhone;
    private String receiverEmail;
    
    private String receiverZip;
    private String receiverAddress2;
    private String receiverAddress1;
    private String orderMemo;

    private List<OrderItemDTO> items; // 주문에 포함된 상품 리스트
}
