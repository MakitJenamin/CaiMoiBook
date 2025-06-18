
<%@page import="dao.BorrowRecordDAO"%>
<%@page import="dto.Record"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.RequestDTO" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    BorrowRecordDAO dao = new BorrowRecordDAO();
    List<Record> history = dao.getBorrowHistoryByUserId(userId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Borrow History</title>
    <link rel="stylesheet" href="css/borrow_history.css">
</head>
<body>
            <a href="index.jsp">Home</a>
    <div class="history-container">
        <h2 class="history-title">Lịch Sử Mượn Sách</h2>
        <% for (Record r : history) { %>
            <div class="history-card">
                <div class="history-header">
                    <div class="book-title"><%= r.getBookTitle()%></div>
                        <% if ("Borrowed".equalsIgnoreCase(r.getStatus())) { %>
          <form action="ReturnBookController" method="post">
            <input type="hidden" name="recordId" value="<%= r.getRecordId() %>"/>
            <button type="submit" class="return-btn">Trả sách</button>
          </form>
        <% } %>
                    <div class="status-badge 
                        <%= "Returned".equals(r.getStatus()) ? "status-returned" 
                            : "Overdue".equals(r.getStatus()) ? "status-overdue" 
                            : "status-borrowed" %>">
                        <%= r.getStatus() %>
                    </div>
                </div>
                <div class="history-info">
                    <span><strong>Ngày mượn:</strong> <%= r.getBorrowDate() %></span>
                    <span><strong>Hạn trả:</strong> <%= r.getDueDate() %></span>
                    <span><strong>Ngày trả:</strong> <%= r.getReturnDate() != null ? r.getReturnDate() : "Chưa trả" %></span>
                </div>
            </div>
        <% } %>
    </div>
</body>
</html>
