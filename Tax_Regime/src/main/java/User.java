import java.util.Date;

public class User {
    private String pno;
    private String name;
    private String level;
    private Date date; // Changed type to Date
    private String switchOption;

    public User(String pno, String name, String level, Date date, String switchOption) {
        this.pno = pno;
        this.name = name;
        this.level = level;
        this.date = date;
        this.switchOption = switchOption;
    }

    // Getters and Setters
    public String getPno() {
        return pno;
    }

    public void setPno(String pno) {
        this.pno = pno;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getSwitchOption() {
        return switchOption;
    }

    public void setSwitchOption(String switchOption) {
        this.switchOption = switchOption;
    }
}
