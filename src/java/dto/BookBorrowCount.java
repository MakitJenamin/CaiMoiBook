package dto;

public class BookBorrowCount {
    private String bookTitle;
    private int borrowCount;

    public BookBorrowCount(String bookTitle, int borrowCount) {
        this.bookTitle = bookTitle;
        this.borrowCount = borrowCount;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public int getBorrowCount() {
        return borrowCount;
    }

    public void setBorrowCount(int borrowCount) {
        this.borrowCount = borrowCount;
    }
} 