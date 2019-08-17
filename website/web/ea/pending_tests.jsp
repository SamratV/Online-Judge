<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
<body>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="link.Link"%>
<%@ page import="java.sql.*"%>
<%@ page import="admin.Pager"%>
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
					<h2 class="page-header">Pending test uploads</h2>
				</div>
			</div>
			<!-- /.row -->
			<div class="container col-lg-12">
				<table class="table table-striped">
					<thead>
					<tr>
						<th scope="col">#</th>
						<th scope="col">Test name</th>
						<th scope="col">Date</th>
						<th scope="col">Time</th>
						<th scope="col">View</th>
					</tr>
					</thead>
					<tbody>
					<%
						String query = "SELECT t.tid, t.name, t.date, t.time FROM test AS t"
								     + " WHERE t.no_of_questions != (SELECT COUNT(q.qid) FROM"
								     + " questions AS q WHERE q.uploaded=1 AND q.tid=t.tid)"
								     + " ORDER BY t.tid DESC LIMIT ?, ?";
						PreparedStatement stmt = link.prepareStatement(query);
						stmt.setInt(1, page_current);
						stmt.setInt(2, per_page);
						ResultSet result = stmt.executeQuery();
						while(result.next()){
							int tid  = result.getInt("tid");
							String n = result.getString("name");
							String d = result.getString("date");
							String t = result.getString("time");
							out.println("<tr><th scope='row'>" + tid + "</th>");
							out.println("<td>" + n + "</td>");
							out.println("<td>" + d + "</td>");
							out.println("<td>" + t + "</td>");
							out.println("<td><a href='../ea/test_details.jsp?tid=" + tid + "'><i class='fas fa-link'></i></a></td></tr>");
						}
						stmt.close();
					%>
					</tbody>
				</table>
			</div>
			<%
				int count   = ValidateField.getPTCount();
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