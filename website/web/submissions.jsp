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

	String qid  = request.getParameter("q");
	String user = session.getAttribute("username").toString();
	String time = request.getParameter("ti");
	int id      = ValidateField.getInt(qid);

	if(id <= 0){
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
<%@ page import="org.owasp.encoder.Encode" %>
<%@ page import="compiler.OutputFormatter" %>
<%@ page import="admin.Pager" %>
<%! public Connection link = Link.getConnection(); %>
<div class="container">
	<br><br>
	<h5>Submissions</h5>
	<small class="text-muted">
		Note: Recent submissions might take a while to appear on this page.
	</small>
	<hr>
	<%
		if(time != null){
			String query = "SELECT lang, passed_tc, qcode, solved, exec_time, exec_mem FROM submissions WHERE qid=? AND username=? AND time_solved=?";
			PreparedStatement stmt = link.prepareStatement(query);
			stmt.setInt(1, id);
			stmt.setString(2, user);
			stmt.setLong(3, Long.parseLong(time));
			ResultSet result = stmt.executeQuery();
			while(result.next()){
				String lang    = result.getString("lang");
				String code    = result.getString("qcode");
				boolean solved = result.getInt("solved") > 0;
				long exec_mem  = result.getLong("exec_mem");
				int exec_time  = result.getInt("exec_time");
				int passed     = result.getInt("passed_tc");
	%>
	<small class="ml-lg-5">Status: <%=solved ? "Success" : "Failure"%></small>
	<small class="ml-lg-5">Number of testcase(s) passed: <%=passed%></small>
	<small class="ml-lg-5">Language: <%=ValidateField.getLang(lang)%></small>
	<small class="ml-lg-5">Max time: <%=OutputFormatter.round(exec_time / 1000.f)%> s</small>
	<small class="ml-lg-5">Max memory: <%=OutputFormatter.round(exec_mem / (1024 * 1024.f))%> MB</small>
	<br><br>
<pre class="alert alert-secondary">
<code>
<%=Encode.forHtml(code)%>
</code>
</pre>
	<br>
	<%
			}
			stmt.close();
		}else{
			String query = "SELECT time_solved, lang, solved FROM submissions WHERE qid=? AND username=? LIMIT ?, ?";
			PreparedStatement stmt = link.prepareStatement(query);
			stmt.setInt(1, id);
			stmt.setString(2, user);
			stmt.setInt(3, page_current);
			stmt.setInt(4, per_page);
			ResultSet result = stmt.executeQuery();
			int i = (pageno - 1) * per_page + 1;
			while(result.next()){
				String lang    = result.getString("lang");
				boolean solved = result.getInt("solved") > 0;
				long timestamp = result.getLong("time_solved");
	%>
	<div class="card">
		<div class="card-body">
			<div>
				Submission &raquo; <%=i%>
				<a href="submissions.jsp?q=<%=qid %>&ti=<%=timestamp%>" class="btn btn-success float-right">View</a>
			</div>
			<div>
				<small class="text-muted">Language: <%=ValidateField.getLang(lang)%></small>
				<small class="text-muted ml-lg-5">Status: <%=solved ? "Success" : "Failure"%></small>
			</div>
		</div>
	</div>
	<br>
	<%
				++i;
			}
			stmt.close();
		}
	%>
	<br>
</div>
<%
	if(time == null){
		int count   = ValidateField.countSubmissions(id, user);
		Pager pager = new Pager(pageno, per_page, count);
		out.println(pager._getPager());
	}
%>
<jsp:include page="/view/footer.jsp"></jsp:include>