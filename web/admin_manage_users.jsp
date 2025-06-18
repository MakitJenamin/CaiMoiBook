<%-- 
    Document   : admin_manage_users
    Created on : Jun 11, 2025, 12:55:11 PM
    Author     : letpl
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="dto.User" %>
<%
    User user = (User) request.getAttribute("searchedUser");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Borrow History</title>
    <link rel="stylesheet" href="css/admin_usersmanage.css">

</head>
<body>
            <a href="index.jsp">Home</a>
    <h2>🔍 Quản lý tài khoản người dùng</h2>
<div class="search-container">
    <form method="get" action="AdminUserManageController">
        <label>Nhập email người dùng: </label>
        <input type="text" name="email" required />
        <button type="submit">Tìm kiếm</button>
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

        <form method="post" action="AdminUserManageController">
            <input type="hidden" name="userId" value="<%= user.getId() %>" />
            <input type="hidden" name="email" value="<%= user.getEmail() %>" />
            <input type="hidden" name="status" value="<%= user.getStatus().equals("active") ? "inactive" : "active" %>" />
            <button type="submit">
                <%= user.getStatus().equals("active") ? "❌ Vô hiệu hóa tài khoản" : "✅ Kích hoạt tài khoản" %>
            </button>
        </form>
    </div>
<% } %>
    </body>
</html>