/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import dao.BookDAO;
import dao.BorrowRecordDAO;
import dao.RequestDAO;
import dto.RequestDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Date;
import java.time.LocalDate;

/**
 *
 * @author letpl
 */
public class HandleRequestController extends HttpServlet {

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
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet HandleRequestController</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet HandleRequestController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
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

        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String action = request.getParameter("action");

        BookDAO dao = new BookDAO();
        if ("approve".equals(action)) {
            dao.approveRequest(requestId);
                            // Lấy thông tin từ request
            RequestDTO requestfound = RequestDAO.getRequestById(requestId);
            int userId = requestfound.getUserId();
            int bookId = requestfound.getBookId();

            // Ngày mượn là hôm nay
            LocalDate borrowDate = LocalDate.now();
            // Hạn trả là 14 ngày sau (có thể chỉnh tùy chính sách)
            LocalDate dueDate = borrowDate.plusDays(14);
            // Ghi vào bảng borrow_records
            BorrowRecordDAO.insertBorrowRecord(userId, bookId, Date.valueOf(borrowDate), Date.valueOf(dueDate));

        } else if ("reject".equals(action)) {
            dao.rejectRequest(requestId);
        }

        response.sendRedirect("MainController?action=adminRequest");
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
