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
    <style>
        .message {
            text-align: center;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 5px;
            font-size: 0.9rem;
        }
        .success-message {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .form-group.error input {
            border-color: #dc3545;
        }
        .form-group.error .error-text {
            color: #dc3545;
            font-size: 0.8rem;
            margin-top: 5px;
        }
    </style>
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
            
            <!-- Hiển thị thông báo thành công -->
            <% 
                String successMessage = (String) request.getAttribute("successMessage");
                if (successMessage != null) {
            %>
                <div class="message success-message">
                    <%= successMessage %>
                </div>
            <%
                }
            %>
            
            <!-- Hiển thị thông báo lỗi -->
            <% 
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
            %>
                <div class="message error-message">
                    <%= errorMessage %>
                </div>
            <%
                }
            %>
            
            <form class="login-form" action="MainController" method="post" id="registerForm">
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
                    <div class="error-text" id="passwordError"></div>
                </div>
                <div class="form-group">
                    <label for="confirm-password">Confirm Password</label>
                    <input type="password" id="confirm-password" name="confirm-password" required>
                    <div class="error-text" id="confirmPasswordError"></div>
                </div>
                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox" name="terms" id="terms" required>
                        <span>I agree to the <a href="#" class="terms-link">Terms & Conditions</a></span>
                    </label>
                </div>
                <button type="submit" name="action" value="register" class="login-button">Create Account</button>
                <div class="register-link">
                    Already have an account? <a href="login.jsp">Login here</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            let isValid = true;
            
            // Reset error states
            document.querySelectorAll('.form-group').forEach(group => {
                group.classList.remove('error');
            });
            document.querySelectorAll('.error-text').forEach(error => {
                error.textContent = '';
            });
            
            // Validate password length
            const password = document.getElementById('password').value;
            if (password.length < 6) {
                document.getElementById('password').parentElement.classList.add('error');
                document.getElementById('passwordError').textContent = 'Mật khẩu phải có ít nhất 6 ký tự';
                isValid = false;
            }
            
            // Validate password confirmation
            const confirmPassword = document.getElementById('confirm-password').value;
            if (password !== confirmPassword) {
                document.getElementById('confirm-password').parentElement.classList.add('error');
                document.getElementById('confirmPasswordError').textContent = 'Mật khẩu và xác nhận mật khẩu không khớp';
                isValid = false;
            }
            
            // Validate terms checkbox
            const terms = document.getElementById('terms').checked;
            if (!terms) {
                alert('Vui lòng đồng ý với điều khoản và điều kiện');
                isValid = false;
            }
            
            if (!isValid) {
                e.preventDefault();
            }
        });
        
        // Real-time password validation
        document.getElementById('password').addEventListener('input', function() {
            const password = this.value;
            const errorElement = document.getElementById('passwordError');
            
            if (password.length > 0 && password.length < 6) {
                this.parentElement.classList.add('error');
                errorElement.textContent = 'Mật khẩu phải có ít nhất 6 ký tự';
            } else {
                this.parentElement.classList.remove('error');
                errorElement.textContent = '';
            }
        });
        
        // Real-time confirm password validation
        document.getElementById('confirm-password').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            const errorElement = document.getElementById('confirmPasswordError');
            
            if (confirmPassword.length > 0 && password !== confirmPassword) {
                this.parentElement.classList.add('error');
                errorElement.textContent = 'Mật khẩu và xác nhận mật khẩu không khớp';
            } else {
                this.parentElement.classList.remove('error');
                errorElement.textContent = '';
            }
        });
    </script>
</body>
</html> 