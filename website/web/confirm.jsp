<jsp:include page="/view/header.jsp"></jsp:include>
<jsp:include page="/view/navigation.jsp"></jsp:include>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	String user = request.getParameter("u");
	UData ud    = ValidateField.getUData(user);

	if(!ud.isValid() || ud.isConfirmed()){
		response.sendRedirect("./");
		return;
	}

	String url = request.getRequestURL().toString();
%>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.UData"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="link.Link"%>
<%@ page import="java.sql.*"%>
<%! public Connection link = Link.getConnection(); %>
<div class="container">
	<br><br><br>
	<div class="col-lg-5 table-center border form-box">
		<h3 class="text-center"><i class="fa fa-users fa-2x"></i></h3>
		<h5 class="text-center">Confirm account</h5>
		<p class="text-center">
			<small>Please enter your profile details here.</small>
		</p>
		<form method="post" action="CAMailer" onsubmit="return checkFN();">
			<input type="hidden" name="username" value="<%=ud.getUsername()%>">
			<input type="hidden" name="url" value="<%=url.substring(0, url.indexOf("confirm.jsp"))%>">
			<div class="form-group">
				<label for="fullname">Fullname</label>
				<input type="text" class="form-control" id="fullname" maxlength="100" name="fullname" placeholder="Fullname" required="required">
			</div>
			<div class="form-group">
				<label for="dob">Date of birth</label>
				<input type="text" class="form-control" name="dob" id="dob" placeholder="D.O.B" required="required">
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
			<br>
			<div class="text-center">
				<button type="submit" class="btn btn-success">Confirm</button>
			</div>
			<br>
		</form>
	</div>
	<br>
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