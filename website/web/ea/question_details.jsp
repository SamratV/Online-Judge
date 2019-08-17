<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
<body>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="admin.QData"%>
<%@ page import="admin.QSol"%>
<%@ page import="admin.TQData"%>
<%@ page import="org.owasp.encoder.Encode"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	if(ValidateField.checkSession(session)){
		response.sendRedirect("../");
		return;
	}

	String qid = request.getParameter("qid");
	QData qd   = ValidateField.getQData(qid);
	TQData tqd = ValidateField.getTQData(qid);

	if(!qd.isValid() && !tqd.isValid()){
		response.sendRedirect("../ea/");
		return;
	}

	QSol qs          = ValidateField.getQSol(qid);
	String title     = qd.isValid() ? qd.getTitle() : tqd.getTitle();
	String statement = qd.isValid() ? qd.getStatement() : tqd.getStatement();
	int tc_public    = qd.isValid() ? qd.getTc_public() : tqd.getTc_public();
	int tc_private   = qd.isValid() ? qd.getTc_private() : tqd.getTc_private();
	int marks        = qd.isValid() ? qd.getMarks() : tqd.getMarks();
	boolean uploaded = qd.isValid() ? qd.isUploaded() : tqd.isUploaded();
%>
<div id="wrapper">

	<jsp:include page="/ea/view/admin_navigation.jsp"></jsp:include>

	<div id="page-wrapper">

		<div class="container-fluid">

			<!-- Page Heading -->
			<div class="row">
				<div class="col-lg-12">
					<h2 class="page-header">Question details</h2>
				</div>
			</div>
			<!-- /.row -->
			<div class="container col-lg-12">
<pre>
<code>
Question title:                 <%=title%>
Marks:                          <%=marks%>
Number of public testcases:     <%=tc_public%>
Number of private testcases:    <%=tc_private%>
Uploaded:                       <%=uploaded ? "Yes" : "No"%>


<u>Statement:</u><br>
<%=statement%>


<u>Solution (in <%=ValidateField.getLang(qs.getLang())%>):</u><br>
<%=Encode.forHtml(qs.getCode())%>
</code>
</pre>

<textarea id="question-details" class="hidden">
Question title:                 <%=title%>
Marks:                          <%=marks%>
Number of public testcases:     <%=tc_public%>
Number of private testcases:    <%=tc_private%>
Uploaded:                       <%=uploaded ? "Yes" : "No"%>


Statement:
---------------------------------
<%=statement%>


Solution (in <%=ValidateField.getLang(qs.getLang())%>):
---------------------------------
<%=qs.getCode()%>
</textarea>
			</div>
			<div class="container col-lg-12">
				<br>
				<%
					String url = qd.isValid() ? "edit_question.jsp" : "edit_test_question.jsp";
				%>
				<a href="<%=url%>?qid=<%=qid%>" class="btn btn-primary">Back</a>&nbsp;&nbsp;&nbsp;
				<a class="btn btn-primary" id="download-btn">Download details</a>
				<br><br><br><br><br><br>
			</div>
			<form action="../DownloadQS" method="post" class="hidden" id="download-form">
				<input type="hidden" value="<%=qid%>" name="qid">
				<input type="hidden" name="details">
			</form>
		</div>
		<!-- /.container-fluid -->

	</div>
	<!-- /#page-wrapper -->

	<script type="text/javascript">
		$("a#download-btn").click(function(){
			var details = $("textarea#question-details").val();
			$("form#download-form > input[name=details]").val(details);
			$("form#download-form").submit();
		});
	</script>
</div>
<!-- /#wrapper -->
<jsp:include page="/ea/view/admin_footer.jsp"></jsp:include>
</body>
</html>