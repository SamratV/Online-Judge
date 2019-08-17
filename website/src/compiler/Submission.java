package compiler;

class Submission {
	private String username;
	private String lang;
	private String code;
	private int qid;
	private int ctid;
	private int marks;
	private int total;
	private int passed;
	private int solved;
	private int time;
	private long memory;
	private long timestamp;
	private long fulltime;
	private long endtime;
	private boolean success;

	Submission() {
		qid = Integer.MIN_VALUE;
		ctid = Integer.MIN_VALUE;
		marks = Integer.MIN_VALUE;
		total = Integer.MIN_VALUE;
		passed = Integer.MIN_VALUE;
		solved = Integer.MIN_VALUE;
		time = Integer.MIN_VALUE;
		memory = Long.MIN_VALUE;
		timestamp = Long.MIN_VALUE;
	}

	String getUsername() {
		return username;
	}

	void setUsername(String username) {
		this.username = username;
	}

	String getLang() {
		return lang;
	}

	void setLang(String lang) {
		this.lang = lang;
	}

	String getCode() {
		return code;
	}

	void setCode(String code) {
		this.code = code;
	}

	int getQid() {
		return qid;
	}

	void setQid(int qid) {
		this.qid = qid;
	}

	int getCtid() {
		return ctid;
	}

	void setCtid(int ctid) {
		this.ctid = ctid;
	}

	int getMarks() {
		return marks;
	}

	void setMarks(int marks) {
		this.marks = marks;
	}

	int getTotal() {
		return total;
	}

	void setTotal(int total) {
		this.total = total;
	}

	int getPassed() {
		return passed;
	}

	void setPassed(int passed) {
		this.passed = passed;
	}

	int getSolved() {
		return solved;
	}

	void setSolved(int solved) {
		this.solved = solved;
	}

	int getTime() {
		return time;
	}

	void setTime(int time) {
		this.time = time;
	}

	long getMemory() {
		return memory;
	}

	void setMemory(long memory) {
		this.memory = memory;
	}

	long getTimestamp() {
		return timestamp;
	}

	void setTimestamp(long timestamp) {
		this.timestamp = timestamp;
	}

	boolean isSuccess() {
		return success;
	}

	void setSuccess(boolean success) {
		this.success = success;
	}

	long getFulltime() {
		return fulltime;
	}

	void setFulltime(long fulltime) {
		this.fulltime = fulltime;
	}

	long getEndtime() {
		return endtime;
	}

	void setEndtime(long endtime) {
		this.endtime = endtime;
	}
}