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
					<h2 class="page-header">Pending question uploads</h2>
				</div>
			</div>
			<!-- /.row -->
			<div class="container col-lg-12">
				<table class="table table-striped">
					<thead>
					<tr>
						<th scope="col">#</th>
						<th scope="col">Question title</th>
						<th scope="col">Upload Status</th>
						<th scope="col">Edit / View</th>
						<%
							if(ValidateField.isAdmin(session)){
						%>
						<th scope="col">Delete</th>
						<%
							}
						%>
					</tr>
					</thead>
					<tbody>
					<%
						String query = "SELECT qid, qtitle, tid FROM questions WHERE uploaded=0 ORDER BY qid DESC LIMIT ?, ?";
						PreparedStatement stmt = link.prepareStatement(query);
						stmt.setInt(1, page_current);
						stmt.setInt(2, per_page);
						ResultSet result = stmt.executeQuery();
						while(result.next()){
							String qtitle = result.getString("qtitle");
							int qid       = result.getInt("qid");
							int tid       = result.getInt("tid");
							out.println("<tr><th scope='row'>" + qid + "</th>");
							out.println("<td>" + qtitle + "</td>");
							out.println("<td>Incomplete</td>");
							if(tid == 0){
								out.println("<td><a href='../ea/edit_question.jsp?qid=" + qid + "'><i class='fa fa-edit'></i></a></td>");
							}else{
								out.println("<td><a href='../ea/edit_test_question.jsp?qid=" + qid + "'><i class='fa fa-edit'></i></a></td>");
							}
							if(ValidateField.isAdmin(session)){
								out.println("<td><a href='" + qid + "' class='text-danger question_delete'><i class='far fa-trash-alt'></i></a></td>");
							}
							out.println("</tr>");
						}
						stmt.close();
					%>
					</tbody>
				</table>
			</div>
			<%
				int count   = ValidateField.getPQCount();
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