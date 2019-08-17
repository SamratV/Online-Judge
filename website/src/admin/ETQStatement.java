package admin;

import link.Link;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;

public class ETQStatement extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response){
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		if(ValidateField.checkSession(session)) return;
		try {
			Connection link = Link.getConnection();
			String qid	  		= request.getParameter("qid");
			String qtitle 		= request.getParameter("qtitle");
			String qstatement 	= request.getParameter("qstatement");

			if(ValidateField.checkQuestion(qtitle, qstatement)) {
				String query = "UPDATE questions SET qtitle=?, qstatement=? WHERE qid=?";
				PreparedStatement stmt = link.prepareStatement(query);
				stmt.setString(1, qtitle);
				stmt.setString(2, qstatement);
				stmt.setInt(3, Integer.parseInt(qid));
				stmt.executeUpdate();
				stmt.close();
			}

			response.sendRedirect("ea/edit_test_question.jsp?qid=" + qid);
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
}