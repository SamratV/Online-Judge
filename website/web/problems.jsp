<jsp:include page="/view/header.jsp"></jsp:include>
<jsp:include page="/view/navigation.jsp"></jsp:include>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="link.Link"%>
<%@ page import="java.sql.*"%>
<%@ page import="admin.CSData"%>
<%@ page import="admin.Pager"%>
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
	
	String cid 	= request.getParameter("cat");
	String scid = request.getParameter("scat");
	CSData csd 	= ValidateField.getCSData(cid, scid);

	String cat_name  = csd.getCname();
	String scat_name = csd.getScname();

	if(!csd.isValid()){
		response.sendRedirect("home.jsp");
		return;
	}

	int pageno 		 = ValidateField.getPageNo(request.getParameter("pageno"));
	int per_page 	 = 10;
	int page_current = (pageno * per_page) - per_page;
	int mode         = ValidateField.getInt(request.getParameter("mode"));

	String query;

	switch(mode){
		case 1: query = "SELECT q.qid, q.qtitle, q.qmarks, 1 AS solved FROM questions AS q WHERE uploaded=1 AND (SELECT COUNT(qid) FROM submissions WHERE qid=q.qid AND solved=1 AND username=?) > 0 AND scid=? ORDER BY qtitle ASC LIMIT ?, ?";
			break;
		case 2: query = "SELECT q.qid, q.qtitle, q.qmarks, 0 AS solved FROM questions AS q WHERE uploaded=1 AND (SELECT COUNT(qid) FROM submissions WHERE qid=q.qid AND solved=1 AND username=?) < 1 AND scid=? ORDER BY qtitle ASC LIMIT ?, ?";
			break;
		default: query = "SELECT q.qid, q.qtitle, q.qmarks, (SELECT COUNT(qid) FROM submissions WHERE qid=q.qid AND solved=1 AND username=?) AS solved FROM questions AS q WHERE scid=? AND uploaded=1 ORDER BY qtitle ASC LIMIT ?, ?";
	}
%>
<div class="container-fluid">
	<br>
	<div class="container">
		<h5><%="<a class='go-back' href='topics.jsp?cat=" + cid + "'>" + cat_name + "</a>" + " &raquo; " + scat_name %></h5>
		<small class="text-muted">
			Domain rank: <%=ValidateField.getCategoryRank(csd.getCid(), session.getAttribute("username").toString())%>
		</small>
		<hr>
		<div>
			<span class="ml-lg-5">
				All <input class="list-mode" type="checkbox" value="3" <%=mode != 1 && mode != 2 ? "checked" : ""%>>
			</span>
			<span class="ml-lg-5">
				Solved <input class="list-mode" type="checkbox" value="1" <%=mode == 1 ? "checked" : ""%>>
			</span>
			<span class="ml-lg-5">
				Unsolved <input class="list-mode" type="checkbox" value="2" <%=mode == 2 ? "checked" : ""%>>
			</span>
		</div>
		<br>
		<%
			PreparedStatement stmt = link.prepareStatement(query);
			stmt.setString(1, session.getAttribute("username").toString());
			stmt.setInt(2, csd.getScid());
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
					<a href="code_editor.jsp?q=<%=qid %>" class="btn btn-success float-right">Solve</a>
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
		%>
	</div>
	<%
		int count   = ValidateField.countQuestions(scid);
		Pager pager = new Pager(pageno, per_page, count);
		out.println(pager._getPager());
	%>
</div>
<script type="text/javascript">
	$(".list-mode").click(function(){
		if(this.checked){
			window.location.replace("problems.jsp?cat=<%=cid%>&scat=<%=scid%>&mode=" + $(this).val());
		}else{
			this.checked = !this.checked;
		}
	});
</script>
<jsp:include page="/view/footer.jsp"></jsp:include>