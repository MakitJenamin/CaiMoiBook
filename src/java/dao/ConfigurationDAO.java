package dao;

import dto.Configuration;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import mylib.DBUtils;

public class ConfigurationDAO {

    public List<Configuration> getAllConfigurations() {
        List<Configuration> list = new ArrayList<>();
        String sql = "SELECT id, config_key, config_value, description FROM system_config ORDER BY id";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Configuration config = new Configuration();
                config.setId(rs.getInt("id"));
                config.setConfigKey(rs.getString("config_key"));
                config.setConfigValue(rs.getString("config_value"));
                config.setDescription(rs.getString("description"));
                list.add(config);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateConfiguration(String key, String value) {
        String sql = "UPDATE system_config SET config_value = ? WHERE config_key = ?";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, value);
            ps.setString(2, key);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public String getConfigurationValue(String key) {
        String sql = "SELECT config_value FROM system_config WHERE config_key = ?";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, key);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("config_value");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // or a default value
    }
} 