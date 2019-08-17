<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
	<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
	<body>
        <%@ page errorPage="error.jsp"%>
		<%@ page import="admin.ValidateField"%>
		<%@ page import="link.Link"%>
		<%@ page import="java.sql.*"%>
		<%@ page import="admin.CSData"%>
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
		
			String cid 		 = request.getParameter("cat");
			String scid 	 = request.getParameter("scat");
			CSData csd 		 = ValidateField.getCSData(cid, scid);
			String cat_name  = csd.getCname();
			String scat_name = csd.getScname();
			String like      = request.getParameter("query");
			like             = ValidateField.getLikeExpr(like);

			int pageno 		 = ValidateField.getPageNo(request.getParameter("pageno"));
			int per_page 	 = 10;
			int page_current = (pageno * per_page) - per_page;

			boolean not_null = !(cid == null && scid == null);
			if(not_null && !csd.isValid()){
				response.sendRedirect("../ea/questions.jsp");
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
			                    <%=not_null ? (cat_name + " &raquo; " + scat_name + " &raquo; ") : "" %>Practice questions
		                    </h2>
	                    </div>
	                </div>
	                <!-- /.row -->
	                <%if(!not_null){%>
						<div class="container col-lg-12">
							<form>
								<div class="col-lg-3">
									<label for="select_cat">Category</label>
									<select class="form-control" id="select_cat" name="cat" required="required">
										<option selected disabled>-- Select --</option>
										<%
											PreparedStatement stmt = link.prepareStatement("SELECT * FROM category ORDER BY cname");
											ResultSet result = stmt.executeQuery();
											while(result.next()){
												int id      = result.getInt("cid");
												String name = result.getString("cname");
												out.println("<option value='" + id + "'>" + name + "</option>");
											}
											stmt.close();
										%>
									</select>
								</div>
								<div class="col-lg-3" id="select_scat_div"></div>
								<div class="col-lg-3 hidden" id="search_query">
									<label for="query">Question title(optional)</label>
									<input class="form-control" type="text" name="query" id="query">
								</div>
								<div class="col-lg-3 hidden" id="question_link">
									<label>&nbsp;</label>
									<input type="submit" class="btn btn-primary form-control" value="View questions">
								</div>
							</form>
						</div>
					<%}else{ %>
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
									String query = "SELECT qid, qtitle, uploaded FROM questions WHERE scid=? AND qtitle LIKE ? ORDER BY qid ASC LIMIT ?, ?";
									PreparedStatement stmt = link.prepareStatement(query);
									stmt.setInt(1, csd.getScid());
									stmt.setString(2, like);
									stmt.setInt(3, page_current);
									stmt.setInt(4, per_page);
									ResultSet result = stmt.executeQuery();
									while(result.next()){
										String qtitle = result.getString("qtitle");
										int qid       = result.getInt("qid");
										int uploaded  = result.getInt("uploaded");
										out.println("<tr><th scope='row'>" + qid + "</th>");
										out.println("<td>" + qtitle + "</td>");
										if(uploaded == 1){
											out.println("<td>Complete</td>");
											out.println("<td><a href='../practice_preview_editor.jsp?q=" + qid + "' target='_blank'><i class='fas fa-external-link-alt'></i></a></td>");
										}else{
											out.println("<td>Incomplete</td>");
											out.println("<td><i class='fas fa-external-link-alt'></i></td>");
										}
										out.println("<td><a href='../ea/edit_question.jsp?qid=" + qid + "'><i class='fa fa-edit'></i></a></td>");
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
						int count   = ValidateField.countQuestions(scid);
						Pager pager = new Pager(pageno, per_page, count);
						out.println(pager.getPager());
					%>
					<%} %>
	            </div>
	            <!-- /.container-fluid -->
	
	        </div>
	        <!-- /#page-wrapper -->
	
	    </div>
	    <!-- /#wrapper -->

	    <jsp:include page="/ea/view/admin_footer.jsp"></jsp:include>
	</body>
</html>