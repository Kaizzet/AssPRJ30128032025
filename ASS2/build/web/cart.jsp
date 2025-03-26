<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map, java.util.HashMap, Product.ProductDAO, Product.ProductDTO" %>

<%
    // Lấy giỏ hàng từ session
    HashMap<Integer, Integer> cart = (HashMap<Integer, Integer>) session.getAttribute("cart");
    if (cart == null) {
        cart = new HashMap<>();
    }

    // Khởi tạo DAO để lấy thông tin sản phẩm
    ProductDAO productDAO = new ProductDAO();
    double totalPrice = 0;
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - Helios</title>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/css/styles.css">
    
</head>
<body class="cart-page">
    <div class="cart-container">
        <a href="MainController?action=loadProducts" class="home-btn">🏠 Trang chủ</a>
        <h2>Giỏ hàng của bạn</h2>
        <% if (!cart.isEmpty()) { %>
        <table>
            <tr>
                <th>Hình ảnh</th>
                <th>Sản phẩm</th>
                <th>Số lượng</th>
                <th>Giá</th>
                <th>Thành tiền</th>
                <th>Hành động</th>
            </tr>
            <% for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                ProductDTO product = productDAO.getProductById(entry.getKey().intValue());
                if (product != null) { %>
            <tr>
                <td><img class="cart-item" src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>"></td>
                <td><%= product.getName() %></td>
                <td><%= entry.getValue() %></td>
                <td><%= String.format("%,.0f", product.getPrice()) %> VNĐ</td>
                <td><%= String.format("%,.0f", product.getPrice() * entry.getValue()) %> VNĐ</td>
                <td class="cart-actions">
                    <button onclick="removeItem(<%= product.getProductId() %>)">❌ Xóa</button>
                </td>
            </tr>
            <% totalPrice += product.getPrice() * entry.getValue(); %>
            <% } } %>
        </table>
        <p class="total-price">Tổng cộng: <%= String.format("%,.0f", totalPrice) %> VNĐ</p>
        <a href="MainController?action=checkout" class="checkout-btn">Thanh toán ngay</a>
        <% } else { %>
        <p>Giỏ hàng của bạn đang trống.</p>
        <% } %>
    </div>
    <script>
        function removeItem(productId) {
            if (confirm("Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?")) {
                window.location.href = "MainController?action=removeFromCart&productId=" + productId;
            }
        }
    </script>
</body>
</html>
