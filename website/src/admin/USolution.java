package admin;

import link.Link;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class USolution extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) {
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		if(ValidateField.checkSession(session)) return;
		try{
			String qid  = request.getParameter("qid");
			String lang = request.getParameter("lang");
			String code = request.getParameter("soln");
			QData qd    = ValidateField.getQData(qid);
			TQData tqd  = ValidateField.getTQData(qid);

			if(qd.isValid()){
				upload(Integer.parseInt(qid), lang, code);
				response.sendRedirect("ea/success.jsp");
			}else if(tqd.isValid()){
				upload(Integer.parseInt(qid), lang, code);
				response.sendRedirect("ea/test_details.jsp?tid=" + tqd.getTid());
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	private void upload(int qid, String lang, String code) throws SQLException {
		String query = "UPDATE questions SET uploaded=1, code_lang=?, code=? WHERE qid=?";
		Connection link = Link.getConnection();
		PreparedStatement stmt = link.prepareStatement(query);
		stmt.setString(1, lang);
		stmt.setString(2, code);
		stmt.setInt(3, qid);
		stmt.executeUpdate();
		stmt.close();
	}
}