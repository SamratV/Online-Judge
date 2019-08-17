<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
<body>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="link.Link"%>
<%@ page import="java.sql.*"%>
<%! public Connection link = Link.getConnection(); %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	if(!ValidateField.isAdmin(session)){
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
					<h2 class="page-header">Mass disapprove</h2>
					<small class="text-muted">
						Note: This action will have no effect on your account.
					</small>
				</div>
			</div>
			<!-- /.row -->
			<div class="container col-lg-12">
				<br><br>

				<form method="post" action="../MassApp">
					<input type="hidden" name="app" value="0">
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
						<label for="profession">Profession</label>
						<select name="profession" id="profession" class="form-control" required="required">
							<option selected disabled>-- Select --</option>
							<option value="student">Student</option>
							<option value="teacher">Teacher</option>
						</select>
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
					<br><br>
					<button type="submit" class="btn btn-primary">Confirm</button>
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
		$("select#profession > option").click(function(){
			var profession = $(this).val();

			if(profession === "student"){
				$("div#sess").removeClass("hidden");
				$("select#session").prop("required", true);
			}else if(profession === "teacher"){
				$("div#sess").addClass("hidden");
				$("select#session").prop("required", false);
			}
		});
	});
</script>
<jsp:include page="/ea/view/admin_footer.jsp"></jsp:include>
</body>
</html>