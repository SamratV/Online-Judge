package compiler;

import admin.FileUtility;
import admin.ValidateField;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;

public class Tester extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) {
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		if(ValidateField.checkUser(session)) return;
		try{
			PrintWriter out = response.getWriter();
			String code     = request.getParameter("source");
			String lang     = request.getParameter("lang");
			String input    = request.getParameter("input");
			InitData id     = new InitData(getServletContext(), session, lang);

			response.setContentType("text/html");
			response.setCharacterEncoding("UTF-8");

			if(code.length() == 0){
				out.print(OutputFormatter.getFormattedOutput("No code was written. Please write some code."));
			}else if(code.length() > 51200){
				out.print(OutputFormatter.getFormattedOutput("Your code is too large(> 50 KB)."));
			}else{
				if(CompilerUtility.setup(id.getSetupArgs(1)) == 0){

					FileUtility.writeFile(id.getFilename(), code);
					FileUtility.writeFile(id.getInFile(1), input);
					String exit_log = CompilerUtility.compile(id.getCompileArgs());

					if(exit_log != null && exit_log.contains("Success.")){

						ProcessBuilder pb = new ProcessBuilder(id.getRunArgs(1));
						Process process = pb.start();
						process.waitFor();

						String[] x     = CompilerUtility.getResultArray(process.getInputStream());
						String warning = FileUtility.readFile(id.getErrfile());
						String stdout  = FileUtility.getFileSize(id.getOutFile(1)) > 1048576
								       ? OutputFormatter.getOutputTooLargeText()
								       : FileUtility.readFile(id.getOutFile(1));

						String result = OutputFormatter.getFormattedInit(x, id.getJaildir(), warning);

						if(stdout == null || stdout.length() == 0){
							result += OutputFormatter.getLineBreak()
								   +  OutputFormatter.getHeader("STDOUT")
								   +  OutputFormatter.wrapMessage(OutputFormatter.getNoOutputText());
						}else{
							result += OutputFormatter.getLineBreak()
								   +  OutputFormatter.getHeader("STDOUT")
								   +  OutputFormatter.wrapMessage(stdout.replace(id.getJaildir(), ""));
						}

						out.print(OutputFormatter.wrapOutput(result));
					}else{
						if(exit_log == null){
							out.print(OutputFormatter.getFormattedOutput("System error: Unable to compile."));
						}else{
							String error = FileUtility.readFile(id.getErrfile());
							out.print(OutputFormatter.getFormattedCTE(exit_log, error, id.getJaildir()));
						}
					}
				}else{
					out.print(OutputFormatter.getFormattedOutput("System error: Setup failure."));
				}
			}
		}catch(Exception e){
			e.printStackTrace();
			try{
				PrintWriter out = response.getWriter();
				out.print(OutputFormatter.getFormattedOutput("System error: Controller exception."));
			}catch(Exception ex){
				ex.printStackTrace();
			}
		}
	}
}