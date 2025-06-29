package controllers;

import dao.RequestDAO;
import dto.RequestDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class UserRequestHistoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Integer userId = null;

        if (session != null) {
            userId = (Integer) session.getAttribute("userId");
        }

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        RequestDAO dao = new RequestDAO();
        List<RequestDTO> requestHistory = dao.getRequestsByUserId(userId);

        request.setAttribute("requestHistory", requestHistory);
        request.getRequestDispatcher("request_history.jsp").forward(request, response);
    }
} 