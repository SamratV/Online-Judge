<jsp:include page="/view/header.jsp"></jsp:include>
<jsp:include page="/view/navigation.jsp"></jsp:include>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="link.Link"%>
<%@ page import="java.sql.*"%>
<%@ page import="admin.Pager"%>
<%@ page import="admin.TData"%>
<%@ page import="org.owasp.encoder.Encode"%>
<%! public Connection link = Link.getConnection(); %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	if(ValidateField.checkUser(session)){
		response.sendRedirect("./");
		return;
	}

	String tid = request.getParameter("t");
	TData td   = ValidateField.getTData(tid);

	if(!td.isValid()){
		response.sendRedirect("home.jsp");
		return;
	}else if(td.isOver()){
		response.sendRedirect("test_over.jsp");
		return;
	}

	int pageno 		 = ValidateField.getPageNo(request.getParameter("pageno"));
	int per_page 	 = 10;
	int page_current = (pageno * per_page) - per_page;
%>
<div class="container-fluid">
	<br>
	<%
		if(td.isLive()){
	%>
	<div class="container">
		<div id="timer">-- : -- : --</div>
	</div>
	<br>
	<%
		}
	%>
	<div class="container">
		<h5><%=td.getName() %></h5>
		<small class="text-muted">
			Test rank: <%=ValidateField.getTestRank(td.getTid(), session.getAttribute("username").toString())%>
		</small>
		<hr>
<pre class="alert alert-secondary">
<code>
Date:                           <%=td.getDate()%>
Time:                           <%=td.getTime()%>
Duration:                       <%=td.getDuration()%> minutes
Language(s) allowed:            <%=ValidateField.getLang(td.getLang())%>
Number of questions:            <%=td.getQno()%>


<u>Description:</u><br>
<%=Encode.forHtmlContent(td.getDesc())%>
</code>
</pre>
		<br>
		<%
			if(td.isLive() && td.isUploaded()){
				PreparedStatement stmt = link.prepareStatement("SELECT q.qid, q.qtitle, q.qmarks, (SELECT COUNT(qid) FROM submissions WHERE qid=q.qid AND solved=1 AND username=?) AS solved FROM questions AS q WHERE tid=? ORDER BY qtitle ASC LIMIT ?, ?");
				stmt.setString(1, session.getAttribute("username").toString());
				stmt.setInt(2, td.getTid());
				stmt.setInt(3, page_current);
				stmt.setInt(4, per_page);
				ResultSet result = stmt.executeQuery();
				while (result.next()){
					String qtitle  = result.getString("qtitle");
					boolean solved = result.getInt("solved") > 0;
					int qid 	   = result.getInt("qid");
					int qmarks     = result.getInt("qmarks");
		%>
		<div class="card">
			<div class="card-body">
				<div>
					<span class="question-title"><%=qtitle %></span>
					<a href="test_editor.jsp?q=<%=qid %>" class="btn btn-success float-right">Solve</a>
				</div>
				<div>
					<small class="text-muted ml-lg-2">Max score: <%=qmarks %></small>
				<%
					if(solved){
						out.print("<small class='text-muted ml-lg-5'>Solved: <i style='color: #28a745;' class='fas fa-check'></i></small>");
					}
				%>
				</div>
			</div>
		</div>
		<br>
		<%
				}
				stmt.close();
			}else if(td.isLive() && !td.isUploaded()){
		%>
		<div class="alert alert-danger">
			The test questions have not been uploaded. Please contact your admin.
		</div>
		<%
			}
		%>
	</div>
	<%
		if(td.isLive() && td.isUploaded()){
			int count   = td.getUqno();
			Pager pager = new Pager(pageno, per_page, count);
			out.println(pager._getPager());
		}
	%>
</div>
<script type="text/javascript">
	$(function() {
		function pad(n){
			return n < 10 ? "0" + n : n;
		}

		var total = parseInt("<%=(long)Math.ceil(td.getTime_remaining() / 1000.f)%>");

		var x = setInterval(function() {
			var hours   = Math.floor(total / 3600);
			var minutes = Math.floor((total / 60) % 60);
			var seconds = total % 60;
			var timer   = pad(hours) + " : " + pad(minutes) + " : " + pad(seconds);

			$("div#timer").html(timer);

			if (total <= 0) {
				clearInterval(x);
				window.location.replace("test_over.jsp");
			}

			total -= 1;
		}, 1000);
	});
</script>
<jsp:include page="/view/footer.jsp"></jsp:include>