<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    int currentPage = (request.getAttribute("currentPage") != null) ? (Integer) request.getAttribute("currentPage") : 1;
    int totalPages = (request.getAttribute("totalPages") != null) ? (Integer) request.getAttribute("totalPages") : 1;
    String action = (request.getAttribute("action") != null) ? (String) request.getAttribute("action") : "loadProducts";
    String category = (request.getAttribute("category") != null) ? (String) request.getAttribute("category") : "";
%>

<% if (totalPages > 1) { %>
    <div class="pagination">
        <% if (currentPage > 1) { %>
            <a href="MainController?action=<%= action %>&category=<%= category %>&page=<%= currentPage - 1 %>">Previous</a>
        <% } %>

        <% for (int i = 1; i <= totalPages; i++) { %>
            <a href="MainController?action=<%= action %>&category=<%= category %>&page=<%= i %>" 
               class="<%= (i == currentPage) ? "active" : "" %>"><%= i %></a>
        <% } %>

        <% if (currentPage < totalPages) { %>
            <a href="MainController?action=<%= action %>&category=<%= category %>&page=<%= currentPage + 1 %>">Next</a>
        <% } %>
    </div>
<% } %>
