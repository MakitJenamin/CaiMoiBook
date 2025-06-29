/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import dto.Record;
import dto.RequestDTO;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import mylib.DBUtils;

/**
 *
 * @author letpl
 */
public class BorrowRecordDAO {
    // Trong BookDAO hoặc tạo BorrowRecordDAO.java
public List<Record> getBorrowHistoryByUserId(int userId) {
    List<Record> list = new ArrayList<>();
    String sql = "SELECT br.id, br.book_id, br.user_id, br.borrow_date, br.due_date, " +
                 "br.return_date, br.status, b.title AS book_title " +
                 "FROM borrow_records br " +
                 "JOIN books b ON br.book_id = b.id " +
                 "WHERE br.user_id = ? " +
                 "ORDER BY br.borrow_date DESC";

    try (Connection con = DBUtils.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Record record = new Record();
            record.setRecordId(rs.getInt("id"));
            record.setBookId(rs.getInt("book_id"));
            record.setUserId(rs.getInt("user_id"));
            record.setBookTitle(rs.getString("book_title"));
            record.setBorrowDate(rs.getDate("borrow_date"));
            record.setDueDate(rs.getDate("due_date"));
            record.setReturnDate(rs.getDate("return_date"));
            record.setStatus(rs.getString("status"));
            list.add(record);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

    public static void insertBorrowRecord(int userId, int bookId, Date borrowDate, Date dueDate) {
        String sql = "INSERT INTO borrow_records (user_id, book_id, borrow_date, due_date, status) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            ps.setDate(3, borrowDate);
            ps.setDate(4, dueDate);
            ps.setString(5, "borrowed");

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static boolean returnBook(int recordId, Date returnDate) {
    String sql = "UPDATE borrow_records SET return_date = ?, status = 'Returned' WHERE id = ?";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setDate(1, returnDate);
        ps.setInt(2, recordId);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
    }
    
    public int getBookIdByRecordId(int recordId) {
    String sql = "SELECT book_id FROM borrow_records WHERE id = ?";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, recordId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt("book_id");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return -1;
}

    public List<Record> getAllBorrowRecords() {
    List<Record> list = new ArrayList<>();
    String sql = "SELECT br.id, br.book_id, br.user_id, br.borrow_date, br.due_date, " +
                 "br.return_date, br.status, b.title AS book_title, u.name AS user_name " +
                 "FROM borrow_records br " +
                 "JOIN books b ON br.book_id = b.id " +
                 "JOIN users u ON br.user_id = u.id " +
                 "ORDER BY br.borrow_date DESC";

    try (Connection con = DBUtils.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Record record = new Record();
            record.setRecordId(rs.getInt("id"));
            record.setBookId(rs.getInt("book_id"));
            record.setUserId(rs.getInt("user_id"));
            record.setBookTitle(rs.getString("book_title"));
            record.setUserName(rs.getString("user_name"));
            record.setBorrowDate(rs.getDate("borrow_date"));
            record.setDueDate(rs.getDate("due_date"));
            record.setReturnDate(rs.getDate("return_date"));
            record.setStatus(rs.getString("status"));
            list.add(record);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

}
