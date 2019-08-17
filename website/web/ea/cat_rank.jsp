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

	String cid = request.getParameter("cid");
	CData cd   = ValidateField.getCData(cid);

	if(!cd.isValid()){
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
<%@ page import="admin.CData"%>
<%@ page import="admin.Pager"%>
<%! public Connection link = Link.getConnection(); %>
<div id="wrapper">

	<jsp:include page="/ea/view/admin_navigation.jsp"></jsp:include>

	<div id="page-wrapper">

		<div class="container-fluid">

			<!-- Page Heading -->
			<div class="row">
				<div class="col-lg-12">
					<h2 class="page-header">Domain / Category ranks &raquo; <%=cd.getCname()%></h2>
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
						String query = "SELECT (SELECT COUNT(username) FROM score WHERE cid=s.cid AND marks>s.marks) + 1 AS rank, u.fullname, u.username, u.session, u.rollno, (SELECT dept_name FROM dept WHERE dept_id=u.dept_id) AS dept, s.marks FROM users AS u LEFT OUTER JOIN score AS s ON u.username=s.username WHERE s.cid=? ORDER BY s.marks DESC LIMIT ?, ?";
						PreparedStatement stmt = link.prepareStatement(query);
						stmt.setInt(1, cd.getCid());
						stmt.setInt(2, page_current);
						stmt.setInt(3, per_page);
						ResultSet result = stmt.executeQuery();
						while(result.next()){
							int rank        = result.getInt("rank");
							int marks       = result.getInt("marks");
							String name     = result.getString("fullname");
							String username = result.getString("username");
							String batch    = result.getString("session");
							String roll     = result.getString("rollno");
							String dept     = result.getString("dept");
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
				int count   = ValidateField.countCategoryParticipants(cd.getCid());
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