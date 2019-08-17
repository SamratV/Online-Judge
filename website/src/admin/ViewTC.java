package admin;

import com.google.gson.Gson;
import link.Link;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ViewTC extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        if(ValidateField.checkSession(session)) return;
        try{
            String qid 	  = request.getParameter("qid");
            String tc_cat = request.getParameter("tc_cat");
            String tc_no  = request.getParameter("tc_no");
            String query  = "SELECT tc_in, tc_out FROM testcases WHERE tc_type=? AND tc_no=? AND qid=?";
            String input  = "";
            String output = "";

            Connection link = Link.getConnection();
            PreparedStatement stmt = link.prepareStatement(query);
            stmt.setString(1, tc_cat);
            stmt.setInt(2, Integer.parseInt(tc_no));
            stmt.setInt(3, Integer.parseInt(qid));
            ResultSet result = stmt.executeQuery();

            while(result.next()){
                input  = result.getString("tc_in");
                output = result.getString("tc_out");
            }
            stmt.close();

            PrintWriter out = response.getWriter();
            tc x 			= new tc(input, output);
            String JsonObj	= new Gson().toJson(x);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            out.print(JsonObj);
            out.flush();
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    class tc{

        public String input, output;

        public tc(String input, String output) {
            this.input 	= input;
            this.output = output;
        }
    }
}