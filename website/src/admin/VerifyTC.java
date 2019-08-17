package admin;

import link.Link;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class VerifyTC extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
    
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response){
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        if(ValidateField.checkSession(session)) return;
		try {
		    boolean flag = false;
			String qid   = request.getParameter("qid");
			QData qd     = ValidateField.getQData(qid);
			TQData tqd   = ValidateField.getTQData(qid);

			if(qd.isValid() || tqd.isValid()){
				int id       = qd.isValid() ? qd.getId() : tqd.getId();
				int total    = qd.isValid() ?
						       qd.getTc_public() + qd.getTc_private() :
						       tqd.getTc_public() + tqd.getTc_private();
				String query = "SELECT COUNT(qid) AS number FROM testcases WHERE qid=?";

                Connection link = Link.getConnection();
                PreparedStatement stmt = link.prepareStatement(query);
                stmt.setInt(1, id);
                ResultSet result = stmt.executeQuery();
                flag = result.next() && result.getInt("number") == total;
            }

        	session.setAttribute("uploaded", flag);
            
			response.sendRedirect("ea/verify_upload.jsp?qid=" + qid);
		}catch(Exception e) {
		    e.printStackTrace();
        }
	}
}