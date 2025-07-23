/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import dao.BorrowRecordDAO;
import dao.RequestDAO;
import dto.RequestDTO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import java.time.LocalDate;

/**
 *
 * @author letpl
 */
public class ConfirmBorrowController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = "MainController?action=adminRequest";
        
        try {
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            
            // Lấy thông tin từ request
            RequestDTO requestFound = RequestDAO.getRequestById(requestId);
            
            if (requestFound != null && "approved".equals(requestFound.getStatus())) {
                int userId = requestFound.getUserId();
                int bookId = requestFound.getBookId();

                // Ngày mượn là hôm nay
                LocalDate borrowDate = LocalDate.now();
                // Hạn trả là 14 ngày sau (có thể chỉnh tùy chính sách)
                LocalDate dueDate = borrowDate.plusDays(14);
                
                // Ghi vào bảng borrow_records
                BorrowRecordDAO.insertBorrowRecord(userId, bookId, Date.valueOf(borrowDate), Date.valueOf(dueDate));
                
                // Cập nhật trạng thái yêu cầu thành "completed"
                RequestDAO.updateRequestStatus(requestId, "completed");
                
                // Thêm thông báo vào session thay vì request để giữ thông báo sau khi chuyển hướng
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Xác nhận mượn sách thành công!");
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", "Yêu cầu không hợp lệ hoặc không tồn tại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        // Sử dụng sendRedirect thay vì forward để tránh hiển thị trang trắng
        response.sendRedirect(url);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
} 