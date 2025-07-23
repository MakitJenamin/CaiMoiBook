<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.User"%>
<%
    User user = (User) request.getAttribute("user");
    String userName = (String) session.getAttribute("userName");
    String role = (String) session.getAttribute("role");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    
    // Redirect to login if not logged in
    if (user == null || userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thông tin cá nhân - <%= userName %></title>
    <link rel="stylesheet" href="css/styleindex.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: #f8f9fa; 
            margin: 0; 
            padding: 0; 
        }
        .profile-container {
            max-width: 1000px;
            margin: 100px auto 20px auto; /* Increased top margin from 20px to 100px */
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .profile-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        .profile-header h1 {
            color: #333;
            margin-bottom: 10px;
        }
        .profile-header p {
            color: #666;
            margin: 0;
        }
        .profile-content {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        .profile-section {
            flex: 1;
            min-width: 300px;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .profile-section h2 {
            color: #333;
            font-size: 1.3rem;
            margin-top: 0;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #ddd;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
            color: #555;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            text-align: center;
            text-decoration: none;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #0069d9;
        }
        .btn-danger {
            background-color: #dc3545;
        }
        .btn-danger:hover {
            background-color: #c82333;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .user-info {
            margin-bottom: 20px;
        }
        .user-info .info-item {
            display: flex;
            margin-bottom: 10px;
        }
        .user-info .info-label {
            font-weight: 600;
            width: 150px;
            color: #555;
        }
        .user-info .info-value {
            flex: 1;
            color: #333;
        }
        .nav-tabs {
            display: flex;
            border-bottom: 1px solid #ddd;
            margin-bottom: 20px;
        }
        .nav-tabs .tab {
            padding: 10px 20px;
            cursor: pointer;
            border: 1px solid transparent;
            border-bottom: none;
            border-radius: 4px 4px 0 0;
            background-color: #f8f9fa;
            margin-right: 5px;
            color: #495057;
        }
        .nav-tabs .tab.active {
            background-color: white;
            border-color: #ddd;
            color: #007bff;
            font-weight: 500;
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="header-logo">
            <img src="images/simple-book-line-icon-stroke-260nw-1687315123.jpg" alt="LibraryOnline Logo" class="logo">
            <span class="titleName">LibraryOnline</span>
        </div>
        <div class="nav-header">
            <a href="MainController?action=home" class="item-header">Home</a>
            <a href="MainController?action=search" class="item-header">Browse</a>
            <a href="#" class="item-header">Categories</a>
            <a href="#" class="item-header">About</a>
            <a href="#" class="item-header">Contact</a>
            <% if ("admin".equals(role)) { %>
                <a href="admin/panel.jsp" class="item-header">Admin Panel</a>
            <% } %>
        </div>
        <div class="function-header">
            <form id="headerSearchForm" action="MainController" method="get" style="display: flex; align-items: center;">
                <input type="search" name="title" class="form-search" placeholder="Search for books...">
                <input type="hidden" name="action" value="search">
                <i class="fa-solid fa-magnifying-glass search-icon" onclick="document.getElementById('headerSearchForm').submit();" style="cursor: pointer;"></i>
            </form>
            <% if(userName != null){ %>
                <button class="sign-in" onclick="window.location.href='MainController?action=profile'"><%= "🕴" + userName%></button>
                <button class="regis-ter" onclick="window.location.href='MainController?action=logout'">🚪 Logout</button>
            <% } else { %>
                <button class="sign-in" onclick="window.location.href='login.jsp'">Sign in</button>
                <button class="regis-ter" onclick="window.location.href='register.jsp'">Register</button>
            <% } %>
            <a href="search.jsp" class="join">Join Library</a>
        </div>
    </div>

    <!-- Profile Content -->
    <div class="profile-container">
        <div class="profile-header">
            <h1>Thông tin cá nhân</h1>
            <p>Quản lý thông tin cá nhân và bảo mật tài khoản</p>
        </div>
        
        <!-- Messages -->
        <% if (successMessage != null) { %>
            <div class="alert alert-success">
                <%= successMessage %>
            </div>
        <% } %>
        <% if (errorMessage != null) { %>
            <div class="alert alert-danger">
                <%= errorMessage %>
            </div>
        <% } %>
        
        <!-- Tab Navigation -->
        <div class="nav-tabs">
            <div class="tab active" data-tab="info">Thông tin cá nhân</div>
            <div class="tab" data-tab="password">Đổi mật khẩu</div>
            <div class="tab" data-tab="history">Lịch sử mượn sách</div>
        </div>
        
        <div class="profile-content">
            <!-- Tab 1: User Info -->
            <div class="tab-content active" id="info-tab">
                <div class="profile-section">
                    <h2>Thông tin cơ bản</h2>
                    <div class="user-info">
                        <div class="info-item">
                            <div class="info-label">Họ và tên:</div>
                            <div class="info-value"><%= user.getName() %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Email:</div>
                            <div class="info-value"><%= user.getEmail() %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Vai trò:</div>
                            <div class="info-value"><%= user.getRole() %></div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Trạng thái:</div>
                            <div class="info-value"><%= user.getStatus() %></div>
                        </div>
                    </div>
                </div>
                
                <div class="profile-section">
                    <h2>Cập nhật thông tin</h2>
                    <form action="MainController" method="post">
                        <input type="hidden" name="action" value="updateProfile">
                        <div class="form-group">
                            <label for="name">Họ và tên:</label>
                            <input type="text" id="name" name="name" value="<%= user.getName() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email:</label>
                            <input type="email" id="email" name="email" value="<%= user.getEmail() %>" readonly>
                        </div>
                        <button type="submit" class="btn" name="action" value="profile">Cập nhật thông tin</button>
                    </form>
                </div>
            </div>
            
            <!-- Tab 2: Change Password -->
            <div class="tab-content" id="password-tab">
                <div class="profile-section">
                    <h2>Đổi mật khẩu</h2>
                    <form action="MainController" method="post" id="passwordForm">
                        <input type="hidden" name="action" value="changePassword">
                        <div class="form-group">
                            <label for="currentPassword">Mật khẩu hiện tại:</label>
                            <input type="password" id="currentPassword" name="currentPassword" required>
                        </div>
                        <div class="form-group">
                            <label for="newPassword">Mật khẩu mới:</label>
                            <input type="password" id="newPassword" name="newPassword" required>
                        </div>
                        <div class="form-group">
                            <label for="confirmPassword">Xác nhận mật khẩu mới:</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" required>
                        </div>
                        <div id="passwordError" class="alert alert-danger" style="display: none;"></div>
                        <button type="submit" class="btn" name="action" value="changePassword">Đổi mật khẩu</button>
                    </form>
                </div>
            </div>
            
            <!-- Tab 3: Borrow History -->
            <div class="tab-content" id="history-tab">
                <div class="profile-section" style="width: 100%;">
                    <h2>Lịch sử mượn sách</h2>
                    <p>Xem lịch sử mượn sách chi tiết tại <a href="MainController?action=history" style="color: #007bff; text-decoration: none;">trang lịch sử mượn sách</a>.</p>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Tab switching
        document.querySelectorAll('.tab').forEach(tab => {
            tab.addEventListener('click', function() {
                // Remove active class from all tabs
                document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
                document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
                
                // Add active class to clicked tab
                this.classList.add('active');
                
                // Show corresponding content
                const tabId = this.getAttribute('data-tab');
                document.getElementById(tabId + '-tab').classList.add('active');
            });
        });
        
        // Password validation
        const passwordForm = document.getElementById('passwordForm');
        const newPassword = document.getElementById('newPassword');
        const confirmPassword = document.getElementById('confirmPassword');
        const passwordError = document.getElementById('passwordError');
        
        passwordForm.addEventListener('submit', function(e) {
            // Reset error
            passwordError.style.display = 'none';
            
            // Check password length
            if (newPassword.value.length < 6) {
                e.preventDefault();
                passwordError.textContent = 'Mật khẩu mới phải có ít nhất 6 ký tự.';
                passwordError.style.display = 'block';
                return;
            }
            
            // Check if passwords match
            if (newPassword.value !== confirmPassword.value) {
                e.preventDefault();
                passwordError.textContent = 'Xác nhận mật khẩu không khớp với mật khẩu mới.';
                passwordError.style.display = 'block';
            }
        });
    </script>
</body>
</html> 