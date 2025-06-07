/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import dao.BookDAO;
import dto.Book;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author letpl
 */
public class BorrowRequestController extends HttpServlet {

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
            out.println("<title>Servlet BorrowRequestController</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BorrowRequestController at " + request.getContextPath() + "</h1>");
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
                int bookId = Integer.parseInt(request.getParameter("bookId"));
                int userId = Integer.parseInt(request.getParameter("userId"));
                String returnTo = request.getParameter("returnTo");
                String title = request.getParameter("title");
                String author = request.getParameter("author");
                String category = request.getParameter("category");


                BookDAO dao = new BookDAO();
                boolean success = dao.requestBook(userId, bookId);

//                request.getRequestDispatcher("ShowBooks").forward(request, response); // Quay về lại trang danh sách  
        if ("search.jsp".equals(returnTo)) {
            List<Book> result = dao.searchBooksAdvanced(title, author, category);
            List<String> categories = dao.getAllCategories();
            
            request.setAttribute("searchResults", result);
            request.setAttribute("title", title);
            request.setAttribute("author", author);
            request.setAttribute("category", category);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("search.jsp").forward(request, response);
        } else {
            List<Book> bookList = dao.getAllBooks();
            request.setAttribute("bookList", bookList);
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
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
