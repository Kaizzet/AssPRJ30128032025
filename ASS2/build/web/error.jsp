<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
<head>
    <title>Lỗi</title>
</head>
<body>
    <h2 style="color:red;">Lỗi xảy ra</h2>
    <p><%= request.getAttribute("error") %></p>
    <a href="Main.jsp">Quay lại trang chủ</a>
</body>
</html>
