<%@page import="java.util.List"%>
<%@page import="dto.Configuration"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");
    List<Configuration> configList = (List<Configuration>) request.getAttribute("configList");
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Cấu hình hệ thống</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styleindex.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8f9fa; }
        .container { padding-top: 100px; padding-bottom: 40px; max-width: 900px; margin: auto; }
        .page-header { text-align: center; margin-bottom: 30px; }
        .config-form-container { background-color: #fff; padding: 30px 40px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .config-item { display: grid; grid-template-columns: 1fr 2fr; align-items: center; gap: 20px; padding: 15px 0; border-bottom: 1px solid #eee; }
        .config-item:last-child { border-bottom: none; }
        .config-label label { font-weight: 600; }
        .config-label p { font-size: 0.9rem; color: #666; margin: 5px 0 0; }
        .config-input input { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; }
        .form-actions { text-align: center; margin-top: 30px; }
        .form-actions button { padding: 12px 40px; background-color: #007bff; color: white; border: none; border-radius: 5px; font-size: 1.1rem; font-weight: bold; cursor: pointer; transition: background-color 0.3s; }
        .form-actions button:hover { background-color: #0056b3; }
        .message, .error { text-align: center; padding: 15px; margin: 0 auto 20px auto; border-radius: 5px; max-width: 820px; }
        .message { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .admin-tools { margin-top: 30px; background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .admin-tools h2 { margin-top: 0; color: #333; }
        .admin-tools ul { padding-left: 20px; }
        .admin-tools li { margin-bottom: 10px; }
        .admin-tools a { color: #007bff; text-decoration: none; font-weight: 500; }
        .admin-tools a:hover { text-decoration: underline; }
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
        <div class="page-header">
            <h1>Cấu hình hệ thống</h1>
        </div>
        <% if (message != null) { %><div class="message"><%= message %></div><% } %>
        <% if (error != null) { %><div class="error"><%= error %></div><% } %>
        <div class="config-form-container">
            <form action="MainController" method="post">
                <% if (configList != null && !configList.isEmpty()) {
                    for (Configuration conf : configList) { %>
                        <div class="config-item">
                            <div class="config-label">
                                <label for="<%= conf.getConfigKey() %>"><%= conf.getConfigKey().replace("_", " ") %></label>
                                <p><%= conf.getDescription() %></p>
                            </div>
                            <div class="config-input">
                                <input type="text" id="<%= conf.getConfigKey() %>" name="<%= conf.getConfigKey() %>" value="<%= conf.getConfigValue() %>">
                            </div>
                        </div>
                <%  }
                } %>
                <div class="form-actions">
                    <button type="submit" name="action" value="adminConfig" >Lưu thay đổi</button>
                </div>
            </form>
        </div>
        
        <!-- Admin Tools Section -->
        <% if ("admin".equals(role)) { %>
        <div class="admin-tools">
            <h2>Admin Tools</h2>
            <ul>
                <li><a href="<%= request.getContextPath() %>/admin/migratePasswords">Migrate Passwords</a> - Convert plain text passwords to secure hashed passwords</li>
            </ul>
        </div>
        <% } %>
    </div>
</body>
</html> 