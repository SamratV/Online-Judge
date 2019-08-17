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
<%@ page import="admin.Pager" %>
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

	int pageno 		 = ValidateField.getPageNo(request.getParameter("pageno"));
	int per_page 	 = 10;
	int page_current = (pageno * per_page) - per_page;
%>
<div id="wrapper">

	<jsp:include page="/ea/view/admin_navigation.jsp"></jsp:include>

	<div id="page-wrapper">

		<div class="container-fluid">

			<!-- Page Heading -->
			<div class="row">
				<div class="col-lg-12">
					<h2 class="page-header">Test ranks &raquo; <%=ud.getFullname()%></h2>
				</div>
			</div>
			<!-- /.row -->
			<div class="container col-lg-12">
				<table class="table table-bordered table-hover text-center">
					<thead>
					<tr>
						<th class="col-xs-4 text-center">Test name</th>
						<th class="col-xs-2 text-center">Test date</th>
						<th class="col-xs-2 text-center">Rank</th>
					</tr>
					</thead>
					<tbody>
					<%
						String query = "SELECT (SELECT COUNT(username) FROM test_score WHERE tid=t.tid AND (marks>t.marks OR (marks=t.marks AND cmp_index>t.cmp_index))) + 1 AS rank, ts.name, ts.date FROM test_score AS t LEFT OUTER JOIN test AS ts ON t.tid=ts.tid WHERE t.username=? ORDER BY ts.tid LIMIT ?, ?";
						PreparedStatement stmt = link.prepareStatement(query);
						stmt.setString(1, ud.getUsername());
						stmt.setInt(2, page_current);
						stmt.setInt(3, per_page);
						ResultSet result = stmt.executeQuery();
						while (result.next()){
					%>
					<tr>
						<td><%=result.getString("name")%></td>
						<td><%=result.getString("date")%></td>
						<td><%=result.getInt("rank")%></td>
					</tr>
					<%
						}
					%>
					</tbody>
				</table>
				<br><br>
			</div>
			<%
				stmt = link.prepareStatement("SELECT COUNT(tid) AS num FROM test_score WHERE username=?");
				stmt.setString(1, ud.getUsername());
				result = stmt.executeQuery();
				int count = result.next() ? result.getInt("num") : 0;
				stmt.close();

				Pager pager = new Pager(pageno, per_page, count);
				out.println(pager.getPager());
			%>
		</div>
		<!-- /.container-fluid -->

	</div>
	<!-- /#page-wrapper -->

</div>
<!-- /#wrapper -->
<jsp:include page="/ea/view/admin_footer.jsp"></jsp:include>
</body>
</html>