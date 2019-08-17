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

	String required, hidden;

	if(ud.getProfession().equals("student")){
		required = "required=\"required\"";
		hidden   = "";
	}else{
		required = "";
		hidden   = "hidden";
	}

	int success = ValidateField.getInt(request.getParameter("success"));
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
		<h5>Edit profile</h5>
		<hr>
		<form method="post" action="UpdateProfile" onsubmit="return checkFN();">
			<br><br>

			<div class="form-group">
				<label for="fullname">Fullname</label>
				<input type="text" class="form-control" id="fullname" maxlength=100 name="fullname" placeholder="Fullname" required="required" value="<%=ud.getFullname()%>">
			</div>
			<div class="form-group">
				<label for="dob">Date of birth</label>
				<input type="text" class="form-control" name="dob" id="dob" placeholder="D.O.B" required="required" value="<%=ud.getDob()%>">
			</div>
			<div class="form-group <%=hidden%>">
				<label for="roll">Roll number</label>
				<input type="number" class="form-control" id="roll" min="1" max="999999999999999" name="roll" placeholder="Roll number" <%=required%> value="<%=ud.getRoll()%>">
			</div>
			<div class="form-group <%=hidden%>">
				<label for="session">Session</label>
				<select name="session" id="session" class="form-control" <%=required%>>
					<%
						for(int i = 15; i <= 26; ++i){
							String value    = "20" + i + "-" + (i + 4);
							String selected = value.equals(ud.getBatch()) ? "selected" : "";
							out.println("<option value='" + value + "' " + selected + ">" + value + "</option>");
						}
					%>
				</select>
			</div>
			<div class="form-group">
				<label for="dept">Department</label>
				<select name="dept" id="dept" class="form-control" required="required">
					<%
						PreparedStatement stmt = link.prepareStatement("SELECT * FROM dept");
						ResultSet result = stmt.executeQuery();
						while(result.next()){
							int dept_id      = result.getInt("dept_id");
							String dept_name = result.getString("dept_name");
							String selected  = dept_id == ud.getDept_id() ? "selected" : "";
							out.println("<option value='" + dept_id + "' " + selected + ">" + dept_name + "</option>");
						}
					%>
				</select>
			</div>
			<br><br>
			<button type="submit" class="btn btn-success">Update</button>
		</form>
		<br><br><br><br>
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
	$(function(){
		$("#dob").datepicker({
			format: 'yyyy-mm-dd',
			todayHighlight: true,
			autoclose: true
		});

		var success = parseInt("<%=success%>");

		if(success === 1){
			$("#reset-modal-heading").html("Success");
			$("#reset-modal-close").removeClass("btn-danger");
			$("#reset-modal-close").addClass("btn-success");
			showModal("Profile update successful.");
		}
	});

	function showModal(content){
		$("#reset-modal-body").html(content);
		$("#reset-modal").modal("show");
	}

	function checkFN(){
		var name  = $("input#fullname").val();
		var regex = /^([a-zA-Z]|[\s])*$/;

		if(!regex.test(name)){
			showModal("Fullname can contain characters a-z A-Z or whitespaces only.");
			return false;
		}
		return true;
	}
</script>
<jsp:include page="/view/footer.jsp"></jsp:include>