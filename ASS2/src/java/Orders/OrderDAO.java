package Orders;

import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderDAO {

    // Lấy danh sách tất cả đơn hàng
    public List<OrderDTO> getAllOrders() {
    List<OrderDTO> orderList = new ArrayList<>();
    String sql = "SELECT o.*, COUNT(od.product_id) AS total_items " +
                 "FROM orders o " +
                 "LEFT JOIN order_details od ON o.order_id = od.order_id " +
                 "GROUP BY o.order_id, o.user_id, o.order_date, o.status, o.total_price, o.shipping_address";

    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            OrderDTO order = new OrderDTO();
            order.setOrderId(rs.getInt("order_id"));
            order.setUserId(rs.getInt("user_id"));
            order.setCreatedAt(rs.getString("order_date"));
            order.setStatus(rs.getString("status"));
            order.setTotalPrice(rs.getDouble("total_price"));
            order.setTotalItems(rs.getInt("total_items")); // ✅ Lấy số lượng sản phẩm
            order.setShippingAddress(rs.getString("shipping_address"));
            orderList.add(order);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return orderList;
}
    public int createOrder(int userId, HashMap<Integer, Integer> cart, double totalPrice, String shippingAddress) {
    int orderId = -1;

    String sqlInsertOrder = "INSERT INTO Orders (user_id, order_date, status, total_price, shipping_address) " +
                            "VALUES (?, GETDATE(), 'Pending', ?, ?)";

    String sqlInsertOrderItem = "INSERT INTO Order_Items (order_id, product_id, quantity) VALUES (?, ?, ?)";

    try (Connection conn = DBUtils.getConnection();
         PreparedStatement psOrder = conn.prepareStatement(sqlInsertOrder, Statement.RETURN_GENERATED_KEYS);
         PreparedStatement psOrderItem = conn.prepareStatement(sqlInsertOrderItem)) {

        conn.setAutoCommit(false); // Bắt đầu transaction

        // 1. Chèn đơn hàng vào bảng Orders
        psOrder.setInt(1, userId);
        psOrder.setDouble(2, totalPrice);
        psOrder.setString(3, shippingAddress);
        int rowsAffected = psOrder.executeUpdate();

        if (rowsAffected > 0) {
            ResultSet rs = psOrder.getGeneratedKeys();
            if (rs.next()) {
                orderId = rs.getInt(1); // Lấy order_id vừa tạo
            }
        }

        if (orderId > 0) {
            // 2. Chèn từng sản phẩm vào bảng Order_Items
            for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                psOrderItem.setInt(1, orderId);
                psOrderItem.setInt(2, entry.getKey()); // product_id
                psOrderItem.setInt(3, entry.getValue()); // quantity
                psOrderItem.executeUpdate();
            }
            conn.commit(); // Xác nhận transaction
        } else {
            conn.rollback(); // Hủy transaction nếu không tạo được order
        }

    } catch (SQLException e) {
        e.printStackTrace();
        return -1; // Lỗi khi tạo đơn hàng
    }

    return orderId;
}

    // Lấy đơn hàng theo ID
    public OrderDTO getOrderById(int orderId) {
        String sql = "SELECT * FROM orders WHERE order_id = ?";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                OrderDTO order = new OrderDTO();
                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setStatus(rs.getString("status"));
                order.setTotalPrice(rs.getDouble("total_price"));
                order.setShippingAddress(rs.getString("shipping_address"));
                order.setCreatedAt(rs.getString("created_at")); // created_at là String trong DTO
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm đơn hàng mới
    public boolean insertOrder(OrderDTO order) {
        String sql = "INSERT INTO orders (user_id, status, total_price, shipping_address, created_at) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, order.getUserId());
            ps.setString(2, order.getStatus());
            ps.setDouble(3, order.getTotalPrice());
            ps.setString(4, order.getShippingAddress());
            ps.setString(5, order.getCreatedAt()); // created_at là String

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    order.setOrderId(rs.getInt(1)); // Lấy ID vừa tạo
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật đơn hàng
    public boolean updateOrder(OrderDTO order) {
        String sql = "UPDATE orders SET user_id=?, total_price=?, shipping_address=?, status=?, created_at=? WHERE order_id=?";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, order.getUserId());
            ps.setDouble(2, order.getTotalPrice());
            ps.setString(3, order.getShippingAddress());
            ps.setString(4, order.getStatus());
            ps.setString(5, order.getCreatedAt()); // created_at là kiểu String trong DTO
            ps.setInt(6, order.getOrderId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa đơn hàng
    public boolean deleteOrder(int orderId) {
        String sql = "DELETE FROM orders WHERE order_id = ?";
        try (Connection conn = DBUtils.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
