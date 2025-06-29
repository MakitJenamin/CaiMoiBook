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
    if (!"admin".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }
    String userName = (String) session.getAttribute("userName");
    List<RequestDTO> requests = (List<RequestDTO>) request.getAttribute("requests");
    if (requests == null) {
        requests = new ArrayList<>();
    }
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
        }
        .btn-approve { background-color: #28a745; }
        .btn-approve:hover { background-color: #218838; }
        .btn-reject { background-color: #dc3545; }
        .btn-reject:hover { background-color: #c82333; }
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
            <a href="<%= request.getContextPath() %>/SearchBooks" class="item-header">Browse</a>
            <a href="#" class="item-header">Categories</a>
            <a href="#" class="item-header">About</a>
            <a href="#" class="item-header">Contact</a>
            <% if ("admin".equals(role)) { %>
                <a href="<%= request.getContextPath() %>/admin/panel.jsp" class="item-header">Admin Panel</a>
            <% } %>
        </div>
        <div class="function-header">
            <form id="headerSearchForm" action="<%= request.getContextPath() %>/SearchBooks" method="get" style="display: flex; align-items: center;">
                <input type="search" name="title" class="form-search" placeholder="Search for books...">
                <i class="fa-solid fa-magnifying-glass search-icon" onclick="document.getElementById('headerSearchForm').submit();" style="cursor: pointer;"></i>
            </form>
            <% if(userName != null){ %>
                <button class="sign-in" onclick="window.location.href='<%= request.getContextPath() %>/index.jsp'"><%= "🕴" + userName%></button>
                <button class="regis-ter" onclick="window.location.href='<%= request.getContextPath() %>/LogoutController'">🚪 Logout</button>
            <% } else { %>
                <button class="sign-in" onclick="window.location.href='<%= request.getContextPath() %>/login.jsp'">Sign in</button>
                <button class="regis-ter" onclick="window.location.href='<%= request.getContextPath() %>/register.jsp'">Register</button>
            <% } %>
            <a href="<%= request.getContextPath() %>/search.jsp" class="join">Join Library</a>
        </div>
    </div>

    <div class="container">
        <h2 style="text-align: center;">📋 Quản lý Yêu cầu Mượn Sách</h2>
        <% if (requests.isEmpty()) { %>
            <p style="text-align: center;">Không có yêu cầu nào đang chờ xử lý.</p>
        <% } else { %>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Người mượn</th>
                        <th>Sách</th>
                        <th>Ngày yêu cầu</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(RequestDTO r : requests) { %>
                        <tr>
                            <td><%= r.getUserName() %></td>
                            <td><%= r.getBookTitle() %></td>
                            <td><%= r.getRequestDate() %></td>
                            <td style="display: flex; gap: 8px;">
                                <form action="<%= request.getContextPath() %>/HandleRequestController" method="post" style="margin: 0;">
                                    <input type="hidden" name="requestId" value="<%= r.getRequestId() %>">
                                    <input type="hidden" name="action" value="approve">
                                    <button type="submit" class="btn-action btn-approve">Chấp nhận</button>
                                </form>
                                <form action="<%= request.getContextPath() %>/HandleRequestController" method="post" style="margin: 0;">
                                    <input type="hidden" name="requestId" value="<%= r.getRequestId() %>">
                                    <input type="hidden" name="action" value="reject">
                                    <button type="submit" class="btn-action btn-reject">Từ chối</button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</body>
</html>
