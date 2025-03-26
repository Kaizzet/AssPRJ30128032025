<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styles.css?v=1">
</head>
<body class="login-page">
    <div class="login-container">
        <h2>Đăng nhập</h2>

        <h5 style="color: red">${requestScope.ERROR}</h5>

        <form action="MainController" method="post">
            <input type="hidden" name="action" value="login">
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Mật khẩu" required>
            <a href="javascript:void(0)"  class="forgot-password">Quên mật khẩu?</a>
            <button type="submit" class="login-button">Đăng nhập</button>
        </form>

        <a href="register.jsp" class="register-link">Tạo tài khoản</a>
        <a href="MainController?action=loadProducts&page=1" class="register-link">Quay lại cửa hàng</a>
    </div>
</body>
</html>
