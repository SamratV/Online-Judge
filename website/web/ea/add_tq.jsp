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
					<h2 class="page-header">Add a test question</h2>
				</div>
			</div>
			<!-- /.row -->
			<div class="container col-lg-12">
				<div class="alert alert-info col-lg-8" role="alert">
					To add a test question do the following: <br>
					1) One the sidebar click on "Tests" and then click on "Find tests". <br>
					2) Enter relevant details and search your test. A list of tests will appear on searching. <br>
					3) Click on view icon corresponding to your test. "Test details" page will appear. <br>
					4) On the "Test details" page click on "Add question" button and add your question.
					<br><br>
					Note: "Add question" button will appear only if all questions are not uploaded for the test.
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