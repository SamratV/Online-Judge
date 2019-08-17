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
<div class="container">
	<br><br><br><br>
	<h6 class="text-center">The test is over. Thank you for taking the test.</h6>
	<br><br>
	<div class="text-center">
		<a href="home.jsp" class="btn btn-success">Back to home</a>
	</div>
</div>
<jsp:include page="/view/footer.jsp"></jsp:include>