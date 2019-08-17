package compiler;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

class InitData {
	private String username;
	private String workspace;
	private String stdin;
	private String stdout;
	private String dbout;
	private String jail;
	private String filename;
	private String dir;
	private String jaildir;
	private String errfile;
	private String lang;

	InitData(ServletContext context, HttpSession session, String lang) {
		this.lang = lang;
		username  = session.getAttribute("username").toString().toLowerCase();
		workspace = context.getInitParameter("workspace");
		dir       = workspace + username + "/";
		stdin     = dir + "in/";
		stdout    = dir + "out/";
		dbout     = dir + "db_out/";
		jail      = "/cryptic_security/jail/";
		filename  = dir + "Solution." + getExtension(lang);
		jaildir   = "/code/" + username + "/";
		errfile   = dir + "err.txt";
	}

	private static String getExtension(String lang){
		return lang.equals("python") ? "py" : lang;
	}

	String getUsername() {
		return username;
	}

	String getStdin() {
		return stdin;
	}

	String getStdout() {
		return stdout;
	}

	String getDbout() {
		return dbout;
	}

	String getFilename() {
		return filename;
	}

	String getDir() {
		return dir;
	}

	String getJaildir() {
		return jaildir;
	}

	String getErrfile() {
		return errfile;
	}

	String getInFile(int i){
		return stdin + i + ".txt";
	}

	String getOutFile(int i){
		return stdout + i + ".txt";
	}

	String getDBOutFile(int i){
		return dbout + i + ".txt";
	}

	String[] getSetupArgs(int tc_count){
		return new String[]{"/liboj/bin/ssw", username, workspace, Integer.toString(tc_count), jail, lang};
	}

	String[] getCompileArgs(){
		return new String[]{"/liboj/bin/csw", jaildir, lang, jail};
	}

	String[] getRunArgs(int i){
		return new String[]{"/liboj/bin/rsw", jaildir, lang, Integer.toString(i), jail, dir};
	}
}