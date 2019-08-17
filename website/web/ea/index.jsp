<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
	<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
	<body>
		<%@ page errorPage="error.jsp"%>
		<%@ page import="admin.ValidateField"%>
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
	                        <h2 class="page-header">Dashboard</h2>
		                    <small class="text-muted" style="margin-left: 30px">
			                    Below are the quick links to search stuffs.
		                    </small>
	                    </div>
	                </div>
	                <!-- /.row -->
					<div class="col-lg-12">
						<br><br>

						<div class="col-lg-3 col-md-6">
							<div class="panel panel-primary">
								<div class="panel-heading">
									<div class="row">
										<div class="col-xs-3">
											<i class="fas fa-users fa-5x"></i>
										</div>
										<div class="col-xs-9 text-right">
											<div class="huge">&nbsp;</div>
											<div>Users</div>
										</div>
									</div>
								</div>
								<a href="users.jsp">
									<div class="panel-footer">
										<span class="pull-left">View Details</span>
										<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
										<div class="clearfix"></div>
									</div>
								</a>
							</div>
						</div>

						<div class="col-lg-3 col-md-6">
							<div class="panel panel-green">
								<div class="panel-heading">
									<div class="row">
										<div class="col-xs-3">
											<i class="fas fa-book fa-5x"></i>
										</div>
										<div class="col-xs-9 text-right">
											<div class="huge">&nbsp;</div>
											<div>Tests</div>
										</div>
									</div>
								</div>
								<a href="tests.jsp">
									<div class="panel-footer">
										<span class="pull-left">View Details</span>
										<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
										<div class="clearfix"></div>
									</div>
								</a>
							</div>
						</div>

						<div class="col-lg-3 col-md-6">
							<div class="panel panel-yellow">
								<div class="panel-heading">
									<div class="row">
										<div class="col-xs-3">
											<i class="fas fa-question fa-5x"></i>
										</div>
										<div class="col-xs-9 text-right">
											<div class="huge">&nbsp;</div>
											<div>Practice questions</div>
										</div>
									</div>
								</div>
								<a href="questions.jsp">
									<div class="panel-footer">
										<span class="pull-left">View Details</span>
										<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
										<div class="clearfix"></div>
									</div>
								</a>
							</div>
						</div>

						<div class="col-lg-3 col-md-6">
							<div class="panel panel-red">
								<div class="panel-heading">
									<div class="row">
										<div class="col-xs-3">
											<i class="fas fa-question fa-5x"></i>
										</div>
										<div class="col-xs-9 text-right">
											<div class="huge">&nbsp;</div>
											<div>Test questions</div>
										</div>
									</div>
								</div>
								<a href="find_tq.jsp">
									<div class="panel-footer">
										<span class="pull-left">View Details</span>
										<span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
										<div class="clearfix"></div>
									</div>
								</a>
							</div>
						</div>

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