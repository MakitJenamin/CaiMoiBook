<%@page import="java.util.List"%>
<%@page import="dto.BookBorrowCount"%>
<%@page import="dto.MonthlyStat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    String userName = (String) session.getAttribute("userName");

    int totalBooks = (int) request.getAttribute("totalBooks");
    int totalUsers = (int) request.getAttribute("totalUsers");
    int currentlyBorrowed = (int) request.getAttribute("currentlyBorrowed");
    double avgBorrowDuration = (double) request.getAttribute("avgBorrowDuration");
    List<BookBorrowCount> mostBorrowedBooks = (List<BookBorrowCount>) request.getAttribute("mostBorrowedBooks");
    List<MonthlyStat> monthlyStats = (List<MonthlyStat>) request.getAttribute("monthlyStats");
    
    DecimalFormat df = new DecimalFormat("#.0");
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thống kê thư viện</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/styleindex.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8f9fa; }
        .container { padding-top: 100px; padding-bottom: 40px; max-width: 1200px; margin: auto; }
        .page-header { text-align: center; margin-bottom: 30px; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 40px; }
        .stat-card { background-color: #fff; padding: 25px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); text-align: center; }
        .stat-card .value { font-size: 2.5rem; font-weight: 700; color: #007bff; }
        .stat-card .label { font-size: 1rem; color: #6c757d; margin-top: 10px; }
        .stats-details-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; }
        .detail-card { background-color: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .detail-card h3 { margin-top: 0; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 20px; }
        .detail-card table { width: 100%; border-collapse: collapse; }
        .detail-card th, .detail-card td { padding: 10px; text-align: left; border-bottom: 1px solid #f2f2f2; }
        .detail-card th { font-weight: 600; }
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
                <button class="sign-in" onclick="window.location.href='<%= request.getContextPath() %>/MainController?action=profile'"><%= "🕴" + userName%></button>
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
            <h1>Thống kê thư viện</h1>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="value"><%= totalBooks %></div>
                <div class="label">Tổng số sách</div>
            </div>
            <div class="stat-card">
                <div class="value"><%= totalUsers %></div>
                <div class="label">Tổng số người dùng</div>
            </div>
            <div class="stat-card">
                <div class="value"><%= currentlyBorrowed %></div>
                <div class="label">Sách đang được mượn</div>
            </div>
            <div class="stat-card">
                <div class="value"><%= df.format(avgBorrowDuration) %></div>
                <div class="label">Số ngày mượn trung bình</div>
            </div>
        </div>

        <div class="stats-details-grid">
            <div class="detail-card">
                <h3>Top 5 sách được mượn nhiều nhất</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Tên sách</th>
                            <th>Lượt mượn</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (BookBorrowCount book : mostBorrowedBooks) { %>
                            <tr>
                                <td><%= book.getBookTitle() %></td>
                                <td><%= book.getBorrowCount() %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <div class="detail-card">
                <h3>Thống kê mượn sách hàng tháng</h3>
                 <table>
                    <thead>
                        <tr>
                            <th>Tháng</th>
                            <th>Lượt mượn</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (MonthlyStat stat : monthlyStats) { %>
                            <tr>
                                <td><%= stat.getMonth() %></td>
                                <td><%= stat.getBorrowCount() %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html> 