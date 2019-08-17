<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
<body>
<%@ page isErrorPage="true"%>
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
					<h2 class="page-header">Error</h2>
				</div>
			</div>
			<!-- /.row -->
			<div class="container col-lg-12">
				<%=exception %>
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