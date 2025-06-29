/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.BookDAO;
import dto.Book;
import java.util.List;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author letpl
 */
public class ShowBooksController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String returnTo = request.getParameter("returnTo");
        BookDAO dao = new BookDAO();
        HttpSession session = request.getSession(false);
        Integer userId = null;
        if (session != null) {
            userId = (Integer) session.getAttribute("userId");
        }

        if ("search.jsp".equals(returnTo)) { // trang search.jsp
            List<Book> result = dao.getAllBooks(); // Hoặc lấy lại theo searchResults nếu cần
            List<String> categories = dao.getAllCategories();
            
            if (userId != null) {
                Map<Integer, String> bookStatusMap = new HashMap<>();
                for (Book book : result) {
                    String status = dao.checkBookStatusForUser(userId, book.getId());
                    bookStatusMap.put(book.getId(), status);
                }
                request.setAttribute("bookStatusMap", bookStatusMap);
            }
            
            request.setAttribute("searchResults", result);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("search.jsp").forward(request, response);
        } else { // trang chinh
            List<Book> bookList = dao.getNewBooks();
            if (userId != null) {
                Map<Integer, String> bookStatusMap = new HashMap<>();
                for (Book book : bookList) {
                    String status = dao.checkBookStatusForUser(userId, book.getId());
                    bookStatusMap.put(book.getId(), status);
                }
                request.setAttribute("bookStatusMap", bookStatusMap);
            }
            request.setAttribute("bookList", bookList);
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}
