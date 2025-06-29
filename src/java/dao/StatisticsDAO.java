package dao;

import dto.BookBorrowCount;
import dto.MonthlyStat;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import mylib.DBUtils;

public class StatisticsDAO {

    public int getTotalBooks() {
        String sql = "SELECT COUNT(*) FROM books";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getCurrentlyBorrowedCount() {
        String sql = "SELECT COUNT(*) FROM borrow_records WHERE status = 'borrowed'";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<BookBorrowCount> getMostBorrowedBooks() {
        List<BookBorrowCount> list = new ArrayList<>();
        String sql = "SELECT TOP 5 b.title, COUNT(br.book_id) AS borrow_count " +
                     "FROM borrow_records br " +
                     "JOIN books b ON br.book_id = b.id " +
                     "GROUP BY b.title " +
                     "ORDER BY borrow_count DESC";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new BookBorrowCount(rs.getString("title"), rs.getInt("borrow_count")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<MonthlyStat> getMonthlyBorrowingStats() {
        List<MonthlyStat> list = new ArrayList<>();
        // Note: This SQL syntax might need adjustment based on the specific database (e.g., SQL Server, MySQL, PostgreSQL)
        String sql = "SELECT FORMAT(borrow_date, 'yyyy-MM') AS month, COUNT(id) AS borrow_count " +
                     "FROM borrow_records " +
                     "GROUP BY FORMAT(borrow_date, 'yyyy-MM') " +
                     "ORDER BY month DESC";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new MonthlyStat(rs.getString("month"), rs.getInt("borrow_count")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getAverageBorrowDuration() {
        String sql = "SELECT AVG(CAST(DATEDIFF(day, borrow_date, return_date) AS FLOAT)) " +
                     "FROM borrow_records " +
                     "WHERE return_date IS NOT NULL";
        try (Connection con = DBUtils.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
} 