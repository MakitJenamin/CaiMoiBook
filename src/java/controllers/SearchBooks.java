package controllers;

import dao.BookDAO;
import dto.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    
    HttpSession session = request.getSession(false);
    Integer userId = null;
    if (session != null) {
        userId = (Integer) session.getAttribute("userId");
    }
    
    if (userId != null) {
        Map<Integer, String> bookStatusMap = new HashMap<>();
        for (Book book : result) {
            String status = dao.checkBookStatusForUser(userId, book.getId());
            bookStatusMap.put(book.getId(), status);
        }
        request.setAttribute("bookStatusMap", bookStatusMap);
    }
    
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