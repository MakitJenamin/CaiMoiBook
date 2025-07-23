<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dto.Book" %>
<%
    Book book = (Book) request.getAttribute("book");
    if (book == null) {
        // Có thể chuyển hướng đến trang lỗi hoặc hiển thị thông báo
        response.sendRedirect("error/404.jsp");
        return;
    }
    String userName = (String) session.getAttribute("userName");
    String role = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");
    String bookStatus = (String) request.getAttribute("bookStatus");
    if (bookStatus == null) {
        bookStatus = "AVAILABLE"; // Mặc định nếu không có user đăng nhập
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết sách: <%= book.getTitle() %></title>
    <link rel="stylesheet" href="css/styleindex.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .book-detail-container {
            display: flex;
            gap: 40px;
            padding: 120px 20px 40px 20px;
            max-width: 1200px;
            margin: auto;
        }
        .book-cover {
            flex-shrink: 0;
        }
        .book-cover img {
            width: 300px;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .book-info-details {
            flex-grow: 1;
        }
        .book-info-details h1 {
            margin-top: 0;
            font-size: 2.5rem;
        }
        .book-info-details .author {
            font-size: 1.2rem;
            color: #555;
            margin-bottom: 20px;
        }
        .book-info-details .details p {
            font-size: 1rem;
            line-height: 1.6;
            margin-bottom: 10px;
        }
        .book-info-details .details strong {
            color: #333;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-logo">
            <img src="images/simple-book-line-icon-stroke-260nw-1687315123.jpg" alt="LibraryOnline Logo" class="logo">
            <span class="titleName">LibraryOnline</span>
        </div>
        <div class="nav-header">
            <a href="MainController?action=home" class="item-header">Home</a>
            <a href="MainController?action=search" class="item-header">Browse</a>
            <a href="#" class="item-header">Categories</a>
            <a href="#" class="item-header">About</a>
            <a href="#" class="item-header">Contact</a>
            <% if ("user".equals(role)) { %>
                <a href="MainController?action=history" class="item-header">Lịch sử mượn</a>
                <a href="MainController?action=requestHistory" class="item-header">Lịch sử yêu cầu</a>
            <% } else if ("admin".equals(role)) { %>
                <a href="admin/panel.jsp" class="item-header">Admin Panel</a>
            <% } %>
        </div>
        <div class="function-header">
            <form id="headerSearchForm" action="MainController" method="get" style="display: flex; align-items: center;">
                <input type="search" name="title" class="form-search" placeholder="Search for books...">
                <input type="hidden" name="action" value="search">
                <i class="fa-solid fa-magnifying-glass search-icon" onclick="document.getElementById('headerSearchForm').submit();" style="cursor: pointer;"></i>
            </form>
            <% if(userName != null){ %>
                <button class="sign-in" onclick="window.location.href='MainController?action=profile'"><%= "🕴" + userName%></button>
                <button class="regis-ter" onclick="window.location.href='MainController?action=logout'">🚪 Logout</button>
            <% } else { %>
                <button class="sign-in" onclick="window.location.href='login.jsp'">Sign in</button>
                <button class="regis-ter" onclick="window.location.href='register.jsp'">Register</button>
            <% } %>
            <a href="search.jsp" class="join">Join Library</a>  
        </div>
    </div>

    <div class="book-detail-container">
        <div class="book-cover">
            <img src="/placeholder.svg?height=450&width=300" alt="Bìa sách <%= book.getTitle() %>">
        </div>
        <div class="book-info-details">
            <h1><%= book.getTitle() %></h1>
            <p class="author">bởi <%= book.getAuthor() %></p>
            <div class="details">
                <p><strong>ISBN:</strong> <%= book.getIsbn() %></p>
                <p><strong>Thể loại:</strong> <%= book.getCategory() %></p>
                <p><strong>Năm xuất bản:</strong> <%= book.getPublishedYear() %></p>
                <p><strong>Tổng số bản:</strong> <%= book.getTotalCopies() %></p>
                <p><strong>Sẵn có:</strong> <%= book.getAvailableCopies() %></p>
                <p><strong>Trạng thái:</strong> <%= book.getStatus() %></p>
            </div>
            
            <div class="action-buttons" style="margin-top: 20px;">
                <% if ("user".equals(role)) {
                    if (book.getAvailableCopies() > 0 && "AVAILABLE".equals(bookStatus)) { %>
                        <form action="MainController" method="post">
                            <input type="hidden" name="bookId" value="<%= book.getId() %>">
                            <input type="hidden" name="userId" value="<%= userId %>">
                            <button type="submit" class="btn-borrow" name="action" value="borrow" style="width: auto; padding: 12px 24px;">📚 Mượn sách</button>
                        </form>
                <%  } else if ("REQUESTED".equals(bookStatus)) { %>
                        <button disabled class="btn-requested" style="width: auto; padding: 12px 24px;">Đã yêu cầu</button>
                <%  } else if ("APPROVED".equals(bookStatus)) { %>
                        <button disabled class="btn-approved" style="width: auto; padding: 12px 24px;">Đã được duyệt</button>
                <%  } else if ("BORROWED".equals(bookStatus)) { %>
                        <button disabled class="btn-borrowed" style="width: auto; padding: 12px 24px;">Đã mượn</button>
                <%  } else { %>
                        <button disabled class="btn-disabled" style="width: auto; padding: 12px 24px;">Hết sách</button>
                <%  }
                } %>
            </div>
        </div>
    </div>
</body>
</html> 