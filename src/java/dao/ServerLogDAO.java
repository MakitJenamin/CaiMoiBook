package dao;

import dto.ServerLog;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import mylib.DBUtils;

/**
 * ServerLogDAO
 * Quản lý việc lưu và truy xuất log server từ database
 */
public class ServerLogDAO {
    
    /**
     * Thêm một bản ghi log server mới vào database
     * 
     * @param log Đối tượng ServerLog cần thêm
     * @return true nếu thêm thành công, false nếu thất bại
     * @throws SQLException Nếu có lỗi khi thao tác với database
     */
    public boolean addServerLog(ServerLog log) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBUtils.getConnection();
            
            // Kiểm tra xem bảng server_logs đã tồn tại chưa, nếu chưa thì tạo mới
            ensureTableExists(conn);
            
            String sql = "INSERT INTO [dbo].[server_logs] ([action], [timestamp], [details]) VALUES (?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, log.getAction());
            stmt.setTimestamp(2, new Timestamp(log.getTimestamp().getTime()));
            stmt.setString(3, log.getDetails());
            
            int rowsAffected = stmt.executeUpdate();
            success = (rowsAffected > 0);
            
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found", e);
        } finally {
            if (stmt != null) {
                stmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        
        return success;
    }
    
    /**
     * Lấy danh sách tất cả các log server từ database
     * 
     * @return Danh sách các đối tượng ServerLog
     * @throws SQLException Nếu có lỗi khi thao tác với database
     */
    public List<ServerLog> getAllServerLogs() throws SQLException {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List<ServerLog> logs = new ArrayList<>();
        
        try {
            conn = DBUtils.getConnection();
            
            // Kiểm tra xem bảng server_logs đã tồn tại chưa, nếu chưa thì tạo mới
            ensureTableExists(conn);
            
            String sql = "SELECT [id], [action], [timestamp], [details] FROM [dbo].[server_logs] ORDER BY [timestamp] DESC";
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                ServerLog log = new ServerLog();
                log.setId(rs.getInt("id"));
                log.setAction(rs.getString("action"));
                log.setTimestamp(rs.getTimestamp("timestamp"));
                log.setDetails(rs.getString("details"));
                logs.add(log);
            }
            
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found", e);
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (stmt != null) {
                stmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        
        return logs;
    }
    
    /**
     * Đảm bảo bảng server_logs tồn tại trong database
     * Nếu bảng chưa tồn tại, phương thức sẽ tạo bảng mới
     * 
     * @param conn Kết nối database
     * @throws SQLException Nếu có lỗi khi thao tác với database
     */
    private void ensureTableExists(Connection conn) throws SQLException {
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            // Kiểm tra xem bảng server_logs đã tồn tại chưa
            String checkTableSql = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'server_logs'";
            stmt = conn.createStatement();
            rs = stmt.executeQuery(checkTableSql);
            
            if (rs.next() && rs.getInt(1) == 0) {
                // Bảng chưa tồn tại, tạo bảng mới
                String createTableSql = "CREATE TABLE [dbo].[server_logs] ("
                        + "[id] [int] IDENTITY(1,1) PRIMARY KEY,"
                        + "[action] [nvarchar](50) NOT NULL,"
                        + "[timestamp] [datetime] NOT NULL,"
                        + "[details] [nvarchar](max) NULL"
                        + ")";
                stmt.executeUpdate(createTableSql);
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (stmt != null) {
                stmt.close();
            }
        }
    }
} 