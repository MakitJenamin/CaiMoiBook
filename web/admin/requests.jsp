<%-- 
    Document   : requests
    Created on : May 31, 2025, 2:41:33 PM
    Author     : letpl
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="dto.RequestDTO" %>
<%@ page import="java.util.ArrayList" %>
<%
    String role = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    List<RequestDTO> requests = (List<RequestDTO>) request.getAttribute("requests");
    if (requests == null) {
        requests = new ArrayList<>();
    }
    
    // Lấy thông báo thành công/lỗi (nếu có)
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quản lý Yêu cầu Mượn Sách</title>
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
        .admin-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .admin-table th, .admin-table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        .admin-table th {
            background-color: #f2f2f2;
            font-weight: 600;
        }
        .admin-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .admin-table tr:hover {
            background-color: #f1f1f1;
        }
        .btn-action {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            color: white;
            font-weight: 500;
            margin-right: 5px;
        }
        .btn-approve { background-color: #28a745; }
        .btn-approve:hover { background-color: #218838; }
        .btn-reject { background-color: #dc3545; }
        .btn-reject:hover { background-color: #c82333; }
        .btn-confirm { background-color: #007bff; }
        .btn-confirm:hover { background-color: #0069d9; }
        .status-tag {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 0.85em;
            font-weight: 500;
            margin-right: 8px;
        }
        .status-pending {
            background-color: #ffc107;
            color: #212529;
        }
        .status-approved {
            background-color: #28a745;
            color: white;
        }
        .status-completed {
            background-color: #007bff;
            color: white;
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
        <h2 style="text-align: center;">📋 Quản lý Yêu cầu Mượn Sách</h2>
        
        <% if (successMessage != null) { %>
            <div class="alert alert-success"><%= successMessage %></div>
        <% } %>
        <% if (errorMessage != null) { %>
            <div class="alert alert-danger"><%= errorMessage %></div>
        <% } %>
        
        <% if (requests.isEmpty()) { %>
            <p style="text-align: center;">Không có yêu cầu nào đang chờ xử lý.</p>
        <% } else { %>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Người mượn</th>
                        <th>Sách</th>
                        <th>Ngày yêu cầu</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(RequestDTO r : requests) { %>
                        <tr>
                            <td><%= r.getUserName() %></td>
                            <td><%= r.getBookTitle() %></td>
                            <td><%= r.getRequestDate() %></td>
                            <td>
                                <% if ("pending".equals(r.getStatus())) { %>
                                    <span class="status-tag status-pending">Chờ duyệt</span>
                                <% } else if ("approved".equals(r.getStatus())) { %>
                                    <span class="status-tag status-approved">Đã duyệt</span>
                                <% } else if ("completed".equals(r.getStatus())) { %>
                                    <span class="status-tag status-completed">Đã mượn</span>
                                <% } %>
                            </td>
                            <td>
                                <% if ("pending".equals(r.getStatus())) { %>
                                    <form action="<%= request.getContextPath() %>/MainController" method="post" style="display: inline-block; margin: 0;">
                                        <input type="hidden" name="requestId" value="<%= r.getRequestId() %>">
                                        <input type="hidden" name="action" value="handle">
                                        <input type="hidden" name="handleAction" value="approve">
                                        <button type="submit" class="btn-action btn-approve">Chấp nhận</button>
                                    </form>
                                    <form action="<%= request.getContextPath() %>/MainController" method="post" style="display: inline-block; margin: 0;">
                                        <input type="hidden" name="requestId" value="<%= r.getRequestId() %>">
                                        <input type="hidden" name="action" value="handle">
                                        <input type="hidden" name="handleAction" value="reject">
                                        <button type="submit" class="btn-action btn-reject">Từ chối</button>
                                    </form>
                                <% } else if ("approved".equals(r.getStatus())) { %>
                                    <form action="<%= request.getContextPath() %>/MainController" method="post" style="display: inline-block; margin: 0;">
                                        <input type="hidden" name="requestId" value="<%= r.getRequestId() %>">
                                        <input type="hidden" name="action" value="confirmBorrow">
                                        <button type="submit" class="btn-action btn-confirm">Xác nhận mượn</button>
                                    </form>
                                <% } else if ("completed".equals(r.getStatus())) { %>
                                    <!-- Không hiển thị nút hành động cho yêu cầu đã mượn -->
                                <% } %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</body>
</html>
