<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
	<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
	<body>
		<%@ page errorPage="error.jsp"%>
		<%@ page import="admin.ValidateField"%>
		<%@ page import="link.Link"%>
		<%@ page import="java.sql.*"%>
		<%@ page import="admin.CData"%>
		<%@ page import="admin.SData" %>
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
			
			String cid 		= request.getParameter("cat");
			CData cd 		= ValidateField.getCData(cid);
			String cat_name = cd.getCname();

			if(!cd.isValid()){
				response.sendRedirect("../ea/categories.jsp");
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
	                        <h2 class="page-header"><%=cat_name %> &raquo; Sub-categories</h2>
	                    </div>
	                </div>
	                <!-- /.row -->
					<div class="col-xs-4">
				<%
					if(cd.getScount() < 10){
				%>
						<form id="add_scat_form" action="../Subcategory" method="post">
							<div class="form-group">
								<label for="scat_name">Add a new sub-category</label>
								<input type="text" class="form-control" id="scat_name" name="scat_name" maxlength=100 required="required">
							</div>
							<input type="hidden" name="redirect" value="<%=cid %>">
							<div class="form-group text-center">
								<input type="submit" class="btn btn-primary" name="submit" value="Add">
							</div>
						</form>
				<%
					}else{
				%>
						<div class="alert alert-warning" role="alert">
							Add subcategory option is disabled because you have added 10 subcategories and you cannot add more than 10 subcategories in a category.
						</div>
				<%
					}
				%>
						<form id="update_scat_form" action="../Subcategory" method="post" class="hidden">
							<hr>
							<div class="form-group">
								<label for="update_scat_name">Update sub-category</label>
								<input type="text" class="form-control" maxlength=100 name="update_scat_name" id="update_scat_name" required="required">
								<input type="hidden" name="update_scat_id" id="update_scat_id">
							</div>
							<input type="hidden" name="redirect" value="<%=cid %>">
							<div class="form-group text-center">
								<input type="submit" class="btn btn-primary" name="submit" value="Update">&nbsp;&nbsp;
								<button type="button" id="update_scat_cancel" class="btn btn-warning">Cancel</button>
							</div>
						</form>
					</div>
					<div class="col-xs-1"></div>
					<div class="col-xs-7">
						<table class="table table-striped">
							<thead>
								<tr>
									<th scope="col">#</th>
									<th scope="col">Sub-category title</th>
									<th scope="col">Edit</th>
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
									PreparedStatement stmt = link.prepareStatement("SELECT * FROM subcategory WHERE cid=? ORDER BY scname");
									stmt.setInt(1, cd.getCid());
									ResultSet result = stmt.executeQuery();
									while(result.next()){
										int scid 	  = result.getInt("scid");
										String scname = result.getString("scname");
										SData sd 	  = ValidateField.getSData(Integer.toString(scid));
										out.println("<tr><th scope='row'>" + scid + "</th>");
										out.println("<td><a href='questions.jsp?cat=" + cid + "&scat=" + scid + "'>" + scname + "</a></td>");
										out.println("<td><a class='scat_edit' href='" + scid + "," + scname + "'>"
													+ "<i class='fa fa-edit'></i></a></td>");
										if(ValidateField.isAdmin(session)){
											out.println("<td><a class='scat_delete text-danger' href='" + sd.isDeleteable() + "," + scid
													+ "'><i class='far fa-trash-alt'></i></a></td>");
										}
										out.println("</tr>");
									}
									stmt.close();
								%>
							</tbody>
						</table>
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