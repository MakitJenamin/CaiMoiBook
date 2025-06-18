<%-- 
    Document   : addBook
    Created on : Jun 12, 2025, 1:47:53 AM
    Author     : letpl
--%>

<%@page import="java.util.List"%>
<%@page import="dao.BookDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<% String msg = (String) request.getAttribute("message"); %>
<% if (msg != null) { %>
    <div class="success-message"><%= msg %></div>
<% } %>

<%
    BookDAO dao = new BookDAO();
    List<String> categories = dao.getAllCategories(); // lấy các category đã có trong DB
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thêm sách mới</title>
        <link rel="stylesheet" href="css/addBook.css">
    </head>
    <body>
        <a href="index.jsp">Home</a>
    <div class="form-container">
        <h2>📘 Thêm sách mới</h2>
        <form action="AddBookController" method="post">
            <label>Tiêu đề:</label>
            <input type="text" name="title" required>

            <label>Tác giả:</label>
            <input type="text" name="author" required>

            <label>ISBN:</label>
            <input type="text" name="isbn" required>

            <label>Thể loại:</label>
            <select name="category">
                <% for (String c : categories) { %>
                    <option value="<%= c %>"><%= c %></option>
                <% } %>
            </select>

            <label>Năm xuất bản:</label>
            <input type="number" name="publishedYear" required>

            <label>Tổng số bản:</label>
            <input type="number" name="totalCopies" required>

            <label>Số bản hiện còn:</label>
            <input type="number" name="availableCopies" required>

            <label>Trạng thái:</label>
            <select name="status">
                <option value="Available">Available</option>
                <option value="Unavailable">Unavailable</option>
            </select>

            <button type="submit">📚 Thêm sách</button>
        </form>
    </div>
    </body>
</html>
