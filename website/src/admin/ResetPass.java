package admin;

import auth.AuthUtility;
import link.Link;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ResetPass extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response){
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		if(ValidateField.checkUser(session)) return;
		try{
			String user  = session.getAttribute("username").toString();
			String pass  = request.getParameter("pass");
			String pass1 = request.getParameter("pass1");
			String pass2 = request.getParameter("pass2");

			Connection link = Link.getConnection();
			PreparedStatement stmt = link.prepareStatement("SELECT password FROM users WHERE username=?");
			stmt.setString(1, user);
			ResultSet result = stmt.executeQuery();
			String db_pass = result.next() ? result.getString("password") : "";
			stmt.close();

			if(!db_pass.equals("")){
				if(!AuthUtility.checkPassword(pass, db_pass)){
					response.sendRedirect("pass_reset.jsp?err=1");
				}else if(pass1.equals(pass2) && AuthUtility.isValidPassword(pass1)){
					stmt = link.prepareStatement("UPDATE users SET password=? WHERE username=?");
					stmt.setString(1, AuthUtility.hashPassword(pass1));
					stmt.setString(2, user);
					stmt.executeUpdate();
					stmt.close();
					response.sendRedirect("pass_reset.jsp?err=0");
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}