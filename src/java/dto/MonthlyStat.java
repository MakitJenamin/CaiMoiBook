package dto;

public class MonthlyStat {
    private String month;
    private int borrowCount;

    public MonthlyStat(String month, int borrowCount) {
        this.month = month;
        this.borrowCount = borrowCount;
    }

    public String getMonth() {
        return month;
    }

    public void setMonth(String month) {
        this.month = month;
    }

    public int getBorrowCount() {
        return borrowCount;
    }

    public void setBorrowCount(int borrowCount) {
        this.borrowCount = borrowCount;
    }
} 