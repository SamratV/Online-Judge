package admin;

public class QData {
    private boolean valid;
    private boolean uploaded;
    private int id;
    private int marks;
    private int tc_public;
    private int tc_private;
    private int scid;
    private int cid;
    private String title;
    private String statement;
    private String lang;

    public QData() {
        id = Integer.MIN_VALUE;
        marks = Integer.MIN_VALUE;
        tc_public = Integer.MIN_VALUE;
        tc_private = Integer.MIN_VALUE;
        scid = Integer.MIN_VALUE;
        cid = Integer.MIN_VALUE;
    }

    public boolean isValid() {
        return valid;
    }

    public void setValid(boolean valid) {
        this.valid = valid;
    }

    public boolean isUploaded() {
        return uploaded;
    }

    public void setUploaded(boolean uploaded) {
        this.uploaded = uploaded;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getMarks() {
        return marks;
    }

    public void setMarks(int marks) {
        this.marks = marks;
    }

    public int getTc_public() {
        return tc_public;
    }

    public void setTc_public(int tc_public) {
        this.tc_public = tc_public;
    }

    public int getTc_private() {
        return tc_private;
    }

    public void setTc_private(int tc_private) {
        this.tc_private = tc_private;
    }

    public int getScid() {
        return scid;
    }

    public void setScid(int scid) {
        this.scid = scid;
    }

    public int getCid() {
        return cid;
    }

    public void setCid(int cid) {
        this.cid = cid;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getStatement() {
        return statement;
    }

    public void setStatement(String statement) {
        this.statement = statement;
    }

    public String getLang() {
        return lang;
    }

    public void setLang(String lang) {
        this.lang = lang;
    }
}