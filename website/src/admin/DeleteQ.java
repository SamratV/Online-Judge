package admin;

import link.Link;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class DeleteQ extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response){
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		if(!ValidateField.isAdmin(session)) return;
		try{
			String qid = request.getParameter("del_qid");
			Connection link = Link.getConnection();
			PreparedStatement stmt = link.prepareStatement("DELETE FROM questions WHERE qid=? LIMIT 1");
			stmt.setInt(1, Integer.parseInt(qid));
			stmt.executeUpdate();
			stmt.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}