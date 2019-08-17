package auth;

import admin.ValidateField;
import link.Link;
import javax.servlet.http.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class auth extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
    	try {
    		Connection link = Link.getConnection();
        	HttpSession session = request.getSession();

        	String email 	= request.getParameter("email").toLowerCase();
        	String password = request.getParameter("password");
        	String username = request.getParameter("username");
        	String cookie 	= request.getParameter("cookie");
		    int status 	    = ValidateField.getInt(request.getParameter("status"));

        	if(status == 0){ // Login
        		String query = "SELECT username, password, role, confirmed, approved FROM users WHERE email=?";
        		PreparedStatement stmt = link.prepareStatement(query);
        		stmt.setString(1, email);
        		ResultSet result = stmt.executeQuery();

        		String db_username = "";
        		String db_password = "";
        		String db_role 	   = "";

        		int cnf = 0, app = 0;

        		while (result.next()){
        			db_username = result.getString("username");
        			db_password = result.getString("password");
        			db_role 	= result.getString("role");
        			cnf         = result.getInt("confirmed");
        			app         = result.getInt("approved");
                }
        		stmt.close();

        		if(db_username.equals("")){
        			response.sendRedirect("index.jsp?auth_error=1");
        		}else{
        			if(AuthUtility.checkPassword(password, db_password)){
				        if(cnf == 0){
					        response.sendRedirect("confirm.jsp?u=" + db_username);
				        }else if(app == 0){
					        response.sendRedirect("index.jsp?auth_error=8");
				        }else{
					        AuthUtility.sess_init(email, db_username, cookie, db_role, session, response);
					        response.sendRedirect("home.jsp");
				        }
        			}else{
				        response.sendRedirect("index.jsp?auth_error=2");
        			}
        		}
        	}else if(status == 1){ // Sign up
        		if(!AuthUtility.isValidUsername(username)) {
        			response.sendRedirect("index.jsp?auth_error=3");
        			return;
        		}else if(AuthUtility.attributeExists("username", username)) {
        			response.sendRedirect("index.jsp?auth_error=4");
        			return;
        		}else if(!AuthUtility.isValidEmail(email)){
        			response.sendRedirect("index.jsp?auth_error=5");
        			return;
        		}else if(AuthUtility.attributeExists("email", email)){
        			response.sendRedirect("index.jsp?auth_error=6");
        			return;
        		}else if(!AuthUtility.isValidPassword(password)) {
        			response.sendRedirect("index.jsp?auth_error=7");
        			return;
        		}
        		String query = "INSERT INTO users (username, email, password) VALUES(?,?,?)";
                PreparedStatement stmt = link.prepareStatement(query);
                stmt.setString(1, username);
                stmt.setString(2, email);
                stmt.setString(3, AuthUtility.hashPassword(password));
                stmt.executeUpdate();
                stmt.close();

		        response.sendRedirect("confirm.jsp?u=" + username);
        	}
    	}catch(Exception e) {
    		e.printStackTrace();
    	}
    }
}