package auth;

import admin.UData;
import admin.ValidateField;
import link.Link;
import org.apache.commons.validator.GenericValidator;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class CAMailer extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response){
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response){
		try{
			String username   = request.getParameter("username");
			String fullname   = request.getParameter("fullname");
			String dob        = request.getParameter("dob");
			String url        = request.getParameter("url");
			String profession = request.getParameter("profession");
			String roll       = request.getParameter("roll");
			String batch      = request.getParameter("session");
			String dept       = request.getParameter("dept");
			UData ud          = ValidateField.getUData(username);
			boolean valid     = ud.isValid() && !ud.isConfirmed() &&
					            !GenericValidator.isBlankOrNull(fullname) &&
					            GenericValidator.matchRegexp(fullname, "^([a-zA-Z]|[\\s])*$");

			if(valid){
				Connection link = Link.getConnection();
				String token    = Mailer.getRandomText();

				if(batch == null){
					String query = "UPDATE users SET fullname=?, dob=?, profession=?, dept_id=?, reset_token=?, time_token=NOW() WHERE username=?";
					PreparedStatement stmt = link.prepareStatement(query);
					stmt.setString(1, fullname);
					stmt.setString(2, dob);
					stmt.setString(3, profession);
					stmt.setInt(4, Integer.parseInt(dept));
					stmt.setString(5, token);
					stmt.setString(6, username);
					stmt.executeUpdate();
					stmt.close();
				}else{
					String query = "UPDATE users SET fullname=?, dob=?, profession=?, rollno=?, dept_id=?, session=?, reset_token=?, time_token=NOW() WHERE username=?";
					PreparedStatement stmt = link.prepareStatement(query);
					stmt.setString(1, fullname);
					stmt.setString(2, dob);
					stmt.setString(3, profession);
					stmt.setString(4, roll);
					stmt.setInt(5, Integer.parseInt(dept));
					stmt.setString(6, batch);
					stmt.setString(7, token);
					stmt.setString(8, username);
					stmt.executeUpdate();
					stmt.close();
				}

				String sub  = "Account confirmation";
				String text = "Click <a href='" + url + "confirmation.jsp?u=" + username + "&cat=" + token + "'>here</a> to" +
						      " confirm your account.<br><br>Note: The link will be active for 15 minutes only.";

				Mailer.send(ud.getEmail(), sub, text);

				response.sendRedirect("link_sent.jsp");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}