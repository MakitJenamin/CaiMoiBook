<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="css/styleindex.css">
    <link rel="stylesheet" href="css/login.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <div class="login-header">
                <div class="logo-container">
                    <img src="images/simple-book-line-icon-stroke-260nw-1687315123.jpg" alt="Logo" class="logo">
                    <h1 class="titleName">Online Library</h1>
                </div>
                <h2>Login</h2>
                <p>Welcome to online library!</p>
            </div>
            <form class="login-form" action="MainController" method="post">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="text" id="email" name="txtemail" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="txtpassword" required>
                </div>
                <% 
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    if (errorMessage != null) {
                %>
                    <p style="color:red; text-align: center; margin-bottom: 10px;"><%= errorMessage %></p>
                <%
                    }
                %>
                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox" name="remember">
                        <span>Remember me</span>
                    </label>
                    <a href="#" class="forgot-password">Forgot password?</a>
                </div>
                <button type="submit" name = "action" value="login" class="login-button">Login</button>
                <div class="register-link">
                    Don't have an account? <a href="register.jsp">Sign up now</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html> 