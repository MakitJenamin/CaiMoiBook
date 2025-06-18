<%-- 
    Document   : editBook
    Created on : Jun 12, 2025, 4:38:26 AM
    Author     : letpl
--%>

<%@page import="dto.Book"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Book book = (Book) request.getAttribute("book");
    if (book == null) {
        response.sendRedirect("ManageBooksController");
        return;
    }
%>  
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chỉnh sửa sách<</title>
        <link rel="stylesheet" href="css/editBook.css">

    </head>
    <body>
<div class="edit-container">
    <h2>✏️ Chỉnh sửa thông tin sách</h2>
    <form action="UpdateBookController" method="post" class="edit-form">
        <input type="hidden" name="id" value="<%= book.getId() %>">

        <label>Tiêu đề:</label>
        <input type="text" name="title" value="<%= book.getTitle() %>" required>

        <label>Tác giả:</label>
        <input type="text" name="author" value="<%= book.getAuthor() %>" required>

        <label>ISBN:</label>
        <input type="text" name="isbn" value="<%= book.getIsbn() %>" required>

        <label>Thể loại:</label>
        <input type="text" name="category" value="<%= book.getCategory() %>">

        <label>Năm xuất bản:</label>
        <input type="number" name="publishedYear" value="<%= book.getPublishedYear() %>" required>

        <label>Số lượng:</label>
        <input type="number" name="totalCopies" value="<%= book.getTotalCopies() %>" required>

        <label>Số lượng còn lại:</label>
        <input type="number" name="availableCopies" value="<%= book.getAvailableCopies() %>" required>

        <label>Trạng thái:</label>
        <select name="status">
            <option value="Available" <%= "Available".equals(book.getStatus()) ? "selected" : "" %>>Available</option>
            <option value="Unavailable" <%= "Unavailable".equals(book.getStatus()) ? "selected" : "" %>>Unavailable</option>
        </select>

        <div class="btn-group">
            <button type="submit">💾 Cập nhật</button>
            <a href="ManageBooksController" class="cancel-btn">↩️ Quay lại</a>
        </div>
    </form>
</div>
    </body>
</html>
