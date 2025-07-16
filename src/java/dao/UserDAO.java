package dao;

import dto.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import mylib.DBUtils;
import mylib.PasswordHasher;

public class UserDAO {

    // Use  to get data user based on email
    // input: email
    // output: Object user has the same email
    public User getUserByEmail(String email) {
        User result = null;
        Connection cn = null;
        try {
            // 1: ket noi app voi sqlserver
            cn = DBUtils.getConnection();
            if (cn != null) {
                // 2: viet query va execute
                String sql = "select [id],[name],[email],[role],[status]\n"
                        + "from [dbo].[users]\n"
                        + "where email = '" + email + "'";
                Statement st = cn.createStatement();
                ResultSet table = st.executeQuery(sql);
                if (table != null && table.next()) {
                    result = new User();
                    // 3: doc data trong table
                    result.setId(table.getInt("id"));
                    result.setEmail(table.getString("email"));
                    result.setName(table.getString("name"));
                    result.setRole(table.getString("role"));
                    result.setStatus(table.getString("status"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }
    
    /**
     * Lấy thông tin người dùng dựa trên ID
     * 
     * @param userId ID của người dùng cần lấy thông tin
     * @return Đối tượng User nếu tìm thấy, null nếu không tìm thấy
     */
    public User getUserById(int userId) {
        User result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT [id],[name],[email],[role],[status] FROM [dbo].[users] WHERE id = ?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, userId);
                ResultSet table = st.executeQuery();
                
                if (table != null && table.next()) {
                    result = new User();
                    result.setId(table.getInt("id"));
                    result.setEmail(table.getString("email"));
                    result.setName(table.getString("name"));
                    result.setRole(table.getString("role"));
                    result.setStatus(table.getString("status"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }
    
    /**
     * Cập nhật thông tin người dùng
     * 
     * @param userId ID của người dùng cần cập nhật
     * @param name Tên mới của người dùng
     * @param email Email mới của người dùng
     * @return true nếu cập nhật thành công, false nếu không
     */
    public boolean updateUserProfile(int userId, String name, String email) {
        Connection cn = null;
        boolean success = false;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "UPDATE [dbo].[users] SET [name] = ?, [email] = ? WHERE [id] = ?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, name);
                st.setString(2, email);
                st.setInt(3, userId);
                
                int rowsAffected = st.executeUpdate();
                success = (rowsAffected > 0);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return success;
    }
    
    /**
     * Cập nhật mật khẩu của người dùng
     * 
     * @param userId ID của người dùng
     * @param newPassword Mật khẩu mới (chưa được hash)
     * @return true nếu cập nhật thành công, false nếu không
     */
    public boolean updateUserPassword(int userId, String newPassword) {
        Connection cn = null;
        boolean success = false;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // Hash mật khẩu mới trước khi lưu
                String hashedPassword = PasswordHasher.hashPassword(newPassword);
                
                String sql = "UPDATE [dbo].[users] SET [password] = ? WHERE [id] = ?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, hashedPassword);
                st.setInt(2, userId);
                
                int rowsAffected = st.executeUpdate();
                success = (rowsAffected > 0);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return success;
    }
    
    public boolean updateUserStatus(int userId, String status) {
    String sql = "UPDATE users SET status = ? WHERE id = ?";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, status);
        ps.setInt(2, userId);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}

    // ham nay de insert new user vao bang User
    // Input: name, email, password=> id duy nhat, role='user', status='user'
    // output: 1 or 0
    public int insertNewUser(String name, String email, String password) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // Hash the password before storing
                String hashedPassword = PasswordHasher.hashPassword(password);
                
                String sql = "insert [dbo].[users] values (?, ?,?,'user','active')";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, name); // 1 la vi tri cua ? dau tien
                st.setString(2, email);
                st.setString(3, hashedPassword);
                result = st.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    // ham nay de lay User dua vao email, pass
    public User getUser(String email, String password) {
        User result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // Get the user with the given email to check password
                String sql = "select [id],[name],[email],[password],[role],[status]\n"
                        + "from [dbo].[users]\n"
                        + "where email = ?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, email);
                ResultSet table = st.executeQuery();
                
                if (table != null && table.next()) {
                    // Get the stored hashed password
                    String storedHash = table.getString("password");
                    
                    // Verify the password
                    if (PasswordHasher.verifyPassword(password, storedHash)) {
                        // Password is correct, create user object
                        int id = table.getInt("id");
                        String name = table.getString("name");
                        String role = table.getString("role");
                        String status = table.getString("status");
                        result = new User(id, name, email, storedHash, role, status);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    /**
     * Migrates all existing plain text passwords to hashed passwords
     * This method should be called once during application upgrade
     * 
     * @return The number of passwords migrated
     */
    public int migratePasswords() {
        int count = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // Get all users
                String selectSql = "SELECT [id], [password] FROM [dbo].[users]";
                Statement selectSt = cn.createStatement();
                ResultSet users = selectSt.executeQuery(selectSql);
                
                // Prepare update statement
                String updateSql = "UPDATE [dbo].[users] SET [password] = ? WHERE [id] = ?";
                PreparedStatement updateSt = cn.prepareStatement(updateSql);
                
                // For each user, hash the password if it's not already hashed
                while (users.next()) {
                    int id = users.getInt("id");
                    String password = users.getString("password");
                    
                    // Check if password is already hashed (contains a colon which separates salt and hash)
                    if (!password.contains(":")) {
                        // Hash the password
                        String hashedPassword = PasswordHasher.hashPassword(password);
                        
                        // Update the user's password
                        updateSt.setString(1, hashedPassword);
                        updateSt.setInt(2, id);
                        updateSt.executeUpdate();
                        
                        count++;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return count;
    }
}
