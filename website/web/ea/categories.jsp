<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
	<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
	<body>
		<%@ page errorPage="error.jsp"%>
		<%@ page import="admin.ValidateField"%>
		<%@ page import="link.Link"%>
		<%@ page import="java.sql.*"%>
		<%@ page import="admin.CData" %>
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
		%>
		<div id="wrapper">
	
			<jsp:include page="/ea/view/admin_navigation.jsp"></jsp:include>        
	
	        <div id="page-wrapper">
	
	            <div class="container-fluid">
	
	                <!-- Page Heading -->
	                <div class="row">
	                    <div class="col-lg-12">
	                        <h2 class="page-header">Categories</h2>
	                    </div>
	                </div>
	                <!-- /.row -->
					<div class="col-xs-4">
					<%
						if(ValidateField.countCat() < 10){
					%>
							<form id="add_cat_form" action="../Category" method="post">
								<div class="form-group">
									<label for="cat_name">Add a new category</label>
									<input type="text" class="form-control" id="cat_name" name="cat_name" maxlength=100 required="required">
								</div>
								<div class="form-group">
									<label for="cat_lang">Choose language</label>
									<select class="form-control" name="cat_lang" id="cat_lang" required="required">
										<option selected disabled>-- Select --</option>
										<option value="all">All</option>
										<option value="c">C</option>
										<option value="cpp">C++</option>
										<option value="java">Java</option>
										<option value="python">Python</option>
									</select>
								</div>
								<div class="form-group text-center">
									<input type="submit" class="btn btn-primary" name="submit" value="Add">
								</div>
							</form>
					<%
						}else{
					%>
							<div class="alert alert-warning" role="alert">
								Add category option is disabled because you have added 10 categories and you cannot add more than 10 categories.
							</div>
					<%
						}
					%>
						<form id="update_cat_form" action="../Category" method="post" class="hidden">
							<hr>
							<div class="form-group">
								<label for="update_cat_name">Update category</label>
								<input type="text" class="form-control" maxlength=100 name="update_cat_name" id="update_cat_name" required="required">
								<input type="hidden" name="update_cat_id" id="update_cat_id">
							</div>
							<div class="form-group">
								<label for="update_cat_lang">Choose language</label>
								<select class="form-control" name="update_cat_lang" id="update_cat_lang" required="required">
									<option value="all">All</option>
									<option value="c">C</option>
									<option value="cpp">C++</option>
									<option value="java">Java</option>
									<option value="python">Python</option>
								</select>
							</div>
							<div class="form-group text-center">
								<input type="submit" class="btn btn-primary" name="submit" value="Update">&nbsp;&nbsp;
								<button type="button" id="update_cat_cancel" class="btn btn-warning">Cancel</button>
							</div>
						</form>
					</div>
					<div class="col-xs-8">
						<table class="table table-bordered table-hover text-center">
							<thead>
								<tr>
									<th class="col-xs-1 text-center"><i class="fa fa-list"></i></th>
									<th class="col-xs-3 text-center">Category title</th>
									<th class="col-xs-1 text-center">Language</th>
									<th class="col-xs-1 text-center">Ranks</th>
									<th class="col-xs-1 text-center">Edit</th>
									<%
										if(ValidateField.isAdmin(session)){
									%>
									<th class="col-xs-1 text-center">Delete</th>
									<%
										}
									%>
								</tr>
							</thead>
							<tbody>
								<%
									PreparedStatement stmt = link.prepareStatement("SELECT * FROM category ORDER BY cname");
									ResultSet result = stmt.executeQuery();
									while(result.next()){
										int cid      = result.getInt("cid");
										String cname = result.getString("cname");
										String clang = result.getString("clang");
										CData cd     = ValidateField.getCData(Integer.toString(cid));
										out.println("<tr><td>" + cid + "</td>");
										out.println("<td><a href='subcategories.jsp?cat=" + cid + "'>" + cname + "</a></td>");
										out.println("<td>" + ValidateField.getLang(clang) + "</td>");
										out.println("<td><a href='cat_rank.jsp?cid=" + cid + "'><i class='fas fa-chart-line'></i></a></td>");
										out.println("<td><a class='cat_edit' href='" + cid + "," + cname + "," + clang + "'>"
													+ "<i class='fa fa-edit'></i></a></td>");
										if(ValidateField.isAdmin(session)){
											out.println("<td><a class='cat_delete text-danger' href='" + cd.isDeleteable() + "," + cid
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