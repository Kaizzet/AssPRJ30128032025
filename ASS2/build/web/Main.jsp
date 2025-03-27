<%@page import="Product.ProductDAO"%>
<%@page import="Category.CategoryDTO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map, Product.ProductDTO" %>
<%@page import="Users.UserDTO"%>

<%
    // Lấy thông tin user từ session
    UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
%>

<%
    List<ProductDTO> products = (List<ProductDTO>) request.getAttribute("products");
    List<CategoryDTO> categories = (List<CategoryDTO>) request.getAttribute("categories");
    int currentPage = (request.getAttribute("currentPage") != null) ? (Integer) request.getAttribute("currentPage") : 1;
    int totalPages = (request.getAttribute("totalPages") != null) ? (Integer) request.getAttribute("totalPages") : 1;
    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Helios Clone</title>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/css/styles.css">
</head>
<body class="body-main">

    <header>
    <nav>
        <ul>
            <li class="dropdown">
                <a href="#">MENU</a>
                <ul class="dropdown-content">
                    <% if (categories != null && !categories.isEmpty()) {
                        for (CategoryDTO category : categories) { %>
                    <li>
                        <a href="MainController?action=loadCategory&category=<%= category.getCategoryId()%>">
                            <%= category.getCategoryName()%>
                        </a>
                    </li>
                    <%  }
                    } else { %>
                    <li><a href="#">Không có danh mục</a></li>
                    <% } %>
                </ul>
            </li>
        </ul>
    </nav>   

    <div class="logo">𝓗𝓔𝓛𝓘𝓞𝓢</div>
    
    <div class="user-options">
            <%
                UserDTO loggedInUsers = (UserDTO) session.getAttribute("loggedInUser");
                if (loggedInUsers != null) {
            %>
            <%-- Nếu là admin, hiển thị nút "Quản lý Admin" --%>
            <% if ("Quản trị viên".equalsIgnoreCase(loggedInUsers.getRole())) { %>
            <a href="Homepageadmin.jsp" class="btn btn-warning">
                <i class="admin-back"></i> Quản lý Admin
            </a>
            <% } %>
            <%
                }
            %>

    <!-- 🔍 Thêm thanh tìm kiếm vào đây -->
    <div class="search-container">
    <form action="MainController" method="get" class="search-form">
        <input type="hidden" name="action" value="search">
        <input type="text" name="keyword" placeholder="Tìm kiếm sản phẩm...">
        <button type="submit">🔍</button>
    </form>
</div>


    <div class="user-options">
        <% if (loggedInUser == null) { %>
        <a style="color: white" href="<%= request.getContextPath()%>/register.jsp">Đăng ký</a>
        <span style="color: white">/</span> 
        <a style="color: white" href="<%= request.getContextPath()%>/login.jsp">Đăng nhập</a>
        <% } else { %>
        <span style="color: white">Xin chào, <%= loggedInUser.getRole().equalsIgnoreCase("admin") ? "Admin" : loggedInUser.getName()%></span>
        <span style="color: white">|</span>
        <a style="color: white" href="MainController?action=logout">Đăng xuất</a>
        <% } %>
    </div>
    
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
                            <span><strong><%= product.getName()%></strong></span><br>
                            <span>Số lượng: <%= entry.getValue()%></span><br>
                            <span><%= String.format("%,.0f", product.getPrice() * entry.getValue())%> VNĐ</span>
                        </div>
                        
                    </div>
                    <% }
                        } %>
                    <a href="MainController?action=viewCart">🛍 Xem giỏ hàng</a>
                    <% } else { %>
                    <p>Giỏ hàng trống</p>
                    <% } %>
                </div>
            </div>
        </div>
</header>


    <section class="banner">
        <img src="https://raw.githubusercontent.com/tuanptse/ASSprj/main/ASS2/web/images/banner.jpg" alt="Helios Banner">
    </section>

    <section class="products">
        <h2 class="sanphammoi">Sản phẩm mới</h2>
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
            <p>Không có sản phẩm nào để hiển thị.</p>
            <% } %>
        </div>
    </section>
    <jsp:include page="paging.jsp"/>

    <footer>
        <p>© 2025 Helios. All rights reserved.</p>
    </footer>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            let header = document.querySelector("header");

            // Khi không di chuột vào, header sẽ mất màu
            header.classList.add("transparent");

            // Khi trỏ chuột vào header, nó hiện màu đen
            header.addEventListener("mouseenter", function () {
                header.classList.remove("transparent");
            });

            // Khi chuột rời khỏi header, nó trở lại trong suốt
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