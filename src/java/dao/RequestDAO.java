/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.RequestDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
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

    public List<RequestDTO> getRequestsByUserId(int userId) {
        List<RequestDTO> list = new ArrayList<>();
        String sql = "SELECT r.id, r.book_id, r.user_id, r.request_date, r.status, b.title as book_title " +
                     "FROM book_requests r JOIN books b ON r.book_id = b.id " +
                     "WHERE r.user_id = ? ORDER BY r.request_date DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RequestDTO req = new RequestDTO();
                req.setRequestId(rs.getInt("id"));
                req.setBookId(rs.getInt("book_id"));
                req.setUserId(rs.getInt("user_id"));
                req.setBookTitle(rs.getString("book_title"));
                req.setRequestDate(rs.getDate("request_date"));
                req.setStatus(rs.getString("status"));
                list.add(req);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public boolean cancelRequest(int requestId, int userId) {
        String sql = "UPDATE book_requests SET status = 'cancelled' WHERE id = ? AND user_id = ? AND status = 'pending'";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ps.setInt(2, userId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
