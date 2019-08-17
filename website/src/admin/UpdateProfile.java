package admin;

import link.Link;
import org.apache.commons.validator.GenericValidator;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class UpdateProfile extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response){
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		if(ValidateField.checkSession(session)) return;
		try{
			String username = session.getAttribute("username").toString();
			String fullname = request.getParameter("fullname");
			String dob      = request.getParameter("dob");
			String roll     = request.getParameter("roll");
			String batch    = request.getParameter("session");
			String dept     = request.getParameter("dept");

			if(!GenericValidator.isBlankOrNull(fullname) && GenericValidator.matchRegexp(fullname, "^([a-zA-Z]|[\\s])*$")){
				Connection link = Link.getConnection();

				if(batch == null){
					String query = "UPDATE users SET fullname=?, dob=?, dept_id=? WHERE username=?";
					PreparedStatement stmt = link.prepareStatement(query);
					stmt.setString(1, fullname);
					stmt.setString(2, dob);
					stmt.setInt(3, Integer.parseInt(dept));
					stmt.setString(4, username);
					stmt.executeUpdate();
					stmt.close();
				}else{
					String query = "UPDATE users SET fullname=?, dob=?, rollno=?, dept_id=?, session=? WHERE username=?";
					PreparedStatement stmt = link.prepareStatement(query);
					stmt.setString(1, fullname);
					stmt.setString(2, dob);
					stmt.setString(3, roll);
					stmt.setInt(4, Integer.parseInt(dept));
					stmt.setString(5, batch);
					stmt.setString(6, username);
					stmt.executeUpdate();
					stmt.close();
				}
			}

			response.sendRedirect("edit_profile.jsp?success=1");
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}