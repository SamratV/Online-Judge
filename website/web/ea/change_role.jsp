<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
<body>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="admin.UData"%>
<%@ page import="link.Link"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.apache.commons.validator.GenericValidator"%>
<%! public Connection link = Link.getConnection(); %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	if(!ValidateField.isAdmin(session)){
		response.sendRedirect("../ea/");
		return;
	}

	String username = request.getParameter("u");
	UData ud        = ValidateField.getUData(username);

	if(!ud.isValid() || ud.getUsername().equals(session.getAttribute("username"))){
		response.sendRedirect("../ea/");
		return;
	}

	String role = request.getParameter("role");
	int success = -1;

	if(!GenericValidator.isBlankOrNull(role)){
		try{
			PreparedStatement stmt = link.prepareStatement("UPDATE users SET role=? WHERE username=?");
			stmt.setString(1, role);
			stmt.setString(2, ud.getUsername());
			stmt.executeUpdate();
			stmt.close();

			success = 0;
			ud.setRole(role);
		}catch(Exception e){
			e.printStackTrace();
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
					<h2 class="page-header">Change user role &raquo; <%=ud.getUsername()%></h2>
				</div>
			</div>
			<!-- /.row -->
			<div class="container col-lg-12">
				<form method="post">
					<div class="form-group">
						<label for="role">Role</label>
						<select name="role" id="role" class="form-control" required="required">
							<option value="admin" <%=ud.getRole().equals("admin") ? "selected" : ""%>>Admin</option>
							<option value="editor" <%=ud.getRole().equals("editor") ? "selected" : ""%>>Editor</option>
							<option value="user" <%=ud.getRole().equals("user") ? "selected" : ""%>>Normal user</option>
						</select>
					</div>
					<br>
					<button type="submit" class="btn btn-primary">Change</button>
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
		var success = parseInt("<%=success%>");

		if(success === 0){
			$("#admin-modal-confirm").addClass("hidden");
			showModal("Success", "Role updated! If the user is logged in then please ask the user to logout and then login to see the change in role.", "", "", "");
		}

		$("#admin-modal").on("hidden.bs.modal", function(){
			window.location.replace("user_details.jsp?u=<%=ud.getUsername()%>");
		});
	});
</script>
<jsp:include page="/ea/view/admin_footer.jsp"></jsp:include>
</body>
</html>