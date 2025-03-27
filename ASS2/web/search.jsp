<%-- 
    Document   : search
    Created on : Mar 27, 2025, 12:10:17 AM
    Author     : ADMIN
--%>

<%@page import="Category.CategoryDTO"%>
<%@page import="java.util.Map"%>
<%@page import="Product.ProductDTO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    List<ProductDTO> products = (List<ProductDTO>) request.getAttribute("products");
    List<CategoryDTO> categories = (List<CategoryDTO>) request.getAttribute("categories");
    int currentPage = (request.getAttribute("currentPage") != null) ? (Integer) request.getAttribute("currentPage") : 1;
    int totalPages = (request.getAttribute("totalPages") != null) ? (Integer) request.getAttribute("totalPages") : 1;
    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/styles.css">

        <title>JSP Page</title>
    </head>
    <body>
        <h2 class="head-search">Kết quả tìm kiếm</h2>
        <div class="product-lists">
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
    <p>Không tìm thấy sản phẩm nào.</p>
    <% } %>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
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
