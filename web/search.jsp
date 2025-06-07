<%-- 
    Document   : search
    Created on : Jun 5, 2025, 1:14:28 PM
    Author     : letpl
--%>
<%@page import="dao.BookDAO"%>
<%@page import="java.util.List"%>
<%@page import="dto.Book"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dto.Book" %>
<%
    List<Book> books = (List<Book>) request.getAttribute("searchResults");
    if(books == null) {
        BookDAO dao = new BookDAO();
        List<Book> bookList = dao.getAllBooks();
        books = bookList;
    }
    List<String> categories = (List<String>) request.getAttribute("categories");
    if(categories == null) {
        BookDAO dao = new BookDAO();
        List<String> categoriesList = dao.getAllCategories();
        categories = categoriesList;
    }
    String title = (String) request.getAttribute("title");
    if(title == null) title = "";
    String author = (String) request.getAttribute("author");
    if(author == null) author = "";
    String category = (String) request.getAttribute("category");
    if(category == null) category = "";

    String role = (String) session.getAttribute("role"); // để hiển thị nút "Mượn"
    Integer userId = (Integer) session.getAttribute("userId"); // dùng cho mượn
%>
<!DOCTYPE html>
<html>
<head>
    <title>Tìm kiếm sách</title>
    <link rel="stylesheet" href="css/styleindex.css">
</head>
<body>
    <h2 style="text-align:center;">🔍 Tìm kiếm sách</h2>
    <form method="get" action="SearchBooks" style="text-align:center;">
        <input type="text" name="title" placeholder="Tiêu đề sách" value= "<%= title %>"/>
        <input type="text" name="author" placeholder="Tác giả" value= "<%= author %>"/>
        <select name="category">
            <option value="">-- Chọn thể loại --</option>
            <% if (categories != null) {
                for (String cat : categories) { 
                    String selected = cat.equals(category) ? "selected" : "";
            %>
                <option value="<%= cat %>" <%= selected %>><%= cat %></option>
            <%  }} %>
        </select>
        <button type="submit">Tìm</button>
    </form>

    <div class="book-grid">
        <% if (books != null && !books.isEmpty()) {
            for (Book b : books) { %>
            <div class="book-card">
                <div class="book-image"></div>  
                <div class="book-info">
                    <h3><%= b.getTitle() %></h3>
                    <p>Tác giả: <%= b.getAuthor() %></p>
                    <p>Thể loại: <%= b.getCategory() %></p>
                    <p>Năm: <%= b.getPublishedYear() %></p>

                    <% if ("user".equals(role)) { %>
                        <form action="BorrowRequestController" method="post">
                            <input type="hidden" name="userId" value="<%= userId %>">
                            <input type="hidden" name="bookId" value="<%= b.getId() %>">
                            <input type="hidden" name="returnTo" value="search.jsp">
                            <input type="hidden" name="title" value="<%= title %>">
                            <input type="hidden" name="author" value="<%= author %>">
                            <input type="hidden" name="category" value="<%= category %>">
                            <button type="submit">📚 Mượn sách</button>
                        </form>
                    <% } %>
                </div>
            </div>
        <% }} else { %>
            <p style="text-align:center;">Không tìm thấy kết quả nào.</p>
        <% } %>
    </div>
</body>
</html>
