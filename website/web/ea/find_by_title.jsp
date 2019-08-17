<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
<body>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="admin.Pager"%>
<%@ page import="java.sql.*"%>
<%@ page import="link.Link"%>
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

	String q         = request.getParameter("query");
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
					<h2 class="page-header">Find questions</h2>
				</div>
			</div>
			<!-- /.row -->
			<div class="container col-lg-12">
				<form>
					<div class="col-lg-4">
						<label for="query">Question title</label>
						<input class="form-control" type="text" name="query" id="query" required="required" value="<%=q != null ? q : ""%>">
					</div>
					<div class="col-lg-3">
						<label>&nbsp;</label>
						<input type="submit" class="btn btn-primary form-control" value="Search">
					</div>
				</form>
				<br><br><br><br>
			</div>
			<%
				if(q != null){
			%>
			<div class="container col-lg-12">
				<table class="table table-striped">
					<thead>
					<tr>
						<th scope="col">#</th>
						<th scope="col">Question title</th>
						<th scope="col">Question type</th>
						<th scope="col">Upload Status</th>
						<th scope="col">Preview</th>
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
						String query = "SELECT qid, qtitle, uploaded, tid FROM questions WHERE qtitle LIKE ? ORDER BY qid ASC LIMIT ?, ?";
						PreparedStatement stmt = link.prepareStatement(query);
						stmt.setString(1, "%" + q + "%");
						stmt.setInt(2, page_current);
						stmt.setInt(3, per_page);
						ResultSet result = stmt.executeQuery();
						while(result.next()){
							String qtitle = result.getString("qtitle");
							int qid       = result.getInt("qid");
							int tid       = result.getInt("tid");
							int uploaded  = result.getInt("uploaded");
							out.println("<tr><th scope='row'>" + qid + "</th>");
							out.println("<td>" + qtitle + "</td>");
							String preview, edit;
							if(tid == 0){
								out.println("<td>Practice question</td>");
								preview = "practice_preview_editor.jsp";
								edit = "edit_question.jsp";
							}else{
								out.println("<td>Test question</td>");
								preview = "test_preview_editor.jsp";
								edit = "edit_test_question.jsp";
							}
							if(uploaded == 1){
								out.println("<td>Complete</td>");
								out.println("<td><a href='../" + preview + "?q=" + qid + "' target='_blank'><i class='fas fa-external-link-alt'></i></a></td>");
							}else{
								out.println("<td>Incomplete</td>");
								out.println("<td><i class='fas fa-external-link-alt'></i></td>");
							}
							out.println("<td><a href='../ea/" + edit + "?qid=" + qid + "'><i class='fa fa-edit'></i></a></td>");
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
					int count   = ValidateField.getQCount(q);
					Pager pager = new Pager(pageno, per_page, count);
					out.println(pager.getPager());
				}
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