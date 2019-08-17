<jsp:include page="/view/header.jsp"></jsp:include>
<jsp:include page="/view/navigation.jsp"></jsp:include>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	String token = request.getParameter("cat");
	String user  = request.getParameter("u");
	UData ud     = ValidateField.getUData(user);

	if(!ud.isValid() || ud.isConfirmed() || !token.equals(ud.getToken())){
		response.sendRedirect("./");
		return;
	}

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	Date sent = sdf.parse(ud.getToken_time());
	Date now  = new Date();
	long time = (now.getTime() - sent.getTime()) / (1000 * 60);
%>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.UData"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="link.Link"%>
<%@ page import="java.sql.*"%>
<%@ page import="auth.Mailer"%>
<%! public Connection link = Link.getConnection(); %>
<div class="container">
	<%
		if(time >= 15){
	%>
	<br><br><br><br>
	<h6 class="text-center">
		This link has expired.
	</h6>
	<br><br>
	<div class="text-center">
		<a href="./" class="btn btn-success">Back to home</a>
	</div>
	<%
	}else{
			PreparedStatement stmt = link.prepareStatement("UPDATE users SET confirmed=1, reset_token=? WHERE username=?");
			stmt.setString(1, Mailer.getRandomText());
			stmt.setString(2, ud.getUsername());
			stmt.executeUpdate();
			stmt.close();
	%>
	<br><br><br><br>
	<h6 class="text-center">
		Account confirmed successfully.
	</h6>
	<br><br>
	<div class="text-center">
		<a href="./" class="btn btn-success">Login here</a>
	</div>
	<br><br>
	<div class="text-center alert alert-warning col-lg-7 table-center">
		Note: You cannot login until the admin approves your account.
	</div>
	<%
		}
	%>
</div>
<jsp:include page="/view/footer.jsp"></jsp:include>