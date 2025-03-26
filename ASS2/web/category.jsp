<%@page import="java.util.HashMap"%>
<%@page import="Product.ProductDAO"%>
<%@page import="java.util.Map"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, Product.ProductDTO, Category.CategoryDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    HashMap<Integer, Integer> cart = (HashMap<Integer, Integer>) session.getAttribute("cart");
    if (cart == null) {
        cart = new HashMap<>(); // Tạo giỏ hàng trống nếu chưa có
    }
%>

<%
    List<ProductDTO> products = (List<ProductDTO>) request.getAttribute("products");
    List<CategoryDTO> categories = (List<CategoryDTO>) request.getAttribute("categories");
    String categoryName = (String) request.getAttribute("categoryName");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= categoryName != null ? categoryName : "Danh mục sản phẩm"%></title>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/css/styles.css">
    <style>
        .cart-dropdown {
            display: none;
            position: absolute;
            background-color: white;
            border: 1px solid #ccc;
            width: 300px;
            right: 0;
            top: 30px;
            padding: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            border-radius: 5px;
        }
        .cart:hover .cart-dropdown {
            display: block;
        }
        .cart-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #ddd;
        }
        .cart-item img {
            width: 50px;
            height: 50px;
            margin-right: 10px;
            border-radius: 5px;
        }
        .cart-item-details {
            flex-grow: 1;
        }
        .cart-item-remove {
            cursor: pointer;
            color: red;
        }
    </style>
</head>
<body>

    <!-- HEADER -->
    <header>
        <nav>
            <ul>
                <li class="dropdown">
                    <a href="#">MENU</a>
                    <ul class="dropdown-content">
                        <% if (categories != null && !categories.isEmpty()) {
                            for (CategoryDTO category : categories) { %>
                        <li>
                            <a href="MainController?action=loadCategory&category=<%= category.getCategoryId()%>&page=1">
                                <%= category.getCategoryName()%>
                            </a>
                        </li>
                        <%  }
                        } else { %>
                        <li><a href="#">Không có danh mục</a></li>
                        <% }%>
                    </ul>
                </li>
            </ul>
        </nav>       
        <div class="logo">
            <a href="MainController?action=loadProducts&page=1">
                𝓗𝓔𝓛𝓘𝓞𝓢
            </a>
        </div>

        <div class="user-options">
            <a style="color: white" href="<%= request.getContextPath()%>/register.jsp">Đăng ký</a>
            <span style="color: white">/</span> 
            <a style="color: white" href="<%= request.getContextPath()%>/login.jsp"> Đăng nhập</a>
            <div class="cart">
                <a href="#">🛒</a>
                <div class="cart-dropdown">
                    <% if (cart != null && !cart.isEmpty()) {
                        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                            ProductDTO product = new ProductDAO().getProductById(entry.getKey());
                            if (product != null) { %>
                    <div class="cart-item">
                        <img src="<%= product.getImageUrl()%>" alt="<%= product.getName()%>">
                        <div class="cart-item-details">
                            <span><strong><%= product.getName()%></strong></span>
                            <span>x<%= entry.getValue()%></span>
                            <span><%= String.format("%,.0f", product.getPrice() * entry.getValue())%> VNĐ</span>
                        </div>
                    </div>
                    <% }
                        } %>
                    <a href="MainController?action=viewCart">Xem giỏ hàng</a>
                    <% } else { %>
                    <p>Giỏ hàng trống</p>
                    <% }%>
                </div>
            </div>
        </div>
    </header>

    <!-- TIÊU ĐỀ DANH MỤC -->
    <section class="category-header">
        <h2><%= categoryName != null ? categoryName : "Sản phẩm"%></h2>
    </section>

    <!-- DANH SÁCH SẢN PHẨM -->
    <section class="products">
        <div class="product-list">
            <% if (products != null && !products.isEmpty()) {
                for (ProductDTO p : products) { %>
            <div class="product">
                <img src="<%= p.getImageUrl()%>" alt="<%= p.getName()%>">
                <h3><%= p.getName()%></h3>
                <p><strong><%= String.format("%,.0f", p.getPrice())%> VNĐ</strong></p>
                <p><%= p.getDescription()%></p>
                <button class="add-to-cart" data-product-id="<%= p.getProductId()%>">Thêm nhanh</button>
            </div>
            <%  }
            } else { %>
            <p>Không có sản phẩm nào trong danh mục này.</p>
            <% }%>
        </div>
    </section>

    <!-- PHÂN TRANG -->
    <% if (products != null && !products.isEmpty()) { %>
    <div class="pagination">
        <% if (currentPage > 1) { %>
        <a href="MainController?action=<%= selectedCategory != null ? "loadCategory&category=" + selectedCategory : "loadProducts"%>&page=<%= currentPage - 1 %>">Previous</a>
        <% } %>

        <% for (int i = 1; i <= totalPages; i++) { %>
        <% if (i == currentPage) { %>
        <span class="current"><%= i %></span>
        <% } else { %>
        <a href="MainController?action=<%= selectedCategory != null ? "loadCategory&category=" + selectedCategory : "loadProducts"%>&page=<%= i %>"><%= i %></a>
        <% } %>
        <% } %>

        <% if (currentPage < totalPages) { %>
        <a href="MainController?action=<%= selectedCategory != null ? "loadCategory&category=" + selectedCategory : "loadProducts"%>&page=<%= currentPage + 1 %>">Next</a>
        <% } %>
    </div>
    <% } %>

    <!-- FOOTER -->
    <footer class="footer">
        <div class="footer-container">
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
            </div>
        </div>
    </footer>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            let header = document.querySelector("header");
            header.classList.add("transparent");

            header.addEventListener("mouseenter", function () {
                header.classList.remove("transparent");
            });

            header.addEventListener("mouseleave", function () {
                header.classList.add("transparent");
            });

            document.querySelectorAll(".add-to-cart").forEach(button => {
                button.addEventListener("click", function () {
                    let productId = this.getAttribute("data-product-id");
                    fetch("MainController?action=addToCart&productId=" + productId, {method: "GET"})
                        .then(response => response.json())
                        .then(data => {
                            if (data.status === "success") {
                                alert("Sản phẩm đã được thêm vào giỏ hàng!");
                                location.reload(); // Tải lại trang để cập nhật giỏ hàng
                            }
                        })
                        .catch(error => console.error("Lỗi:", error));
                });
            });
        });
    </script>
</body>
</html>