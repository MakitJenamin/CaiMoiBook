/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.RequestDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import mylib.DBUtils;

/**
 *
 * @author letpl
 */
public class RequestDAO {
    public static RequestDTO getRequestById(int requestId) {
        RequestDTO request = null;
        String sql = "SELECT r.id, r.book_id, r.user_id, r.request_date, r.status, b.title " +
                     "FROM book_requests r JOIN books b ON r.book_id = b.id " +
                     "WHERE r.id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                request = new RequestDTO();
                request.setRequestId(rs.getInt("id"));
                request.setBookId(rs.getInt("book_id"));
                request.setUserId(rs.getInt("user_id"));
                request.setRequestDate(rs.getDate("request_date"));
                request.setStatus(rs.getString("status"));
                request.setBookTitle(rs.getString("title"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return request;
    }
}
