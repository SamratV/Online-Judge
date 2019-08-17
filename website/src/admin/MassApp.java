package admin;

import link.Link;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class MassApp extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response){
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		if(!ValidateField.isAdmin(session)) return;
		try{
			String app  = request.getParameter("app");
			String dept = request.getParameter("dept");
			String prof = request.getParameter("profession");
			String sess = request.getParameter("session");
			String user = session.getAttribute("username").toString();

			Connection link = Link.getConnection();
			PreparedStatement stmt;

			if(sess == null){
				String query = "UPDATE users SET approved=? WHERE dept_id=? AND profession=? AND username <> ?";
				stmt = link.prepareStatement(query);
				stmt.setInt(1, Integer.parseInt(app));
				stmt.setInt(2, Integer.parseInt(dept));
				stmt.setString(3, prof);
				stmt.setString(4, user);
			}else{
				String query = "UPDATE users SET approved=? WHERE dept_id=? AND profession=? AND session=? AND username <> ?";
				stmt = link.prepareStatement(query);
				stmt.setInt(1, Integer.parseInt(app));
				stmt.setInt(2, Integer.parseInt(dept));
				stmt.setString(3, prof);
				stmt.setString(4, sess);
				stmt.setString(5, user);
			}

			stmt.executeUpdate();
			stmt.close();

			response.sendRedirect("ea/message.jsp");
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
