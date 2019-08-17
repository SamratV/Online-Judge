package admin;

import link.Link;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class Subcategory extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
    
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) {
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		if(ValidateField.checkSession(session))	return;
		try {
			Connection link = Link.getConnection();
			String cat = request.getParameter("redirect");

			if(request.getParameter("scat_name") != null){
				String x = request.getParameter("scat_name");

				if(ValidateField.checkField(x)) {
					PreparedStatement stmt = link.prepareStatement("INSERT INTO subcategory (scname,cid) VALUES(?,?)");
					stmt.setString(1, x);
					stmt.setInt(2, Integer.parseInt(cat));
					stmt.executeUpdate();
					stmt.close();
				}

				response.sendRedirect("ea/subcategories.jsp?cat=" + cat);
			}else if(request.getParameter("update_scat_name") != null) {
				String x = request.getParameter("update_scat_name");
				String y = request.getParameter("update_scat_id");

				if (ValidateField.checkField(x)) {
					PreparedStatement stmt = link.prepareStatement("UPDATE subcategory SET scname=? WHERE scid=?");
					stmt.setString(1, x);
					stmt.setInt(2, Integer.parseInt(y));
					stmt.executeUpdate();
					stmt.close();
				}

				response.sendRedirect("ea/subcategories.jsp?cat=" + cat);
			}else if(ValidateField.isAdmin(session) && request.getParameter("scat_delete") != null){
				String x = request.getParameter("scat_delete");

				SData sd = ValidateField.getSData(x);
				if(sd.isDeleteable()){
					PreparedStatement stmt = link.prepareStatement("DELETE FROM subcategory WHERE scid=? LIMIT 1");
					stmt.setInt(1, sd.getScid());
					stmt.executeUpdate();
					stmt.close();
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
}