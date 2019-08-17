<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
<body>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="admin.QData"%>
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
	QData qd   = ValidateField.getQData(qid);
	TQData tqd = ValidateField.getTQData(qid);

	if(!qd.isValid() && !tqd.isValid()){
		response.sendRedirect("../ea/");
		return;
	}

	String lang    = qd.isValid() ? qd.getLang() : tqd.getLang();
	int tc_public  = qd.isValid() ? qd.getTc_public() : tqd.getTc_public();
	int tc_private = qd.isValid() ? qd.getTc_private() : tqd.getTc_private();
%>
<div id="wrapper">

	<jsp:include page="/ea/view/admin_navigation.jsp"></jsp:include>

	<div id="page-wrapper">

		<div class="container-fluid">

			<!-- Page Heading -->
			<div class="row">
				<div class="col-lg-12">
					<h2 class="page-header">
						Upload solution
					</h2>
				</div>
			</div>
			<!-- /.row -->
			<div class="container col-lg-12">
				<form action="../USolution" method="post">
					<input type="hidden" name="qid" value="<%=qid %>">
					<div class="form-group">
						<label for="lang">Language</label>
						<select name="lang" id="lang" class="form-control" required="required">
						<%
							if(lang.equals("all")){
						%>
							<option value="c" selected>C</option>
							<option value="cpp">C++</option>
							<option value="java">Java</option>
							<option value="python">Python</option>
						<%
							}else{
						%>
							<option value="<%=lang%>" selected><%=ValidateField.getLang(lang)%></option>
						<%
							}
						%>
						</select>
					</div>
					<div class="form-group">
						<label for="soln">Code</label>
						<textarea class="form-control" id="soln" rows="10" name="soln" required="required"></textarea>
					</div>
					<div class="form-group hidden" id="public-msg">
						<i style="color: #28a745;" class="fas fa-check"></i> Public testcases checked.
					</div>
					<div class="form-group hidden" id="private-msg">
						<i style="color: #28a745;" class="fas fa-check"></i> Private testcases checked.
					</div>
					<input type="button" class="btn btn-default" id="btn-public" value="Check against public testcases">
					<input type="button" class="btn btn-default hidden" id="btn-private" value="Check against private testcases">
					<input type="submit" class="btn btn-primary hidden" id="btn-upload" value="Upload">
				</form>
				<br><br><br><br><br><br>
			</div>
		</div>
		<!-- /.container-fluid -->

	</div>
	<!-- /#page-wrapper -->

	<script type="text/javascript">
		$("#btn-public").click(function(){
			execute("public");
		});

		$("#btn-private").click(function(){
			execute("private");
		});

		function execute(mode){
			var ldr = "<div id='load-screen'><div id='loading'></div></div>";
			$("body").prepend(ldr);

			var code = $("textarea#soln").val();
			var lang = $("select#lang option:selected").val();

			if(code.length === 0){
				$("#load-screen").delay(290).fadeOut(10, function(){
					$(this).remove();
					$("#admin-modal-confirm").addClass("hidden");
					showModal("Error", "No code was written. Please write some code.", "", "", "");
				});
			}else if(code.length > 51200){
				$("#load-screen").delay(290).fadeOut(10, function(){
					$(this).remove();
					$("#admin-modal-confirm").addClass("hidden");
					showModal("Error", "Your code is too large(> 50 KB).", "", "", "");
				});
			}else{
				var tc_count = mode === "public" ? "<%=tc_public %>" : "<%=tc_private %>";
				$.ajax({
					type: "POST",
					url: "../UCompile",
					data: {source: code, lang: lang, mode: mode, qid: "<%=qid %>", tc_count: tc_count},
					success: function(data){
						$("#load-screen").delay(290).fadeOut(10, function(){
							$(this).remove();

							if(data === "1"){
								if(mode === "public"){
									$("div#public-msg").removeClass("hidden");
									$("div#private-msg").addClass("hidden");
									$("input#btn-public").addClass("hidden");
									$("input#btn-private").removeClass("hidden");
									$("input#btn-upload").addClass("hidden");
								}else{
									$("div#public-msg").removeClass("hidden");
									$("div#private-msg").removeClass("hidden");
									$("input#btn-public").addClass("hidden");
									$("input#btn-private").addClass("hidden");
									$("input#btn-upload").removeClass("hidden");
								}
							}else{
								data = data === null ? "" : data.trim();
								data = data.length === 0 ? "Error code: 6<br>Controller exception." : data;
								$("#admin-modal-confirm").addClass("hidden");
								showModal("Error", data, "", "", "");
							}
						});
					},
					error: function(){
						$("#load-screen").delay(290).fadeOut(10, function(){
							$(this).remove();
							$("#admin-modal-confirm").addClass("hidden");
							showModal("Error", "Cannot check code against " + mode + " testcases.", "", "", "");
						});
					}
				});
			}
		}
	</script>

</div>
<!-- /#wrapper -->
<jsp:include page="/ea/view/admin_footer.jsp"></jsp:include>
</body>
</html>