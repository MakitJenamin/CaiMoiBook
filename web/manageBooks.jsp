<%@page import="java.util.List"%>
<%@page import="dto.Book"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    if (!"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String userName = (String) session.getAttribute("userName");
    List<Book> books = (List<Book>) request.getAttribute("bookList");
    String msg = (String) request.getParameter("message");
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quản lý sách</title>
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
            max-width: 1400px;
            margin: auto;
            padding-left: 20px;
            padding-right: 20px;
        }
        .page-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .book-table-container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow-x: auto;
        }
        .book-table {
            width: 100%;
            border-collapse: collapse;
        }
        .book-table th, .book-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #ddd;
            text-align: left;
        }
        .book-table th {
            background-color: #f2f2f2;
            font-weight: 600;
        }
        .book-table tr:hover {
            background-color: #f5f5f5;
        }
        .actions-cell {
            display: flex;
            gap: 10px;
        }
        .actions-cell .edit-btn, .actions-cell .delete-btn {
            padding: 8px 12px;
            border-radius: 5px;
            text-decoration: none;
            color: white;
            font-weight: 500;
            border: none;
            cursor: pointer;
            font-size: 0.9rem;
        }
        .edit-btn {
            background-color: #ffc107;
        }
        .delete-btn {
            background-color: #dc3545;
        }
        .success-message {
            text-align: center;
            padding: 15px;
            margin-bottom: 20px;
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
            border-radius: 5px;
        }
        .no-books {
            text-align: center;
            padding: 50px;
            font-size: 1.2rem;
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
            <h1>📘 Quản lý Sách</h1>
        </div>
        <% if (msg != null) { %>
            <div class="success-message"><%= msg %></div>
        <% } %>
        <div class="book-table-container">
            <% if (books != null && !books.isEmpty()) { %>
            <table class="book-table">
                <thead>
                    <tr>
                        <th>Tiêu đề</th>
                        <th>Tác giả</th>
                        <th>ISBN</th>
                        <th>Thể loại</th>
                        <th>Số lượng</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Book b : books) { %>
                    <tr>
                        <td><%= b.getTitle() %></td>
                        <td><%= b.getAuthor() %></td>
                        <td><%= b.getIsbn() %></td>
                        <td><%= b.getCategory() %></td>
                        <td><%= b.getAvailableCopies() %> / <%= b.getTotalCopies() %></td>
                        <td><%= b.getStatus() %></td>
                        <td class="actions-cell">
                            <a href="MainController?action=edit&id=<%= b.getId() %>" class="edit-btn">✏️ Sửa</a>
                            <form action="MainController" method="post" onsubmit="return confirm('Bạn chắc chắn muốn xoá sách này?');" style="margin:0;">
                                <input type="hidden" name="id" value="<%= b.getId() %>">
                                <button type="submit" name="action" value="deleteBook" class="delete-btn">🗑️ Xoá</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
                <div class="no-books">
                    <p>Chưa có sách nào trong thư viện.</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
