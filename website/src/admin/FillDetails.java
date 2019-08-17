package admin;

import link.Link;
import org.apache.commons.validator.GenericValidator;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class FillDetails extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response){
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		if(!ValidateField.isAdmin(session)) return;
		try{
			String username   = request.getParameter("username");
			String fullname   = request.getParameter("fullname");
			String dob        = request.getParameter("dob");
			String profession = request.getParameter("profession");
			String roll       = request.getParameter("roll");
			String batch      = request.getParameter("session");
			String dept       = request.getParameter("dept");
			String role       = request.getParameter("role");
			String confirmed  = request.getParameter("confirmed");
			String approved   = request.getParameter("app");

			if(!GenericValidator.isBlankOrNull(fullname) && GenericValidator.matchRegexp(fullname, "^([a-zA-Z]|[\\s])*$")){
				Connection link = Link.getConnection();

				if(batch == null){
					String query = "UPDATE users SET fullname=?, dob=?, profession=?, dept_id=?, role=?, confirmed=?, approved=? WHERE username=?";
					PreparedStatement stmt = link.prepareStatement(query);
					stmt.setString(1, fullname);
					stmt.setString(2, dob);
					stmt.setString(3, profession);
					stmt.setInt(4, Integer.parseInt(dept));
					stmt.setString(5, role);
					stmt.setInt(6, Integer.parseInt(confirmed));
					stmt.setInt(7, Integer.parseInt(approved));
					stmt.setString(8, username);
					stmt.executeUpdate();
					stmt.close();
				}else{
					String query = "UPDATE users SET fullname=?, dob=?, profession=?, rollno=?, dept_id=?, role=?, session=?, confirmed=?, approved=? WHERE username=?";
					PreparedStatement stmt = link.prepareStatement(query);
					stmt.setString(1, fullname);
					stmt.setString(2, dob);
					stmt.setString(3, profession);
					stmt.setString(4, roll);
					stmt.setInt(5, Integer.parseInt(dept));
					stmt.setString(6, role);
					stmt.setString(7, batch);
					stmt.setInt(8, Integer.parseInt(confirmed));
					stmt.setInt(9, Integer.parseInt(approved));
					stmt.setString(10, username);
					stmt.executeUpdate();
					stmt.close();
				}
			}

			response.sendRedirect("ea/user_details.jsp?u=" + username);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}