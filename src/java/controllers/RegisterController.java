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
        PrintWriter out = response.getWriter();
        if (name != null && email != null && pass != null) {
            // check email la duy nhat trong DB
            UserDAO d = new UserDAO();
            User us = d.getUserByEmail(email);
            if (us == null) {
                int result = d.insertNewUser(name, email, pass);
                if (result >= 1) {
                    out.print("<h1>Inserted!!!!</h1>");
                    out.print("<p><a href='index.jsp'>home</a></p>");
                } else {
                    out.print("<h1>no insert</h1>");
                    out.print("<p><a href='index.jsp'>home</a></p>");
                }
            } else {
                out.print("<h1>duplicate email</h1>");
                out.print("<p><a href='index.jsp'>home</a></p>");
            }
        }

    }

}
