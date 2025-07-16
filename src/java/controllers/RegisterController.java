/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import dao.UserDAO;
import dto.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("txtname");
        String email = request.getParameter("txtemail");
        String pass = request.getParameter("txtpassword");
        String confirmPass = request.getParameter("confirm-password");
        
        if (name != null && email != null && pass != null && confirmPass != null) {
            // Kiểm tra mật khẩu và xác nhận mật khẩu có khớp nhau không
            if (!pass.equals(confirmPass)) {
                request.setAttribute("errorMessage", "Mật khẩu và xác nhận mật khẩu không khớp.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // Kiểm tra độ dài mật khẩu
            if (pass.length() < 6) {
                request.setAttribute("errorMessage", "Mật khẩu phải có ít nhất 6 ký tự.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // check email la duy nhat trong DB
            UserDAO d = new UserDAO();
            User us = d.getUserByEmail(email);
            if (us == null) {
                int result = d.insertNewUser(name, email, pass);
                if (result >= 1) {
                    // Đăng ký thành công
                    request.setAttribute("successMessage", "Đăng ký thành công! Bạn có thể đăng nhập ngay bây giờ.");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                } else {
                    // Lỗi khi thêm user
                    request.setAttribute("errorMessage", "Có lỗi xảy ra khi đăng ký. Vui lòng thử lại.");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                }
            } else {
                // Email đã tồn tại
                request.setAttribute("errorMessage", "Email này đã được sử dụng. Vui lòng chọn email khác.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        } else {
            // Dữ liệu không hợp lệ
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
