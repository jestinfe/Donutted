package order;

import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import cart.CartDAO;
import cart.CartItemDTO;
import user.UserDTO;
import util.CryptoUtil;
import util.RangeDTO;

public class OrderService {
    private OrderDAO dao = OrderDAO.getInstance();
    private CartDAO cDAO = CartDAO.getInstance();

    public List<OrderItemDTO> getRefundableItems(int userId) throws SQLException {
        return dao.getRefundableItems(userId);
    }

    public OrderItemDTO getOrderItemDetail(int orderItemId) throws SQLException {
        return dao.getOrderItemDetail(orderItemId);
    }

    public List<OrderItemDTO> getReviewableItems(int userId) throws SQLException {
        return dao.getReviewableItems(userId);
    }

    public List<OrderDTO> getOrdersByUser(int userId) throws SQLException {
        return dao.getOrdersByUser(userId);
    }

    public OrderDTO getReviewableItemsByOrder(int userId, int orderId) throws SQLException {
        return dao.getReviewableItemsByOrder(userId, orderId);
    }

    public List<OrderItemDTO> getRefundableItemsByOrderId(int orderId) {
        try {
            return dao.getRefundableItemsByOrderId(orderId);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public OrderDTO makeOrder(OrderItemDTO opDTO, UserDTO uDTO) {
        OrderDTO oDTO = new OrderDTO();
        try {
            dao.insertOrder(opDTO, uDTO.getUserId());
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return oDTO;
    }

    public List<OrderItemDTO> loadAllProductsFromOrder(int orderId) {
        try {
            return dao.insertAllProducts(orderId);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public void showAllOrderList(List<OrderItemDTO> list) {
        for (OrderItemDTO item : list) {
            System.out.println(item);
        }
    }

    public OrderDTO getOrder(int orderId) {
        try {
            return dao.selectOrder(orderId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public OrderItemDTO getProductByOrderId(int productId) {
        try {
            return dao.selectProduct(productId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public SingleOrderDTO getSingleOrder(int productId) {
        try {
            return dao.selectProductById(productId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<OrderItemDTO> makeNewOrder(int userId, int cartId) throws SQLException {
        int totalPrice = 0;
        List<OrderItemDTO> targetList = dao.selectOrderedItemsByUserId(userId);
        for (OrderItemDTO item : targetList) {
            totalPrice += item.getQuantity() * item.getUnitPrice();
        }
        dao.insertNewOrder(userId, totalPrice);
        return targetList;
    }

    public List<OrderItemDTO> makeNewOrderItems(int userId, int cartId) throws SQLException {
        return dao.selectOrderedItemsByUserId(userId);
    }

    public List<OrderItemDTO> makeNewOrderItemsBySelection(int userId, int cartId, List<Integer> selectedProductIds) throws SQLException {
        List<CartItemDTO> selectedItems = dao.selectCartItemsByProductIds(userId, cartId, selectedProductIds);
        List<OrderItemDTO> orderItems = new ArrayList<>();
        for (CartItemDTO item : selectedItems) {
            OrderItemDTO orderItem = new OrderItemDTO();
            orderItem.setProductId(item.getProductId());
            orderItem.setProductName(item.getProductName());
            orderItem.setQuantity(item.getQuantity());
            orderItem.setUnitPrice(item.getPrice());
            orderItem.setThumbnailUrl(item.getThumbnailImg());
            orderItems.add(orderItem);
        }
        return orderItems;
    }

    public boolean placeOrder(int userId, int cartId, String name, String phone, String email,
                              String zipCode, String addr1, String addr2, String memo, int totalCost) {
        Connection conn = null;
        try {
            javax.naming.Context ctx = new javax.naming.InitialContext();
            javax.sql.DataSource ds = (javax.sql.DataSource) ctx.lookup("java:comp/env/jdbc/myoracle");
            conn = ds.getConnection();
            conn.setAutoCommit(false);

            int orderId = dao.insertOrderWithUserInfo(conn, userId, name, phone, email, zipCode, addr1, addr2, memo, totalCost);
            dao.insertOrderItemsFromCart(conn, userId, cartId, orderId);
            cDAO.clearCart(conn, cartId);
            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            return false;
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (Exception closeEx) {
                closeEx.printStackTrace();
            }
        }
    }

    public List<OrderDTO> getAllOrders() {
        try {
            return dao.getAllOrders();
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<OrderDTO> searchOrders(String searchName, Date searchDate, String searchStatus) {
        try {
            return dao.searchOrders(searchName, searchDate, searchStatus);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<OrderDTO> getOrdersByRange(RangeDTO range, String searchName, Date searchDate, String searchStatus) {
        try {
            List<OrderDTO> all = dao.selectOrdersByRange(new RangeDTO(1, Integer.MAX_VALUE), null, searchDate, searchStatus);
            List<OrderDTO> filtered = new ArrayList<>();
            for (OrderDTO dto : all) {
                String decryptedName = dto.getUserName();
                dto.setUserName(decryptedName);

                boolean match = true;
                if (searchName != null && !searchName.trim().isEmpty()) {
                    if (decryptedName == null || !decryptedName.contains(searchName.trim())) {
                        match = false;
                    }
                }
                if (searchDate != null && !dto.getOrderDate().toLocalDate().equals(searchDate.toLocalDate())) {
                    match = false;
                }
                if (searchStatus != null && !searchStatus.trim().isEmpty()) {
                    if (!dto.getOrderStatus().equals(searchStatus)) {
                        match = false;
                    }
                }
                if (match) {
                    filtered.add(dto);
                }
            }

            int fromIndex = Math.max(0, range.getStartNum() - 1);
            int toIndex = Math.min(filtered.size(), range.getEndNum());
            return fromIndex < filtered.size() ? filtered.subList(fromIndex, toIndex) : new ArrayList<>();

        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public int getOrderCount(String searchName, Date searchDate, String searchStatus) {
        return getOrdersByRange(new RangeDTO(1, Integer.MAX_VALUE), searchName, searchDate, searchStatus).size();
    }

    public List<OrderItemDTO> getOrderItems(int orderId) {
        try {
            return dao.getOrderItemsByOrderId(orderId);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public boolean changeOrderStatus(int orderId, String newStatus) {
        try {
            return dao.updateOrderStatus(orderId, newStatus);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean placeSingleOrder(int userId, int productId, String productName, int unitPrice, int quantity,
                                    String name, String phone, String email,
                                    String zipCode, String addr1, String addr2,
                                    String memo, int totalCost) {
        Connection conn = null;
        try {
            javax.naming.Context ctx = new javax.naming.InitialContext();
            javax.sql.DataSource ds = (javax.sql.DataSource) ctx.lookup("java:comp/env/jdbc/myoracle");
            conn = ds.getConnection();
            conn.setAutoCommit(false);

            int orderId = dao.insertOrderWithUserInfo(conn, userId, name, phone, email, zipCode, addr1, addr2, memo, totalCost);
            dao.insertSingleOrderItem(conn, orderId, productId, productName, unitPrice, quantity);
            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            return false;
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (Exception closeEx) {
                closeEx.printStackTrace();
            }
        }
    }

    public boolean cancelOrder(int orderId) {
        try {
            return dao.cancelOrder(orderId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private String safeDecrypt(String encryptedValue) {
        try {
            return CryptoUtil.isValidBase64(encryptedValue) ? CryptoUtil.decrypt(encryptedValue) : encryptedValue;
        } catch (Exception e) {
            return ""; // 복호화 실패 시 빈 문자열 반환
        }
    }

    public List<OrderDTO> getOrdersByUserWithRange(int userId, RangeDTO range) {
        try {
            return dao.getOrdersByUserWithRange(userId, range);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public OrderDTO getItemsWithReviewStatusByOrder(int userId, int orderId) throws SQLException {
        return dao.getItemsWithReviewStatusByOrder(userId, orderId);
    }

    public int calculateCartTotal(int cartId, int userId) {
        int total = 0;
        try {
            List<CartItemDTO> items = cDAO.selectAllCartItem(cartId);
            for (CartItemDTO item : items) {
                total += item.getPrice() * item.getQuantity();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    public int calculateSingleTotal(int unitPrice, int quantity) {
        return unitPrice * quantity;
    }

    public boolean isOrderOwnedByUser(int orderId, int userId) {
        OrderDAO dao = OrderDAO.getInstance();
        try {
            return dao.isOrderOwnedByUser(orderId, userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isOrderItemOwnedByUser(int orderItemId, int userId) {
        OrderDAO dao = OrderDAO.getInstance();
        try {
            return dao.isOrderItemOwnedByUser(orderItemId, userId);
        } catch (SQLException e) {
            e.printStackTrace();            return false;
        }
    }
    
    public boolean placeOrderBySelection(int userId, int cartId, List<Integer> selectedProductIds,
            String name, String phone, String email,
            String zipCode, String addr1, String addr2,
            String memo, int totalCost) {
Connection conn = null;
try {
javax.naming.Context ctx = new javax.naming.InitialContext();
javax.sql.DataSource ds = (javax.sql.DataSource) ctx.lookup("java:comp/env/jdbc/myoracle");
conn = ds.getConnection();
conn.setAutoCommit(false);

// 1. 주문 생성
int orderId = dao.insertOrderWithUserInfo(conn, userId, name, phone, email, zipCode, addr1, addr2, memo, totalCost);

// 2. 선택된 상품만 주문 상품으로 insert
dao.insertSelectedOrderItems(conn, userId, cartId, selectedProductIds, orderId);

// 3. 선택된 상품만 장바구니에서 제거
cDAO.clearSelectedCartItems(conn, cartId, selectedProductIds);

conn.commit();
return true;
} catch (Exception e) {
e.printStackTrace();
try {
if (conn != null) conn.rollback();
} catch (Exception rollbackEx) {
rollbackEx.printStackTrace();
}
return false;
} finally {
try {
if (conn != null) conn.close();
} catch (Exception closeEx) {
closeEx.printStackTrace();
}
}
}

}
