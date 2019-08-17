package admin;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.FileInputStream;
import java.io.PrintWriter;


public class DownloadQS extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) {
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		if(ValidateField.checkSession(session)) return;
		try{
			ServletContext context = request.getServletContext();
			String qid 			   = request.getParameter("qid");
			String details         = request.getParameter("details");
			String username        = session.getAttribute("username").toString().toLowerCase();
			String filePath		   = context.getInitParameter("temp") + username + "/";
			String name            = "q" + qid + "_details.txt";
			String file            = filePath + name;

			FileUtility.delDir(filePath);
			FileUtility.makeDir(filePath);
			FileUtility.writeFile(file, details);

			response.setContentType("text/html");
			response.setContentType("APPLICATION/OCTET-STREAM");
			response.setHeader("Content-Disposition","attachment; filename=\"" + name + "\"");

			FileInputStream fis = new FileInputStream(file);
			PrintWriter out     = response.getWriter();

			int i;
			while((i = fis.read()) != -1) out.write(i);
			fis.close();
			out.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}