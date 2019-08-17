<%@ page import="link.Link"%>
<%@ page import="java.sql.*"%>
<%@ page import="admin.ValidateField"%>
<%! public Connection link = Link.getConnection(); %>
<%
	try{
		response.setContentType("text/html");
		response.setCharacterEncoding("UTF-8");

		if(!ValidateField.checkUser(session)){
			String user	= session.getAttribute("username").toString();

			PreparedStatement stmt = link.prepareStatement("UPDATE users SET last_activity=NOW() WHERE username=?");
			stmt.setString(1, user);
			stmt.executeUpdate();
			stmt.close();

			stmt = link.prepareStatement("SELECT COUNT(username) AS num FROM users WHERE TIME_TO_SEC(TIMEDIFF(NOW(), last_activity))<=5");
			ResultSet rs = stmt.executeQuery();
			int count    = rs.next() ? rs.getInt("num") : 0;
			stmt.close();
			out.print(count);
		}
	}catch(Exception e){
		// No error logging required here.
	}
%>