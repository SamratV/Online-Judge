<jsp:include page="/view/header.jsp"></jsp:include>
<jsp:include page="/view/navigation.jsp"></jsp:include>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	String token = request.getParameter("rt");
	String user  = request.getParameter("u");
	UData ud     = ValidateField.getUData(user);

	if(!ud.isValid() || !token.equals(ud.getToken())){
		response.sendRedirect("./");
		return;
	}

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	Date sent = sdf.parse(ud.getToken_time());
	Date now  = new Date();
	long time = (now.getTime() - sent.getTime()) / (1000 * 60);
%>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.UData"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<div class="container">
	<%
		if(time >= 15){
	%>
	<br><br><br><br>
	<h6 class="text-center">
		This link has expired.
	</h6>
	<br><br>
	<div class="text-center">
		<a href="./" class="btn btn-success">Back to home</a>
	</div>
	<%
		}else{
	%>
	<br>
	<div class="col-lg-4 table-center border form-box">
		<form method="post" action="EResetPass" onsubmit="return checkPass();">
			<h3 class="text-center"><i class="fa fa-lock fa-2x"></i></h3>
			<h5 class="text-center">Reset password</h5>
			<br>
			<input type="hidden" name="username" value="<%=ud.getUsername()%>">
			<input type="hidden" name="token" value="<%=ud.getToken()%>">
			<div class="form-group">
				<label for="pass1">New password</label>
				<input type="password" class="form-control" id="pass1" minlength="6" maxlength="100" name="pass1" placeholder="New password" required="required">
			</div>
			<div class="form-group">
				<label for="pass2">Confirm password</label>
				<input type="password" class="form-control" id="pass2" minlength="6" maxlength="100" name="pass2" placeholder="Confirm password" required="required">
			</div>
			<br>
			<button type="submit" class="btn btn-success btn-block">Reset</button>
		</form>
	</div>
	<br>
	<%
		}
	%>
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

	function checkPass(){
		var pass1 = $("input#pass1").val();
		var pass2 = $("input#pass2").val();

		if(pass1 !== pass2){
			showModal("Both password fields must match.");
			return false;
		}
		return true;
	}
</script>
<jsp:include page="/view/footer.jsp"></jsp:include>