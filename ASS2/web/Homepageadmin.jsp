<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>HELIOS - Admin Home</title>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/admin.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    </head>
    <body>
        <!-- NAVBAR -->
        <nav class="navbar">
            <div class="nav-left">
                <h2 class="logo">HELIOS</h2>
                <ul class="nav-menu">
                    <!-- Thêm link Home -->
                    <li><a href="Homepageadmin.jsp" class="active">Home</a></li>
                    <li><a href="Ordersadmin.jsp">Orders</a></li>
                    <li><a href="Productsadmin.jsp">Products</a></li>
                    <li><a href="Usersadmin.jsp">Users</a></li>
                    <button onclick="window.location.href = 'MainController?action=loadProducts&page=1'" class="back-btn">Back to Web</button>
                    

                </ul>
            </div>
            <div class="nav-right">
                <img src="../images/avatar.png" alt="Avatar" class="avatar">
            </div>
        </nav>

        <!-- SUB-HEADER -->
        <div class="sub-header">
            <h1>Admin Home</h1>
        </div>

        <!-- CONTENT -->
        <div class="content">
            <p>Chào mừng bạn đến với trang quản trị HELIOS. Hãy chọn một mục bên trên để quản lý!</p>
        </div>
    </body>
</html>
