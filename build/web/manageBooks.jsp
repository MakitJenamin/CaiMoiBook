<%-- 
    Document   : manageBooks
    Created on : Jun 12, 2025, 3:23:39 AM
    Author     : letpl
--%>

<%@page import="java.util.List"%>
<%@page import="dto.Book"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% String msg = (String) request.getParameter("message"); %>
<% if (msg != null) { %>
    <div class="success-message"><%= msg %></div>
<% } %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý sách</title>
        <link rel="stylesheet" href="css/manageBooks.css" />
    </head>
    <body>
        <h1 style="text-align:center;">📘 Quản lý Sách</h1>
                <a href="index.jsp">Home</a>
        <div class="book-card-container">
            <%
                List<Book> books = (List<Book>) request.getAttribute("bookList");
                for (Book b : books) {
            %>
            <div class="book-card">
                <div class="book-info">
                    <h3><%= b.getTitle() %></h3>
                    <p><strong>Tác giả:</strong> <%= b.getAuthor() %></p>
                    <p><strong>ISBN:</strong> <%= b.getIsbn() %></p>
                    <p><strong>Thể loại:</strong> <%= b.getCategory() %></p>
                    <p><strong>Năm:</strong> <%= b.getPublishedYear() %></p>
                    <p><strong>Total Copies:</strong> <%= b.getTotalCopies() %></p>
                    <p><strong>Available Copies:</strong> <%= b.getAvailableCopies() %></p>
                    <p><strong>Trạng thái:</strong> <%= b.getStatus() %></p>
                </div>
                <div class="card-actions">
                    <a href="EditBookController?id=<%= b.getId() %>" class="edit-btn">✏️ Sửa</a>
                    <form action="DeleteBookController" method="post" onsubmit="return confirm('Bạn chắc chắn muốn xoá sách này?');">
                        <input type="hidden" name="id" value="<%= b.getId() %>">
                        <button type="submit" class="delete-btn">🗑️ Xoá</button>
                    </form>
                </div>
            </div>
            <% } %>
        </div>
    </body>
</html>
