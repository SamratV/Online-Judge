<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
<body>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="admin.TQData"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	if(ValidateField.checkSession(session)){
		response.sendRedirect("../");
		return;
	}

	String qid = request.getParameter("qid");

	TQData tqd        = ValidateField.getTQData(qid);
	String qtitle     = tqd.getTitle();
	String qstatement = tqd.getStatement();
	int qtc_public    = tqd.getTc_public();
	int qtc_private   = tqd.getTc_private();
	boolean uploaded  = tqd.isUploaded();

	if(!tqd.isValid()){
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
					<h2 class="page-header">Edit / View</h2>
				</div>
			</div>
			<!-- /.row -->
			<div class="container col-lg-12">
				<div class="alert alert-warning" role="alert">
					Note: If you re-upload testcases then you will be required to re-upload
					the solution also to complete the upload process and set the uploaded flag.
					Otherwise the question will not be displayed on the users side.
				</div>
			</div>
			<div class="container col-lg-12">
				<button type="button" class="btn btn-default" id="edit-question-button">Edit Question</button>&nbsp;&nbsp;&nbsp;
				<% if(uploaded){%>
				<button type="button" class="btn btn-default" id="view-testcases-button">View Testcases</button>&nbsp;&nbsp;&nbsp;
				<a href="../DownloadTC?qid=<%=qid %>" class="btn btn-default">Download Testcases</a>&nbsp;&nbsp;&nbsp;
				<a href="add_testcases.jsp?qid=<%=qid %>" class="btn btn-default">Re-upload Testcases</a>&nbsp;&nbsp;&nbsp;
				<a href="question_details.jsp?qid=<%=qid %>" class="btn btn-default">View & Download Details</a>&nbsp;&nbsp;&nbsp;
				<a href="../test_preview_editor.jsp?q=<%=qid %>" class="btn btn-default" target="_blank">Preview</a>
				<% }else{%>
				<a href="add_testcases.jsp?qid=<%=qid %>" class="btn btn-default">Upload Testcases</a>&nbsp;&nbsp;&nbsp;
				<a href="question_details.jsp?qid=<%=qid %>" class="btn btn-default">View & Download Details</a>
				<% }%>
				<br><br>
			</div>
			<div class="container col-lg-12 hidden" id="edit-question">
				<form method="post" action="../ETQStatement" id="edit-question-form" onsubmit="return checkQuestion();">
					<input type="hidden" value="<%=qid %>" name="qid">
					<div class="form-group">
						<label for="qtitle">Question title</label>
						<input type="text" class="form-control" id="qtitle" maxlength=100 name="qtitle" placeholder="Title" value="<%=qtitle %>" required="required">
					</div>
					<div class="form-group">
						<label for="qstatement">Question statement</label>
						<br>
						<small class="text-muted">For accessibility help click on the editor and press ALT + 0.</small>
						<textarea class="form-control" id="qstatement" name="qstatement"><%=qstatement %></textarea>
					</div>
					<button type="submit" class="btn btn-primary">Confirm</button>
				</form>
				<br><br><br><br>
			</div>
			<div class="container col-lg-12 hidden" id="view-testcases">
				<div class="form-group">
					<label for="tc_type">Testcase type</label>
					<select class="form-control" id="tc_type">
						<option disabled selected> -- Select -- </option>
						<option value="public">Public</option>
						<option value="private">Private</option>
					</select>
				</div>
				<div class="form-group hidden" id="tc_cat_public">
					<label for="tc_public">Public testcase number</label>
					<select class="form-control" id="tc_public">
						<option disabled selected> -- Select -- </option>
						<%
							for(int i = 1; i <= qtc_public; i++){
								out.println("<option value='" + i + "'>" + i + "</option>");
							}
						%>
					</select>
				</div>
				<div class="form-group hidden" id="tc_cat_private">
					<label for="tc_private">Private testcase number</label>
					<select class="form-control" id="tc_private">
						<option disabled selected> -- Select -- </option>
						<%
							for(int i = 1; i <= qtc_private; i++){
								out.println("<option value='" + i + "'>" + i + "</option>");
							}
						%>
					</select>
				</div>
				<form class="hidden" id="view-testcases-form">
					<input type="hidden" value="<%=qid %>" name="qid">
					<input type="hidden" value="" name="tc_cat">
					<div class="form-group">
						<label for="tc_input">Input</label>
						<textarea class="form-control" id="tc_input" name="tc_input" rows="10" disabled></textarea>
					</div>
					<div class="form-group">
						<label for="tc_output">Output</label>
						<textarea class="form-control" id="tc_output" name="tc_output" rows="10" disabled></textarea>
					</div>
				</form>
				<br><br><br><br>
			</div>
			<div class="container col-lg-12 hidden" id="message"></div>
		</div>
		<!-- /.container-fluid -->

	</div>
	<!-- /#page-wrapper -->

</div>
<script type="text/javascript">
	$("#edit-question-button").click(function(){
		$("#edit-question").toggleClass("hidden");
		$("#view-testcases").addClass("hidden");
		$("#message").addClass("hidden");
	});

	$("#view-testcases-button").click(function(){
		$("#view-testcases").toggleClass("hidden");
		$("#edit-question").addClass("hidden");
		$("#message").addClass("hidden");
	});

	$("select#tc_type option").click(function(){
		var value = $(this).val();
		$("form#view-testcases-form input[name=tc_cat]").val(value);

		if(value === "public"){
			$("#tc_cat_public").removeClass("hidden");
			$("#tc_cat_private").addClass("hidden");
		}else{
			$("#tc_cat_private").removeClass("hidden");
			$("#tc_cat_public").addClass("hidden");
		}

		$("form#view-testcases-form").addClass("hidden");
	});

	$("select#tc_public option, select#tc_private option").click(function(){
		var number 	= $(this).val();
		var type 	= $("form#view-testcases-form input[name=tc_cat]").val();
		var qid 	= $("form#view-testcases-form input[name=qid]").val();

		$.ajax({
			type: "POST",
			url: "../ViewTC",
			data: {tc_no: number, tc_cat: type, qid: qid},
			success: function(data){
				$("#tc_input").html(data.input);
				$("#tc_output").html(data.output);
				$("form#view-testcases-form").removeClass("hidden");
			},
			error: function(){
				$("#message").html("<div class='alert alert-danger col-lg-2 text-center' role='alert'>Unable to fetch data. Please retry.</div>");
				$("#view-testcases").addClass("hidden");
				$("#edit-question").addClass("hidden");
				$("#message").removeClass("hidden");
			}
		});
	});
</script>
<!-- /#wrapper -->
<jsp:include page="/ea/view/admin_footer.jsp"></jsp:include>
</body>
</html>