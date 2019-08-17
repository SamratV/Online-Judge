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
			
			String qid = request.getParameter("qid");
			if(!ValidateField.isValidQid(qid)){
				response.sendRedirect("../ea/");
				return;
			}

			String url = ValidateField.getQData(qid).isValid()
					   ? "edit_question.jsp"
					   : "edit_test_question.jsp";
		%>
		<div id="wrapper">
	
			<jsp:include page="/ea/view/admin_navigation.jsp"></jsp:include>        
	
	        <div id="page-wrapper">
	
	            <div class="container-fluid">
				
	                <!-- Page Heading -->
	                <div class="row">
	                    <div class="col-lg-12">
	                      <h2 class="page-header">
	                      	 Verify upload
	                      </h2>
	                    </div>
	                </div>
	                <!-- /.row -->
	                <div class="container col-lg-12">
	                	<%
							Object attr   = session.getAttribute("uploaded");
	                		String status = attr == null ? null : attr.toString();
	                		session.removeAttribute("uploaded");

	                		if(status == null){
						%>
								<form method="post" action="../VerifyTC">
									<p>Click verify button to verify upload and complete the upload process.</p>
									<input type="hidden" name="qid" value="<%=qid %>">
									<br>
									<div class="col-lg-12">
										<button type="submit" class="btn btn-default">Verify</button>
									</div>
								</form>
						<%
	                		}else if(status.equals("true")){
						%>
	                			<div class="alert alert-success col-lg-6 text-center" role="alert">
	                				Upload successful. 
	                				Click <a href="<%=url%>?qid=<%=qid %>">here</a>
									if you want to edit else click next.
	                			</div>
								<div class="col-lg-12">
									<a href="upload_solution.jsp?qid=<%=qid %>" class="btn btn-default">Next</a>
								</div>
						<%
	                		}else if(status.equals("false")){
						%>
	                			<div class="alert alert-danger col-lg-6 text-center" role="alert">
	                				Upload rolled back. Inappropriate files where uploaded.
	                				Click <a href="add_testcases.jsp?qid=<%=qid %>">here</a> to upload again.
	                			</div>
						<%
	                		}
	                	%>
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