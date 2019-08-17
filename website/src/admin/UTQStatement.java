package admin;

import link.Link;
import com.mysql.jdbc.Statement;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UTQStatement extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response){
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		if(ValidateField.checkSession(session))	return;
		try {
			Connection link = Link.getConnection();
			String qtitle 		= request.getParameter("qtitle");
			String qmarks 		= request.getParameter("qmarks");
			String qtc_public 	= request.getParameter("qtc_public");
			String qtc_private 	= request.getParameter("qtc_private");
			String tid 		    = request.getParameter("tid");
			String qstatement 	= request.getParameter("qstatement");

			if(ValidateField.checkQuestion(qtitle, qmarks, qtc_public, qtc_private, qstatement)) {
				String query = "INSERT INTO questions (qtitle, qstatement, qtc_public, qtc_private, qmarks, tid) VALUES(?,?,?,?,?,?)";
				PreparedStatement stmt = link.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
				stmt.setString(1, qtitle);
				stmt.setString(2, qstatement);
				stmt.setInt(3, Integer.parseInt(qtc_public));
				stmt.setInt(4, Integer.parseInt(qtc_private));
				stmt.setInt(5, Integer.parseInt(qmarks));
				stmt.setInt(6, Integer.parseInt(tid));
				stmt.executeUpdate();
				ResultSet result = stmt.getGeneratedKeys();
				String id = "";
				if(result.next()) id = result.getString(1);
				stmt.close();

				response.sendRedirect("ea/add_testcases.jsp?qid=" + id);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
}