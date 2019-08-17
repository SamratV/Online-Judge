<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
<body>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
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
					<h2 class="page-header">Unconfirmed users</h2>
					<small class="text-muted">
						List of users whose email addresses haven't been confirmed by themselves.
					</small>
				</div>
			</div>
			<!-- /.row -->
			<div class="col-lg-12">
				<br><br>
				<table class="table table-striped">
					<thead>
					<tr>
						<th scope="col" class="text-center">#</th>
						<th scope="col" class="text-center">Fullname</th>
						<th scope="col" class="text-center">Username</th>
						<th scope="col" class="text-center">Department</th>
						<th scope="col" class="text-center">Profession</th>
						<th scope="col" class="text-center">User details</th>
					</tr>
					</thead>
					<tbody>
					<%
						PreparedStatement stmt = link.prepareStatement("SELECT u.fullname, u.username, u.profession, (SELECT dept_name FROM dept WHERE dept_id=u.dept_id) AS dept FROM users AS u WHERE u.confirmed=0 LIMIT ?, ?");
						stmt.setInt(1, page_current);
						stmt.setInt(2, per_page);
						ResultSet result = stmt.executeQuery();
						int i = (pageno - 1) * per_page + 1;
						while(result.next()){
							String fname      = result.getString("fullname");
							String uname      = result.getString("username");
							String dept_name  = result.getString("dept");
							String profession = result.getString("profession");
					%>
					<tr>
						<td class="text-center"><%=i%></td>
						<td class="text-center"><%=fname%></td>
						<td class="text-center"><%=uname%></td>
						<td class="text-center"><%=dept_name%></td>
						<td class="text-center"><%=ValidateField.capitalize(profession)%></td>
						<td class="text-center">
							<a href="user_details.jsp?u=<%=uname%>">
								<i style="color: #28a745; font-size: 150%;" class="fas fa-info-circle"></i>
							</a>
						</td>
					</tr>

					<%
							++i;
						}
						stmt.close();
					%>
					</tbody>
				</table>
			</div>
			<%
				Pager pager = new Pager(pageno, per_page, ValidateField.countUnconfirmed());
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