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

	int pageno 		 = ValidateField.getPageNo(request.getParameter("pageno"));
	int per_page 	 = 10;
	int page_current = (pageno * per_page) - per_page;
%>
<%@ page errorPage="error.jsp"%>
<%@ page import="link.Link"%>
<%@ page import="java.sql.*"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="admin.Pager" %>
<%! public Connection link = Link.getConnection(); %>
<div class="container">
	<br><br>
	<h5>Upcoming tests</h5>
	<hr>
	<div class="alert alert-secondary">
		Click view button to view live tests.
		<a href="exam.jsp" class="btn btn-info ml-lg-5">View</a>
	</div>
	<br>
	<%
		PreparedStatement stmt = link.prepareStatement("SELECT tid, name, no_of_questions, duration, TIMESTAMP(date, time) AS starts FROM test WHERE TIMESTAMP(date, time) > NOW() ORDER BY date ASC, time ASC LIMIT ?, ?");
		stmt.setInt(1, page_current);
		stmt.setInt(2, per_page);
		ResultSet result = stmt.executeQuery();
		while (result.next()){
			int tid 	  = result.getInt("tid");
			int n         = result.getInt("no_of_questions");
			int d         = result.getInt("duration");
			String name   = result.getString("name");
			String starts = result.getString("starts");
	%>
	<div class="card">
		<div class="card-body">
			<div>
				<%=name %>
				<a href="test_problems.jsp?t=<%=tid %>" class="btn btn-secondary float-right">Details</a>
			</div>
			<div>
				<small class="text-muted">Starts: <%=starts.substring(0, starts.lastIndexOf(':')) %></small>
				<small class="text-muted ml-lg-5">Number of questions: <%=n %></small>
				<small class="text-muted ml-lg-5">Duration: <%=d %> minutes</small>
			</div>
		</div>
	</div>
	<br>
	<%
		}
		stmt.close();
	%>
</div>
<%
	int count   = ValidateField.countUpcomingTests();
	Pager pager = new Pager(pageno, per_page, count);
	out.println(pager._getPager());
%>
<jsp:include page="/view/footer.jsp"></jsp:include>