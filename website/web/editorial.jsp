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

	String qid = request.getParameter("q");
	QSol qs    = ValidateField.getQSol(qid, session.getAttribute("username").toString());

	if(!qs.isValid()){
		response.sendRedirect("home.jsp");
		return;
	}
%>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="admin.QSol"%>
<%@ page import="org.owasp.encoder.Encode"%>
<div class="container">
	<br><br>
	<h5>Admin's solution (Editorial)</h5>
	<hr>
	<%
		if(qs.isSolved() || !ValidateField.checkSession(session)){
	%>
	<small class="ml-lg-5">Language: <%=ValidateField.getLang(qs.getLang())%></small>
	<br><br>
<pre class="alert alert-secondary">
<code>
<%=Encode.forHtml(qs.getCode())%>
</code>
</pre>
	<%
		}else{
	%>
	<div class="alert alert-secondary">
		You cannot see admin's solution because you have not solved this question.
	</div>
	<%
		}
	%>
	<br><br>
</div>
<jsp:include page="/view/footer.jsp"></jsp:include>