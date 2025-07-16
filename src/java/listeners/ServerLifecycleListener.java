package listeners;

import dao.ServerLogDAO;
import dto.ServerLog;
import java.sql.SQLException;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * ServerLifecycleListener
 * Ghi log vào database khi server khởi động và tắt
 */
@WebListener
public class ServerLifecycleListener implements ServletContextListener {
    
    private static final Logger LOGGER = Logger.getLogger(ServerLifecycleListener.class.getName());
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("Server starting up at " + new Date());
        try {
            // Tạo log khi server khởi động
            ServerLog log = new ServerLog();
            log.setAction("START");
            log.setTimestamp(new Date());
            log.setDetails("Server started successfully");
            
            // Lưu vào database
            ServerLogDAO logDAO = new ServerLogDAO();
            logDAO.addServerLog(log);
            
            // Lưu đối tượng DAO vào context để sử dụng khi shutdown
            sce.getServletContext().setAttribute("serverLogDAO", logDAO);
            
            LOGGER.info("Server startup logged to database");
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to log server startup to database", ex);
        }
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("Server shutting down at " + new Date());
        try {
            // Tạo log khi server tắt
            ServerLog log = new ServerLog();
            log.setAction("STOP");
            log.setTimestamp(new Date());
            log.setDetails("Server stopped gracefully");
            
            // Lấy DAO từ context
            ServerLogDAO logDAO = (ServerLogDAO) sce.getServletContext().getAttribute("serverLogDAO");
            if (logDAO == null) {
                logDAO = new ServerLogDAO(); // Tạo mới nếu không tìm thấy
            }
            
            // Lưu vào database
            logDAO.addServerLog(log);
            
            LOGGER.info("Server shutdown logged to database");
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to log server shutdown to database", ex);
        }
    }
} 