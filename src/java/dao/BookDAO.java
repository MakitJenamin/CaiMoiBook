package dao;

import dto.RequestDTO;
import dto.Book;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import mylib.DBUtils;

public class BookDAO {

    public ArrayList<Book> getBooksByName(String name) {
        ArrayList<Book> list = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "select [id],[title],[author],[isbn],[category],[published_year],[total_copies],[available_copies],[status]\n"
                        + "from [dbo].[books]\n"
                        + "where title like '%" + name + "%'";
                Statement st = cn.createStatement();
                ResultSet table = st.executeQuery(sql);
                while (table != null && table.next()) {
                    int id = table.getInt("id");
                    String title = table.getString("title");
                    String author = table.getString("author");
                    String isbn = table.getString("isbn");
                    String category = table.getString("category");
                    int year = table.getInt("published_year");
                    int total = table.getInt("total_copies");
                    int available = table.getInt("available_copies");
                    String status = table.getString("status");
                    list.add(new Book(id, title, author, isbn, category, year, total, available, status));
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
        return list;
    }
    
        public List<Book> getAllBooks() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM books";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Book b = new Book();
                b.setId(rs.getInt("id"));
                b.setTitle(rs.getString("title"));
                b.setAuthor(rs.getString("author"));
                b.setIsbn(rs.getString("isbn"));
                b.setCategory(rs.getString("category"));
                b.setPublishedYear(rs.getInt("published_year"));
                b.setTotalCopies(rs.getInt("total_copies"));
                b.setAvailableCopies(rs.getInt("available_copies"));
                b.setStatus(rs.getString("status"));
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
        public boolean requestBook(int userId, int bookId) {
            String sql = "INSERT INTO book_requests(user_id, book_id, request_date, status) VALUES (?, ?, GETDATE(), 'pending')";
            try (Connection conn = DBUtils.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, bookId);
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
            }
            return false;
        }
        
public List<RequestDTO> getAllPendingRequests() {
    List<RequestDTO> list = new ArrayList<>();
    String sql = "SELECT r.id, b.title, u.name, r.request_date, r.status " +
    "FROM book_requests r " +
    "JOIN books b ON r.book_id = b.id " +
    "JOIN users u ON r.user_id = u.id " +
    "WHERE r.status = 'pending'";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            RequestDTO r = new RequestDTO();
            r.setRequestId(rs.getInt("id"));
            r.setBookTitle(rs.getString("title"));
            r.setUserName(rs.getString("name"));
            r.setRequestDate(rs.getDate("request_date"));
            r.setStatus(rs.getString("status"));
            list.add(r);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

public void approveRequest(int requestId) {
    String updateRequest = "UPDATE book_requests SET status = 'approved' WHERE id = ?";
    String updateBook = 
        "UPDATE books SET available_copies = available_copies - 1" +
        "WHERE id = (SELECT book_id FROM book_requests WHERE id = ?)";
   
    try (Connection conn = DBUtils.getConnection()) {
        conn.setAutoCommit(false);
        try (
            PreparedStatement ps1 = conn.prepareStatement(updateRequest);
            PreparedStatement ps2 = conn.prepareStatement(updateBook)
        ) {
            ps1.setInt(1, requestId);
            ps1.executeUpdate();

            ps2.setInt(1, requestId);
            ps2.executeUpdate();

            conn.commit();
        } catch (Exception e) {
            conn.rollback();
            e.printStackTrace();
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
}

public void rejectRequest(int requestId) {
    String sql = "UPDATE book_requests SET status = 'rejected' WHERE id = ?";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, requestId);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

public List<Book> searchBooksAdvanced(String title, String author, String category) {
    List<Book> list = new ArrayList<>();
    String sql = "SELECT * FROM books WHERE 1=1";

    if (title != null && !title.trim().isEmpty()) {
        sql += " AND title LIKE ?";
    }
    if (author != null && !author.trim().isEmpty()) {
        sql += " AND author LIKE ?";
    }
    if (category != null && !category.trim().isEmpty()) {
        sql += " AND category = ?";
    }

    try (Connection conn = DBUtils.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        int i = 1;
        if (title != null && !title.trim().isEmpty()) {
            stmt.setString(i++, "%" + title + "%");
        }
        if (author != null && !author.trim().isEmpty()) {
            stmt.setString(i++, "%" + author + "%");
        }
        if (category != null && !category.trim().isEmpty()) {
            stmt.setString(i++, category);
        }

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            Book b = new Book();
            b.setId(rs.getInt("id"));
            b.setTitle(rs.getString("title"));
            b.setAuthor(rs.getString("author"));
            b.setCategory(rs.getString("category"));
            b.setPublishedYear(rs.getInt("published_year"));
            // các trường khác nếu có
            list.add(b);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

public List<String> getAllCategories() {
    List<String> list = new ArrayList<>();
    String sql = "SELECT DISTINCT category FROM books WHERE category IS NOT NULL AND category <> ''";

    try (Connection conn = DBUtils.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {

        while (rs.next()) {
            list.add(rs.getString("category"));
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

public Book getBookByISBN(String isbn) {
    String sql = "SELECT * FROM books WHERE isbn = ?";
    try (Connection conn = DBUtils.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, isbn);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return new Book(
                rs.getInt("id"),
                rs.getString("title"),
                rs.getString("author"),
                rs.getString("isbn"),
                rs.getString("category"),
                rs.getInt("published_year"),
                rs.getInt("total_copies"),
                rs.getInt("available_copies"),
                rs.getString("status")
            );
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}



}
