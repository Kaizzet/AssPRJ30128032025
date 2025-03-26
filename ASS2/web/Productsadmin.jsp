<%@ page import="java.util.List" %>
<%@ page import="Product.ProductDAO" %>
<%@ page import="Product.ProductDTO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Products Admin</title>
  <link rel="stylesheet" href="<%= request.getContextPath()%>/css/admin.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
</head>
<body>
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
    <h1>Products</h1>
    <input type="text" id="searchInput" class="search-box" placeholder="Search products..." onkeyup="searchTable()">
  </div>
  <div class="content">
    <section class="page-section">
      <div class="table-container">
        <table id="productsTable">
          <thead>
            <tr>
              <th><input type="checkbox" onclick="toggleAll('productsTable')"></th>
              <th>PRODUCT ID</th>
              <th>NAME</th>
              <th>MATERIAL</th>
              <th>PRICE</th>
              <th>IMAGE</th>
              <th>AMOUNT</th>
              <th>RATE</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <% 
                ProductDAO productDAO = new ProductDAO();
                List<ProductDTO> productList = productDAO.getAllProducts();
                for (ProductDTO product : productList) { 
            %>
            <tr>
              <td><input type="checkbox"></td>
              <td><%= product.getProductId() %></td>
              <td><%= product.getName() %></td>
              <td><%= product.getMaterial() %></td>
              <td>$<%= product.getPrice() %></td>
              <td><img src="<%= product.getImageUrl() %>" alt="Product Image" width="50"></td>
              <td><%= product.getProductAmount() %></td>
              <td><%= product.getAverageRating() %></td>
              <td>
                <span class="material-icons edit-icon" onclick="editRow(this)">edit</span>
                <span class="material-icons delete-icon" onclick="deleteRow(this)">delete</span>
              </td>
            </tr>
            <% } %>
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
  <script>
    function searchTable() {
      const keyword = document.getElementById('searchInput').value.toLowerCase();
      const rows = document.getElementById('productsTable').querySelectorAll('tbody tr');
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
    function editRow(elem) {
      alert("Edit row (demo).");
    }
    function deleteRow(elem) {
      alert("Delete row (demo).");
    }
  </script>
</body>
</html>
