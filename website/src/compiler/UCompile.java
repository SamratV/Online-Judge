package compiler;

import admin.FileUtility;
import admin.ValidateField;
import org.apache.commons.io.IOUtils;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;

public class UCompile extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) {
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		if(ValidateField.checkSession(session)) return;
		try{
			PrintWriter out = response.getWriter();
			String code     = request.getParameter("source");
			String lang     = request.getParameter("lang");
			String mode     = request.getParameter("mode");
			String qid      = request.getParameter("qid");
			int tc_count    = Integer.parseInt(request.getParameter("tc_count"));
			InitData id     = new InitData(getServletContext(), session, lang);

			response.setContentType("text/html");
			response.setCharacterEncoding("UTF-8");

			/*
			* Code printed by out.print():
			* ----------------------------
			* 1 = Correct
			* 2 = Wrong answer
			* 3 = Compile time error
			* 4 = Run time error
			* 5 = Large code (> 50 KB)
			* 6 = System error
			* 7 = No code written
			*/

			if(code.length() == 0){
				out.print("Error code: 7<br>No code was written. Please write some code.");
			}else if(code.length() > 51200){
				out.print("Error code: 5<br>Your code is too large(> 50 KB).");
			}else{
				if(CompilerUtility.setup(id.getSetupArgs(tc_count)) == 0){

					FileUtility.writeFile(id.getFilename(), code);
					CompilerUtility.fromDB(qid, mode, id.getStdin(), id.getDbout());
					String exit_log = CompilerUtility.compile(id.getCompileArgs());

					if(exit_log != null && exit_log.contains("Success.")){
						int[] tc = new int[tc_count + 1];
						Process[] p = new Process[tc_count + 1];

						for(int i = 1; i <= tc_count; ++i){
							ProcessBuilder pb = new ProcessBuilder(id.getRunArgs(i));
							p[i] = pb.start();
						}

						for(int i = tc_count; i >= 1; --i){
							p[i].waitFor();
							String x = IOUtils.toString(p[i].getInputStream(), "UTF-8").trim();
							tc[i] = x.startsWith("Success.") ? (x.endsWith(":0") ? 0 : 1) : 2;
						}

						StringBuilder x = new StringBuilder();
						StringBuilder y = new StringBuilder();
						for(int i = 1; i <= tc_count; ++i){
							if(tc[i] == 1){
								x.append(i).append(", ");
							}else if(tc[i] == 2){
								y.append(i).append(", ");
							}
						}

						boolean t1 = x.length() > 0;
						boolean t2 = y.length() > 0;
						if(t1 || t2){
							if(t1){
								x = new StringBuilder(x.substring(0, x.lastIndexOf(",")) + ".");
								out.print("Error code: 2<br>Answers do not match for the following testcase(s): " + x);
							}
							if(t2){
								y = new StringBuilder(y.substring(0, y.lastIndexOf(",")) + ".");
								out.print("Error code: 4<br>Run time error in the following testcase(s): " + y);
							}
						}else{
							out.print(1);
						}
					}else{
						if(exit_log == null){
							out.print("Error code: 6<br>System error: Unable to compile.");
						}else{
							out.print("Error code: 3<br>" + exit_log.split(":")[0]);
						}
					}
				}else{
					out.print("Error code: 6<br>System error: Setup failure.");
				}
			}
		}catch(Exception e){
			e.printStackTrace();
			try{
				PrintWriter out = response.getWriter();
				out.print("Error code: 6<br>System error: Controller exception.");
			}catch(Exception ex){
				ex.printStackTrace();
			}
		}
	}
}