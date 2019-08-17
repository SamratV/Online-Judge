package auth;

import link.Link;
import org.apache.commons.validator.GenericValidator;
import org.mindrot.jbcrypt.BCrypt;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AuthUtility {
	static void  sess_init(String email, String username, String cookie, String role, HttpSession session, HttpServletResponse response){
		session.setAttribute("email", email);
		session.setAttribute("username", username);
		session.setAttribute("role", role);
		session.setMaxInactiveInterval(604800);
		if(cookie != null){
			Cookie x = new Cookie("username", username);
			x.setMaxAge(30*24*60*60);
			response.addCookie(x);
		}
	}

	public static String hashPassword(String password) {
		return BCrypt.hashpw(password, BCrypt.gensalt(12));
	}

	public static boolean checkPassword(String password, String hash) {
		return BCrypt.checkpw(password, hash);
	}

	static boolean isValidEmail(String e) {
		return !GenericValidator.isBlankOrNull(e)
			   && GenericValidator.maxLength(e, 320)
			   && GenericValidator.minLength(e, 3)
			   && GenericValidator.isEmail(e);
	}

	public static boolean isValidPassword(String p) {
		return !GenericValidator.isBlankOrNull(p)
			   && GenericValidator.maxLength(p, 100)
			   && GenericValidator.minLength(p, 6);
	}

	static boolean isValidUsername(String u) {
		String regex = "^[a-zA-Z]+(?:[_]?[a-zA-Z0-9])*$";
		return !GenericValidator.isBlankOrNull(u)
			   && GenericValidator.maxLength(u, 100)
			   && GenericValidator.minLength(u, 6)
			   && GenericValidator.matchRegexp(u, regex);
	}

	static boolean attributeExists(String attribute, String value) {
		try {
			Connection link = Link.getConnection();
			PreparedStatement stmt = link.prepareStatement("SELECT username FROM users WHERE " + attribute + " =?");
			stmt.setString(1, value);
			ResultSet result = stmt.executeQuery();
			boolean flag = result.next();
			stmt.close();

			return flag;
		}catch(Exception e) {
			e.printStackTrace();
		}

		return false;
	}
}