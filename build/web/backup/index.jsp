<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dto.Book" %>
<%
    if (request.getAttribute("bookList") == null) {
        response.sendRedirect("ShowBooks");
        return;
    }
%>
<% 
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
%>
<%
    List<Book> books = (List<Book>) request.getAttribute("bookList");
    if (books == null) {
        books = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<!--
Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Html.html to edit this template
-->
<html>
    <head>
        <title>Thư viện sách</title>
        <style>
        body {
            font-family: Arial, sans-serif;
        }
        .book-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            padding: 20px;
        }
        .book-card {
            border: 1px solid #ccc;
            border-radius: 8px;
            width: 220px;
            padding: 10px;
            box-shadow: 2px 2px 5px rgba(0,0,0,0.1);
            transition: transform 0.2s ease;
        }
        .book-card:hover {
            transform: scale(1.03);
        }
        .book-image {
            background: #eee;
            height: 150px;
            margin-bottom: 10px;
            border-radius: 4px;
        }
        .book-title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .book-author {
            font-size: 14px;
            color: #555;
        }
        .book-date {
            font-size: 13px;
            color: #888;
        }
    </style>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body>
    <div style="background:#999661; height:50px;padding: 20px; " >
    <a href="index.jsp">home</a>|<a href="Login.html">Login</a>
    <form action="SearchBooks" style="float:right" method="get">
            <input type="text" name="txtsearch" />
            <input type="submit" value="find"/>
    </form>
    </div>    
    <div style="float:left; width: 70%;">coming soon</div>   
    <% if ("admin".equals(role)) { %>
    <div style="margin: 10px 0;">
        <a href="AdminRequestController" style="color: red; font-weight: bold;">
            🔧 Xử lý yêu cầu mượn sách
        </a>
    </div>
<% } %>

    <div style="float:left; width: 30%; background: #ffffcc;">       
        <form action="RegisterController" style=" padding: 5%" method="post">
            <p>name:<input type="text" name="txtname" required>*</p>
            <p>email<input type="text" name="txtemail" required>*</p>
            <p>password:<input type="password" name="txtpassword" required>*</p>
            <p>confirm password:<input type="password" name="txtconfirmpassword" required>*</p>
            <p><input type="submit" name="btn" value="submit"></p>
        </form>
      </div>
    
    <h2 style="text-align:center;">📚 Danh sách sách</h2>
    <div class="book-grid">
    <% for(Book b : books) { %>
        <div class="book-card">
            <div class="book-image">
                <!-- chỗ này có thể đặt ảnh minh hoạ -->
            </div>
            <div class="book-title"><%= b.getTitle() %></div>
                <div class="book-author">👤 <%= b.getAuthor() %></div>
            <div class="book-date">📅 <%= b.getPublishedYear() %></div>
                        <div class="book-date">Số Lượng Có Thể Mượn : <%= b.getAvailableCopies() %></div>
            <% if ("user".equals(role)) { %>
            <form action="BorrowRequestController" method="post">
                <input type="hidden" name="bookId" value="<%= b.getId() %>">
                <input type="hidden" name="userId" value="<%= userId %>">
                <button type="submit">📚 Mượn sách</button>
                
            </form>
        <% } %>
        </div>
    <% } %>
    </div>
    </body>
</html>
