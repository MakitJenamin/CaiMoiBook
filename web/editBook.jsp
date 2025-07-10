<%-- 
    Document   : editBook
    Created on : Jun 12, 2025, 4:38:26 AM
    Author     : letpl
--%>

<%@page import="dto.Book"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    if (!"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String userName = (String) session.getAttribute("userName");
    Book book = (Book) request.getAttribute("book");
    if (book == null) {
        response.sendRedirect("MainController?action=manage");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chỉnh sửa sách</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styleindex.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8f9fa;
        }
        .container {
            padding-top: 100px;
            padding-bottom: 40px;
            max-width: 800px;
            margin: auto;
        }
        .form-container {
            background-color: #fff;
            padding: 30px 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .form-container h2 {
            text-align: center;
            margin-top: 0;
            margin-bottom: 30px;
        }
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
        }
        .form-group label {
            margin-bottom: 8px;
            font-weight: 500;
        }
        .form-group input,
        .form-group select {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 1rem;
        }
        .full-width {
            grid-column: 1 / -1;
        }
        .form-actions {
            grid-column: 1 / -1;
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
        }
        .form-actions button, .form-actions .cancel-btn {
            padding: 12px 30px;
            border-radius: 5px;
            font-size: 1.1rem;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            border: none;
        }
        .form-actions button {
            background-color: #007bff;
            color: white;
            transition: background-color 0.3s;
        }
        .form-actions button:hover {
            background-color: #0056b3;
        }
        .cancel-btn {
            background-color: #6c757d;
            color: white;
            transition: background-color 0.3s;
        }
        .cancel-btn:hover {
            background-color: #5a6268;
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
        <div class="form-container">
            <h2>✏️ Chỉnh sửa thông tin sách</h2>
            <form action="MainController" method="post" class="form-grid">
                <input type="hidden" name="id" value="<%= book.getId() %>">

                <div class="form-group full-width">
                    <label for="title">Tiêu đề:</label>
                    <input id="title" type="text" name="title" value="<%= book.getTitle() %>" required>
                </div>

                <div class="form-group">
                    <label for="author">Tác giả:</label>
                    <input id="author" type="text" name="author" value="<%= book.getAuthor() %>" required>
                </div>

                <div class="form-group">
                    <label for="isbn">ISBN:</label>
                    <input id="isbn" type="text" name="isbn" value="<%= book.getIsbn() %>" required>
                </div>

                <div class="form-group">
                    <label for="category">Thể loại:</label>
                    <input id="category" type="text" name="category" value="<%= book.getCategory() %>">
                </div>

                <div class="form-group">
                    <label for="publishedYear">Năm xuất bản:</label>
                    <input id="publishedYear" type="number" name="publishedYear" value="<%= book.getPublishedYear() %>" required>
                </div>
                
                <div class="form-group">
                    <label for="totalCopies">Tổng số bản:</label>
                    <input id="totalCopies" type="number" name="totalCopies" value="<%= book.getTotalCopies() %>" required>
                </div>
                
                <div class="form-group">
                    <label for="availableCopies">Số bản hiện còn:</label>
                    <input id="availableCopies" type="number" name="availableCopies" value="<%= book.getAvailableCopies() %>" required>
                </div>
                
                <div class="form-group full-width">
                    <label for="status">Trạng thái:</label>
                    <select id="status" name="status">
                        <option value="Available" <%= "Available".equals(book.getStatus()) ? "selected" : "" %>>Available</option>
                        <option value="Unavailable" <%= "Unavailable".equals(book.getStatus()) ? "selected" : "" %>>Unavailable</option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="submit" name="action" value="updateBook">💾 Cập nhật</button>
                    <a href="MainController?action=manage" class="cancel-btn">↩️ Quay lại</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
