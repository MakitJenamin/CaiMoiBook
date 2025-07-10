<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.Record" %>
<%@ page import="java.util.ArrayList" %>
<%
    String userName = (String) session.getAttribute("userName");
    String role = (String) session.getAttribute("role");
    List<Record> history = (List<Record>) request.getAttribute("borrowHistory");
    if (history == null) {
        history = new ArrayList<>();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Lịch Sử Mượn Sách</title>
    <link rel="stylesheet" href="css/styleindex.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .container {
            padding-top: 100px;
            padding-left: 20px;
            padding-right: 20px;
            padding-bottom: 20px;
            max-width: 1200px;
            margin: auto;
        }
        .history-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .history-table th, .history-table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        .history-table th {
            background-color: #f2f2f2;
            font-weight: 600;
        }
        .history-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .history-table tr:hover {
            background-color: #f1f1f1;
        }
        .return-btn {
            padding: 8px 12px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .return-btn:hover {
            background-color: #218838;
        }
        .status-borrowed { color: #007bff; font-weight: bold; }
        .status-returned { color: #28a745; font-weight: bold; }
        .status-overdue { color: #dc3545; font-weight: bold; }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-logo">
            <img src="images/simple-book-line-icon-stroke-260nw-1687315123.jpg" alt="LibraryOnline Logo" class="logo">
            <span class="titleName">LibraryOnline</span>
        </div>

        <div class="nav-header">
            <a href="index.jsp" class="item-header">Home</a>
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
                <i class="fa-solid fa-magnifying-glass search-icon" onclick="document.getElementById('headerSearchForm').submit();" style="cursor: pointer;"></i>
                <input type="hidden" name="action" value="search">
            </form>
            <% if(userName != null){ %>
                <button class="sign-in" onclick="window.location.href='index.jsp'"><%= "🕴" + userName%></button>
                <button class="regis-ter" onclick="window.location.href='MainController?action=logout'">🚪 Logout</button>
            <% } else { %>
                <button class="sign-in" onclick="window.location.href='login.jsp'">Sign in</button>
                <button class="regis-ter" onclick="window.location.href='register.jsp'">Register</button>
            <% } %>
            <a href="search.jsp" class="join">Join Library</a>  
        </div>
    </div>

    <div class="container">
        <h2 style="text-align: center;">Lịch Sử Mượn Sách</h2>
        <% if (history.isEmpty()) { %>
            <p style="text-align: center;">Bạn chưa mượn cuốn sách nào.</p>
        <% } else { %>
            <table class="history-table">
                <thead>
                    <tr>
                        <th>Tên sách</th>
                        <th>Ngày mượn</th>
                        <th>Hạn trả</th>
                        <th>Ngày trả</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Record r : history) { %>
                        <tr>
                            <td><%= r.getBookTitle() %></td>
                            <td><%= r.getBorrowDate() %></td>
                            <td><%= r.getDueDate() %></td>
                            <td><%= r.getReturnDate() != null ? r.getReturnDate() : "Chưa trả" %></td>
                            <td>
                                <%
                                    String statusText = "";
                                    String rawStatus = r.getStatus();
                                    if ("borrowed".equalsIgnoreCase(rawStatus)) {
                                        statusText = "Đang mượn";
                                    } else if ("returned".equalsIgnoreCase(rawStatus)) {
                                        statusText = "Đã trả";
                                    } else {
                                        statusText = rawStatus; // Giữ nguyên các trạng thái khác nếu có
                                    }
                                %>
                                <span class="status-<%= rawStatus.toLowerCase() %>">
                                    <%= statusText %>
                                </span>
                            </td>
                            <td>
                                <% if ("borrowed".equalsIgnoreCase(r.getStatus())) { %>
                                    <form action="MainController" method="post" style="margin: 0;">
                                        <input type="hidden" name="recordId" value="<%= r.getRecordId() %>"/>
                                        <button type="submit" name="action" value="return" class="return-btn">Trả sách</button>
                                    </form>
                                <% } %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</body>
</html>
