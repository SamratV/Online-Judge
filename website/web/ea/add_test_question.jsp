<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
<body>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="admin.TData" %>
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

	if(!td.isValid() || td.isUploaded()){
		response.sendRedirect("../ea/");
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
						Add question
					</h2>
				</div>
			</div>
			<!-- /.row -->
			<div class="container col-lg-12">
				<form method="post" action="../UTQStatement" onsubmit="return checkQuestion();">
					<input type="hidden" value="<%=td.getTid()%>" name="tid">
					<div class="form-group">
						<label for="qtitle">Question title</label>
						<input type="text" class="form-control" id="qtitle" maxlength=100 name="qtitle" placeholder="Title"  required="required">
					</div>
					<div class="form-group">
						<label for="qmarks">Marks</label>
						<select class="form-control" id="qmarks" name="qmarks" required="required">
							<option selected disabled>-- Select --</option>
							<%
								for(int i = 1; i <= 10; i++){
									out.println("<option value='" + i * 10 + "'>" + i * 10 + "</option>");
								}
							%>
						</select>
					</div>
					<div class="form-group">
						<label for="qtc_public">No. of public test cases</label>
						<select class="form-control" id="qtc_public" name="qtc_public" required="required">
							<option selected disabled>-- Select --</option>
							<%
								for(int i = 1; i <= 5; i++){
									out.println("<option value='" + i + "'>" + i + "</option>");
								}
							%>
						</select>
					</div>
					<div class="form-group">
						<label for="qtc_private">No. of private test cases</label>
						<select class="form-control" id="qtc_private" name="qtc_private" required="required">
							<option selected disabled>-- Select --</option>
							<%
								for(int i = 1; i <= 30; i++){
									out.println("<option value='" + i + "'>" + i + "</option>");
								}
							%>
						</select>
					</div>
					<div class="form-group">
						<label for="qstatement">Question statement</label>
						<br>
						<small class="text-muted">For accessibility help click on the editor and press ALT + 0.</small>
						<textarea class="form-control" id="qstatement" name="qstatement"></textarea>
					</div>
					<button type="submit" class="btn btn-default">Next</button>
				</form>
				<br><br><br><br>
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