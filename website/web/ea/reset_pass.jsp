<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
<body>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="admin.UData"%>
<%@ page import="org.apache.commons.validator.GenericValidator"%>
<%@ page import="link.Link"%>
<%@ page import="java.sql.*"%>
<%@ page import="auth.AuthUtility"%>
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

	String username = request.getParameter("u");
	UData ud        = ValidateField.getUData(username);

	if(!ud.isValid() || (!ValidateField.isAdmin(session) && !ud.getUsername().equals(session.getAttribute("username")))){
		response.sendRedirect("../ea/");
		return;
	}

	String pass1 = request.getParameter("pass1");
	String pass2 = request.getParameter("pass2");
	int error    = -1;

	if(!GenericValidator.isBlankOrNull(pass1) && !GenericValidator.isBlankOrNull(pass2)){
		if(!pass1.equals(pass2)){
			error = 1;
		}else{
			try{
				PreparedStatement stmt = link.prepareStatement("UPDATE users SET password=? WHERE username=?");
				stmt.setString(1, AuthUtility.hashPassword(pass1));
				stmt.setString(2, ud.getUsername());
				stmt.executeUpdate();
				stmt.close();

				error = 0;
			}catch(Exception e){
				e.printStackTrace();
			}
		}
	}
%>
<div id="wrapper">

	<jsp:include page="/ea/view/admin_navigation.jsp"></jsp:include>

	<div id="page-wrapper">

		<div class="container-fluid">

			<!-- Page Heading -->
			<div class="row">
				<div class="col-lg-12">
					<h2 class="page-header">Reset password &raquo; <%=ud.getUsername()%></h2>
				</div>
			</div>
			<!-- /.row -->
			<div class="container col-lg-12">
				<form method="post">
					<div class="form-group">
						<label for="pass1">New password</label>
						<input type="password" class="form-control" id="pass1" minlength="6" maxlength="100" name="pass1" placeholder="New password" required="required">
					</div>
					<div class="form-group">
						<label for="pass2">Confirm password</label>
						<input type="password" class="form-control" id="pass2" minlength="6" maxlength="100" name="pass2" placeholder="Confirm password" required="required">
					</div>
					<br>
					<button type="submit" class="btn btn-primary">Reset</button>
				</form>
			</div>
		</div>
		<!-- /.container-fluid -->

	</div>
	<!-- /#page-wrapper -->

</div>
<!-- /#wrapper -->

<script type="text/javascript">
	$(function(){
		var error = parseInt("<%=error%>");

		if(error === 1){
			$("#admin-modal-confirm").addClass("hidden");
			showModal("Error", "Both password fields must match.", "", "", "");
		}else if(error === 0){
			$("#admin-modal-confirm").addClass("hidden");
			showModal("Success", "Password updated!", "", "", "");
		}

		$("#admin-modal").on("hidden.bs.modal", function(){
			window.location.replace("user_details.jsp?u=<%=ud.getUsername()%>");
		});
	});
</script>
<jsp:include page="/ea/view/admin_footer.jsp"></jsp:include>
</body>
</html>