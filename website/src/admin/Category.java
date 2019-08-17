package admin;

import link.Link;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class Category extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
    
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		if(ValidateField.checkSession(session))	return;
		try {
			Connection link = Link.getConnection();
			if(request.getParameter("cat_name") != null){
				String x = request.getParameter("cat_name");
				String y = request.getParameter("cat_lang");

				if(ValidateField.checkField(x)) {
					PreparedStatement stmt = link.prepareStatement("INSERT INTO category (cname, clang) VALUES(?,?)");
					stmt.setString(1, x);
					stmt.setString(2, y);
					stmt.executeUpdate();
					stmt.close();
				}

				response.sendRedirect("ea/categories.jsp");
			}else if(request.getParameter("update_cat_name") != null){
				String x  = request.getParameter("update_cat_name");
				String id = request.getParameter("update_cat_id");
				String y  = request.getParameter("update_cat_lang");

				if(ValidateField.checkField(x)) {
					PreparedStatement stmt = link.prepareStatement("UPDATE category SET cname=?, clang=? WHERE cid=?");
					stmt.setString(1, x);
					stmt.setString(2, y);
					stmt.setInt(3, Integer.parseInt(id));
					stmt.executeUpdate();
					stmt.close();
				}

				response.sendRedirect("ea/categories.jsp");
			}else if(ValidateField.isAdmin(session) && request.getParameter("cat_delete") != null){
				String x = request.getParameter("cat_delete");

				CData cd = ValidateField.getCData(x);
				if(cd.isDeleteable()){
					PreparedStatement stmt = link.prepareStatement("DELETE FROM category WHERE cid=? LIMIT 1");
					stmt.setInt(1, cd.getCid());
					stmt.executeUpdate();
					stmt.close();
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
    }
}