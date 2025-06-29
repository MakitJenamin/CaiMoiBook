package controllers;

import dao.ConfigurationDAO;
import dto.Configuration;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Enumeration;
import java.util.List;

public class AdminConfigController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        if (!"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        ConfigurationDAO dao = new ConfigurationDAO();
        List<Configuration> configList = dao.getAllConfigurations();

        request.setAttribute("configList", configList);
        request.getRequestDispatcher("admin_config.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        if (!"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        ConfigurationDAO dao = new ConfigurationDAO();
        Enumeration<String> parameterNames = request.getParameterNames();
        boolean allSuccess = true;

        while (parameterNames.hasMoreElements()) {
            String paramName = parameterNames.nextElement();
            String paramValue = request.getParameter(paramName);
            if (!dao.updateConfiguration(paramName, paramValue)) {
                allSuccess = false;
            }
        }

        if (allSuccess) {
            request.setAttribute("message", "Cập nhật cấu hình thành công!");
        } else {
            request.setAttribute("error", "Đã có lỗi xảy ra khi cập nhật cấu hình.");
        }
        
        // Refresh the page with the message
        doGet(request, response);
    }
} 