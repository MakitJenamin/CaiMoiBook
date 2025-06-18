<%-- 
    Document   : requests
    Created on : May 31, 2025, 2:41:33 PM
    Author     : letpl
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="dto.RequestDTO" %>
<%
    String role = (String) session.getAttribute("role");
    if (!"admin".equals(role)) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<%
    List<RequestDTO> requests = (List<RequestDTO>) request.getAttribute("requests");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>📋 Yêu cầu mượn sách</title>
    </head>
    <body>
                <a href="index.jsp">Home</a>
        <h2>📋 Yêu cầu mượn sách</h2>
<table border="1" cellpadding="5">
    <tr>
        <th>Người mượn</th>
        <th>Sách</th>
        <th>Ngày yêu cầu</th>
        <th>Trạng thái</th>
        <th>Duyệt</th>
        <th>Hủy</th>
    </tr>
    <% for(RequestDTO r : requests) { %>
        <tr>
            <td><%= r.getUserName() %></td>
            <td><%= r.getBookTitle() %></td>
            <td><%= r.getRequestDate() %></td>
            <td><%= r.getStatus() %></td>
            <td>
                <form action="HandleRequestController" method="post">
                    <input type="hidden" name="requestId" value="<%= r.getRequestId() %>">
                    <input type="hidden" name="action" value="approve">
                    <button type="submit">✅</button>
                </form>
            </td>
            <td>
                <form action="HandleRequestController" method="post">
                    <input type="hidden" name="requestId" value="<%= r.getRequestId() %>">
                    <input type="hidden" name="action" value="reject">
                    <button type="submit">❌</button>
                </form>
            </td>
        </tr>
    <% } %>
</table>
    </body>
</html>
