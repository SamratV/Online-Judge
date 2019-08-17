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
	<h5>Live tests</h5>
	<hr>
	<div class="alert alert-secondary">
		Click view button to view upcoming tests.
		<a href="upcoming_exams.jsp" class="btn btn-info ml-lg-5">View</a>
	</div>
	<br>
	<%
		PreparedStatement stmt = link.prepareStatement("SELECT tid, name, no_of_questions, TIMESTAMP(date, time) + INTERVAL duration MINUTE AS ends FROM test WHERE TIMESTAMP(date, time) < NOW() AND NOW() < TIMESTAMP(date, time) + INTERVAL duration MINUTE ORDER BY time ASC LIMIT ?, ?");
		stmt.setInt(1, page_current);
		stmt.setInt(2, per_page);
		ResultSet result = stmt.executeQuery();
		while (result.next()){
			int tid 	= result.getInt("tid");
			int n       = result.getInt("no_of_questions");
			String name = result.getString("name");
			String ends = result.getString("ends");
	%>
	<div class="card">
		<div class="card-body">
			<div>
				<%=name %>
				<a href="test_problems.jsp?t=<%=tid %>" class="btn btn-success float-right">Attempt</a>
			</div>
			<div>
				<small class="text-muted">Ends: <%=ends.substring(0, ends.lastIndexOf(':')) %></small>
				<small class="text-muted ml-lg-5">Number of questions: <%=n %></small>
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
	int count   = ValidateField.countLiveTests();
	Pager pager = new Pager(pageno, per_page, count);
	out.println(pager._getPager());
%>
<jsp:include page="/view/footer.jsp"></jsp:include>