<jsp:include page="/view/header.jsp"></jsp:include>
<jsp:include page="/view/navigation.jsp"></jsp:include>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	if(ValidateField.checkUser(session)){
		response.sendRedirect("./");
		return;
	}
%>
<div class="container-fluid">
	<br><br>
	<div class="container">
		<h5>Tracks</h5>
		<hr>
		<%@ page errorPage="error.jsp"%>
		<%@ page import="admin.ValidateField"%>
	    <%@ page import="link.Link"%>
		<%@ page import="java.sql.*"%>
		<%! public Connection link = Link.getConnection(); %>
		<div class="row">
			<%
				PreparedStatement stmt = link.prepareStatement("SELECT * FROM category ORDER BY cname ASC");
				ResultSet result = stmt.executeQuery();
				while (result.next()){
					int cid 	 = result.getInt("cid");
					String cname = result.getString("cname");
					out.println("<a href='topics.jsp?cat=" + cid + "'><div class='tabs'>" + cname + "</div></a>");
		        }
				stmt.close();
			%>
		</div>
	</div>
</div>
<jsp:include page="/view/footer.jsp"></jsp:include>