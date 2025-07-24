/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import dao.UserDAO;
import dto.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;

public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("txtemail");
        String password = request.getParameter("txtpassword");
        PrintWriter out = response.getWriter();
        if (email != null && password != null) {
            UserDAO d = new UserDAO();
            User user = d.getUser(email, password);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", user.getId());
                session.setAttribute("userName", user.getName());
                session.setAttribute("role", user.getRole());
                session.setAttribute("status", user.getStatus());

                // Kiểm tra nếu có URL chuyển hướng được lưu trong session
                String redirectURL = (String) session.getAttribute("redirectURL");
                if (redirectURL != null) {
                    session.removeAttribute("redirectURL"); // Xóa URL chuyển hướng khỏi session
                    response.sendRedirect(redirectURL);
                } else {
                    // Nếu không có URL chuyển hướng, chuyển hướng theo vai trò
                    response.sendRedirect("MainController?action=home");
                }
            } else {
                request.setAttribute("errorMessage", "Email hoặc mật khẩu không chính xác.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        }
    }
}
