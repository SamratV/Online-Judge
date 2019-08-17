<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
<body>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%@ page import="admin.TData"%>
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

    String tid = request.getParameter("tid");
    TData td = ValidateField.getTData(tid);

    if(!td.isValid()){
        response.sendRedirect("../ea/");
        return;
    }
%>
<div id="wrapper">

    <jsp:include page="/ea/view/admin_navigation.jsp"></jsp:include>

    <div id="page-wrapper">

        <div class="container-fluid">

            <!-- Page Heading -->
            <div class="row">
                <div class="col-lg-12">
                    <h2 class="page-header">Test details</h2>
                </div>
            </div>
            <!-- /.row -->
            <div class="container col-lg-12">
<pre>
<code>
Test name:                      <%=td.getName()%>
Test id:                        <%=td.getTid()%>
Date:                           <%=td.getDate()%>
Time:                           <%=td.getTime()%>
Duration:                       <%=td.getDuration()%> minutes
Languages allowed:              <%=ValidateField.getLang(td.getLang())%>
Number of questions:            <%=td.getQno()%>
Number of questions uploaded:   <%=td.getUqno()%>
Uploaded:                       <%=td.isUploaded() ? "Yes" : "No"%>


<u>Description:</u><br>
<%=Encode.forHtmlContent(td.getDesc())%>
</code>
</pre>
            </div>
            <div class="container col-lg-12">
                <br>
                <a href="edit_test.jsp?tid=<%=td.getTid()%>" class="btn btn-warning">Edit</a>&nbsp;&nbsp;&nbsp;
                <% if(ValidateField.isAdmin(session) && !(td.isUploaded() && td.isLive())){%>
                <a href="<%=td.getTid()%>" id="test_delete" class="btn btn-danger">Delete</a>&nbsp;&nbsp;&nbsp;
                <% }
                   if(!td.isUploaded()){
                %>
                <a href="add_test_question.jsp?tid=<%=td.getTid()%>" class="btn btn-primary">Add question</a>&nbsp;&nbsp;&nbsp;
                <% }
                   if(td.getUqno() > 0){
                %>
                <a href="test_questions.jsp?tid=<%=td.getTid()%>" class="btn btn-default">View questions</a>&nbsp;&nbsp;&nbsp;
                <% }
                   if(!td.isUpcomimg() && td.isUploaded()){
                %>
                <a href="test_rank.jsp?tid=<%=td.getTid()%>" class="btn btn-default">Ranks <i class="fas fa-chart-line"></i></a>
                <%
                   }
                %>
                <br><br><br><br>
            </div>
        </div>
        <!-- /.container-fluid -->

    </div>
    <!-- /#page-wrapper -->

</div>
<!-- /#wrapper -->
<jsp:include page="/ea/view/admin_footer.jsp"></jsp:include>
</body>
</html>