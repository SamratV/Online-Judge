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

	String user = session.getAttribute("username").toString();
	UData ud    = ValidateField.getUData(user);

	if(!ud.isValid()){
		response.sendRedirect("./");
		return;
	}

	int pageno 		 = ValidateField.getPageNo(request.getParameter("pageno"));
	int per_page 	 = 10;
	int page_current = (pageno * per_page) - per_page;
%>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="admin.UData" %>
<%@ page import="link.Link"%>
<%@ page import="java.sql.*"%>
<%@ page import="admin.Pager" %>
<%! public Connection link = Link.getConnection(); %>
<div class="container-fluid">
	<br><br>
	<div class="container">
		<h5>Test ranks</h5>
		<hr>
		<br>
		<div class="col-lg-8 table-center">
			<table class="table table-bordered table-hover text-center">
				<thead>
					<tr>
						<th class="col-xs-4 text-center">Test name</th>
						<th class="col-xs-2 text-center">Test date</th>
						<th class="col-xs-2 text-center">Rank</th>
					</tr>
				</thead>
				<tbody>
					<%
						String query = "SELECT (SELECT COUNT(username) FROM test_score WHERE tid=t.tid AND (marks>t.marks OR (marks=t.marks AND cmp_index>t.cmp_index))) + 1 AS rank, ts.name, ts.date FROM test_score AS t LEFT OUTER JOIN test AS ts ON t.tid=ts.tid WHERE t.username=? ORDER BY ts.tid LIMIT ?, ?";
						PreparedStatement stmt = link.prepareStatement(query);
						stmt.setString(1, ud.getUsername());
						stmt.setInt(2, page_current);
						stmt.setInt(3, per_page);
						ResultSet result = stmt.executeQuery();
						while (result.next()){
					%>
					<tr>
						<td><%=result.getString("name")%></td>
						<td><%=result.getString("date")%></td>
						<td><%=result.getInt("rank")%></td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
			<br><br>
		</div>
	</div>
	<%
		stmt = link.prepareStatement("SELECT COUNT(tid) AS num FROM test_score WHERE username=?");
		stmt.setString(1, ud.getUsername());
		result = stmt.executeQuery();
		int count = result.next() ? result.getInt("num") : 0;
		stmt.close();

		Pager pager = new Pager(pageno, per_page, count);
		out.println(pager._getPager());
	%>
</div>
<jsp:include page="/view/footer.jsp"></jsp:include>