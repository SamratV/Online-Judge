<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
<body>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="admin.UData"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	if(ValidateField.checkSession(session)){
		response.sendRedirect("../");
		return;
	}

	String username = request.getParameter("u");
	UData ud        = ValidateField.getUData(username);

	if(!ud.isValid()){
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
					<h2 class="page-header">User details</h2>
				</div>
			</div>
			<!-- /.row -->
			<div class="container col-lg-12">
<pre>
<code>
Username:                   <%=ud.getUsername()%>
Fullname:                   <%=ud.getFullname()%>
D.O.B:                      <%=ud.getDob()%>
Session:                    <%=ud.getProfession().equals("teacher") ? "NA" : ud.getBatch()%>
Roll number:                <%=ud.getProfession().equals("teacher") ? "NA" : ud.getRoll()%>
Department:                 <%=ud.getDept_name()%>
Email:                      <%=ud.getEmail()%>
Profession:                 <%=ValidateField.capitalize(ud.getProfession())%>
Role:                       <%=ud.getRole()%>
Last activity:              <%=ud.getLast_activity()%>
Account confirmed by user:  <%=ud.isConfirmed() ? "Yes" : "No"%>
Account approved by admin:  <%=ud.isApproved() ? "Yes" : "No"%>
</code>
</pre>
			</div>
			<div class="container col-lg-12">
				<br>
				<a href="domain_rank.jsp?u=<%=ud.getUsername()%>" class="btn btn-default">Domain ranks</a>&nbsp;&nbsp;&nbsp;
				<a href="user_test_rank.jsp?u=<%=ud.getUsername()%>" class="btn btn-default">Test ranks</a>&nbsp;&nbsp;&nbsp;
				<%
					if(ValidateField.isAdmin(session)){
				%>
						<a href="reset_pass.jsp?u=<%=ud.getUsername()%>" class="btn btn-default">Reset password</a>&nbsp;&nbsp;&nbsp;
				<%
						if(!ud.getUsername().equals(session.getAttribute("username"))){
							if(!ud.isApproved()){
				%>
								<a href="approval.jsp?action=1&u=<%=ud.getUsername()%>" class="btn btn-primary">Approve</a>&nbsp;&nbsp;&nbsp;
				<%
							}else{%>
								<a href="approval.jsp?action=0&u=<%=ud.getUsername()%>" class="btn btn-primary">Disapprove</a>&nbsp;&nbsp;&nbsp;
				<%
							}
							if(!ud.isConfirmed()){
				%>
								<a href="confirm.jsp?u=<%=ud.getUsername()%>" class="btn btn-success">Confirm</a>&nbsp;&nbsp;&nbsp;
				<%
							}
				%>
							<a href="change_role.jsp?u=<%=ud.getUsername()%>" class="btn btn-warning">Change role</a>&nbsp;&nbsp;&nbsp;
							<a href="<%=ud.getUsername()%>" id="delete_user" class="btn btn-danger">Delete</a>
				<%
						}
					}else if(ud.getUsername().equals(session.getAttribute("username"))){
				%>
						<a href="reset_pass.jsp?u=<%=ud.getUsername()%>" class="btn btn-default">Reset password</a>
				<%
					}
				%>
				<br><br><br><br>
			</div>
		</div>
		<!-- /.container-fluid -->

	</div>
	<!-- /#page-wrapper -->

</div>
<!-- /#wrapper -->
<jsp:include page="/ea/view/admin_footer.jsp"></jsp:include>
</body>
</html>