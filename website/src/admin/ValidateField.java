package admin;

import link.Link;
import org.apache.commons.validator.GenericValidator;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ValidateField {

	private static Connection link = Link.getConnection();

	public static boolean isAdmin(HttpSession session){
		return session.getAttribute("role") != null && session.getAttribute("role").equals("admin");
	}

	public static boolean checkSession(HttpSession session){
		boolean t1 = session.getAttribute("role") == null || !(
					 session.getAttribute("role").equals("admin") ||
					 session.getAttribute("role").equals("editor")
				);

		return checkUser(session) || t1;
	}

	public static boolean checkUser(HttpSession session){
		return session.getAttribute("username") == null;
	}

	public static boolean checkField(String field) {
		String regex = "^[a-zA-Z]+([a-zA-Z0-9_:+-]|[\\s])*$";
		return !GenericValidator.isBlankOrNull(field)
				&& GenericValidator.maxLength(field, 100)
				&& GenericValidator.matchRegexp(field, regex);
	}
	
	public static boolean checkQuestion(String qtitle, String qmarks, String qtc_public, String qtc_private, String qstatement) {
		boolean t1 = getInt(qtc_public) > 0;
		boolean t2 = getInt(qtc_private) > 0;
		boolean t3 = getInt(qmarks) > 0;
		return t1 && t2 && t3 && checkQuestion(qtitle, qstatement);
	}

	public static boolean checkQuestion(String qtitle, String qstatement) {
		boolean t1 = !GenericValidator.isBlankOrNull(qstatement)
				   && GenericValidator.maxLength(qstatement, 102400);
		boolean t2 = checkField(qtitle);
		return t1 && t2;
	}

	public static boolean checkTest(String name, String lang, String span, String date, String hour, String min, String qno, String desc){
		boolean t1 = checkField(name);
		boolean t2 = lang.equals("all") || lang.equals("c") || lang.equals("cpp") || lang.equals("java") || lang.equals("python");
		boolean t3 = GenericValidator.isInRange(getInt(span), 1, 360);
		boolean t4 = checkDate(date);
		boolean t5 = GenericValidator.isInRange(getInt(hour), 0, 23);
		boolean t6 = GenericValidator.isInRange(getInt(min), 0, 59);
		boolean t7 = GenericValidator.isInRange(getInt(qno), 1, 12);
		boolean t8 = !GenericValidator.isBlankOrNull(desc)
				   && GenericValidator.maxLength(desc, 102400);
		return t1 && t2 && t3 && t4 && t5 && t6 && t7 && t8;
	}

	public static PreparedStatement checkTSDate(String pref, String date, String date1, String date2, String query, int start, int count){
		PreparedStatement stmt = null;
		query = GenericValidator.isBlankOrNull(query) ? "%" : "%" + query + "%";

		try{
			if(pref != null && (pref.equals("on") || pref.equals("after") || pref.equals("before"))){
				if(checkDate(date)){
					String sign = pref.equals("on") ? "=" : (pref.equals("after") ? ">" : "<");
					String sqlQuery = "SELECT tid, name, date, time FROM test WHERE name LIKE ? AND date " + sign + " ? ORDER BY date DESC LIMIT ?, ?";
					stmt = link.prepareStatement(sqlQuery);
					stmt.setString(1, query);
					stmt.setString(2, date);
					stmt.setInt(3, start);
					stmt.setInt(4, count);
				}
			}else if(pref != null && pref.equals("between")){
				if(checkDate(date1) && checkDate(date2) && compareDate(date1, date2)){
					String sqlQuery = "SELECT tid, name, date, time FROM test WHERE name LIKE ? AND date >= ? AND date <= ? ORDER BY date DESC LIMIT ?, ?";
					stmt = link.prepareStatement(sqlQuery);
					stmt.setString(1, query);
					stmt.setString(2, date1);
					stmt.setString(3, date2);
					stmt.setInt(4, start);
					stmt.setInt(5, count);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
			stmt = null;
		}

		return stmt;
	}

	public static int countTest(String pref, String date, String date1, String date2, String query){
		int n = 0;
		query = GenericValidator.isBlankOrNull(query) ? "%" : "%" + query + "%";
		try{
			if(pref != null && (pref.equals("on") || pref.equals("after") || pref.equals("before"))){
				if(checkDate(date)){
					String sqlQuery = "SELECT COUNT(tid) AS num FROM test WHERE name LIKE ? AND date = ?";
					PreparedStatement stmt = link.prepareStatement(sqlQuery);
					stmt.setString(1, query);
					stmt.setString(2, date);
					ResultSet result = stmt.executeQuery();
					if(result.next()){
						n = result.getInt("num");
					}
					stmt.close();
				}
			}else if(pref != null && pref.equals("between")){
				if(checkDate(date1) && checkDate(date2) && compareDate(date1, date2)){
					String sqlQuery = "SELECT COUNT(tid) AS number FROM test WHERE name LIKE ? AND date >= ? AND date <= ?";
					PreparedStatement stmt = link.prepareStatement(sqlQuery);
					stmt.setString(1, query);
					stmt.setString(2, date1);
					stmt.setString(3, date2);
					ResultSet result = stmt.executeQuery();
					if(result.next()){
						n = result.getInt("number");
					}
					stmt.close();
				}
			}
		}catch(Exception e){
			e.printStackTrace();
			n = 0;
		}

		return n;
	}

	private static boolean checkDate(String date){
		return GenericValidator.isDate(date, "yyyy-MM-dd", true);
	}

	private static boolean compareDate(String date1, String date2){
		try{
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Date d1 = sdf.parse(date1);
			Date d2 = sdf.parse(date2);

			return d1.compareTo(d2) <= 0;
		}catch(Exception e){
			e.printStackTrace();
		}

		return false;
	}

	public static boolean isValidQid(String qid){
		boolean flag = false;
		int n = getInt(qid);
		if(n != Integer.MIN_VALUE){
			try{
				PreparedStatement stmt = link.prepareStatement("SELECT qid FROM questions WHERE qid=?");
				stmt.setInt(1, n);
				ResultSet result = stmt.executeQuery();
				flag = result.next();
				stmt.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return flag;
	}

	public static QData getQData(String qid){
		int n = getInt(qid);
		QData x = new QData();
		if(n != Integer.MIN_VALUE){
			try{
				String query = "SELECT q.qtitle, q.qmarks, q.qtc_public, q.qtc_private, q.scid, q.tid,"
						     + " q.qstatement, q.uploaded, s.cid, c.clang FROM questions AS q LEFT OUTER JOIN"
						     + " subcategory AS s ON q.scid = s.scid LEFT OUTER JOIN category AS c ON"
						     + " s.cid = c.cid WHERE q.qid=?";
				PreparedStatement stmt = link.prepareStatement(query);
				stmt.setInt(1, n);
				ResultSet result = stmt.executeQuery();
				if(result.next()){
					x.setUploaded(result.getInt("uploaded") == 1);
					x.setId(n);
					x.setMarks(result.getInt("qmarks"));
					x.setTc_public(result.getInt("qtc_public"));
					x.setTc_private(result.getInt("qtc_private"));
					x.setCid(result.getInt("cid"));
					x.setScid(result.getInt("scid"));
					x.setValid(result.getInt("tid") < 1);
					x.setStatement(result.getString("qstatement"));
					x.setTitle(result.getString("qtitle"));
					x.setLang(result.getString("clang"));
				}
				stmt.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return x;
	}

	public static int getInt(String s){
		int n;
		try{
			n = Integer.parseInt(s);
		}catch(Exception e){
			n = Integer.MIN_VALUE;
		}
		return n;
	}

	public static int getPageNo(String x){
		int n;
		try{
			n = Integer.parseInt(x);
		}catch(Exception e){
			n = 1;
		}
		return n;
	}

	public static int countQuestions(String scat){
		SData sd = getSData(scat);
		return sd.getQcount();
	}

	public static CSData getCSData(String cat, String scat){
		CSData x = new CSData();
		int n = getInt(cat), m = getInt(scat);
		if(n != Integer.MIN_VALUE && m != Integer.MIN_VALUE) {
			try{
				String query = "SELECT c.cname, sc.scname FROM category AS c LEFT OUTER JOIN"
							 + " subcategory AS sc ON c.cid=sc.cid WHERE sc.cid=? AND sc.scid=?";
				PreparedStatement stmt = link.prepareStatement(query);
				stmt.setInt(1, n);
				stmt.setInt(2, m);
				ResultSet result = stmt.executeQuery();
				if(result.next()){
					x.setCid(n);
					x.setScid(m);
					x.setValid(true);
					x.setCname(result.getString("cname"));
					x.setScname(result.getString("scname"));
				}
				stmt.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return x;
	}

	public static CData getCData(String cat){
		CData x = new CData();
		int n = getInt(cat);
		if(n != Integer.MIN_VALUE){
			try{
				String query = "SELECT c.cname, COUNT(sc.scid) AS scount FROM category AS c"
						     + " LEFT OUTER JOIN subcategory AS sc ON c.cid=sc.cid WHERE c.cid=?";
				PreparedStatement stmt = link.prepareStatement(query);
				stmt.setInt(1, n);
				ResultSet result = stmt.executeQuery();
				if(result.next() && result.getString("cname") != null){
					x.setCid(n);
					x.setCname(result.getString("cname"));
					x.setScount(result.getInt("scount"));
					x.setValid(true);
					x.setDeleteable(x.getScount() == 0);
				}
				stmt.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return x;
	}

	public static SData getSData(String scat){
		SData x = new SData();
		int n = getInt(scat);
		if(n != Integer.MIN_VALUE){
			try{
				String query = "SELECT s.scname, COUNT(q.qid) AS qcount FROM subcategory AS s"
							 + " LEFT OUTER JOIN questions AS q ON s.scid=q.scid WHERE s.scid=?";
				PreparedStatement stmt = link.prepareStatement(query);
				stmt.setInt(1, n);
				ResultSet result = stmt.executeQuery();
				if(result.next() && result.getString("scname") != null){
					x.setScid(n);
					x.setQcount(result.getInt("qcount"));
					x.setScname(result.getString("scname"));
					x.setValid(true);
					x.setDeleteable(x.getQcount() == 0);
				}
				stmt.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return x;
	}

	public static int countCat(){
		int count = 0;
		try{
			PreparedStatement stmt = link.prepareStatement("SELECT COUNT(cid) AS number FROM category");
			ResultSet result = stmt.executeQuery();
			while(result.next()){
				String x = result.getString("number");
				count = Integer.parseInt(x);
			}
			stmt.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		return count;
	}

	public static String getLang(String l){
		if(GenericValidator.isBlankOrNull(l)) return null;
		else if(l.equals("c"))			      return "C";
		else if(l.equals("cpp"))	          return "C++";
		else if(l.equals("java"))	          return "Java";
		else if(l.equals("python"))	          return "Python";
		else						          return "All";
	}

	public static TData getTData(String tid){
		TData x = new TData();
		int n = getInt(tid);
		if(n != Integer.MIN_VALUE){
			try{
				String query = "SELECT t.name, t.lang, t.description, t.duration,"
						     + " t.no_of_questions, t.date, t.time, COUNT(q.qid) AS"
						     + " qcount FROM test AS t LEFT OUTER JOIN questions AS"
						     + " q ON t.tid=q.tid WHERE t.tid=? AND q.uploaded=1";
				PreparedStatement stmt = link.prepareStatement(query);
				stmt.setInt(1, n);
				ResultSet result = stmt.executeQuery();
				if(result.next() && result.getString("name") != null){
					x.setTid(n);
					x.setName(result.getString("name"));
					x.setLang(result.getString("lang"));
					x.setDesc(result.getString("description"));
					x.setDate(result.getString("date"));
					x.setTime(result.getString("time"));
					x.setDuration(result.getInt("duration"));
					x.setQno(result.getInt("no_of_questions"));
					x.setUqno(result.getInt("qcount"));
					x.setValid(true);
					x.setUploaded(x.getUqno() == x.getQno());

					Test t = new Test(x.getDate(), x.getTime(), x.getDuration());
					x.setOver(t.isOver());
					x.setUpcomimg(t.isUpcoming());
					x.setLive(t.isLive());
					x.setTime_remaining(t.getRemaining());
				}
				stmt.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return x;
	}

	public static TQData getTQData(String qid){
		TQData x = new TQData();
		int n = getInt(qid);
		if(n != Integer.MIN_VALUE){
			try{
				String query = "SELECT t.tid, t.lang, t.duration, t.date, t.time, q.qtitle,"
						     + " q.qstatement, q.qtc_public, q.qtc_private, q.qmarks, q.uploaded FROM"
						     + " test AS t LEFT OUTER JOIN questions AS q ON t.tid=q.tid WHERE q.qid=?";
				PreparedStatement stmt = link.prepareStatement(query);
				stmt.setInt(1, n);
				ResultSet result = stmt.executeQuery();
				if(result.next()){
					x.setId(n);
					x.setMarks(result.getInt("qmarks"));
					x.setTc_public(result.getInt("qtc_public"));
					x.setTc_private(result.getInt("qtc_private"));
					x.setStatement(result.getString("qstatement"));
					x.setTitle(result.getString("qtitle"));
					x.setTid(result.getInt("tid"));
					x.setLang(result.getString("lang"));
					x.setTest_duration(result.getInt("duration"));
					x.setTest_date(result.getString("date"));
					x.setTest_time(result.getString("time"));
					x.setValid(true);
					x.setUploaded(result.getInt("uploaded") == 1);

					Test t = new Test(x.getTest_date(), x.getTest_time(), x.getTest_duration());
					x.setOver(t.isOver());
					x.setUpcomimg(t.isUpcoming());
					x.setLive(t.isLive());
					x.setTime_remaining(t.getRemaining());
				}
				stmt.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return x;
	}

	public static QSol getQSol(String qid){
		QSol x = new QSol();
		int n = getInt(qid);
		if(n != Integer.MIN_VALUE){
			try{
				String query = "SELECT code, code_lang FROM questions WHERE qid=?";
				PreparedStatement stmt = link.prepareStatement(query);
				stmt.setInt(1, n);
				ResultSet result = stmt.executeQuery();
				if(result.next()){
					x.setQid(n);
					x.setLang(result.getString("code_lang"));
					x.setCode(result.getString("code"));
				}
				stmt.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return x;
	}

	public static QSol getQSol(String qid, String username){
		QSol x = new QSol();
		int n = getInt(qid);
		if(n != Integer.MIN_VALUE){
			try{
				String query = "SELECT q.code, q.code_lang, (SELECT COUNT(qid) FROM submissions WHERE qid=q.qid AND solved=1 AND username=?) AS solved FROM questions AS q WHERE q.qid=?";
				PreparedStatement stmt = link.prepareStatement(query);
				stmt.setString(1, username);
				stmt.setInt(2, n);
				ResultSet result = stmt.executeQuery();
				if(result.next() && result.getString("code_lang") != null){
					x.setQid(n);
					x.setLang(result.getString("code_lang"));
					x.setCode(result.getString("code"));
					x.setSolved(result.getInt("solved") > 0);
					x.setValid(true);
				}
				stmt.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return x;
	}

	public static int getPQCount(){
		return counter("SELECT COUNT(qid) AS num FROM questions WHERE uploaded=0");
	}

	public static int getPTCount(){
		return counter("SELECT COUNT(t.tid) AS num FROM test AS t WHERE"
			 + " t.no_of_questions != (SELECT COUNT(q.qid) FROM questions AS q WHERE"
			 + " q.uploaded=1 AND q.tid=t.tid)");
	}

	private static int counter(String query){
		int n = 0;
		try{
			PreparedStatement stmt = link.prepareStatement(query);
			ResultSet result = stmt.executeQuery();
			n = result.next() ? result.getInt("num") : 0;
			stmt.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		return n;
	}

	public static int getQCount(String q){
		int n = 0;
		try{
			String query = "SELECT COUNT(qid) AS num FROM questions WHERE qtitle LIKE ?";
			PreparedStatement stmt = link.prepareStatement(query);
			stmt.setString(1, "%" + q + "%");
			ResultSet result = stmt.executeQuery();
			n = result.next() ? result.getInt("num") : 0;
			stmt.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		return n;
	}

	public static int countLiveTests(){
		return counter("SELECT COUNT(tid) AS num FROM test WHERE TIMESTAMP(date, time) < NOW() AND NOW() < TIMESTAMP(date, time) + INTERVAL duration MINUTE");
	}

	public static int countUpcomingTests(){
		return counter("SELECT COUNT(tid) AS num FROM test WHERE TIMESTAMP(date, time) > NOW()");
	}

	public static int countSubmissions(int qid, String username){
		int n = 0;
		try{
			String query = "SELECT COUNT(qid) AS num FROM submissions WHERE qid=? AND username=?";
			PreparedStatement stmt = link.prepareStatement(query);
			stmt.setInt(1, qid);
			stmt.setString(2, username);
			ResultSet result = stmt.executeQuery();
			n = result.next() ? result.getInt("num") : 0;
			stmt.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		return n;
	}

	public static String getTestRank(int tid, String username){
		String query = "SELECT (SELECT COUNT(username) FROM test_score WHERE tid=t.tid AND (marks>t.marks OR (marks=t.marks AND cmp_index>t.cmp_index))) + 1 AS rank FROM test_score AS t WHERE t.tid=? AND t.username=?";
		return getRank(query, tid, username);
	}

	public static String getCategoryRank(int cid, String username){
		String query = "SELECT (SELECT COUNT(username) FROM score WHERE cid=s.cid AND marks>s.marks) + 1 AS rank FROM score AS s WHERE s.cid=? AND s.username=?";
		return getRank(query, cid, username);
	}

	private static String getRank(String query, int id, String username){
		int n = -1;
		try{
			PreparedStatement stmt = link.prepareStatement(query);
			stmt.setInt(1, id);
			stmt.setString(2, username);
			ResultSet result = stmt.executeQuery();
			n = result.next() ? result.getInt("rank") : -1;
			stmt.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		return n == -1 ? "NA" : Integer.toString(n);
	}

	private static int countParticipants(String query, int id){
		int n = 0;
		try{
			PreparedStatement stmt = link.prepareStatement(query);
			stmt.setInt(1, id);
			ResultSet result = stmt.executeQuery();
			n = result.next() ? result.getInt("num") : 0;
			stmt.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		return n;
	}

	public static int countTestParticipants(int tid){
		String query = "SELECT COUNT(t.username) AS num FROM users AS u LEFT OUTER JOIN test_score AS t ON u.username=t.username WHERE t.tid=?";
		return countParticipants(query, tid);
	}

	public static int countCategoryParticipants(int cid){
		String query = "SELECT COUNT(s.username) AS num FROM users AS u LEFT OUTER JOIN score AS s ON u.username=s.username WHERE s.cid=?";
		return countParticipants(query, cid);
	}

	public static String getLikeExpr(String like){
		return like == null || like.length() == 0 ? "%" : "%" + like + "%";
	}

	public static int countDisapproved(){
		return counter("SELECT COUNT(username) AS num FROM users WHERE approved=0");
	}

	public static int countUnconfirmed(){
		return counter("SELECT COUNT(username) AS num FROM users WHERE confirmed=0");
	}

	public static String capitalize(String s){
		return GenericValidator.isBlankOrNull(s)
			 ? ""
			 : Character.toUpperCase(s.charAt(0)) + s.substring(1);
	}

	public static UData getUData(String username){
		UData x = new UData();
		try{
			String query = "SELECT u.*, (SELECT dept_name FROM dept WHERE dept_id=u.dept_id) AS dept FROM users AS u WHERE u.username=?";
			PreparedStatement stmt = link.prepareStatement(query);
			stmt.setString(1, username);
			ResultSet result = stmt.executeQuery();
			if(result.next()){
				x.setValid(true);
				x.setConfirmed(result.getInt("confirmed") == 1);
				x.setApproved(result.getInt("approved") == 1);
				x.setFullname(result.getString("fullname"));
				x.setUsername(result.getString("username"));
				x.setDob(result.getString("dob"));
				x.setBatch(result.getString("session"));
				x.setRoll(result.getString("rollno"));
				x.setDept_name(result.getString("dept"));
				x.setEmail(result.getString("email"));
				x.setRole(result.getString("role"));
				x.setProfession(result.getString("profession"));
				x.setLast_activity(result.getString("last_activity"));
				x.setDept_id(result.getInt("dept_id"));
				x.setToken(result.getString("reset_token"));
				x.setToken_time(result.getString("time_token"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return x;
	}
}