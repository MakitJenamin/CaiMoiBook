package controllers;

import dao.StatisticsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class    StatisticsController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        if (!"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        StatisticsDAO dao = new StatisticsDAO();

        request.setAttribute("totalBooks", dao.getTotalBooks());
        request.setAttribute("totalUsers", dao.getTotalUsers());
        request.setAttribute("currentlyBorrowed", dao.getCurrentlyBorrowedCount());
        request.setAttribute("mostBorrowedBooks", dao.getMostBorrowedBooks());
        request.setAttribute("monthlyStats", dao.getMonthlyBorrowingStats());
        request.setAttribute("avgBorrowDuration", dao.getAverageBorrowDuration());

        request.getRequestDispatcher("admin_statistics.jsp").forward(request, response);
    }
} 