package compiler;

import admin.FileUtility;
import link.Link;
import org.apache.commons.io.IOUtils;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.concurrent.TimeUnit;

class CompilerUtility {

	private static Connection link = Link.getConnection();

	static void fromDB(String qid, String mode, String stdin, String dbout) throws SQLException {
		String query = "SELECT tc_in, tc_out, tc_no FROM testcases WHERE qid=? AND tc_type=?";
		PreparedStatement stmt = link.prepareStatement(query);
		stmt.setInt(1, Integer.parseInt(qid));
		stmt.setString(2, mode);
		ResultSet result = stmt.executeQuery();
		while(result.next()){
			int i = result.getInt("tc_no");
			FileUtility.writeFile(stdin + i + ".txt", result.getString("tc_in"));
			FileUtility.writeFile(dbout + i + ".txt", result.getString("tc_out"));
		}
	}

	private static String execute(String[] cmd, int time) throws IOException, InterruptedException {
		ProcessBuilder pb = new ProcessBuilder(cmd);
		Process process   = pb.start();
		boolean tle       = !process.waitFor(time, TimeUnit.SECONDS);
		if(tle){
			process.destroy();
			process.waitFor();
		}

		return tle ? null : IOUtils.toString(process.getInputStream(), "UTF-8").trim();
	}

	static int setup(String[] cmd) throws IOException, InterruptedException {
		String x = execute(cmd, 10);
		return x == null || !x.contains("Success.") ? 1 : 0;
	}

	static String compile(String[] cmd) throws IOException, InterruptedException {
		return execute(cmd, 5);
	}

	static String[] getResultArray(InputStream in) throws IOException {
		// Message | Memory | Time | Exit code | Match
		return IOUtils.toString(in, "UTF-8").trim().split(":");
	}

	static long max(long a, long b){
		return a > b ? a : b;
	}

	static int max(int a, int b){
		return a > b ? a : b;
	}

	private static void addSubmission(Submission x) throws SQLException {
		String query = "INSERT INTO submissions (username, qid, time_solved, lang, passed_tc, qcode, "
				     + "solved, exec_time, exec_mem) VALUES(?,?,?,?,?,?,?,?,?)";
		PreparedStatement stmt = link.prepareStatement(query);
		stmt.setString(1, x.getUsername());
		stmt.setInt(2, x.getQid());
		stmt.setLong(3, x.getTimestamp());
		stmt.setString(4, x.getLang());
		stmt.setInt(5, x.getPassed());
		stmt.setString(6, x.getCode());
		stmt.setInt(7, x.getSolved());
		stmt.setInt(8, x.getTime());
		stmt.setLong(9, x.getMemory());
		stmt.executeUpdate();
		stmt.close();
	}

	private static boolean exists(String query, String username, int id) throws SQLException {
		PreparedStatement stmt = link.prepareStatement(query);
		stmt.setString(1, username);
		stmt.setInt(2, id);
		ResultSet result = stmt.executeQuery();
		boolean flag = result.next();
		stmt.close();
		return flag;
	}

	private static boolean existsPracticeScore(String username, int cid) throws SQLException {
		String query = "SELECT marks FROM score WHERE username=? AND cid=?";
		return exists(query, username, cid);
	}

	private static boolean existsTestScore(String username, int tid) throws SQLException {
		String query = "SELECT marks FROM test_score WHERE username=? AND tid=?";
		return exists(query, username, tid);
	}

	private static boolean requiresUpdate(int passed, int time, long memory, int _passed, int _time, long _memory){
		if(passed <= 0) return false;

		if(passed > _passed)                        return true;
		else if(passed == _passed && time < _time)  return true;
		else                                        return passed == _passed && time == _time && memory < _memory;
	}

	private static float langTimeLimit(String lang){ // Time in ms
		switch(lang){
			case "c":
			case "cpp":
				return 2000;
			case "java":
				return 4000;
			case "python":
				return 5000;
			default:
				return Integer.MIN_VALUE;
		}
	}

	private static float calculateCI(long end, long current, long full, long mem, int time, float tl){
		return ((end - current) * 1000000.f) / full
			 + (1.f - (time / tl)) * 10000.f
	         + (1.f - (mem / (128 * 1024 * 1024.f))) * 100.f;
	}

	static void updatePR(Submission sub){
		try{
			String query = "SELECT solved FROM submissions WHERE username=? AND qid=? LIMIT 1";
			PreparedStatement stmt = link.prepareStatement(query);
			stmt.setString(1, sub.getUsername());
			stmt.setInt(2, sub.getQid());
			ResultSet rs = stmt.executeQuery();
			boolean solved = rs.next() && rs.getInt("solved") == 1;
			stmt.close();

			addSubmission(sub);

			if(!solved && sub.isSuccess()){
				if(existsPracticeScore(sub.getUsername(), sub.getCtid())){
					query = "UPDATE score SET marks=marks+? WHERE username=? AND cid=?";
				}else{
					query = "INSERT INTO score (marks, username, cid) VALUES(?,?,?)";
				}

				stmt = link.prepareStatement(query);
				stmt.setInt(1, sub.getMarks());
				stmt.setString(2, sub.getUsername());
				stmt.setInt(3, sub.getCtid());
				stmt.executeUpdate();
				stmt.close();
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	static void updateTR(Submission sub){
		try{
			String query = "SELECT time_solved, passed_tc, solved, exec_time, exec_mem FROM"
					     + " submissions WHERE username=? AND qid=? ORDER BY passed_tc DESC"
					     + ", time_solved ASC, exec_time ASC, exec_mem ASC LIMIT 1";
			PreparedStatement stmt = link.prepareStatement(query);
			stmt.setString(1, sub.getUsername());
			stmt.setInt(2, sub.getQid());
			ResultSet rs    = stmt.executeQuery();
			int _passed     = Integer.MIN_VALUE;
			int _time       = Integer.MAX_VALUE;
			long _memory    = Long.MAX_VALUE;
			long _timestamp = Long.MAX_VALUE;
			boolean solved  = false;
			boolean exists  = false;
			if(rs.next()){
				_passed    = rs.getInt("passed_tc");
				_time      = rs.getInt("exec_time");
				_memory    = rs.getLong("exec_mem");
				_timestamp = rs.getLong("time_solved");
				solved     = rs.getInt("solved") == 1;
				exists     = true;
			}
			stmt.close();

			addSubmission(sub);

			if(!solved && requiresUpdate(sub.getPassed(), sub.getTime(), sub.getMemory(), _passed, _time, _memory)){
				float tl   = langTimeLimit(sub.getLang());
				float ci   = calculateCI(sub.getEndtime(), sub.getTimestamp(), sub.getFulltime(), sub.getMemory(), sub.getTime(), tl);
				float mrks = (sub.getPassed() / (sub.getTotal() * 1.f)) * sub.getMarks();

				if(exists){
					ci   -= calculateCI(sub.getEndtime(), _timestamp, sub.getFulltime(), _memory, _time, tl);
					mrks -= (_passed / (sub.getTotal() * 1.f)) * sub.getMarks();
				}

				if(existsTestScore(sub.getUsername(), sub.getCtid())){
					query = "UPDATE test_score SET marks=marks+?, cmp_index=cmp_index+? WHERE username=? AND tid=?";
				}else{
					query = "INSERT INTO test_score(marks, cmp_index, username, tid) VALUES(?,?,?,?)";
				}

				stmt = link.prepareStatement(query);
				stmt.setFloat(1, mrks);
				stmt.setFloat(2, ci);
				stmt.setString(3, sub.getUsername());
				stmt.setInt(4, sub.getCtid());
				stmt.executeUpdate();
				stmt.close();
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}