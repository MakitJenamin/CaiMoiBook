package controllers;

import dao.UserDAO;
import dto.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mylib.PasswordHasher;

public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Lấy thông tin người dùng
        int userId = (int) session.getAttribute("userId");
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserById(userId);
        
        if (user == null) {
            session.invalidate(); // Xóa session nếu không tìm thấy user
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Gửi thông tin user đến trang profile
        request.setAttribute("user", user);
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int userId = (int) session.getAttribute("userId");
        UserDAO userDAO = new UserDAO();
        
        // Xác định hành động từ form
        String action = request.getParameter("action");
        
        if ("updateProfile".equals(action)) {
            // Cập nhật thông tin cá nhân
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            
            // Kiểm tra email đã tồn tại chưa (nếu thay đổi email)
            User currentUser = userDAO.getUserById(userId);
            if (!currentUser.getEmail().equals(email)) {
                User existingUser = userDAO.getUserByEmail(email);
                if (existingUser != null) {
                    request.setAttribute("errorMessage", "Email này đã được sử dụng bởi người dùng khác.");
                    request.setAttribute("user", currentUser);
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                    return;
                }
            }
            
            // Cập nhật thông tin
            boolean success = userDAO.updateUserProfile(userId, name, email);
            
            if (success) {
                // Cập nhật session với tên mới
                session.setAttribute("userName", name);
                request.setAttribute("successMessage", "Cập nhật thông tin cá nhân thành công!");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật thông tin.");
            }
            
            // Lấy thông tin user đã cập nhật
            User updatedUser = userDAO.getUserById(userId);
            request.setAttribute("user", updatedUser);
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            
        } else if ("changePassword".equals(action)) {
            // Đổi mật khẩu
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            // Kiểm tra mật khẩu hiện tại
            User user = userDAO.getUserById(userId);
            if (!PasswordHasher.verifyPassword(currentPassword, user.getPassword())) {
                request.setAttribute("errorMessage", "Mật khẩu hiện tại không đúng.");
                request.setAttribute("user", user);
                request.getRequestDispatcher("profile.jsp").forward(request, response);
                return;
            }
            
            // Kiểm tra mật khẩu mới
            if (newPassword.length() < 6) {
                request.setAttribute("errorMessage", "Mật khẩu mới phải có ít nhất 6 ký tự.");
                request.setAttribute("user", user);
                request.getRequestDispatcher("profile.jsp").forward(request, response);
                return;
            }
            
            // Kiểm tra xác nhận mật khẩu
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("errorMessage", "Xác nhận mật khẩu không khớp với mật khẩu mới.");
                request.setAttribute("user", user);
                request.getRequestDispatcher("profile.jsp").forward(request, response);
                return;
            }
            
            // Cập nhật mật khẩu
            boolean success = userDAO.updateUserPassword(userId, newPassword);
            
            if (success) {
                request.setAttribute("successMessage", "Đổi mật khẩu thành công!");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi đổi mật khẩu.");
            }
            
            request.setAttribute("user", user);
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        } else {
            // Nếu không xác định được hành động, trả về trang profile
            response.sendRedirect("MainController?action=profile");
        }
    }
} 