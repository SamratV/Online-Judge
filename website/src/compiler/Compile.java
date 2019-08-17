package compiler;

import admin.FileUtility;
import admin.Test;
import admin.ValidateField;
import com.google.gson.Gson;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

public class Compile extends HttpServlet {

	private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        if(ValidateField.checkUser(session)) return;
        try{
            String code      = request.getParameter("source");
            String qid       = request.getParameter("qid");
            String lang      = request.getParameter("lang");
            String action    = request.getParameter("action");
            String marks     = request.getParameter("marks");
            String cid       = request.getParameter("cid");
	        String tid       = request.getParameter("tid");
	        String date      = request.getParameter("date");
	        String time      = request.getParameter("time");
	        String duration  = request.getParameter("duration");
            InitData id      = new InitData(getServletContext(), session, lang);
	        Test tst         = new Test();
	        boolean test     = tid != null;
	        boolean practice = cid != null;
	        int tc_count     = Integer.parseInt(request.getParameter("tc_count"));

	        if(test){
		        tst = new Test(date, time, Integer.parseInt(duration));
		        if(tst.isOver()){
			        printOutput(response, OutputFormatter.getFormattedOutput("The test is over."), 2);
			        return;
		        }
	        }

            if(code.length() == 0){
                printOutput(response, OutputFormatter.getFormattedOutput("No code was written. Please write some code."), 1);
            }else if(code.length() > 51200){
                printOutput(response, OutputFormatter.getFormattedOutput("Your code is too large(> 50 KB)."), 1);
            }else{
                String mode  = action.equals("submit") ? "private" : "public";

                if(CompilerUtility.setup(id.getSetupArgs(tc_count)) == 0){

                    FileUtility.writeFile(id.getFilename(), code);
                    CompilerUtility.fromDB(qid, mode, id.getStdin(), id.getDbout());
                    String exit_log = CompilerUtility.compile(id.getCompileArgs());

                    if(exit_log != null && exit_log.contains("Success.")){
	                    Process[] p       = new Process[tc_count + 1];
	                    String[][] result = new String[tc_count + 1][];
	                    int[] fail        = new int[tc_count + 1];
	                    int passed_tc     = 0;
	                    int max_time      = Integer.MIN_VALUE;
	                    long max_mem      = Long.MIN_VALUE;

                        for(int i = 1; i <= tc_count; ++i){
                            ProcessBuilder pb = new ProcessBuilder(id.getRunArgs(i));
                            p[i] = pb.start();
                        }

                        for(int i = tc_count; i >= 1; --i){
                            p[i].waitFor();

                            result[i] = CompilerUtility.getResultArray(p[i].getInputStream());
	                        max_mem   = CompilerUtility.max(max_mem, Long.parseLong(result[i][1]));
	                        max_time  = CompilerUtility.max(max_time, Integer.parseInt(result[i][2]));

							// System.out.println(result[i][0] + " " + result[i][1] + " " + result[i][2] + " " + result[i][3]);

							if(result[i][3].equals("0") && result[i][4].equals("0")){
		                        ++passed_tc;
	                        }else{
		                        fail[i] = 1;
	                        }
                        }

                        boolean pass      = tc_count == passed_tc;
	                    int flag          = pass ? 0 : 1;
	                    String[] x        = {pass ? "Success." : "Error.", Long.toString(max_mem), Integer.toString(max_time)};
	                    String warning    = FileUtility.readFile(id.getErrfile());
	                    StringBuilder res = new StringBuilder(OutputFormatter.getFormattedInit(x, id.getJaildir(), warning));

                        if(mode.equals("public")){
							for(int i = 1; i <= tc_count; ++i){
								String userOut;
								if(FileUtility.getFileSize(id.getOutFile(i)) > 10240){
									userOut = OutputFormatter.getOutputTooLargeText();
								}else{
									String stdout = FileUtility.readFile(id.getOutFile(i));
									if(stdout == null || stdout.length() == 0){
										userOut = OutputFormatter.getNoOutputText();
									}else{
										userOut = stdout.replace(id.getJaildir(), "");
									}
								}

								String status;
								if(fail[i] == 1 && result[i][0].equals("Success.")){
									status = "Wrong answer. ";
								}else{
									status = result[i][0] + " ";
								}

								res.append(OutputFormatter.getLineBreak())
									.append(OutputFormatter.getHeader("TESTCASE " + i))
									.append(OutputFormatter.wrapMessage(
										"Status: " + status
									+   (fail[i] == 0 ? OutputFormatter.getTick() : OutputFormatter.getCross())
									+   OutputFormatter.getSeparator()
									+   OutputFormatter.getHeader("STDIN")
									+   FileUtility.readFile(id.getInFile(i)) + OutputFormatter.getSeparator()
									+   OutputFormatter.getHeader("EXPECTED OUTPUT")
									+   FileUtility.readFile(id.getDBOutFile(i)) + OutputFormatter.getSeparator()
									+   OutputFormatter.getHeader("YOUR OUTPUT")
									+   userOut
								));
							}
                        }else{
							if(pass){
								res.append(OutputFormatter.getLineBreak())
									.append(OutputFormatter.getHeader("STATUS"))
									.append(OutputFormatter.wrapMessage(
										OutputFormatter.getTick()
									+   " You have passed all the testcase(s)."
								));
							}else{
								res.append(OutputFormatter.getLineBreak())
									.append(OutputFormatter.getHeader("STATUS"))
									.append(OutputFormatter.wrapMessage(
										OutputFormatter.getCross()
									+   " You did not pass the following testcase(s): "
									+   OutputFormatter.getFailedTC(fail)
								));
							}

							// Store submissions and calculate rank
	                        if(test || practice){
		                        Submission sub = new Submission();
		                        sub.setUsername(id.getUsername());
		                        sub.setLang(lang);
		                        sub.setCode(code);
		                        sub.setQid(Integer.parseInt(qid));
		                        sub.setCtid(Integer.parseInt(test ? tid : cid));
		                        sub.setMarks(Integer.parseInt(marks));
		                        sub.setTotal(tc_count);
		                        sub.setPassed(passed_tc);
		                        sub.setSolved(pass ? 1 : 0);
		                        sub.setTime(max_time);
		                        sub.setMemory(max_mem);
		                        sub.setSuccess(pass);
		                        sub.setTimestamp(test ? tst.getCurrent() : new Date().getTime());
		                        sub.setFulltime(test ? Integer.parseInt(duration) * 60000 : 0);
		                        sub.setEndtime(test ? tst.getEnd() : 0);

		                        if(test){
			                        new Thread(()-> CompilerUtility.updateTR(sub)).start();
		                        }else{
			                        new Thread(()-> CompilerUtility.updatePR(sub)).start();
		                        }
	                        }
                        }

                        printOutput(response, OutputFormatter.wrapOutput(res.toString()), flag);
                    }else{
                        if(exit_log == null){
                            printOutput(response, OutputFormatter.getFormattedOutput("System error: Unable to compile."), 1);
                        }else{
                            String error = FileUtility.readFile(id.getErrfile());
                            printOutput(response, OutputFormatter.getFormattedCTE(exit_log, error, id.getJaildir()), 1);
                        }
                    }
                }else{
                    printOutput(response, OutputFormatter.getFormattedOutput("System error: Setup failure."), 1);
                }
            }
        }catch(Exception e){
            e.printStackTrace();
            try{
                printOutput(response, OutputFormatter.getFormattedOutput("System error: Controller exception."), 1);
            }catch(Exception ex){
                ex.printStackTrace();
            }
        }
    }

    /*
    * flag = 0 => Success
    * flag = 1 => Error
    * flag = 2 => Question is a test question and it has been submitted after the test has ended
    */
    private void printOutput(HttpServletResponse response, String result, int flag) throws IOException {
	    PrintWriter out = response.getWriter();
	    OutputData x 	= new OutputData(flag, result);
	    String JsonObj	= new Gson().toJson(x);
	    response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    out.print(JsonObj);
	    out.flush();
    }

    class OutputData{
		public int flag;
		public String result;

	    OutputData(int flag, String result) {
		    this.flag = flag;
		    this.result = result;
	    }
    }
}