package auth;

import link.Link;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class FPMailer extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response){
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response){
		try{
			String url   = request.getParameter("url");
			String email = request.getParameter("email");

			Connection link = Link.getConnection();
			PreparedStatement stmt = link.prepareStatement("SELECT username FROM users WHERE email=?");
			stmt.setString(1, email);
			ResultSet result = stmt.executeQuery();
			String user = result.next() ? result.getString("username") : "";
			stmt.close();

			if(!user.equals("")){
				String token = Mailer.getRandomText();
				stmt = link.prepareStatement("UPDATE users SET reset_token=?, time_token=NOW() WHERE username=?");
				stmt.setString(1, token);
				stmt.setString(2, user);
				stmt.executeUpdate();
				stmt.close();

				String sub  = "Password reset";
				String text = "Click <a href='" + url + "recover.jsp?u=" + user + "&rt=" + token + "'>here</a> to" +
						      " reset your password.<br><br>Note: The link will be active for 15 minutes only.";

				Mailer.send(email, sub, text);

				response.sendRedirect("link_sent.jsp");
			}else{
				response.sendRedirect("email.jsp?error=1");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}