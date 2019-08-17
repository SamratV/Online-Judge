<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
<body>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if(ValidateField.checkSession(session)){
        response.sendRedirect("../");
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
                    <h2 class="page-header">Add test</h2>
                </div>
            </div>
            <!-- /.row -->
            <div class="container col-lg-12">
                <form action="../AddTest" method="post" onsubmit="return checkTest();">
                    <div class="form-group">
                        <label for="tname">Test name</label>
                        <input type="text" class="form-control" id="tname" maxlength=100 name="name" placeholder="Name" required="required">
                    </div>
                    <div class="form-group">
                        <label for="tlang">Allowed language(s)</label>
                        <select name="lang" id="tlang" class="form-control" required="required">
                            <option disabled selected> --Select language-- </option>
                            <option value="all">All</option>
                            <option value="c">C</option>
                            <option value="cpp">C++</option>
                            <option value="java">Java</option>
                            <option value="python">Python</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="tduration">Duration</label>
                        <select name="duration" id="tduration" class="form-control" required="required">
                            <option disabled selected> --Select duration-- </option>
                            <%
                                for(int i = 1; i <= 12; i++){
                                    out.println("<option value='" + i * 30 + "'>" + i * 30 + " minutes</option>");
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="tdatepicker">Date</label>
                        <input type="text" class="form-control" name="date" id="tdatepicker" required="required">
                    </div>
                    <div class="form-group">
                        <div class="col-lg-12 no-padding">
                            <label for="thour">Time</label>
                        </div>
                        <div class="col-lg-2 no-padding mr-custom-20-px">
                            <select class="form-control" name="hour" id="thour" required="required">
                                <option disabled selected> Hour </option>
                                <%
                                    for(int i = 0; i <= 23; i++){
                                        String x = i < 10 ? "0" + i : Integer.toString(i);
                                        out.println("<option value='" + x + "'>" + x + "</option>");
                                    }
                                %>
                            </select>
                        </div>
                        <div class="col-lg-2 no-padding">
                            <select class="form-control" name="min" id="tmin" required="required">
                                <option disabled selected> Minute </option>
                                <%
                                    for(int i = 0; i <= 59; i++){
                                        String x = i < 10 ? "0" + i : Integer.toString(i);
                                        out.println("<option value='" + x + "'>" + x + "</option>");
                                    }
                                %>
                            </select>
                        </div>
                        <div class="clear-float-both"></div>
                    </div>
                    <div class="form-group">
                        <label for="tqno">Number of questions</label>
                        <select name="qno" id="tqno" class="form-control" required="required">
                            <option disabled selected> --Select-- </option>
                            <%
                                for(int i = 1; i <= 12; i++){
                                    out.println("<option value='" + i + "'>" + i + "</option>");
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="tdesc">Test description / rules</label>
                        <textarea class="form-control" id="tdesc" rows="10" name="description" required="required"></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">Add</button>
                </form>
                <br><br><br>
            </div>
        </div>
        <!-- /.container-fluid -->

    </div>
    <!-- /#page-wrapper -->

    <script type="text/javascript">
        $(function(){
            $("#tdatepicker").datepicker({
                format: 'yyyy-mm-dd',
                startDate: '-0m',
                todayHighlight: true,
                autoclose: true
            });
        });
    </script>

</div>
<!-- /#wrapper -->
<jsp:include page="/ea/view/admin_footer.jsp"></jsp:include>
</body>
</html>