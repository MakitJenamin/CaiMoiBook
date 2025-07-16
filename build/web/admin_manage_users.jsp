<%-- 
    Document   : admin_manage_users
    Created on : Jun 11, 2025, 12:55:11 PM
    Author     : letpl
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="dto.User" %>
<%
    User user = (User) request.getAttribute("searchedUser");
    String role = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quản lý người dùng</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styleindex.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8f9fa;
        }
        .container {
            padding-top: 100px;
            padding-bottom: 20px;
            max-width: 800px;
            margin: auto;
        }
        .search-container {
            background-color: #fff;
            padding: 20px 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .search-container form {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .search-container label {
            font-weight: 500;
        }
        .search-container input[type="text"] {
            flex-grow: 1;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .search-container button {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .search-container button:hover {
            background-color: #0056b3;
        }
        .user-card {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .user-card h3 {
            margin-top: 0;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
            margin-bottom: 20px;
        }
        .user-card p {
            margin: 10px 0;
            font-size: 1.1rem;
        }
        .user-card .status {
            font-weight: bold;
        }
        .user-card .status.active {
            color: #28a745;
        }
        .user-card .status.inactive {
            color: #dc3545;
        }
        .user-card form {
            margin-top: 25px;
        }
        .user-card button {
            padding: 12px 25px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-weight: bold;
            transition: opacity 0.3s;
        }
        .user-card button:hover {
            opacity: 0.8;
        }
        .user-card button.activate {
             background-color: #28a745;
             color: white;
        }
        .user-card button.deactivate {
            background-color: #dc3545;
            color: white;
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
            <a href="<%= request.getContextPath() %>/MainController?action=home" class="item-header">Home</a>
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
                <i class="fa-solid fa-magnifying-glass search-icon" onclick="document.getElementById('headerSearchForm').submit();" style="cursor: pointer;"></i>
                <input type="hidden" name="action" value="search">
            </form>
            <% if(userName != null){ %>
                <button class="sign-in" onclick="window.location.href='<%= request.getContextPath() %>/MainController?action=profile'"><%= "🕴" + userName%></button>
                <button class="regis-ter" onclick="window.location.href='<%= request.getContextPath() %>/MainController?action=logout'">🚪 Logout</button>
            <% } else { %>
                <button class="sign-in" onclick="window.location.href='<%= request.getContextPath() %>/login.jsp'">Sign in</button>
                <button class="regis-ter" onclick="window.location.href='<%= request.getContextPath() %>/register.jsp'">Register</button>
            <% } %>
            <a href="<%= request.getContextPath() %>/search.jsp" class="join">Join Library</a>
        </div>
    </div>

    <div class="container">
        <h2 style="text-align: center; margin-bottom: 20px;">🔍 Quản lý tài khoản người dùng</h2>
        <div class="search-container">
            <form method="get" action="MainController">
                <label for="email-search">Nhập email người dùng:</label>
                <input id="email-search" type="text" name="email" required value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"/>
                <button type="submit" name="action" value="adminManage">Tìm kiếm</button>
                <input type="hidden" name="action" value="adminManage">
            </form>
        </div>

        <% if (user != null) { %>
            <div class="user-card">
                <h3>👤 <%= user.getName()%></h3>
                <p><strong>Email:</strong> <%= user.getEmail() %></p>
                <p><strong>Vai trò:</strong> <%= user.getRole() %></p>
                <p>
                    <strong>Trạng thái:</strong>
                    <span class="status <%= user.getStatus() %>">
                        <%= user.getStatus().equals("active") ? "Đang hoạt động" : "Đã vô hiệu hóa" %>
                    </span>
                </p>

                <form method="post" action="MainController">
                    <input type="hidden" name="userId" value="<%= user.getId() %>" />
                    <input type="hidden" name="email" value="<%= user.getEmail() %>" />
                    <% if (user.getStatus().equals("active")) { %>
                        <input type="hidden" name="status" value="inactive" />
                        <button type="submit" class="deactivate">❌ Vô hiệu hóa tài khoản</button>
                    <% } else { %>
                        <input type="hidden" name="status" value="active" />
                        <button type="submit" class="activate">✅ Kích hoạt tài khoản</button>
                    <% } %>
                    <input type="hidden" name="action" value="adminManage">
                </form>
            </div>
        <% } else if (request.getParameter("email") != null) { %>
            <div class="user-card" style="text-align: center;">
                <p>Không tìm thấy người dùng với email cung cấp.</p>
            </div>
        <% } %>
    </div>
</body>
</html>