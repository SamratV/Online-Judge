<jsp:include page="/view/header.jsp"></jsp:include>
<jsp:include page="/view/navigation.jsp"></jsp:include>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="link.Link"%>
<%@ page import="java.sql.*"%>
<%@ page import="admin.CData"%>
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
			
	String cid 		= request.getParameter("cat");
	CData cd   		= ValidateField.getCData(cid);
	String cat_name = cd.getCname();

	if(!cd.isValid()){
		response.sendRedirect("home.jsp");
		return;
	}
%>
<div class="container-fluid">
	<br>
	<div class="container">
		<h5><%=cat_name %></h5>
		<small class="text-muted">
			Domain rank: <%=ValidateField.getCategoryRank(cd.getCid(), session.getAttribute("username").toString())%>
		</small>
		<hr>
		<div class="row">
			<%
				PreparedStatement stmt = link.prepareStatement("SELECT * FROM subcategory WHERE cid=? ORDER BY scname ASC");
				stmt.setInt(1, cd.getCid());
				ResultSet result = stmt.executeQuery();
				while (result.next()){
					int scid      = result.getInt("scid");
					String scname = result.getString("scname");
					out.println("<a href='problems.jsp?cat=" + cd.getCid() + "&scat=" + scid + "'><div class='tabs'>" + scname + "</div></a>");
		        }
				stmt.close();
			%>
		</div>
	</div>
</div>
<jsp:include page="/view/footer.jsp"></jsp:include>