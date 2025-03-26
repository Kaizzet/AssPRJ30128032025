<%@ page import="java.util.List" %>
<%@ page import="Users.UserDAO" %>
<%@ page import="Users.UserDTO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Users Admin</title>
  <link rel="stylesheet" href="<%= request.getContextPath()%>/css/admin.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
</head>
<body>
  <nav class="navbar">
    <div class="nav-left">
      <h2 class="logo">HELIOS</h2>
      <ul class="nav-menu">
        <li><a href="Homepageadmin.jsp">Home</a></li>
        <li><a href="Ordersadmin.jsp">Orders</a></li>
        <li><a href="Productsadmin.jsp">Products</a></li>
        <li><a href="Usersadmin.jsp" class="active">Users</a></li>
      </ul>
    </div>
    <div class="nav-right">
      <img src="../images/avatar.png" alt="Avatar" class="avatar">
    </div>
  </nav>
  <div class="sub-header">
    <h1>Users</h1>
    <input type="text" id="searchInput" class="search-box" placeholder="Search users..." onkeyup="searchTable()">
  </div>
  <div class="content">
    <section class="page-section">
      <div class="table-container">
        <table id="usersTable">
          <thead>
            <tr>
              <th><input type="checkbox" onclick="toggleAll('usersTable')"></th>
              <th>USER ID</th>
              <th>NAME</th>
              <th>EMAIL</th>
              <th>PHONE</th>
              <th>ADDRESS</th>
              <th>CREATED_AT</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <% 
                UserDAO userDAO = new UserDAO();
                List<UserDTO> userList = userDAO.getAllUsers();
                for (UserDTO user : userList) { 
            %>
            <tr id="userRow-<%= user.getUserId() %>">
  <td><input type="checkbox"></td>
  <td><%= user.getUserId() %></td>
  <td><%= user.getName() %></td>
  <td><%= user.getEmail() %></td>
  <td><%= user.getPhone() %></td>
  <td><%= user.getAddress() %></td>
  <td><%= user.getCreatedAt() %></td>
  <td>
    <span class="material-icons edit-icon" onclick="editRow(this)">edit</span>
    <span class="material-icons delete-icon" onclick="confirmDelete(<%= user.getUserId() %>)">delete</span>
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
      const rows = document.getElementById('usersTable').querySelectorAll('tbody tr');
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
    function confirmDelete(userId) {
    if (confirm("Bạn có chắc chắn muốn xóa người dùng này không?")) {
        fetch("MainController?action=deleteUser&userId=" + userId, {
            method: "GET"
        })
        .then(response => response.json()) 
        .then(data => {
            if (data.status === "success") {
                // Xóa hàng tương ứng trên giao diện
                document.getElementById("userRow-" + userId).remove();
            } else {
                alert("Xóa thất bại: " + data.message);
            }
        })
        .catch(error => console.error("Lỗi khi gửi yêu cầu xóa:", error));
    }
}

  </script>
</body>
</html>
