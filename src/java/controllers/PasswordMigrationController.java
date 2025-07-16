package controllers;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Controller for migrating existing plain text passwords to hashed passwords
 * This should only be accessible to administrators
 */
@WebServlet(name = "PasswordMigrationController", urlPatterns = {"/admin/migratePasswords"})
public class PasswordMigrationController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || 
                !session.getAttribute("role").equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/error/access_denied.jsp");
            return;
        }
        
        // Show migration form
        request.getRequestDispatcher("/admin/migrate_passwords.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || 
                !session.getAttribute("role").equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/error/access_denied.jsp");
            return;
        }
        
        // Perform migration
        UserDAO userDAO = new UserDAO();
        int count = userDAO.migratePasswords();
        
        // Set result in request and forward to result page
        request.setAttribute("migratedCount", count);
        request.getRequestDispatcher("/admin/migrate_passwords_result.jsp").forward(request, response);
    }
} 