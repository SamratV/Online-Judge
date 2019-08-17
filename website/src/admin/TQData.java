package admin;

public class TQData {
	private boolean valid;
	private boolean uploaded;
	private boolean over;
	private boolean live;
	private boolean upcomimg;
	private int id;
	private int marks;
	private int tc_public;
	private int tc_private;
	private int tid;
	private int test_duration;
	private long time_remaining;
	private String title;
	private String statement;
	private String lang;
	private String test_date;
	private String test_time;

	public TQData() {
		id = Integer.MIN_VALUE;
		marks = Integer.MIN_VALUE;
		tc_public = Integer.MIN_VALUE;
		tc_private = Integer.MIN_VALUE;
		tid = Integer.MIN_VALUE;
		test_duration = Integer.MIN_VALUE;
		time_remaining = Long.MIN_VALUE;
	}

	public long getTime_remaining() {
		return time_remaining;
	}

	public void setTime_remaining(long time_remaining) {
		this.time_remaining = time_remaining;
	}

	public boolean isOver() {
		return over;
	}

	public void setOver(boolean over) {
		this.over = over;
	}

	public boolean isLive() {
		return live;
	}

	public void setLive(boolean live) {
		this.live = live;
	}

	public boolean isUpcomimg() {
		return upcomimg;
	}

	public void setUpcomimg(boolean upcomimg) {
		this.upcomimg = upcomimg;
	}

	public int getTid() {
		return tid;
	}

	public void setTid(int tid) {
		this.tid = tid;
	}

	public int getTest_duration() {
		return test_duration;
	}

	public void setTest_duration(int test_duration) {
		this.test_duration = test_duration;
	}

	public String getTest_date() {
		return test_date;
	}

	public void setTest_date(String test_date) {
		this.test_date = test_date;
	}

	public String getTest_time() {
		return test_time;
	}

	public void setTest_time(String test_time) {
		this.test_time = test_time;
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