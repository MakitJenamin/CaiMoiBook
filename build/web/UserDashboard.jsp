<%-- 
    Document   : UserDashboard
    Created on : May 31, 2025, 1:12:06 PM
    Author     : letpl
--%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null) {
%>
    <p>Bạn chưa đăng nhập</p>
<%
    } else {
%>
    <p>Xin chào: <%= session.getAttribute("userName") %> - Vai trò: <%= role %></p>
<%  
    }
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Dashboard</title>
    </head>
    <body>
        <h1>User Dashboard</h1>
        <ul>
            <li><a href="UserProfile.html">Profile</a></li>
            <li><a href="SearchBook.html">Search book</a></li>
            <li><a href="ViewBookAvailable.html" >View books available</a></li>
            <li><a href="BorrowBook.html">Borrow book</a></li>
            <li><a href="ViewHistoryBorrow.html">View history borrow</a></li>
            <li><a href="index.jsp">Logout</a></li>
        </ul>
    </body>
</html>
