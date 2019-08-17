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

	UData ud = ValidateField.getUData(session.getAttribute("username").toString());
%>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="admin.UData" %>
<div class="container-fluid">
	<br><br>
	<div class="container">
		<h5>Your profile</h5>
		<hr>
		<pre class="alert alert-secondary">
<code>
Username:      <%=ud.getUsername()%>
Fullname:      <%=ud.getFullname()%>
D.O.B:         <%=ud.getDob()%>
Session:       <%=ud.getProfession().equals("teacher") ? "NA" : ud.getBatch()%>
Roll number:   <%=ud.getProfession().equals("teacher") ? "NA" : ud.getRoll()%>
Department:    <%=ud.getDept_name()%>
Email:         <%=ud.getEmail()%>
Profession:    <%=ValidateField.capitalize(ud.getProfession())%>
Last activity: <%=ud.getLast_activity()%>
</code>
</pre>
	</div>
	<div class="container">
		<br>
		<a href="pass_reset.jsp" class="btn btn-outline-success">Reset password</a>&nbsp;&nbsp;&nbsp;
		<a href="edit_profile.jsp" class="btn btn-outline-success">Edit</a>&nbsp;&nbsp;&nbsp;
		<a href="domain_rank.jsp" class="btn btn-outline-success">Domain ranks <i class="fas fa-chart-line"></i></a>&nbsp;&nbsp;&nbsp;
		<a href="test_rank.jsp" class="btn btn-outline-success">Test ranks <i class="fas fa-chart-line"></i></a>
	</div>
</div>
<jsp:include page="/view/footer.jsp"></jsp:include>