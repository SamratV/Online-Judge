package admin;

public class TData {
	private boolean valid;
	private boolean uploaded;
	private boolean over;
	private boolean live;
	private boolean upcomimg;
	private int tid;
	private int duration;
	private int qno;
	private int uqno;
	private long time_remaining;
	private String name;
	private String lang;
	private String desc;
	private String date;
	private String time;

	public TData() {
		tid = Integer.MIN_VALUE;
		duration = Integer.MIN_VALUE;
		qno = Integer.MIN_VALUE;
		time_remaining = Long.MIN_VALUE;
	}

	public int getUqno() {
		return uqno;
	}

	public void setUqno(int uqno) {
		this.uqno = uqno;
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

	public int getTid() {
		return tid;
	}

	public void setTid(int tid) {
		this.tid = tid;
	}

	public int getDuration() {
		return duration;
	}

	public void setDuration(int duration) {
		this.duration = duration;
	}

	public int getQno() {
		return qno;
	}

	public void setQno(int qno) {
		this.qno = qno;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getLang() {
		return lang;
	}

	public void setLang(String lang) {
		this.lang = lang;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}
}