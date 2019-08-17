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

	String user = session.getAttribute("username").toString();
	UData ud    = ValidateField.getUData(user);

	if(!ud.isValid()){
		response.sendRedirect("./");
		return;
	}
%>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="admin.UData"%>
<%@ page import="link.Link"%>
<%@ page import="java.sql.*"%>
<%! public Connection link = Link.getConnection(); %>
<div class="container-fluid">
	<br><br>
	<div class="container">
		<h5>Domain ranks</h5>
		<hr>
		<br>
		<div class="col-lg-8 table-center">
			<table class="table table-bordered table-hover text-center">
				<thead>
					<tr>
						<th class="col-xs-4 text-center">Domain name</th>
						<th class="col-xs-2 text-center">Rank</th>
					</tr>
				</thead>
				<tbody>
					<%
						String query = "SELECT (SELECT COUNT(username) FROM score WHERE cid=s.cid AND marks>s.marks) + 1 AS rank, (SELECT cname FROM category WHERE cid=s.cid) AS domain FROM score AS s WHERE s.username=? ORDER BY s.cid";
						PreparedStatement stmt = link.prepareStatement(query);
						stmt.setString(1, ud.getUsername());
						ResultSet result = stmt.executeQuery();
						while (result.next()){
					%>
					<tr>
						<td><%=result.getString("domain")%></td>
						<td><%=result.getInt("rank")%></td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
			<br><br>
		</div>
	</div>
</div>
<jsp:include page="/view/footer.jsp"></jsp:include>