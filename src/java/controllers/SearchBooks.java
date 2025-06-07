package controllers;

import dao.BookDAO;
import dto.Book;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

public class SearchBooks extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            String title = request.getParameter("title");
    String author = request.getParameter("author");
    String category = request.getParameter("category");

    BookDAO dao = new BookDAO();
    List<Book> result = dao.searchBooksAdvanced(title, author, category);
    List<String> categories = dao.getAllCategories(); // <-- Lấy tất cả thể loại
    
    request.setAttribute("searchResults", result);
    request.setAttribute("title", title);
    request.setAttribute("author", author);
    request.setAttribute("category", category);
    request.setAttribute("categories", categories);  // <-- Gửi cho JSP
    request.getRequestDispatcher("search.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}