<jsp:include page="/view/header.jsp"></jsp:include>
<jsp:include page="/view/navigation.jsp"></jsp:include>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	if(ValidateField.checkUser(session)){
		response.sendRedirect("./");
		return;
	}

	String user = session.getAttribute("username").toString();
	UData ud    = ValidateField.getUData(user);

	if(!ud.isValid()){
		response.sendRedirect("./");
		return;
	}

	int error = ValidateField.getInt(request.getParameter("err"));
%>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="admin.UData"%>
<%@ page import="link.Link"%>
<%@ page import="java.sql.*"%>
<%! public Connection link = Link.getConnection(); %>
<div class="container-fluid">
	<br><br>
	<div class="container">
		<h5>Reset password</h5>
		<hr>
		<br>
		<div>
			<form method="post" action="ResetPass" onsubmit="return checkPass();">
				<div class="form-group">
					<label for="pass">Current password</label>
					<input type="password" class="form-control" id="pass" name="pass" placeholder="Current password" required="required">
				</div>
				<div class="form-group">
					<label for="pass1">New password</label>
					<input type="password" class="form-control" id="pass1" minlength="6" maxlength="100" name="pass1" placeholder="New password" required="required">
				</div>
				<div class="form-group">
					<label for="pass2">Confirm password</label>
					<input type="password" class="form-control" id="pass2" minlength="6" maxlength="100" name="pass2" placeholder="Confirm password" required="required">
				</div>
				<br>
				<button type="submit" class="btn btn-success">Reset</button>
			</form>
			<br><br>
		</div>
	</div>
</div>

<div id="reset-modal" class="modal" tabindex="-1" role="dialog">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header" id="reset-modal-header">
				<h5 class="modal-title" id="reset-modal-heading">Error!</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div id="reset-modal-body" class="modal-body text-center">
				<!-- Modal text content -->
			</div>
			<div class="modal-footer" id="reset-modal-footer">
				<button type="button" class="btn btn-danger" id="reset-modal-close" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	function checkPass(){
		var pass1 = $("input#pass1").val();
		var pass2 = $("input#pass2").val();

		if(pass1 !== pass2){
			showModal("\"New password\" and \"Confirm password\" fields must match.");
			return false;
		}

		return true;
	}

	function showModal(content){
		$("#reset-modal-body").html(content);
		$("#reset-modal").modal("show");
	}

	$(function(){
		var error = parseInt("<%=error%>");

		if(error === 1){
			showModal("Wrong current password.");
		}else if(error === 0){
			$("#reset-modal-heading").html("Success");
			$("#reset-modal-close").removeClass("btn-danger");
			$("#reset-modal-close").addClass("btn-success");
			showModal("Password reset successful.");
		}
	});
</script>
<jsp:include page="/view/footer.jsp"></jsp:include>