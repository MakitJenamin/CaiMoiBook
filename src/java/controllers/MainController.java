/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author 2imtina
 */
public class MainController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "404.jsp";

        try {

            String action = request.getParameter("action");
            if (action == null) {
                action = "HOME";
            }

            switch (action) {
                case "home":
                    url = "ShowBooks";
                    break;
                case "login":
                    url = "LoginController";
                    break;
                case "logout":
                    url = "LogoutController";
                    break;
                case "register":
                    url = "RegisterController";
                    break;
                case "profile":
                    url = "ProfileController";
                    break;
                case "search":
                    url = "SearchBooks";
                    break;
                case "detail":
                    url = "BookDetailController";
                    break;
                case "borrow":
                    url = "BorrowRequestController";
                    break;
                case "return":
                    url = "ReturnBookController";
                    break;
                case "adminRequest":
                    url = "AdminRequestController";
                    break;
                case "handle":
                    url = "HandleRequestController";
                    break; 
                case "adminBorrow":
                    url = "AdminBorrowsController";
                    break;
                case "adminConfirmReturn":
                    url = "AdminConfirmReturnController";
                    break;
                case "statistics":
                    url = "StatisticsController";
                    break;
                case "manage":
                    url = "ManageBooksController";
                    break;
                case "adminConfig":
                    url = "AdminConfigController";
                    break;
                case "adminManage":
                    url = "AdminUserManageController";
                    break;
                case "addBook":
                    url = "AddBookController";
                    break;
                case "deleteBook":
                    url = "DeleteBookController";
                    break;
                case "edit":
                    url = "EditBookController";
                    break;
                case "updateBook":
                    url = "UpdateBookController";
                    break;
                case "history":
                    url = "UserBorrowHistoryController";
                    break;
                case "requestHistory":
                    url = "UserRequestHistoryController";
                    break;
                case "cancelRequest":
                    url = "CancelRequestController";
                    break;
                
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                request.getRequestDispatcher(url).forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
            }
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
