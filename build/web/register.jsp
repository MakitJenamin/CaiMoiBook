<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register</title>
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
                <h2>Create Account</h2>
                <p>Join our online library community!</p>
            </div>
            <form class="login-form" action="MainController" method="post">
                <div class="form-group">
                    <label for="fullname">Full Name</label>
                    <input type="text" id="fullname" name="fullname" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="txtemail" required>
                </div>
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="txtname" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="txtpassword" required>
                </div>
                <div class="form-group">
                    <label for="confirm-password">Confirm Password</label>
                    <input type="password" id="confirm-password" name="confirm-password" required>
                </div>
                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox" name="terms" required>
                        <span>I agree to the <a href="#" class="terms-link">Terms & Conditions</a></span>
                    </label>
                </div>
                <button type="submit" name = "action" value = "register" class="login-button">Create Account</button>
                <div class="register-link">
                    Already have an account? <a href="login.jsp">Login here</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html> 