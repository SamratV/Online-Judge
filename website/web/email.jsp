<jsp:include page="/view/header.jsp"></jsp:include>
<jsp:include page="/view/navigation.jsp"></jsp:include>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	int error  = ValidateField.getInt(request.getParameter("error"));
	String url = request.getRequestURL().toString();
%>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField" %>
<div class="container">
	<br><br><br><br>
	<div class="table-center col-lg-4 border form-box">
		<div class="panel panel-default">
			<div class="panel-body">
				<div class="text-center">
					<h3><i class="fa fa-lock fa-2x"></i></h3>
					<h5 class="text-center">Forgot password?</h5>
					<p>
						<small>You can reset your password here.</small>
					</p>
					<div class="panel-body">
						<form action="FPMailer" role="form" autocomplete="off" class="form" method="post">
							<div class="form-group">
								<div class="input-group">
									<div class="input-group-prepend">
										<div class="input-group-text">
											<i class="fas fa-envelope"></i>
										</div>
									</div>
									<input name="email" placeholder="Email address" class="form-control auth-input" type="email" required="required">
								</div>
							</div>
							<input type="hidden" name="url" value="<%=url.substring(0, url.indexOf("email.jsp"))%>">
							<div class="form-group">
								<input class="btn btn-success btn-block" value="Reset password" type="submit">
							</div>
						</form>
					</div>
				</div>
			</div>
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
	function showModal(content){
		$("#reset-modal-body").html(content);
		$("#reset-modal").modal("show");
	}

	$(function(){
		var error = parseInt("<%=error%>");

		if(error === 1){
			showModal("The email address you entered is not registered with us.");
		}
	});
</script>
<jsp:include page="/view/footer.jsp"></jsp:include>