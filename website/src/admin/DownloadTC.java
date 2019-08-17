package admin;

import link.Link;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.FileInputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DownloadTC extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        if(ValidateField.checkSession(session)) return;
        try{
            ServletContext context 	= request.getServletContext();
            String qid 				= request.getParameter("qid");
            String username         = session.getAttribute("username").toString().toLowerCase();
            String folder			= context.getInitParameter("io") + "q" + qid; // Location of testcases
            String filePath			= context.getInitParameter("temp") + username + "/"; // Path to zip file
            String fileName         = "q" + qid + ".zip"; // Name of zip file
            String zip              = filePath + fileName;

            FileUtility.delDir(filePath);
            FileUtility.makeDir(filePath);
            fromDB(folder, qid);
            ZipUtility.zip(zip, folder);
            FileUtility.delDir(folder);

            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            response.setContentType("APPLICATION/OCTET-STREAM");
            response.setHeader("Content-Disposition","attachment; filename=\"" + fileName + "\"");

            FileInputStream fileInputStream = new FileInputStream(zip);

            int i;
            while((i = fileInputStream.read()) != -1) out.write(i);
            fileInputStream.close();
            out.close();
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    private void fromDB(String folder, String qid) throws SQLException {
        FileUtility.delDir(folder);
        FileUtility.makeDir(folder);
        FileUtility.makeDir(folder + "/public");
        FileUtility.makeDir(folder + "/public/input");
        FileUtility.makeDir(folder + "/public/output");
        FileUtility.makeDir(folder + "/private");
        FileUtility.makeDir(folder + "/private/input");
        FileUtility.makeDir(folder + "/private/output");

        Connection link = Link.getConnection();
        PreparedStatement stmt = link.prepareStatement("SELECT * FROM testcases WHERE qid=?");
        stmt.setInt(1, Integer.parseInt(qid));
        ResultSet result = stmt.executeQuery();

        while(result.next()){
            String number   = result.getString("tc_no");
            String type     = result.getString("tc_type");
            String stdin    = result.getString("tc_in");
            String stdout   = result.getString("tc_out");

            String in_path  = folder + "/" + type + "/input/" + number + ".txt";
            String out_path = folder + "/" + type + "/output/" + number + ".txt";

            FileUtility.writeFile(in_path, stdin);
            FileUtility.writeFile(out_path, stdout);
        }
        stmt.close();
    }
}