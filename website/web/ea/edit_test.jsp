<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
<body>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="admin.TData"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	if(ValidateField.checkSession(session)){
		response.sendRedirect("../");
		return;
	}

	String tid = request.getParameter("tid");
	TData td   = ValidateField.getTData(tid);

	if(!td.isValid()){
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
					<h2 class="page-header">Edit test</h2>
				</div>
			</div>
			<!-- /.row -->
			<div class="container col-lg-12">
				<form action="../EditTest" method="post" onsubmit="return checkTest();">
					<input type="hidden" name="tid" value="<%=td.getTid()%>">
					<div class="form-group">
						<label for="tname">Test name</label>
						<input type="text" class="form-control" id="tname" maxlength=100 name="name" value="<%=td.getName()%>" placeholder="Name" required="required">
					</div>
					<div class="form-group">
						<label for="tlang">Allowed language(s)</label>
						<select name="lang" id="tlang" class="form-control" required="required">
							<option value="all" <%=td.getLang().equals("all") ? "selected" : ""%>>All</option>
							<option value="c" <%=td.getLang().equals("c") ? "selected" : ""%>>C</option>
							<option value="cpp" <%=td.getLang().equals("cpp") ? "selected" : ""%>>C++</option>
							<option value="java" <%=td.getLang().equals("java") ? "selected" : ""%>>Java</option>
							<option value="python" <%=td.getLang().equals("python") ? "selected" : ""%>>Python</option>
						</select>
					</div>
					<div class="form-group">
						<label for="tduration">Duration</label>
						<select name="duration" id="tduration" class="form-control" required="required">
							<%
								for(int i = 1; i <= 12; i++){
									String selected = td.getDuration() == i * 30 ? "selected" : "";
									out.println("<option value='" + i * 30 + "' " + selected + ">" + i * 30 + " minutes</option>");
								}
							%>
						</select>
					</div>
					<div class="form-group">
						<label for="tdatepicker">Date</label>
						<input type="text" class="form-control" name="date" value="<%=td.getDate()%>" id="tdatepicker" required="required">
					</div>
					<div class="form-group">
						<div class="col-lg-12 no-padding">
							<label for="thour">Time</label>
						</div>
						<div class="col-lg-2 no-padding mr-custom-20-px">
							<select class="form-control" name="hour" id="thour" required="required">
								<%
									for(int i = 0; i <= 23; i++){
										String x = i < 10 ? "0" + i : Integer.toString(i);
										String selected = Integer.parseInt(td.getTime().split(":")[0]) == i ? "selected" : "";
										out.println("<option value='" + x + "' " + selected + ">" + x + "</option>");
									}
								%>
							</select>
						</div>
						<div class="col-lg-2 no-padding">
							<select class="form-control" name="min" id="tmin" required="required">
								<%
									for(int i = 0; i <= 59; i++){
										String x = i < 10 ? "0" + i : Integer.toString(i);
										String selected = Integer.parseInt(td.getTime().split(":")[1]) == i ? "selected" : "";
										out.println("<option value='" + x + "' " + selected + ">" + x + "</option>");
									}
								%>
							</select>
						</div>
						<div class="clear-float-both"></div>
					</div>
					<div class="form-group">
						<label for="tqno">Number of questions</label>
						<select name="qno" id="tqno" class="form-control" required="required">
							<%
								for(int i = 1; i <= 12; i++){
									String selected = td.getQno() == i ? "selected" : "";
									out.println("<option value='" + i + "' " + selected + ">" + i + "</option>");
								}
							%>
						</select>
					</div>
					<div class="form-group">
						<label for="tdesc">Test description / rules</label>
						<textarea class="form-control" id="tdesc" rows="10" name="description" required="required"><%=td.getDesc()%></textarea>
					</div>
					<button type="submit" class="btn btn-primary">Save</button>
				</form>
				<br><br><br><br><br><br>
			</div>
		</div>
		<!-- /.container-fluid -->

	</div>
	<!-- /#page-wrapper -->

	<script type="text/javascript">
		$(function(){
			$("#tdatepicker").datepicker({
				format: 'yyyy-mm-dd',
				startDate: '-0m',
				todayHighlight: true,
				autoclose: true
			});
		});
	</script>

</div>
<!-- /#wrapper -->
<jsp:include page="/ea/view/admin_footer.jsp"></jsp:include>
</body>
</html>