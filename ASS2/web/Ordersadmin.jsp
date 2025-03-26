<%@ page import="java.util.List" %>
<%@ page import="Orders.OrderDAO" %>
<%@ page import="Orders.OrderDTO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    OrderDAO orderDAO = new OrderDAO();
    List<OrderDTO> orderList = orderDAO.getAllOrders(); // ✅ Lấy danh sách đơn hàng
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Orders Admin</title>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/admin.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    </head>
    <body>
        <!-- NAVBAR -->
        <nav class="navbar">
            <div class="nav-left">
                <h2 class="logo">HELIOS</h2>
                <ul class="nav-menu">
                    <li><a href="Homepageadmin.jsp" class="active">Home</a></li>
        <li><a href="Ordersadmin.jsp">Orders</a></li>
        <li><a href="Productsadmin.jsp">Products</a></li>
        <li><a href="Usersadmin.jsp">Users</a></li>
                </ul>
            </div>
            <div class="nav-right">
                <img src="../images/avatar.png" alt="Avatar" class="avatar">
            </div>
        </nav>

        <div class="sub-header">
            <h1>Orders</h1>
            <input type="text" id="searchInput" class="search-box" placeholder="Search orders..." onkeyup="searchTable()">
        </div>

        <div class="content">
            <section class="page-section">
                <div class="table-container">
                    <table id="ordersTable">
                        <thead>
                            <tr>
                                <th><input type="checkbox" onclick="toggleAll('ordersTable')"></th>
                                <th>ORDER ID</th>
                                <th>DATE</th>
                                <th>USER ID</th>
                                <th>STATUS</th>
                                <th>TOTAL</th>
                                <th>ITEMS</th>
                                <th>ADDRESS</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (OrderDTO order : orderList) {%>
                            <tr>
                                <td><input type="checkbox"></td>
                                <td><%= order.getOrderId()%></td>
                                <td><%= order.getCreatedAt()%></td>
                                <td><%= order.getUserId()%></td>
                                <td><%= order.getStatus()%></td>
                                <td>$<%= order.getTotalPrice()%></td>
                                <td>
                                    <a href="OrderDetails.jsp?orderId=<%= order.getOrderId()%>" class="view-items">
                                        <%= order.getTotalItems()%>
                                    </a>
                                </td>
                                <td><%= order.getShippingAddress()%></td>
                                
                            </tr>
                            <% }%>
                        </tbody>
                    </table>
                </div>
                <div class="pagination">
                    <a href="#">&laquo; Previous</a>
                    <a href="#" class="active">1</a>
                    <a href="#">Next &raquo;</a>
                </div>
            </section>
        </div>

        <!-- Script -->
        <script>
            function searchTable() {
                const keyword = document.getElementById('searchInput').value.toLowerCase();
                const rows = document.getElementById('ordersTable').querySelectorAll('tbody tr');
                rows.forEach(row => {
                    const text = row.innerText.toLowerCase();
                    row.style.display = text.indexOf(keyword) > -1 ? '' : 'none';
                });
            }

            function toggleAll(tableId) {
                const table = document.getElementById(tableId);
                const headCB = table.querySelector('thead input[type="checkbox"]');
                const rowCBs = table.querySelectorAll('tbody input[type="checkbox"]');
                rowCBs.forEach(cb => cb.checked = headCB.checked);
            }

            function editRow(orderId) {
                window.location.href = "EditOrder.jsp?orderId=" + orderId;
            }

            function deleteRow(orderId) {
                if (confirm("Are you sure you want to delete this order?")) {
                    window.location.href = "DeleteOrder.jsp?orderId=" + orderId;
                }
            }
        </script>
    </body>
</html>
