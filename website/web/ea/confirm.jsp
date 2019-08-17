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

	if(!ud.isValid() || ud.getUsername().equals(session.getAttribute("username")) || ud.isConfirmed()){
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
					<h2 class="page-header">Confirm user account</h2>
				</div>
			</div>
			<!-- /.row -->
			<div class="col-lg-12">
				<div class="alert alert-warning">
					Note: Confirm a user account using this page only when the user is not able to confirm his/her
					account because he/she is unable to receive the system generated confirmation email. Please do
					make sure that the details you are filling up are correct.
				</div>
			</div>
			<div class="container col-lg-12">
				<form method="post" action="../FillDetails" onsubmit="return checkFN();">
					<input type="hidden" name="username" value="<%=ud.getUsername()%>">
					<input type="hidden" name="confirmed" value="1">
					<div class="form-group">
						<label for="fullname">Fullname</label>
						<input type="text" class="form-control" id="fullname" maxlength="100" name="fullname" placeholder="Fullname" required="required">
					</div>
					<div class="form-group">
						<label for="dob">Date of birth</label>
						<input type="text" class="form-control" name="dob" id="dob" placeholder="D.O.B" required="required">
					</div>
					<div class="form-group">
						<label for="profession">Profession</label>
						<select name="profession" id="profession" class="form-control" required="required">
							<option selected disabled>-- Select --</option>
							<option value="student">Student</option>
							<option value="teacher">Teacher</option>
						</select>
					</div>
					<div class="form-group hidden" id="rollno">
						<label for="roll">Roll number</label>
						<input type="number" class="form-control" id="roll" min="1" max="999999999999999" name="roll" placeholder="Roll number">
					</div>
					<div class="form-group hidden" id="sess">
						<label for="session">Session</label>
						<select name="session" id="session" class="form-control">
							<option selected disabled>-- Select --</option>
							<%
								for(int i = 15; i <= 26; ++i){
									String value = "20" + i + "-" + (i + 4);
									out.println("<option value='" + value + "'>" + value + "</option>");
								}
							%>
						</select>
					</div>
					<div class="form-group">
						<label for="dept">Department</label>
						<select name="dept" id="dept" class="form-control" required="required">
							<option selected disabled>-- Select --</option>
							<%
								PreparedStatement stmt = link.prepareStatement("SELECT * FROM dept");
								ResultSet result = stmt.executeQuery();
								while(result.next()){
									int dept_id = result.getInt("dept_id");
									String dept_name = result.getString("dept_name");
									out.println("<option value='" + dept_id + "'>" + dept_name + "</option>");
								}
							%>
						</select>
					</div>
					<div class="form-group">
						<label for="app">Approve this account</label>
						<select name="app" id="app" class="form-control" required="required">
							<option selected disabled>-- Select --</option>
							<option value="1">Yes</option>
							<option value="0">No</option>
						</select>
					</div>
					<div class="form-group">
						<label for="role">Role</label>
						<select name="role" id="role" class="form-control" required="required">
							<option selected disabled>-- Select --</option>
							<option value="admin">Admin</option>
							<option value="editor">Editor</option>
							<option value="user">Normal user</option>
						</select>
					</div>
					<br><br>
					<button type="submit" class="btn btn-primary">Confirm</button>
				</form>
				<br><br><br><br>
			</div>
		</div>
		<!-- /.container-fluid -->

	</div>
	<!-- /#page-wrapper -->

</div>
<!-- /#wrapper -->

<script type="text/javascript">
	$(function(){
		$("#dob").datepicker({
			format: 'yyyy-mm-dd',
			todayHighlight: true,
			autoclose: true
		});

		$("select#profession > option").click(function(){
			var profession = $(this).val();

			if(profession === "student"){
				$("div#rollno").removeClass("hidden");
				$("div#sess").removeClass("hidden");
				$("select#session").prop("required", true);
				$("input#roll").prop("required", true);
			}else if(profession === "teacher"){
				$("div#rollno").addClass("hidden");
				$("div#sess").addClass("hidden");
				$("select#session").prop("required", false);
				$("input#roll").prop("required", false);
			}
		});
	});

	function checkFN(){
		var name  = $("input#fullname").val();
		var regex = /^([a-zA-Z]|[\s])*$/;

		if(!regex.test(name)){
			$("#admin-modal-confirm").addClass("hidden");
			showModal("Error", "Fullname can contain characters a-z A-Z or whitespaces only.", "", "", "");
			return false;
		}
		return true;
	}
</script>
<jsp:include page="/ea/view/admin_footer.jsp"></jsp:include>
</body>
</html>