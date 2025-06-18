/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import dao.UserDAO;
import dto.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;

public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("txtemail");
        String password = request.getParameter("txtpassword");
        PrintWriter out = response.getWriter();
        if(email!= null && password != null){
            UserDAO d = new UserDAO();
            User user = d.getUser(email, password);
            if(user !=null){
        HttpSession session = request.getSession();
        session.setAttribute("userId", user.getId());   
        session.setAttribute("userName", user.getName());
        session.setAttribute("role", user.getRole());
        session.setAttribute("status", user.getStatus());
                String role = user.getRole();
                if(role.equalsIgnoreCase("admin")){
                    // welcome coming soon
                    // dung redirect chuyen trang auto
                    response.sendRedirect("index.jsp");
                }else{
                    response.sendRedirect("index.jsp");
                }
            }else{
                out.print("<h1>Email or Password incorrect</h1>");
                out.print("<p><a href='index.jsp'>Home</a></p>");
            }
        }
    }

}
