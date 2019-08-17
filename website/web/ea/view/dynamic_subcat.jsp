<%@ page import="admin.ValidateField"%>
<%@ page import="link.Link"%>
<%@ page import="java.sql.*"%>
<%! public Connection link = Link.getConnection(); %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
	response.setContentType("text/html");
	response.setCharacterEncoding("UTF-8");

	if(ValidateField.checkSession(session))	return;
%>
<option selected disabled>-- Select --</option>
<%
	String cid = request.getParameter("cat");
	PreparedStatement stmt = link.prepareStatement("SELECT * FROM subcategory WHERE cid=? ORDER BY scname");
	stmt.setInt(1, Integer.parseInt(cid));
	ResultSet result = stmt.executeQuery();
	while(result.next()){
		int id 		= result.getInt("scid");
		String name = result.getString("scname");
		out.println("<option value='" + id + "'>" + name + "</option>");
	}
	stmt.close();
%>