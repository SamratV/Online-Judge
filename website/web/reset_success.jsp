<jsp:include page="/view/header.jsp"></jsp:include>
<jsp:include page="/view/navigation.jsp"></jsp:include>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
%>
<%@ page errorPage="error.jsp"%>
<div class="container">
	<br><br><br><br>
	<h6 class="text-center">
		Password reset successful.
	</h6>
	<br><br>
	<div class="text-center">
		<a href="./" class="btn btn-success">Back to home</a>
	</div>
</div>
<jsp:include page="/view/footer.jsp"></jsp:include>