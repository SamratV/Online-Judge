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

	int action      = ValidateField.getInt(request.getParameter("action"));
	String username = request.getParameter("u");
	UData ud        = ValidateField.getUData(username);

	if(!ud.isValid() || ud.getUsername().equals(session.getAttribute("username")) || (action != 1 && action != 0)){
		response.sendRedirect("../ea/");
		return;
	}

	String act  = request.getParameter("act");
	int success = -1;

	if(!GenericValidator.isBlankOrNull(act)){
		try{
			PreparedStatement stmt = link.prepareStatement("UPDATE users SET approved=? WHERE username=?");
			stmt.setInt(1, action);
			stmt.setString(2, ud.getUsername());
			stmt.executeUpdate();
			stmt.close();

			success = 0;
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
					<h2 class="page-header">
						<%=(action == 1 ? "Approve user account" : "Disapprove user account") + " &raquo; " + ud.getUsername()%>
					</h2>
				</div>
			</div>
			<!-- /.row -->
			<div class="container col-lg-12">
				<form method="post">
					<p>
						Click on the button below to complete the action.
					</p>
					<input type="hidden" name="act" value="true">
					<br>
					<button type="submit" class="btn btn-primary">
						<%=action == 1 ? "Approve" : "Disapprove"%>
					</button>
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
			showModal("Success", "Action complete!", "", "", "");
		}

		$("#admin-modal").on("hidden.bs.modal", function(){
			window.location.replace("user_details.jsp?u=<%=ud.getUsername()%>");
		});
	});
</script>
<jsp:include page="/ea/view/admin_footer.jsp"></jsp:include>
</body>
</html>