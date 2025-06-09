package order;

import java.sql.*;
import java.sql.Date;
import java.util.*;

import cart.CartDAO;
import cart.CartItemDTO;
import product.ProductDAO;
import product.ProductDTO;
import util.CryptoUtil;
import util.DbConnection;
import util.RangeDTO;

public class OrderDAO {
    private static OrderDAO dao;
    private DbConnection db;
    private int currentMaxOrderIdSeq;

    private OrderDAO() {
        db = DbConnection.getInstance();
    }

    public static OrderDAO getInstance() {
        if (dao == null) {
            dao = new OrderDAO();
        }
        return dao;
    }

    /** 1) 환불 가능 아이템 조회 **/
    public List<OrderItemDTO> getRefundableItems(int userId) throws SQLException {
        List<OrderItemDTO> list = new ArrayList<>();
        String sql = """
            SELECT oi.order_item_id, p.name AS product_name, p.thumbnail_url
              FROM order_item oi
              JOIN orders o ON oi.order_id = o.order_id
              JOIN product p ON oi.product_id = p.product_id
             WHERE o.user_id = ?
               AND oi.order_item_id NOT IN (SELECT order_item_id FROM refund)
             ORDER BY oi.order_item_id DESC
        """;

        try (Connection con = db.getDbConn();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    OrderItemDTO dto = new OrderItemDTO();
                    dto.setOrderItemId(rs.getInt("order_item_id"));
                    dto.setProductName(rs.getString("product_name"));
                    dto.setThumbnailUrl(rs.getString("thumbnail_url"));
                    list.add(dto);
                }
            }
        }
        return list;
    }

    /** 2) 주문 아이템 상세 조회 **/
    public OrderItemDTO getOrderItemDetail(int orderItemId) throws SQLException {
        OrderItemDTO dto = null;
        String sql = """
            SELECT oi.order_item_id, oi.order_id, oi.product_id, oi.quantity, oi.unit_price,
                   p.name AS product_name, p.thumbnail_url
              FROM order_item oi
              JOIN product p ON oi.product_id = p.product_id
             WHERE oi.order_item_id = ?
        """;

        try (Connection con = db.getDbConn();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, orderItemId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    dto = new OrderItemDTO();
                    dto.setOrderItemId(rs.getInt("order_item_id"));
                    dto.setOrderId(rs.getInt("order_id"));
                    dto.setProductId(rs.getInt("product_id"));
                    dto.setQuantity(rs.getInt("quantity"));
                    dto.setUnitPrice(rs.getInt("unit_price"));
                    dto.setProductName(rs.getString("product_name"));
                    dto.setThumbnailUrl(rs.getString("thumbnail_url"));
                }
            }
        }
        return dto;
    }

    /** 3) 리뷰 가능 아이템 조회 **/
    public List<OrderItemDTO> getReviewableItems(int userId) throws SQLException {
        List<OrderItemDTO> list = new ArrayList<>();
        String sql = """
            SELECT oi.order_item_id, oi.order_id, o.order_date,
                   p.name AS product_name, p.thumbnail_url
              FROM order_item oi
              JOIN orders o ON oi.order_id = o.order_id
              JOIN product p ON oi.product_id = p.product_id
             WHERE o.user_id = ?
               AND oi.order_item_id NOT IN (SELECT order_item_id FROM review)
             ORDER BY o.order_date DESC, oi.order_item_id DESC
        """;

        try (Connection con = db.getDbConn();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    OrderItemDTO dto = new OrderItemDTO();
                    dto.setOrderItemId(rs.getInt("order_item_id"));
                    dto.setOrderId(rs.getInt("order_id"));
                    dto.setCreatedAt(rs.getDate("order_date"));
                    dto.setProductName(rs.getString("product_name"));
                    dto.setThumbnailUrl(rs.getString("thumbnail_url"));
                    list.add(dto);
                }
            }
        }
        return list;
    }

    /** 4) 회원별 전체 주문 조회 (사용자) **/
    public List<OrderDTO> getOrdersByUser(int userId) throws SQLException {
        List<OrderDTO> orderList = new ArrayList<>();

        String sql = """
            SELECT o.order_id, o.order_date, o.order_status, o.total_price,
                   oi.order_item_id, oi.product_id, oi.quantity, oi.unit_price,
                   p.name AS product_name, p.thumbnail_url,
                   CASE 
                     WHEN EXISTS (
                       SELECT 1 FROM review r WHERE r.order_item_id = oi.order_item_id
                     ) THEN 1 ELSE 0 
                   END AS reviewed
            FROM orders o
            JOIN order_item oi ON o.order_id = oi.order_id
            JOIN product p ON oi.product_id = p.product_id
            WHERE o.user_id = ?
            ORDER BY o.order_date DESC, o.order_id DESC
        """;

        try (Connection con = db.getDbConn();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                Map<Integer, OrderDTO> orderMap = new LinkedHashMap<>();

                while (rs.next()) {
                    int orderId = rs.getInt("order_id");

                    OrderDTO order = orderMap.get(orderId);
                    if (order == null) {
                        order = new OrderDTO();
                        order.setOrderId(orderId);
                        order.setOrderDate(rs.getDate("order_date"));
                        order.setOrderStatus(rs.getString("order_status"));
                        order.setTotalPrice(rs.getInt("total_price"));
                        order.setItems(new ArrayList<>());
                        orderMap.put(orderId, order);
                    }

                    OrderItemDTO item = new OrderItemDTO();
                    item.setOrderItemId(rs.getInt("order_item_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getInt("unit_price"));
                    item.setProductName(rs.getString("product_name"));
                    item.setThumbnailUrl(rs.getString("thumbnail_url"));
                    item.setReviewed(rs.getInt("reviewed") == 1); // ✅ 핵심 라인

                    order.getItems().add(item);
                }

                orderList.addAll(orderMap.values());
            }
        }

        return orderList;
    }


    /** 5) 특정 주문 내 리뷰 가능 아이템 조회 **/
    public OrderDTO getReviewableItemsByOrder(int userId, int orderId) throws SQLException {
        OrderDTO order = null;
        String sql = """
            SELECT oi.order_item_id, oi.order_id, oi.product_id, o.order_date,
                   p.name AS product_name, p.thumbnail_url
              FROM order_item oi
              JOIN orders o ON oi.order_id = o.order_id
              JOIN product p ON oi.product_id = p.product_id
             WHERE o.user_id = ?
               AND o.order_id = ?
               AND o.order_status = 'O3'
               AND oi.order_item_id NOT IN (SELECT order_item_id FROM review)
        """;

        try (Connection con = db.getDbConn();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, orderId);
            try (ResultSet rs = pstmt.executeQuery()) {
                List<OrderItemDTO> itemList = new ArrayList<>();
                while (rs.next()) {
                    if (order == null) {
                        order = new OrderDTO();
                        order.setOrderId(rs.getInt("order_id"));
                        order.setOrderDate(rs.getDate("order_date"));
                        order.setItems(itemList);
                    }
                    OrderItemDTO item = new OrderItemDTO();
                    item.setOrderItemId(rs.getInt("order_item_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setProductName(rs.getString("product_name"));
                    item.setThumbnailUrl(rs.getString("thumbnail_url"));
                    itemList.add(item);
                }
            }
        }
        return order;
    }

    /** 6) 마지막 주문 ID 조회 (시퀀스 대체용) **/
    public int selectLastOrderId() throws SQLException {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = db.getDbConn();
            String sql = "SELECT MAX(order_id) AS max_id FROM orders";
            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                currentMaxOrderIdSeq = rs.getInt("max_id");
            }
        } finally {
            db.dbClose(rs, pstmt, con);
        }
        return currentMaxOrderIdSeq;
    }

    /** 7) 주문에 포함된 모든 상품 불러오기 **/
    public List<OrderItemDTO> insertAllProducts(int orderId) throws SQLException {
        List<OrderItemDTO> orderList = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = db.getDbConn();
            String sql = "SELECT * FROM order_item WHERE order_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                OrderItemDTO opDTO = new OrderItemDTO();
                opDTO.setOrderId(rs.getInt("order_id"));
                opDTO.setProductId(rs.getInt("product_id"));
                opDTO.setQuantity(rs.getInt("quantity"));
                opDTO.setUnitPrice(rs.getInt("unit_price"));
                // 상품명이나 썸네일은 별도 조회해야 하지만, 기존대로 name 컬럼을 시도
                opDTO.setProductName(rs.getString("name"));
                orderList.add(opDTO);
            }
        } finally {
            db.dbClose(rs, pstmt, con);
        }
        return orderList;
    }

    /** 8) 단일 주문 생성 (예시 구조) **/
    public void insertOrder(OrderItemDTO opDTO, int currentUserId) throws SQLException {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = db.getDbConn();
            String sql = """
                INSERT INTO orders (
                   order_id, user_id, order_date, order_status,
                   total_price, receiver_name, receiver_phone, receiver_email, receiver_zip,
                   receiver_address1, receiver_address2, order_memo
                ) VALUES (?, ?, SYSDATE, ?,
                          ?, ?, ?, ?, ?,
                          ?, ?, ?)
            """;
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, selectLastOrderId() + 1);
            pstmt.setInt(2, currentUserId);
            pstmt.setString(3, "O2"); // 기본값: 배송 준비중
            pstmt.setDouble(4, opDTO.getUnitPrice() * opDTO.getQuantity());
            pstmt.setString(5, opDTO.getProductName()); // 예시: 상품명을 수령자명처럼 사용
            pstmt.setString(6, "010-0000-0000"); // 예시 전화번호
            pstmt.setString(7, "example@example.com"); // 예시 이메일
            pstmt.setString(8, "12345"); // 예시 우편번호
            pstmt.setString(9, "주소1 예시"); // 예시 주소1
            pstmt.setString(10, "주소2 예시"); // 예시 주소2
            pstmt.setString(11, "메모 예시"); // 예시 메모
            pstmt.executeUpdate();
        } finally {
            db.dbClose(rs, pstmt, con);
        }
    }

    /** 9) 단일 상품 정보 조회 **/
    public OrderItemDTO selectProduct(int productId) throws SQLException {
        OrderItemDTO opDTO = null;
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = db.getDbConn();
            String sql = "SELECT * FROM product WHERE product_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, productId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                opDTO = new OrderItemDTO();
                opDTO.setOrderItemId(rs.getInt("product_id"));  // 임시 매핑
                opDTO.setProductId(rs.getInt("product_id"));
                opDTO.setQuantity(1);
                opDTO.setUnitPrice(rs.getInt("price"));
                opDTO.setProductName(rs.getString("name"));
                opDTO.setThumbnailUrl(rs.getString("thumbnail_url"));
            }
        } finally {
            db.dbClose(rs, pstmt, con);
        }
        return opDTO;
    }

    /** 10) 단일 상품 상세 조회 **/
    public SingleOrderDTO selectProductById(int productId) throws SQLException {
        SingleOrderDTO soDTO = null;
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = db.getDbConn();
            String sql = "SELECT * FROM product WHERE product_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, productId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                soDTO = new SingleOrderDTO();
                soDTO.setProductId(rs.getInt("product_id"));
                soDTO.setName(rs.getString("name"));
                soDTO.setPrice(rs.getInt("price"));
                soDTO.setStock(rs.getInt("stock_quantity"));
                soDTO.setCategoryId(rs.getInt("category_id"));
                soDTO.setRedDate(rs.getDate("created_at"));
                soDTO.setModDate(rs.getDate("updated_at"));
                soDTO.setCode(rs.getString("code"));
                soDTO.setThumbnailImg(rs.getString("thumbnail_url"));
                soDTO.setDetailImg(rs.getString("detail_url"));
            }
        } finally {
            db.dbClose(rs, pstmt, con);
        }
        return soDTO;
    }

    /** 11) 장바구니 연동: 사용자 ID로 주문 아이템 리스트 생성 **/
    public List<OrderItemDTO> selectOrderedItemsByUserId(int userId) throws SQLException {
        CartDAO cDAO = CartDAO.getInstance();
        int targetCartId = 0;
        try {
            targetCartId = cDAO.getCartIdByUser(userId);
        } catch (SQLException se) {
            se.printStackTrace();
        }

        List<OrderItemDTO> outputList = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = db.getDbConn();
            String sql = "SELECT * FROM cart_item WHERE cart_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, targetCartId);
            rs = pstmt.executeQuery();
            OrderDAO oDAO = OrderDAO.getInstance();
            int idInsideTheOrder = 1;
            while (rs.next()) {
                OrderItemDTO targetItem = new OrderItemDTO();
                targetItem.setOrderId(oDAO.selectLastOrderId() + 1);
                targetItem.setOrderItemId(idInsideTheOrder++);
                targetItem.setProductId(rs.getInt("product_id"));
                targetItem.setQuantity(rs.getInt("quantity"));

                ProductDAO pDAO = ProductDAO.getInstance();
                ProductDTO pDTO = pDAO.selectProductById(rs.getInt("product_id"));
                targetItem.setUnitPrice(pDTO.getPrice());
                targetItem.setProductName(pDTO.getName());
                targetItem.setCreatedAt(rs.getDate("added_at"));

                outputList.add(targetItem);
            }
        } finally {
            db.dbClose(rs, pstmt, con);
        }
        return outputList;
    }

    /** 12) 장바구니 연동: 새 주문 생성(총액만) **/
    public int insertNewOrder(int userId, int totalPrice) throws SQLException {
        Connection con = null;
        PreparedStatement pstmt = null;
        try {
            con = db.getDbConn();
            String sql = """
                INSERT INTO orders (
                  order_id, user_id, order_date, order_status,
                  total_price, receiver_name, receiver_phone, receiver_email,
                  receiver_zip, receiver_address1, receiver_address2, order_memo
                ) VALUES (
                  ?, ?, SYSDATE, ?, ?, ?, ?, ?, ?, ?, ?, ?
                )
            """;
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, selectLastOrderId() + 1);
            pstmt.setInt(2, userId);
            pstmt.setString(3, "O1"); // 결제 완료
            pstmt.setDouble(4, totalPrice);
            pstmt.setString(5, "recieverNameSample");
            pstmt.setString(6, "recieverPhoneSample");
            pstmt.setString(7, "recieverEmailSample");
            pstmt.setString(8, "12345");
            pstmt.setString(9, "recieverAddress1Sample");
            pstmt.setString(10, "recieverAddress2Sample");
            pstmt.setString(11, "orderMemoSample");
            pstmt.executeUpdate();
        } finally {
            db.dbClose(null, pstmt, con);
        }
        return selectLastOrderId();
    }

    /** 13) 단일 주문 아이템 삽입 **/
    public boolean insertNewOrderItem(int userId, OrderItemDTO oiDTO) throws SQLException {
        boolean insertFlag = false;
        Connection con = null;
        PreparedStatement pstmt = null;
        try {
            con = db.getDbConn();
            String sql = """
                INSERT INTO order_item (
                  order_item_id, order_id, product_id, quantity, unit_price
                ) VALUES (?, ?, ?, ?, ?)
            """;
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, oiDTO.getOrderItemId());
            pstmt.setInt(2, oiDTO.getOrderId());
            pstmt.setInt(3, oiDTO.getProductId());
            pstmt.setInt(4, oiDTO.getQuantity());
            pstmt.setDouble(5, oiDTO.getUnitPrice());
            pstmt.executeUpdate();
            insertFlag = true;
        } finally {
            db.dbClose(null, pstmt, con);
        }
        return insertFlag;
    }

    /** 14) 총 주문 금액 조회 **/
    public double selectTotalPrice(OrderDTO oDTO, int userId) throws SQLException {
        double output = 0;
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = db.getDbConn();
            String sql = "SELECT total_price FROM orders WHERE order_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, oDTO.getOrderId());
            rs = pstmt.executeQuery();
            if (rs.next()) {
                output = rs.getDouble("total_price");
            }
        } finally {
            db.dbClose(rs, pstmt, con);
        }
        return output;
    }

    /** 15) 주문별 환불 가능 아이템 조회 **/
    public List<OrderItemDTO> getRefundableItemsByOrderId(int orderId) throws SQLException {
        List<OrderItemDTO> list = new ArrayList<>();
        String sql = """
            SELECT oi.order_item_id, p.name AS product_name, p.thumbnail_url
              FROM order_item oi
              JOIN orders o ON oi.order_id = o.order_id
              JOIN product p ON oi.product_id = p.product_id
             WHERE oi.order_id = ?
               AND oi.order_item_id NOT IN (SELECT order_item_id FROM refund)
             ORDER BY oi.order_item_id DESC
        """;

        try (Connection con = db.getDbConn();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, orderId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    OrderItemDTO dto = new OrderItemDTO();
                    dto.setOrderItemId(rs.getInt("order_item_id"));
                    dto.setProductName(rs.getString("product_name"));
                    dto.setThumbnailUrl(rs.getString("thumbnail_url"));
                    list.add(dto);
                }
            }
        }
        return list;
    }

    /** 16) 주문 정보(배송 정보 포함) 저장 후 생성된 order_id 반환 **/
    public int insertOrderWithUserInfo(Connection conn, int userId, String name, String phone, String email,
                                       String zipCode, String addr1, String addr2, String memo, int totalCost) throws SQLException {
        int orderId = 0;
        String sql = """
            INSERT INTO orders (
              user_id, total_price, receiver_name, receiver_phone, receiver_email,
              receiver_zip, receiver_address1, receiver_address2, order_memo
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;
        String[] generatedCols = {"order_id"};
        try (PreparedStatement pstmt = conn.prepareStatement(sql, generatedCols)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, totalCost);
            pstmt.setString(3, name);
            pstmt.setString(4, phone);
            pstmt.setString(5, email);
            pstmt.setString(6, zipCode);
            pstmt.setString(7, addr1);
            pstmt.setString(8, addr2);
            pstmt.setString(9, memo);
            pstmt.executeUpdate();
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    orderId = rs.getInt(1);
                }
            }
        }
        return orderId;
    }

    /** 17) cart_item → order_item 삽입 **/
    public void insertOrderItemsFromCart(Connection conn, int userId, int cartId, int orderId) throws SQLException {
        String sql = """
            INSERT INTO order_item (order_id, product_id, quantity, unit_price)
            SELECT ?, ci.product_id, ci.quantity, p.price
              FROM cart_item ci
              JOIN product p ON ci.product_id = p.product_id
             WHERE ci.cart_id = ?
        """;
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, orderId);
            pstmt.setInt(2, cartId);
            pstmt.executeUpdate();
        }
    }

     /** ✅ 수정 대상 1: selectOrdersByRange 내부의 복호화용 이름 컬럼 **/
     public List<OrderDTO> selectOrdersByRange(RangeDTO range,
                                                String searchName,
                                                java.sql.Date searchDate,
                                                String searchStatus) throws SQLException {

         List<OrderDTO> orders = new ArrayList<>();
         StringBuilder baseQuery = new StringBuilder();
         baseQuery.append("""
             SELECT * FROM (
                 SELECT inner_query.*, ROWNUM AS rnum FROM (
                     SELECT o.order_id, o.user_id, u.name AS user_name, o.order_date, o.order_status, o.total_price,
                            o.receiver_name, o.receiver_phone, o.receiver_email, o.receiver_zip,
                            o.receiver_address1, o.receiver_address2, o.order_memo
                       FROM orders o
                       JOIN users u ON o.user_id = u.user_id
                      WHERE 1=1
         """);

         if (searchDate != null) baseQuery.append(" AND TRUNC(o.order_date) = ? ");
         if (searchStatus != null && !searchStatus.trim().isEmpty()) baseQuery.append(" AND o.order_status = ? ");

         baseQuery.append("""
                     ORDER BY o.order_date DESC, o.order_id DESC
                 ) inner_query
                 WHERE ROWNUM <= ?
             )
             WHERE rnum >= ?
         """);

         Map<Integer, OrderDTO> orderMap = new LinkedHashMap<>();

         try (Connection con = db.getDbConn();
              PreparedStatement pstmt = con.prepareStatement(baseQuery.toString())) {

             int idx = 1;
             if (searchDate != null) pstmt.setDate(idx++, searchDate);
             if (searchStatus != null && !searchStatus.trim().isEmpty()) pstmt.setString(idx++, searchStatus);
             pstmt.setInt(idx++, range.getEndNum());
             pstmt.setInt(idx, range.getStartNum());

             try (ResultSet rs = pstmt.executeQuery()) {
                 while (rs.next()) {
                     OrderDTO order = new OrderDTO();
                     int orderId = rs.getInt("order_id");
                     order.setOrderId(orderId);
                     order.setUserId(rs.getInt("user_id"));

                     try {
                         order.setUserName(CryptoUtil.decrypt(rs.getString("user_name")));  // name 컬럼 복호화 적용
                         System.out.println(order.getUserName());
                     } catch (Exception e) {
                         e.printStackTrace();
                     }

                     order.setOrderDate(rs.getDate("order_date"));
                     order.setOrderStatus(rs.getString("order_status"));
                     order.setTotalPrice(rs.getDouble("total_price"));
                     order.setReceiverName(rs.getString("receiver_name"));
                     order.setReceiverPhone(rs.getString("receiver_phone"));
                     order.setReceiverEmail(rs.getString("receiver_email"));
                     order.setReceiverZip(rs.getString("receiver_zip"));
                     order.setReceiverAddress1(rs.getString("receiver_address1"));
                     order.setReceiverAddress2(rs.getString("receiver_address2"));
                     order.setOrderMemo(rs.getString("order_memo"));
                     order.setItems(new ArrayList<>());

                     orderMap.put(orderId, order);
                 }
             }
         }

         if (!orderMap.isEmpty()) {
             StringBuilder itemQuery = new StringBuilder();
             itemQuery.append("""
                 SELECT oi.order_id, oi.order_item_id, oi.product_id, oi.quantity, oi.unit_price,
                        p.name AS product_name, p.thumbnail_url
                   FROM order_item oi
                   JOIN product p ON oi.product_id = p.product_id
                  WHERE oi.order_id IN (
             """);

             StringJoiner joiner = new StringJoiner(", ");
             for (int i = 0; i < orderMap.size(); i++) joiner.add("?");
             itemQuery.append(joiner).append(")");

             try (Connection con = db.getDbConn();
                  PreparedStatement pstmt = con.prepareStatement(itemQuery.toString())) {

                 int i = 1;
                 for (Integer orderId : orderMap.keySet()) pstmt.setInt(i++, orderId);

                 try (ResultSet rs = pstmt.executeQuery()) {
                     while (rs.next()) {
                         int orderId = rs.getInt("order_id");
                         OrderItemDTO item = new OrderItemDTO();
                         item.setOrderItemId(rs.getInt("order_item_id"));
                         item.setOrderId(orderId);
                         item.setProductId(rs.getInt("product_id"));
                         item.setQuantity(rs.getInt("quantity"));
                         item.setUnitPrice(rs.getInt("unit_price"));
                         item.setProductName(rs.getString("product_name"));
                         item.setThumbnailUrl(rs.getString("thumbnail_url"));

                         orderMap.get(orderId).getItems().add(item);
                     }
                 }
             }
         }

         orders.addAll(orderMap.values());
         return orders;
     }




    /** 19) 검색 조건에 맞는 주문 건수 조회 **/
//    public int countOrders(String searchName,
//                           java.sql.Date searchDate,
//                           String searchStatus) throws SQLException {
//        StringBuilder sb = new StringBuilder();
//        sb.append("""
//            SELECT COUNT(*) FROM orders o
//            JOIN users u ON o.user_id = u.user_id
//            WHERE 1=1
//        """);
//        if (searchName != null && !searchName.trim().isEmpty()) {
//            sb.append(" AND LOWER(u.name) LIKE LOWER(?) ");
//        }
//        if (searchDate != null) {
//            sb.append(" AND TRUNC(o.order_date) = ? ");
//        }
//        if (searchStatus != null && !searchStatus.trim().isEmpty()) {
//            sb.append(" AND o.order_status = ? ");
//        }
//
//        try (Connection con = db.getDbConn();
//             PreparedStatement pstmt = con.prepareStatement(sb.toString())) {
//            int idx = 1;
//            if (searchName != null && !searchName.trim().isEmpty()) {
//                pstmt.setString(idx++, "%" + searchName.trim() + "%");
//            }
//            if (searchDate != null) {
//                pstmt.setDate(idx++, searchDate);
//            }
//            if (searchStatus != null && !searchStatus.trim().isEmpty()) {
//                pstmt.setString(idx++, searchStatus);
//            }
//            try (ResultSet rs = pstmt.executeQuery()) {
//                return rs.next() ? rs.getInt(1) : 0;
//            }
//        }
//    }

    /** 20) 단일 주문 조회 (회원명 포함) **/
    public OrderDTO selectOrder(int orderId) throws SQLException {
        OrderDTO oDTO = null;
        String sql = """
            SELECT o.order_id, o.user_id, u.name AS user_name, o.order_date, o.order_status, o.total_price,
                   o.receiver_name, o.receiver_phone, o.receiver_email, o.receiver_zip,
                   o.receiver_address1, o.receiver_address2, o.order_memo
              FROM orders o
              JOIN users u ON o.user_id = u.user_id
             WHERE o.order_id = ?
        """;

        try (Connection con = db.getDbConn();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, orderId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    oDTO = new OrderDTO();
                    oDTO.setOrderId(rs.getInt("order_id"));
                    oDTO.setUserId(rs.getInt("user_id"));
                    oDTO.setUserName(rs.getString("user_name"));
                    oDTO.setOrderDate(rs.getDate("order_date"));
                    oDTO.setOrderStatus(rs.getString("order_status"));
                    oDTO.setTotalPrice(rs.getDouble("total_price"));
                    oDTO.setReceiverName(rs.getString("receiver_name"));
                    oDTO.setReceiverPhone(rs.getString("receiver_phone"));
                    oDTO.setReceiverEmail(rs.getString("receiver_email"));
                    oDTO.setReceiverZip(rs.getString("receiver_zip"));
                    oDTO.setReceiverAddress1(rs.getString("receiver_address1"));
                    oDTO.setReceiverAddress2(rs.getString("receiver_address2"));
                    oDTO.setOrderMemo(rs.getString("order_memo"));
                }
            }
        }
        return oDTO;
    }

    /** 21) 주문 아이템 목록 조회 **/
    public List<OrderItemDTO> getOrderItemsByOrderId(int orderId) throws SQLException {
        List<OrderItemDTO> list = new ArrayList<>();
        String sql = """
            SELECT oi.order_item_id, oi.product_id, oi.quantity, oi.unit_price,
                   p.name AS product_name, p.thumbnail_url
              FROM order_item oi
              JOIN product p ON oi.product_id = p.product_id
             WHERE oi.order_id = ?
        """;

        try (Connection con = db.getDbConn();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, orderId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    OrderItemDTO item = new OrderItemDTO();
                    item.setOrderItemId(rs.getInt("order_item_id"));
                    item.setOrderId(orderId);
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getInt("unit_price"));
                    item.setProductName(rs.getString("product_name"));
                    item.setThumbnailUrl(rs.getString("thumbnail_url"));
                    list.add(item);
                }
            }
        }
        return list;
    }

    /** 22) 배송 상태 업데이트 **/
    public boolean updateOrderStatus(int orderId, String newStatus) throws SQLException {
        String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        try (Connection con = db.getDbConn();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, orderId);
            int updated = pstmt.executeUpdate();
            return updated == 1;
        }
    }
    
    public List<OrderDTO> getAllOrders() throws SQLException {
        List<OrderDTO> list = new ArrayList<>();
        String sql = """
            SELECT o.order_id, o.user_id, u.name AS user_name, o.order_date, o.order_status, o.total_price,
                   o.receiver_name, o.receiver_phone, o.receiver_email, o.receiver_zip,
                   o.receiver_address1, o.receiver_address2, o.order_memo
              FROM orders o
              JOIN users u ON o.user_id = u.user_id
             ORDER BY o.order_date DESC
        """;
        try (Connection con = db.getDbConn();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                OrderDTO dto = new OrderDTO();
                dto.setOrderId(rs.getInt("order_id"));
                dto.setUserId(rs.getInt("user_id"));
                dto.setUserName(rs.getString("user_name"));
                dto.setOrderDate(rs.getDate("order_date"));
                dto.setOrderStatus(rs.getString("order_status"));
                dto.setTotalPrice(rs.getDouble("total_price"));
                dto.setReceiverName(rs.getString("receiver_name"));
                dto.setReceiverPhone(rs.getString("receiver_phone"));
                dto.setReceiverEmail(rs.getString("receiver_email"));
                dto.setReceiverZip(rs.getString("receiver_zip"));
                dto.setReceiverAddress1(rs.getString("receiver_address1"));
                dto.setReceiverAddress2(rs.getString("receiver_address2"));
                dto.setOrderMemo(rs.getString("order_memo"));
                list.add(dto);
            }
        }
        return list;
    }
    
    public List<OrderDTO> searchOrders(String name, Date date, String status) throws SQLException {
        List<OrderDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("""
            SELECT o.order_id, o.user_id, u.name AS user_name, o.order_date, o.order_status, o.total_price,
                   o.receiver_name, o.receiver_phone, o.receiver_email, o.receiver_zip,
                   o.receiver_address1, o.receiver_address2, o.order_memo
              FROM orders o
              JOIN users u ON o.user_id = u.user_id
             WHERE 1=1
        """);

        // 검색 조건에 따라 필터 추가
        if (name != null && !name.isBlank()) sql.append(" AND u.name LIKE ? ");
        if (date != null) sql.append(" AND o.order_date = ? ");
        if (status != null && !status.equals("배송상태")) sql.append(" AND o.order_status = ? ");
        sql.append(" ORDER BY o.order_date DESC ");

        try (Connection con = db.getDbConn();
             PreparedStatement pstmt = con.prepareStatement(sql.toString())) {
            
            int idx = 1;
            if (name != null && !name.isBlank()) pstmt.setString(idx++, "%" + name + "%");
            if (date != null) pstmt.setDate(idx++, date);
            if (status != null && !status.equals("배송상태")) pstmt.setString(idx++, status);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    OrderDTO dto = new OrderDTO();
                    dto.setOrderId(rs.getInt("order_id"));
                    dto.setUserId(rs.getInt("user_id"));
                    dto.setUserName(rs.getString("user_name"));
                    dto.setOrderDate(rs.getDate("order_date"));
                    dto.setOrderStatus(rs.getString("order_status"));
                    dto.setTotalPrice(rs.getDouble("total_price"));
                    dto.setReceiverName(rs.getString("receiver_name"));
                    dto.setReceiverPhone(rs.getString("receiver_phone"));
                    dto.setReceiverEmail(rs.getString("receiver_email"));
                    dto.setReceiverZip(rs.getString("receiver_zip"));
                    dto.setReceiverAddress1(rs.getString("receiver_address1"));
                    dto.setReceiverAddress2(rs.getString("receiver_address2"));
                    dto.setOrderMemo(rs.getString("order_memo"));
                    list.add(dto);
                }
            }
        }
        return list;
    }
    
    /** ✅ 단일 상품 주문 아이템 삽입 **/
    public void insertSingleOrderItem(Connection conn, int orderId, int productId, String productName,
                                      int unitPrice, int quantity) throws SQLException {
        String sql = """
            INSERT INTO order_item (
              order_id, product_id, quantity, unit_price
            ) VALUES (?, ?, ?, ?)
        """;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, orderId);
            pstmt.setInt(2, productId);
            pstmt.setInt(3, quantity);
            pstmt.setInt(4, unitPrice);
            pstmt.executeUpdate();
        }
    }

    public boolean cancelOrder(int orderId) throws SQLException {
        String sql = "UPDATE orders SET order_status = 'O0' WHERE order_id = ?";
        
        try (Connection conn = db.getDbConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, orderId);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        }
    }


        /**
         *  ─────────────────────────────────────────────────────────────────
         *  주문(orderId) 내 모든 order_item + “리뷰 여부(reviewed)”를 함께 조회
         *  (주문 상태 O3(배송완료)인 것만, 사용자(userId) 검증 포함)
         *  reviewed = true  ↔ review 테이블에 해당 order_item_id가 있으면
         *  reviewed = false ↔ review 테이블에 없으면
         *  ─────────────────────────────────────────────────────────────────
         */
        public OrderDTO getItemsWithReviewStatusByOrder(int userId, int orderId) throws SQLException {
            OrderDTO order = null;
            String sql = """
                SELECT 
                  oi.order_item_id,
                  oi.order_id,
                  oi.product_id,
                  o.order_date,
                  p.name               AS product_name,
                  p.thumbnail_url      AS thumbnail_url,
                  CASE 
                    WHEN r.order_item_id IS NULL THEN 0 
                    ELSE 1 
                  END AS is_reviewed
                FROM order_item oi
                JOIN orders o ON oi.order_id = o.order_id
                JOIN product p ON oi.product_id = p.product_id
                LEFT JOIN review r ON oi.order_item_id = r.order_item_id
                WHERE o.user_id = ?
                  AND o.order_id = ?
                  AND o.order_status = 'O4'
                """;

            try (Connection con = db.getDbConn();
                 PreparedStatement pstmt = con.prepareStatement(sql)) {
                pstmt.setInt(1, userId);
                pstmt.setInt(2, orderId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    List<OrderItemDTO> itemList = new ArrayList<>();
                    while (rs.next()) {
                        if (order == null) {
                            order = new OrderDTO();
                            order.setOrderId(rs.getInt("order_id"));
                            order.setOrderDate(rs.getDate("order_date"));
                            order.setItems(itemList);  // 빈 리스트 연결
                        }
                        OrderItemDTO item = new OrderItemDTO();
                        item.setOrderItemId(rs.getInt("order_item_id"));
                        item.setProductId(rs.getInt("product_id"));
                        item.setProductName(rs.getString("product_name"));
                        item.setThumbnailUrl(rs.getString("thumbnail_url"));
                        // is_reviewed 컬럼이 0/1 형태로 넘어옴 → boolean으로 매핑
                        item.setReviewed(rs.getInt("is_reviewed") == 1);
                        itemList.add(item);
                    }
                }
            }
            return order;
        }

        public List<OrderDTO> getOrdersByUserWithRange(int userId, RangeDTO range) throws SQLException {
            List<OrderDTO> orders = new ArrayList<>();

            String sql = """
                SELECT * FROM (
                    SELECT inner_query.*, ROWNUM rnum FROM (
                        SELECT o.order_id, o.user_id, o.order_date, o.order_status, o.total_price,
                               o.receiver_name, o.receiver_phone, o.receiver_email,
                               o.receiver_zip, o.receiver_address1, o.receiver_address2, o.order_memo,
                               oi.order_item_id, oi.product_id, oi.quantity, oi.unit_price,
                               p.name AS product_name, p.thumbnail_url,
                               CASE WHEN r.order_item_id IS NOT NULL THEN 1 ELSE 0 END AS reviewed
                        FROM orders o
                        JOIN order_item oi ON o.order_id = oi.order_id
                        JOIN product p ON oi.product_id = p.product_id
                        LEFT JOIN review r ON oi.order_item_id = r.order_item_id
                        WHERE o.user_id = ?
                        ORDER BY o.order_date DESC
                    ) inner_query
                    WHERE ROWNUM <= ?
                ) WHERE rnum >= ?
            """;

            try (Connection con = db.getDbConn();
                 PreparedStatement pstmt = con.prepareStatement(sql)) {

                pstmt.setInt(1, userId);
                pstmt.setInt(2, range.getEndNum());
                pstmt.setInt(3, range.getStartNum());

                ResultSet rs = pstmt.executeQuery();

                Map<Integer, OrderDTO> orderMap = new LinkedHashMap<>();

                while (rs.next()) {
                    int orderId = rs.getInt("order_id");
                    OrderDTO order = orderMap.get(orderId);

                    if (order == null) {
                        order = new OrderDTO();
                        order.setOrderId(orderId);
                        order.setUserId(rs.getInt("user_id"));
                        order.setOrderDate(rs.getDate("order_date"));
                        order.setOrderStatus(rs.getString("order_status"));
                        order.setTotalPrice(rs.getInt("total_price"));
                        order.setReceiverName(rs.getString("receiver_name"));
                        order.setReceiverPhone(rs.getString("receiver_phone"));
                        order.setReceiverEmail(rs.getString("receiver_email"));
                        order.setReceiverZip(rs.getString("receiver_zip"));
                        order.setReceiverAddress1(rs.getString("receiver_address1"));
                        order.setReceiverAddress2(rs.getString("receiver_address2"));
                        order.setOrderMemo(rs.getString("order_memo"));
                        order.setItems(new ArrayList<>());

                        orderMap.put(orderId, order);
                    }

                    OrderItemDTO item = new OrderItemDTO();
                    item.setOrderItemId(rs.getInt("order_item_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getInt("unit_price"));
                    item.setProductName(rs.getString("product_name"));
                    item.setThumbnailUrl(rs.getString("thumbnail_url"));
                    item.setReviewed(rs.getInt("reviewed") == 1);

                    order.getItems().add(item);
                }

                orders.addAll(orderMap.values());
            }

            return orders;
        }

        public boolean isOrderOwnedByUser(int orderId, int userId) throws SQLException {
            String sql = "SELECT COUNT(*) FROM orders WHERE order_id = ? AND user_id = ?";
            
            try (Connection conn = db.getDbConn();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {

                pstmt.setInt(1, orderId);
                pstmt.setInt(2, userId);

                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1) > 0;
                    }
                }
            }

            return false;
        }
        
        public boolean isOrderItemOwnedByUser(int orderItemId, int userId) throws SQLException {
            String sql = """
                SELECT COUNT(*)
                  FROM order_item oi
                  JOIN orders o ON oi.order_id = o.order_id
                 WHERE oi.order_item_id = ? AND o.user_id = ?
            """;

            try (Connection conn = db.getDbConn();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, orderItemId);
                pstmt.setInt(2, userId);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1) > 0;
                    }
                }
            }
            return false;
        }

        public List<CartItemDTO> selectCartItemsByProductIds(int userId, int cartId, List<Integer> selectedProductIds) throws SQLException {
            List<CartItemDTO> list = new ArrayList<>();
            if (selectedProductIds == null || selectedProductIds.isEmpty()) return list;

            StringBuilder placeholders = new StringBuilder();
            for (int i = 0; i < selectedProductIds.size(); i++) {
                placeholders.append("?");
                if (i < selectedProductIds.size() - 1) placeholders.append(",");
            }

            String sql = "SELECT ci.cart_id, ci.product_id, ci.quantity, ci.added_at, " +
                         "p.name AS product_name, p.price AS unit_price, p.thumbnail_url " +
                         "FROM cart_item ci " +
                         "JOIN product p ON ci.product_id = p.product_id " +
                         "WHERE ci.cart_id = ? " +
                         "AND ci.product_id IN (" + placeholders + ")";

            try (Connection conn = db.getDbConn();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {

                pstmt.setInt(1, cartId);
                for (int i = 0; i < selectedProductIds.size(); i++) {
                    pstmt.setInt(i + 2, selectedProductIds.get(i));
                }

                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        CartItemDTO dto = new CartItemDTO();
                        dto.setCartId(rs.getInt("cart_id"));
                        dto.setProductId(rs.getInt("product_id"));
                        dto.setQuantity(rs.getInt("quantity"));
                        dto.setAdded_at(rs.getDate("added_at"));
                        dto.setPrice(rs.getInt("unit_price"));  // 🔥 product 테이블의 price
                        dto.setProductName(rs.getString("product_name"));
                        dto.setThumbnailImg(rs.getString("thumbnail_url"));
                        list.add(dto);
                    }
                }
            }

            return list;
        }



        
        public void insertSelectedOrderItems(Connection conn, int userId, int cartId, List<Integer> selectedProductIds, int orderId) throws SQLException {
            if (selectedProductIds == null || selectedProductIds.isEmpty()) return;

            StringBuilder sql = new StringBuilder();
            sql.append("""
                INSERT INTO order_item (order_item_id, order_id, product_id, quantity, unit_price)
                SELECT order_item_seq.NEXTVAL, ?, ci.product_id, ci.quantity, p.price
                  FROM cart_item ci
                  JOIN product p ON ci.product_id = p.product_id
                 WHERE ci.cart_id = ?
                   AND ci.product_id IN (
            """);

            for (int i = 0; i < selectedProductIds.size(); i++) {
                sql.append("?");
                if (i < selectedProductIds.size() - 1) {
                    sql.append(", ");
                }
            }
            sql.append(")");

            try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
                pstmt.setInt(1, orderId);
                pstmt.setInt(2, cartId);
                for (int i = 0; i < selectedProductIds.size(); i++) {
                    pstmt.setInt(3 + i, selectedProductIds.get(i));
                }
                pstmt.executeUpdate();
            }
        }



}
