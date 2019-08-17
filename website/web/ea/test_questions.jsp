<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
<body>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="link.Link"%>
<%@ page import="java.sql.*"%>
<%@ page import="admin.TData" %>
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

	String tid = request.getParameter("tid");
	TData td   = ValidateField.getTData(tid);

	if(!td.isValid()){
		response.sendRedirect("../ea/tests.jsp");
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
					<h2 class="page-header">
						Test questions
					</h2>
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
						<th scope="col">Preview</th>
						<th scope="col">Edit / View</th>
						<%
							if(ValidateField.isAdmin(session) && !(td.isUploaded() && td.isLive())){
						%>
						<th scope="col">Delete</th>
						<%
							}
						%>
					</tr>
					</thead>
					<tbody>
					<%
						String query = "SELECT qid, qtitle, uploaded FROM questions WHERE tid=? ORDER BY qid ASC LIMIT 0, 12";
						PreparedStatement stmt = link.prepareStatement(query);
						stmt.setInt(1, td.getTid());
						ResultSet result = stmt.executeQuery();
						while(result.next()){
							String qtitle = result.getString("qtitle");
							int qid       = result.getInt("qid");
							int uploaded  = result.getInt("uploaded");
							out.println("<tr><th scope='row'>" + qid + "</th>");
							out.println("<td>" + qtitle + "</td>");
							out.println("<td>" + (uploaded == 1 ? "Complete" : "Incomplete") + "</td>");
							out.println("<td><a href='../test_preview_editor.jsp?q=" + qid + "' target='_blank'><i class='fas fa-external-link-alt'></i></a></td>");
							out.println("<td><a href='../ea/edit_test_question.jsp?qid=" + qid + "'><i class='fa fa-edit'></i></a></td>");
							if(ValidateField.isAdmin(session) && !(td.isUploaded() && td.isLive())){
								out.println("<td><a href='" + qid + "' class='text-danger question_delete'><i class='far fa-trash-alt'></i></a></td>");
							}
							out.println("</tr>");
						}
						stmt.close();
					%>
					</tbody>
				</table>
				<br><br><br><br><br><br>
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