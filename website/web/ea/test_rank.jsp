<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
<body>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	if(ValidateField.checkSession(session)){
		response.sendRedirect("../");
		return;
	}

	String tid = request.getParameter("tid");
	TData td   = ValidateField.getTData(tid);

	if(!td.isValid() || td.isUpcomimg()){
		response.sendRedirect("../ea/");
		return;
	}

	int pageno 		 = ValidateField.getPageNo(request.getParameter("pageno"));
	int per_page 	 = 10;
	int page_current = (pageno * per_page) - per_page;
%>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="link.Link"%>
<%@ page import="java.sql.*"%>
<%@ page import="admin.TData"%>
<%@ page import="compiler.OutputFormatter"%>
<%@ page import="admin.Pager"%>
<%! public Connection link = Link.getConnection(); %>
<div id="wrapper">

	<jsp:include page="/ea/view/admin_navigation.jsp"></jsp:include>

	<div id="page-wrapper">

		<div class="container-fluid">

			<!-- Page Heading -->
			<div class="row">
				<div class="col-lg-12">
					<h2 class="page-header">Test ranks &raquo; <%=td.getName()%></h2>
				</div>
			</div>
			<!-- /.row -->
			<div class="container col-lg-12">
				<table class="table table-striped">
					<thead>
					<tr>
						<th scope="col" class="text-center">Rank</th>
						<th scope="col" class="text-center">Fullname</th>
						<th scope="col" class="text-center">Session</th>
						<th scope="col" class="text-center">Roll number</th>
						<th scope="col" class="text-center">Department</th>
						<th scope="col" class="text-center">Marks</th>
						<th scope="col" class="text-center">User details</th>
					</tr>
					</thead>
					<tbody>
					<%
						String query = "SELECT (SELECT COUNT(username) FROM test_score WHERE tid=t.tid AND (marks>t.marks OR (marks=t.marks AND cmp_index>t.cmp_index))) + 1 AS rank, u.fullname, u.username, u.session, u.rollno, (SELECT dept_name FROM dept WHERE dept_id=u.dept_id) AS dept, t.marks FROM users AS u LEFT OUTER JOIN test_score AS t ON u.username=t.username WHERE t.tid=? ORDER BY t.marks DESC, t.cmp_index DESC LIMIT ?, ?";
						PreparedStatement stmt = link.prepareStatement(query);
						stmt.setInt(1, td.getTid());
						stmt.setInt(2, page_current);
						stmt.setInt(3, per_page);
						ResultSet result = stmt.executeQuery();
						while(result.next()){
							int rank        = result.getInt("rank");
							String name     = result.getString("fullname");
							String username = result.getString("username");
							String batch    = result.getString("session");
							String roll     = result.getString("rollno");
							String dept     = result.getString("dept");
							String marks    = OutputFormatter.round(result.getDouble("marks"));
					%>
					<tr>
						<th scope="row" class="text-center"><%=rank%></th>
						<td class="text-center"><%=name%></td>
						<td class="text-center"><%=batch%></td>
						<td class="text-center"><%=roll%></td>
						<td class="text-center"><%=dept%></td>
						<td class="text-center"><%=marks%></td>
						<td class="text-center">
							<a href="user_details.jsp?u=<%=username%>">
								<i style="color: #28a745; font-size: 150%;" class="fas fa-info-circle"></i>
							</a>
						</td>
					</tr>

					<%
						}
						stmt.close();
					%>
					</tbody>
				</table>
			</div>
			<%
				int count   = ValidateField.countTestParticipants(td.getTid());
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