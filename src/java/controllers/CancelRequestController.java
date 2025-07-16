package controllers;

import dao.RequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class CancelRequestController extends HttpServlet {

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

        String requestIdStr = request.getParameter("requestId");
        if (requestIdStr == null || requestIdStr.isEmpty()) {
            request.setAttribute("errorMessage", "Mã yêu cầu không hợp lệ");
            request.getRequestDispatcher("MainController?action=requestHistory").forward(request, response);
            return;
        }

        try {
            int requestId = Integer.parseInt(requestIdStr);
            RequestDAO dao = new RequestDAO();
            boolean success = dao.cancelRequest(requestId, userId);

            if (success) {
                request.setAttribute("successMessage", "Đã hủy yêu cầu thành công");
            } else {
                request.setAttribute("errorMessage", "Không thể hủy yêu cầu. Yêu cầu có thể đã được xử lý hoặc không tồn tại");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Mã yêu cầu không hợp lệ");
        }

        response.sendRedirect("MainController?action=requestHistory");
    }
} 