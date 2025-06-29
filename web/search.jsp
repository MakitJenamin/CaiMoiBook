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
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
    List<Book> books = (List<Book>) request.getAttribute("searchResults");
    if (books == null) {
        books = new ArrayList<>(); // Khởi tạo rỗng nếu không có dữ liệu
    }
    List<String> categories = (List<String>) request.getAttribute("categories");
    if(categories == null) {
        categories = new ArrayList<>();
    }
    String title = (String) request.getAttribute("title");
    if(title == null) title = "";
    String author = (String) request.getAttribute("author");
    if(author == null) author = "";
    String category = (String) request.getAttribute("category");
    if(category == null) category = "";

    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    Map<Integer, String> bookStatusMap = (Map<Integer, String>) request.getAttribute("bookStatusMap");
    if (bookStatusMap == null) {
        bookStatusMap = new HashMap<>();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Tìm kiếm sách</title>
    <link rel="stylesheet" href="css/styleindex.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="header">
        <div class="header-logo">
            <img src="images/simple-book-line-icon-stroke-260nw-1687315123.jpg" alt="LibraryOnline Logo" class="logo">
            <span class="titleName">LibraryOnline</span>
        </div>

        <div class="nav-header">
            <a href="index.jsp" class="item-header">Home</a>
            <a href="SearchBooks" class="item-header">Browse</a>
            <a href="#" class="item-header">Categories</a>
            <a href="#" class="item-header">About</a>
            <a href="#" class="item-header">Contact</a>
            <% if ("user".equals(role)) { %>
                <a href="UserBorrowHistoryController" class="item-header">Lịch sử mượn</a>
                <a href="UserRequestHistoryController" class="item-header">Lịch sử yêu cầu</a>
            <% } else if ("admin".equals(role)) { %>
                <a href="admin/panel.jsp" class="item-header">Admin Panel</a>
            <% } %>
        </div>

        <div class="function-header">
            <form id="headerSearchForm" action="SearchBooks" method="get" style="display: flex; align-items: center;">
                <input type="search" name="title" class="form-search" placeholder="Search for books...">
                <i class="fa-solid fa-magnifying-glass search-icon" onclick="document.getElementById('headerSearchForm').submit();" style="cursor: pointer;"></i>
            </form>
            
            <% if(userName != null){ %>
                <button class="sign-in" onclick="window.location.href='index.jsp'"><%= "🕴" + userName%></button>
                <button class="regis-ter" onclick="window.location.href='LogoutController'">🚪 Logout</button>
            <% } else { %>
                <button class="sign-in" onclick="window.location.href='login.jsp'">Sign in</button>
                <button class="regis-ter" onclick="window.location.href='register.jsp'">Register</button>
            <% } %>

            <a href="search.jsp" class="join">Join Library</a>  
        </div>
    </div>
    
    <div class="container" style="padding-top: 20px;">
        <h2 style="text-align:center;">🔍 Tìm kiếm sách</h2>
        <form method="get" action="SearchBooks" style="text-align:center; margin-bottom: 20px;">
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
                    <div class="book-image">
                        <img src="/placeholder.svg?height=300&width=200" alt="<%= b.getTitle() %>" />
                    </div>
                    <div class="book-info">
                        <h3><%= b.getTitle() %></h3>
                        <p>Tác giả: <%= b.getAuthor() %></p>
                        <p>Thể loại: <%= b.getCategory() %></p>
                        <p>Năm: <%= b.getPublishedYear() %></p>
                        <p>Còn lại: <%= b.getAvailableCopies() %></p>
                        <button class="btn-detail" onclick="window.location.href='BookDetailController?id=<%= b.getId() %>'
">Chi tiết</button>
                        <% if ("user".equals(role)) { 
                            String bookStatus = bookStatusMap.getOrDefault(b.getId(), "AVAILABLE");
                            if (b.getAvailableCopies() > 0 && "AVAILABLE".equals(bookStatus)) {
                        %>
                        <form action="BorrowRequestController" method="post" style="display:inline; width: 100%;">
                            <input type="hidden" name="userId" value="<%= userId %>">
                            <input type="hidden" name="bookId" value="<%= b.getId() %>">
                            <input type="hidden" name="returnTo" value="search.jsp">
                            <input type="hidden" name="title" value="<%= title %>">
                            <input type="hidden" name="author" value="<%= author %>">
                            <input type="hidden" name="category" value="<%= category %>">
                            <button type="submit" class="btn-borrow">📚 Mượn sách</button>
                        </form>
                        <% } else if ("REQUESTED".equals(bookStatus)) { %>
                            <button disabled class="btn-requested">Đã yêu cầu</button>
                        <% } else if ("BORROWED".equals(bookStatus)) { %>
                            <button disabled class="btn-borrowed">Đã mượn</button>
                        <% } else { %>
                            <button disabled class="btn-disabled">Hết sách</button>
                        <% 
                            }
                        } %>
                    </div>
                </div>
            <% }} else { %>
                <p style="text-align:center;">Không tìm thấy kết quả nào.</p>
            <% } %>
        </div>
    </div>
</body>
</html>
