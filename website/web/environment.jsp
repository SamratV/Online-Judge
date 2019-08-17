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
%>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<div class="container-fluid">
	<br><br>
	<div class="container">
		<h5>Online judge configurations</h5>
		<hr>
		<p class="text-center">
			Environment for the supported programming languages are as following (OS &raquo; Ubuntu 18.04):
			<br><br>
		</p>
		<div class="col-lg-8 table-center">
			<table class="table table-bordered table-hover text-center">
				<thead>
					<tr>
						<th class="col-xs-2 text-center">Language</th>
						<th class="col-xs-2 text-center">Version</th>
						<th class="col-xs-2 text-center">Time limit</th>
						<th class="col-xs-2 text-center">Memory limit</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>C (C11)</td>
						<td>7.3.0</td>
						<td>2 seconds</td>
						<td>128 MB</td>
					</tr>
					<tr>
						<td>C++ (C++14)</td>
						<td>7.3.0</td>
						<td>2 seconds</td>
						<td>128 MB</td>
					</tr>
					<tr>
						<td>Java (Oracle)</td>
						<td>11.0.2</td>
						<td>4 seconds</td>
						<td>128 MB</td>
					</tr>
					<tr>
						<td>Python</td>
						<td>3.6.5</td>
						<td>5 seconds</td>
						<td>128 MB</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>
<jsp:include page="/view/footer.jsp"></jsp:include>