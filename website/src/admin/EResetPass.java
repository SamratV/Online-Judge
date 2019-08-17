package admin;

import auth.AuthUtility;
import auth.Mailer;
import link.Link;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.Date;

public class EResetPass extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response){
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		try{
			String user  = request.getParameter("username");
			String token = request.getParameter("token");
			String pass1 = request.getParameter("pass1");
			String pass2 = request.getParameter("pass2");
			UData ud     = ValidateField.getUData(user);

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date sent = sdf.parse(ud.getToken_time());
			Date now  = new Date();
			long time = (now.getTime() - sent.getTime()) / (1000 * 60);

			if(ud.isValid() && time < 15 && token.equals(ud.getToken()) && pass1.equals(pass2) && AuthUtility.isValidPassword(pass1)){
				Connection link = Link.getConnection();
				PreparedStatement stmt = link.prepareStatement("UPDATE users SET password=?, reset_token=? WHERE username=?");
				stmt.setString(1, AuthUtility.hashPassword(pass1));
				stmt.setString(2, Mailer.getRandomText());
				stmt.setString(3, user);
				stmt.executeUpdate();
				stmt.close();
				response.sendRedirect("reset_success.jsp");
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}