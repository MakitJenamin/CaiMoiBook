<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.concurrent.TimeUnit"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="dto.Record"%>
<%@page import="dao.ConfigurationDAO"%>
<%@page import="java.util.Calendar"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    if (!"admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String userName = (String) session.getAttribute("userName");
    List<Record> borrowList = (List<Record>) request.getAttribute("borrowList");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new java.util.Locale("vi", "VN"));
    
    ConfigurationDAO configDAO = new ConfigurationDAO();
    String finePerDayString = configDAO.getConfigurationValue("overdue_fine_per_day");
    long finePerDay = 1000; // Giá trị mặc định nếu không lấy được từ DB
    try {
        if (finePerDayString != null) {
            finePerDay = (long) Double.parseDouble(finePerDayString);
        }
    } catch (NumberFormatException e) {
        // Giữ giá trị mặc định nếu có lỗi parse
    }
    
    String maxBorrowDaysString = configDAO.getConfigurationValue("max_borrow_days");
    int maxBorrowDays = 14; // Giá trị mặc định
    try {
        if (maxBorrowDaysString != null) {
            maxBorrowDays = Integer.parseInt(maxBorrowDaysString);
        }
    } catch (NumberFormatException e) {
        // Giữ giá trị mặc định nếu có lỗi parse
    }
    
    String filter = request.getParameter("filter");
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Lịch sử mượn sách</title>
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
        .history-table-container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow-x: auto;
        }
        .history-table {
            width: 100%;
            border-collapse: collapse;
        }
        .history-table th, .history-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #ddd;
            text-align: left;
            vertical-align: middle;
        }
        .history-table th {
            background-color: #f2f2f2;
            font-weight: 600;
        }
        .history-table tr:hover {
            background-color: #f5f5f5;
        }
        .status {
            padding: 5px 10px;
            border-radius: 15px;
            color: #fff;
            font-size: 0.9rem;
            text-align: center;
        }
        .status.borrowed { background-color: #ffc107; color: #000;}
        .status.Returned { background-color: #28a745; }
        .no-records {
            text-align: center;
            padding: 50px;
            font-size: 1.2rem;
            color: #666;
        }
        .fee-cell {
            font-weight: bold;
            color: #dc3545;
        }
        .filter-controls {
            text-align: center;
            margin-bottom: 20px;
        }
        .filter-controls a {
            display: inline-block;
            padding: 10px 20px;
            margin: 0 10px;
            border-radius: 5px;
            text-decoration: none;
            background-color: #e9ecef;
            color: #495057;
            font-weight: 500;
            transition: background-color 0.3s;
        }
        .filter-controls a:hover, .filter-controls a.active {
            background-color: #007bff;
            color: #fff;
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
            <h1>Lịch sử mượn trả sách</h1>
        </div>
        
        <div class="filter-controls">
            <a href="MainController?action=adminBorrow" class="<%= (filter == null || !filter.equals("overdue")) ? "active" : "" %>">Xem tất cả</a>
            <a href="MainController?action=adminBorrow&filter=overdue" class="<%= "overdue".equals(filter) ? "active" : "" %>">Chỉ xem sách quá hạn</a>
        </div>

        <div class="history-table-container">
            <% if (borrowList != null && !borrowList.isEmpty()) { %>
            <table class="history-table">
                <thead>
                    <tr>
                        <th>Người mượn</th>
                        <th>Tên sách</th>
                        <th>Ngày mượn</th>
                        <th>Ngày hẹn trả</th>
                        <th>Ngày trả</th>
                        <th>Trạng thái</th>
                        <th>Phí trễ hạn</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    int displayedRows = 0;
                    for (Record record : borrowList) { 
                        long fee = 0;
                        long overdueDays = 0;
                        Date today = new Date();
                        
                        // Tính ngày hẹn trả dựa trên cấu hình hệ thống
                        Calendar cal = Calendar.getInstance();
                        cal.setTime(record.getBorrowDate());
                        cal.add(Calendar.DAY_OF_MONTH, maxBorrowDays);
                        Date calculatedDueDate = cal.getTime();

                        Date returnDate = record.getReturnDate();

                        if (returnDate != null) { // Đã trả
                            if (returnDate.after(calculatedDueDate)) {
                                long diff = returnDate.getTime() - calculatedDueDate.getTime();
                                overdueDays = TimeUnit.DAYS.convert(diff, TimeUnit.MILLISECONDS);
                            }
                        } else { // Chưa trả
                            if (today.after(calculatedDueDate)) {
                                long diff = today.getTime() - calculatedDueDate.getTime();
                                overdueDays = TimeUnit.DAYS.convert(diff, TimeUnit.MILLISECONDS);
                            }
                        }

                        boolean isCurrentlyOverdue = overdueDays > 0 && returnDate == null;

                        if ("overdue".equals(filter) && !isCurrentlyOverdue) {
                            continue;
                        }
                        
                        if (overdueDays > 0) {
                            fee = overdueDays * finePerDay; // Sử dụng giá trị từ DB
                        }
                        displayedRows++;
                    %>
                    <tr>
                        <td><%= record.getUserName() %></td>
                        <td><%= record.getBookTitle() %></td>
                        <td><%= sdf.format(record.getBorrowDate()) %></td>
                        <td><%= sdf.format(calculatedDueDate) %></td>
                        <td><%= record.getReturnDate() != null ? sdf.format(record.getReturnDate()) : "Chưa trả" %></td>
                        <td>
                           <span class="status <%= record.getStatus().toLowerCase() %>">
                                <%= "borrowed".equalsIgnoreCase(record.getStatus()) ? "Đang mượn" : "Đã trả" %>
                           </span>
                        </td>
                        <td class="<%= fee > 0 ? "fee-cell" : "" %>">
                            <%= currencyFormatter.format(fee) %>
                        </td>
                    </tr>
                    <% } 
                    if (displayedRows == 0) {
                    %>
                        <tr>
                            <td colspan="7" class="no-records">
                                <p>Không có bản ghi nào phù hợp với bộ lọc.</p>
                            </td>
                        </tr>
                    <%
                    }
                    %>
                </tbody>
            </table>
            <% } else { %>
                <div class="no-records">
                    <p>Chưa có lịch sử mượn/trả nào.</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html> 