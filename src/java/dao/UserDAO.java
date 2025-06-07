package dao;

import dto.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import mylib.DBUtils;

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
                String sql = "select [id],[name],[email],[password],[role],[status]\n"
                        + "from [dbo].[users]\n"
                        + "where email = '" + email + "'";
                Statement st = cn.createStatement();
                ResultSet table = st.executeQuery(sql);
                if (table != null && table.next()) {
                    // 3: doc data trong table
                    int id = table.getInt("id");
                    String name = table.getString("name");
                    String password = table.getString("password");
                    String role = table.getString("role");
                    String status = table.getString("status");
                    result = new User(id, name, email, password, role, status);
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

    // ham nay de insert new user vao bang User
    // Input: name, email, password=> id duy nhat, role='user', status='user'
    // output: 1 or 0
    public int insertNewUser(String name, String email, String password) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "insert [dbo].[users] values (?, ?,?,'user','active')";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, name); // 1 la vi tri cua ? dau tien
                st.setString(2, email);
                st.setString(3, password);
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
                String sql = "select [id],[name],[email],[password],[role],[status]\n"
                        + "from [dbo].[users]\n"
                        + "where email = '" + email + "' and password COLLATE SQL_Latin1_General_CP1_CS_AS = '"+password+"'";
                Statement st = cn.createStatement();
                ResultSet table = st.executeQuery(sql);
                if (table != null && table.next()) {
                    // 3: doc data trong table
                    int id = table.getInt("id");
                    String name = table.getString("name");
                    String role = table.getString("role");
                    String status = table.getString("status");
                    result = new User(id, name, email, password, role, status);
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
}
