<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
<body>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="admin.UData"%>
<%@ page import="link.Link"%>
<%@ page import="java.sql.*"%>
<%! public Connection link = Link.getConnection(); %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	if(ValidateField.checkSession(session)){
		response.sendRedirect("../");
		return;
	}

	String user = request.getParameter("u");
	UData ud    = ValidateField.getUData(user);

	if(!ud.isValid()){
		response.sendRedirect("./");
		return;
	}
%>
<div id="wrapper">

	<jsp:include page="/ea/view/admin_navigation.jsp"></jsp:include>

	<div id="page-wrapper">

		<div class="container-fluid">

			<!-- Page Heading -->
			<div class="row">
				<div class="col-lg-12">
					<h2 class="page-header">Domain ranks &raquo; <%=ud.getFullname()%></h2>
				</div>
			</div>
			<!-- /.row -->
			<div class="container col-lg-6">
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
		<!-- /.container-fluid -->

	</div>
	<!-- /#page-wrapper -->

</div>
<!-- /#wrapper -->
<jsp:include page="/ea/view/admin_footer.jsp"></jsp:include>
</body>
</html>