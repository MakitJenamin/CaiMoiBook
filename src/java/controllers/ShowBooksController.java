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
        if ("search.jsp".equals(returnTo)) {
            List<Book> result = dao.getAllBooks(); // Hoặc lấy lại theo searchResults nếu cần
            List<String> categories = dao.getAllCategories();
            request.setAttribute("searchResults", result);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("search.jsp").forward(request, response);
        } else {
            List<Book> bookList = dao.getAllBooks();
            request.setAttribute("bookList", bookList);
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}
