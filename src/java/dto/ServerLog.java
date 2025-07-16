package dto;

import java.io.Serializable;
import java.util.Date;

/**
 * ServerLog DTO
 * Lưu thông tin log của server
 */
public class ServerLog implements Serializable {
    private int id;
    private String action;
    private Date timestamp;
    private String details;
    
    public ServerLog() {
    }
    
    public ServerLog(int id, String action, Date timestamp, String details) {
        this.id = id;
        this.action = action;
        this.timestamp = timestamp;
        this.details = details;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    @Override
    public String toString() {
        return "ServerLog{" + "id=" + id + ", action=" + action + ", timestamp=" + timestamp + ", details=" + details + '}';
    }
} 