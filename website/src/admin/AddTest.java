package admin;

import link.Link;
import com.mysql.jdbc.Statement;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AddTest extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response){
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        if(ValidateField.checkSession(session)) return;
        try{
            String name = request.getParameter("name");
            String lang = request.getParameter("lang");
            String span = request.getParameter("duration");
            String date = request.getParameter("date");
            String hour = request.getParameter("hour");
            String min  = request.getParameter("min");
            String qno  = request.getParameter("qno");
            String desc = request.getParameter("description");

            if(ValidateField.checkTest(name, lang, span, date, hour, min, qno, desc)){
            	String time = hour + ":" + min + ":00";

            	Connection link = Link.getConnection();

            	String query = "INSERT INTO test(name, lang, duration, no_of_questions, date, time, description) VALUES(?,?,?,?,?,?,?)";
	            PreparedStatement stmt = link.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
	            stmt.setString(1, name);
	            stmt.setString(2, lang);
	            stmt.setInt(3, Integer.parseInt(span));
	            stmt.setInt(4, Integer.parseInt(qno));
	            stmt.setString(5, date);
	            stmt.setString(6, time);
	            stmt.setString(7, desc);
	            stmt.executeUpdate();
	            ResultSet result = stmt.getGeneratedKeys();
	            String id = "";
	            if(result.next()) id = result.getString(1);
	            stmt.close();

	            response.sendRedirect("ea/test_details.jsp?tid=" + id);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}