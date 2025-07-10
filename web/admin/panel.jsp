<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="dto.RequestDTO" %>
<%@ page import="java.util.ArrayList" %>
<%
    String role = (String) session.getAttribute("role");
    if (!"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String userName = (String) session.getAttribute("userName");
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Admin Panel</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styleindex.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .container {
            padding-top: 100px;
            padding-left: 20px;
            padding-right: 20px;
            padding-bottom: 20px;
            max-width: 1200px;
            margin: auto;
        }
        .panel-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .panel-card {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            transition: box-shadow 0.3s, transform 0.3s;
            text-decoration: none;
            color: #333;
        }
        .panel-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .panel-card h3 {
            margin-top: 0;
            font-size: 1.2rem;
        }
        .panel-card p {
            font-size: 0.9rem;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-logo">
            <img src="<%= request.getContextPath() %>/images/simple-book-line-icon-stroke-260nw-1687315123.jpg" alt="LibraryOnline Logo" class="logo">
            <span class="titleName">LibraryOnline</span>
        </div>
        <div class="nav-header">
            <a href="<%= request.getContextPath() %>/index.jsp" class="item-header">Home</a>
            <a href="<%= request.getContextPath() %>/MainController?action=search" class="item-header">Browse</a>
            <a href="#" class="item-header">Categories</a>
            <a href="#" class="item-header">About</a>
            <a href="#" class="item-header">Contact</a>
            <% if ("admin".equals(role)) { %>
                <a href="<%= request.getContextPath() %>/admin/panel.jsp" class="item-header">Admin Panel</a>
            <% } %>
        </div>
        <div class="function-header">
             <form id="headerSearchForm" action="<%= request.getContextPath() %>/MainController" method="get" style="display: flex; align-items: center;">
                <input type="search" name="title" class="form-search" placeholder="Search for books...">
                <input type="hidden" name="action" value="search">
                <i class="fa-solid fa-magnifying-glass search-icon" onclick="document.getElementById('headerSearchForm').submit();" style="cursor: pointer;"></i>
            </form>
            <% if(userName != null){ %>
                <button class="sign-in" onclick="window.location.href='<%= request.getContextPath() %>/index.jsp'"><%= "🕴" + userName%></button>
                <button class="regis-ter" onclick="window.location.href='<%= request.getContextPath() %>/MainController?action=logout'">🚪 Logout</button>
            <% } else { %>
                <button class="sign-in" onclick="window.location.href='<%= request.getContextPath() %>/login.jsp'">Sign in</button>
                <button class="regis-ter" onclick="window.location.href='<%= request.getContextPath() %>/register.jsp'">Register</button>
            <% } %>
            <a href="<%= request.getContextPath() %>/search.jsp" class="join">Join Library</a>
        </div>
    </div>

    <div class="container">
        <h2 style="text-align: center;">🛠️ Admin Panel</h2>
        <div class="panel-grid">
            <a href="<%= request.getContextPath() %>/MainController?action=adminRequest" class="panel-card">
                <h3>Xử lý Yêu cầu</h3>
                <p>Chấp nhận hoặc từ chối yêu cầu mượn sách từ người dùng.</p>
            </a>
            <a href="<%= request.getContextPath() %>/MainController?action=adminBorrow" class="panel-card">
                <h3>Lịch sử Mượn/Trả</h3>
                <p>Xem toàn bộ lịch sử mượn và trả sách của tất cả người dùng.</p>
            </a>
            <a href="<%= request.getContextPath() %>/MainController?action=statistics" class="panel-card">
                <h3>Thống kê</h3>
                <p>Xem các số liệu thống kê tổng quan về hoạt động của thư viện.</p>
            </a>
            <a href="<%= request.getContextPath() %>/admin_manage_users.jsp" class="panel-card">
                <h3>Quản lý Người dùng</h3>
                <p>Xem và quản lý tất cả tài khoản người dùng trong hệ thống.</p>
            </a>
            <a href="<%= request.getContextPath() %>/addBook.jsp" class="panel-card">
                <h3>Thêm Sách mới</h3>
                <p>Thêm một đầu sách mới vào thư viện.</p>
            </a>
            <a href="<%= request.getContextPath() %>/MainController?action=manage" class="panel-card">
                <h3>Quản lý Sách</h3>
                <p>Chỉnh sửa hoặc xóa các đầu sách hiện có.</p>
            </a>
            <a href="<%= request.getContextPath() %>/MainController?action=adminConfig" class="panel-card">
                <h3>Cấu hình Hệ thống</h3>
                <p>Chỉnh sửa các tham số và quy định của thư viện.</p>
            </a>
        </div>
    </div>
</body>
</html> 