package filters;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class AuthenticationFilter implements Filter {
    
    private static final String[] PUBLIC_PATHS = {
        "/login.jsp", "/register.jsp", "/index.jsp", "/search.jsp", "/book_detail.jsp",
        "/css/", "/images/", "/js/", "/MainController", "/error/"
    };
    
    private static final String[] ADMIN_PATHS = {
        "/admin/", "/admin_", "/manageBooks.jsp", "/addBook.jsp", "/editBook.jsp"
    };
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khởi tạo filter
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String relativePath = requestURI.substring(contextPath.length());
        
        // Kiểm tra xem đường dẫn có phải là public không
        boolean isPublicPath = false;
        for (String path : PUBLIC_PATHS) {
            if (relativePath.startsWith(path) || relativePath.equals("/")) {
                isPublicPath = true;
                break;
            }
        }
        
        // Kiểm tra xem đường dẫn có phải là admin không
        boolean isAdminPath = false;
        for (String path : ADMIN_PATHS) {
            if (relativePath.contains(path)) {
                isAdminPath = true;
                break;
            }
        }
        
        // Nếu là đường dẫn public, cho phép truy cập
        if (isPublicPath && !isAdminPath) {
            chain.doFilter(request, response);
            return;
        }
        
        // Kiểm tra session
        boolean isLoggedIn = (session != null && session.getAttribute("userId") != null);
        String userRole = (session != null) ? (String) session.getAttribute("role") : null;
        
        // Nếu là đường dẫn admin, kiểm tra quyền admin
        if (isAdminPath) {
            if (isLoggedIn && "admin".equals(userRole)) {
                chain.doFilter(request, response);
            } else {
                // Chuyển hướng đến trang lỗi hoặc trang đăng nhập
                httpResponse.sendRedirect(contextPath + "/error/access_denied.jsp");
            }
            return;
        }
        
        // Đối với các đường dẫn khác cần đăng nhập
        if (isLoggedIn) {
            chain.doFilter(request, response);
        } else {
            // Lưu URL hiện tại để sau khi đăng nhập có thể quay lại
            String queryString = httpRequest.getQueryString();
            String redirectURL = requestURI + (queryString != null ? "?" + queryString : "");
            session = httpRequest.getSession(true);
            session.setAttribute("redirectURL", redirectURL);
            
            // Chuyển hướng đến trang đăng nhập
            httpResponse.sendRedirect(contextPath + "/login.jsp");
        }
    }
    
    @Override
    public void destroy() {
        // Giải phóng tài nguyên
    }
} 