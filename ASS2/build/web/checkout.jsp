<%@page import="Users.UserDAO"%>
<%@page import="Users.UserDTO"%>
<%@ page import="java.util.Map, java.util.HashMap, Product.ProductDAO, Product.ProductDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Product.ProductDAO" %>
<%@ page import="Category.CategoryDTO" %>
<%@ page import="java.util.List, java.util.Map, Product.ProductDTO" %>
<!DOCTYPE html>

<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh Toán - Helios</title>
    <!-- Link tới file CSS (giả sử bạn để trong thư mục css) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/thanhtoan.css">
</head>
<body>

<!-- HEADER (nếu cần) -->

<!-- NỘI DUNG TRANG THANH TOÁN -->
<div class="checkout-container">
    <!-- CỘT BÊN TRÁI: Thông tin liên hệ & giao hàng -->
    <div class="checkout-left">
        <!-- LIÊN HỆ -->
        <section class="section-contact">
            <h2>Liên hệ</h2>
            <div class="input-group">
                <label for="contactInput" >Email</label>
            </div>
            <div class="checkbox-group">
                <input type="checkbox" id="subscribe">
                <label for="subscribe">Giữ tôi cập nhật các ưu đãi qua email</label>
            </div>
        </section>

        <!-- GIAO HÀNG -->
        <section class="section-shipping">
            <h2>Giao hàng</h2>
            <!-- Quốc gia/khu vực -->
            <div class="input-group">
                <label for="country">Quốc gia/Khu vực</label>
                <select id="country">
                    <option value="vn">Việt Nam</option>
                    <option value="us">Hoa Kỳ</option>
                    <option value="jp">Nhật Bản</option>
                    <!-- Thêm tuỳ chọn khác nếu cần -->
                </select>
            </div>
            <!-- Tên & Họ -->
            
            <!-- Địa chỉ, Thành phố -->
            <div class="input-group">
                <label for="address">Địa chỉ</label>
                <input type="text" id="address" placeholder="Số nhà, tên đường...">
            </div>
            
            <!-- Điện thoại -->
            <div class="input-group">
                <label for="phone">Điện thoại</label>
                <input type="text" id="phone" placeholder="Số điện thoại">
            </div>
            <!-- Phương thức vận chuyển -->
            <section class="section-delivery">
                <h3>Phương thức vận chuyển</h3>
                <a class="checkout-btn">Thanh toán ngay</a>
                <!-- Nếu có nhiều tuỳ chọn, thêm ở đây -->
            </section>
        </section>
    </div>

    <%
        // Lấy giỏ hàng từ session
        HashMap<Integer, Integer> cart = (HashMap<Integer, Integer>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
        }

        // DAO để lấy thông tin sản phẩm từ productId
        ProductDAO productDAO = new ProductDAO();
        double totalPrice = 0;
    %>

    <% 
        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            int productId = entry.getKey();
            int quantity = entry.getValue();
                    
            // Lấy thông tin sản phẩm từ DB
            ProductDTO product = productDAO.getProductById(productId);
            if (product != null) {
                double itemTotal = product.getPrice() * quantity;
                totalPrice += itemTotal;
            
     
    %>
    
    <!-- CỘT BÊN PHẢI: Tóm tắt đơn hàng cho từng sản phẩm -->
    <div class="checkout-right">
        <div class="order-summary">
            <div class="summary-item">
                <img class="cart-item" src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>">
                <div class="item-info">
                    <p class="item-name"><%= product.getName() %></p>
                    <!-- Bạn có thể thêm thông tin size, số lượng,... nếu có -->
                    <p class="item-price"><%= String.format("%,.0f", product.getPrice()) %> đ</p>
                </div>
            </div>
            <hr>
            <div class="summary-fee">
                <div class="fee-row">
                    <span>Tổng phụ</span>
                    <span><%= String.format("%,.0f", itemTotal) %> đ</span>
                </div>
                <div class="fee-row">
                    <span>Vận chuyển</span>
                    <span>MIỄN PHÍ</span>
                </div>
            </div>
            <hr>
            <div class="summary-total">
                <div class="fee-row">
                    <span class="total-label">Tổng</span>
                    <span class="total-amount"><%= String.format("%,.0f", totalPrice) %> đ</span>
                </div>
            </div>
        </div>
    </div>
    <%  
            } // Đóng if (product != null)
        } // Đóng for
    %>
</div>

<!-- FOOTER (nếu cần) -->
<footer class="footer">
    <div class="footer-container">
        <!-- Cột 1: KẾT NỐI VỚI CHÚNG TÔI -->
        <div class="footer-column">
            <h2>KẾT NỐI VỚI CHÚNG TÔI</h2>
            <p>
                HELIOS Shop ra đời nhằm mục đích đem đến các dòng sản phẩm trang sức dành cho mọi người: 
                từ vòng tay thanh lịch, dây chuyền, khuyên tai độc đáo đến những món quà tinh tế. 
                Mỗi chiếc tác phẩm đều là tâm huyết và sáng tạo, 
                với hy vọng mang đến trải nghiệm tuyệt vời cho khách hàng.
            </p>
            <p>Hotline tư vấn:</p>
            
            <p>Hỗ trợ: 0981.551.616</p>
            <p>Email: support@helios.vn</p>
            <!-- Logo/badge minh họa -->
            
        </div>

        <!-- Cột 2: CHĂM SÓC KHÁCH HÀNG -->
        

        <!-- Cột 3: VỀ CHÚNG TÔI -->
        

        <!-- Cột 4: DÀNH CHO KHÁCH HÀNG -->
        
    </div>
</footer>

</body>
</html>
