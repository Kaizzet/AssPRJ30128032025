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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/thanhtoan.css">
</head>
<body>
<div class="checkout-container">
    <div class="checkout-left">
        <section class="section-contact">
            <h2>Liên hệ</h2>
            <div class="input-group">
                <label for="contactInput">Email</label>
            </div>
            <div class="checkbox-group">
                <input type="checkbox" id="subscribe">
                <label for="subscribe">Giữ tôi cập nhật các ưu đãi qua email</label>
            </div>
        </section>
        <section class="section-shipping">
            <h2>Giao hàng</h2>
            <div class="input-group">
                <label for="country">Quốc gia/Khu vực</label>
                <select id="country">
                    <option value="vn">Việt Nam</option>
                    <option value="us">Hoa Kỳ</option>
                    <option value="jp">Nhật Bản</option>
                </select>
            </div>
            <div class="input-group">
                <label for="address">Địa chỉ</label>
                <input type="text" id="address" placeholder="Số nhà, tên đường...">
            </div>
            <div class="input-group">
                <label for="phone">Điện thoại</label>
                <input type="text" id="phone" placeholder="Số điện thoại">
            </div>
            <section class="section-delivery">
                <h3>Phương thức vận chuyển</h3>
                <a class="checkout-btn">Thanh toán ngay</a>
            </section>
        </section>
    </div>

    <div class="checkout-right">
        <div class="order-summary">
            <% 
                HashMap<Integer, Integer> cart = (HashMap<Integer, Integer>) session.getAttribute("cart");
                if (cart == null) {
                    cart = new HashMap<>();
                }
                ProductDAO productDAO = new ProductDAO();
                double totalPrice = 0;
                for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                    int productId = entry.getKey();
                    int quantity = entry.getValue();
                    ProductDTO product = productDAO.getProductById(productId);
                    if (product != null) {
                        double itemTotal = product.getPrice() * quantity;
                        totalPrice += itemTotal;
            %>
            <div class="summary-item">
                <img class="cart-item" src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>">
                <div class="item-info">
                    <p class="item-name"><%= product.getName() %> <%= (quantity > 1) ? " x" + quantity : "" %></p>

                    <p class="item-price"><%= String.format("%,.0f", product.getPrice()) %> đ</p>
                </div>
            </div>
            <hr>
            <%      } 
                } %>
            <div class="summary-fee">
                <div class="fee-row">
                    <span>Tổng phụ</span>
                    <span><%= String.format("%,.0f", totalPrice) %> đ</span>
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
</div>
<footer class="footer">
    <div class="footer-container">
        <div class="footer-column">
            <h2>KẾT NỐI VỚI CHÚNG TÔI</h2>
            <p>HELIOS Shop chuyên cung cấp trang sức cao cấp với mẫu mã độc đáo.</p>
            <p>Hotline tư vấn: 0981.551.616</p>
            <p>Email: support@helios.vn</p>
        </div>
    </div>
</footer>
</body>
</html>
