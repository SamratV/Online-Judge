package admin;

import link.Link;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class EditTest extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response){
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		if(ValidateField.checkSession(session)) return;
		try{
			String tid  = request.getParameter("tid");
			String date = request.getParameter("date");
			String name = request.getParameter("name");
			String lang = request.getParameter("lang");
			String hour = request.getParameter("hour");
			String min  = request.getParameter("min");
			String span = request.getParameter("duration");
			String qno  = request.getParameter("qno");
			String desc = request.getParameter("description");

			if(ValidateField.checkTest(name, lang, span, date, hour, min, qno, desc)){
				String time = hour + ":" + min + ":00";

				Connection link = Link.getConnection();

				String query = "UPDATE test SET name=?, lang=?, duration=?, no_of_questions=?, date=?, time=?, description=? WHERE tid=?";
				PreparedStatement stmt = link.prepareStatement(query);
				stmt.setString(1, name);
				stmt.setString(2, lang);
				stmt.setInt(3, Integer.parseInt(span));
				stmt.setInt(4, Integer.parseInt(qno));
				stmt.setString(5, date);
				stmt.setString(6, time);
				stmt.setString(7, desc);
				stmt.setInt(8, Integer.parseInt(tid));
				stmt.executeUpdate();
				stmt.close();

				response.sendRedirect("ea/test_details.jsp?tid=" + tid);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}