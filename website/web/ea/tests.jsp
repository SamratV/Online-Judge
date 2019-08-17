<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
	<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
	<body>
		<%@ page errorPage="error.jsp"%>
		<%@ page import="admin.ValidateField"%>
		<%@ page import="java.sql.*"%>
		<%@ page import="admin.Pager"%>
		<%
			response.setHeader("Cache-Control", "no-cache");
			response.setHeader("Cache-Control", "no-store");
			response.setHeader("Pragma", "no-cache");
			response.setDateHeader("Expires", 0);

			if(ValidateField.checkSession(session)){
				response.sendRedirect("../");
				return;
			}

			String pref  = request.getParameter("pref");
			String date  = request.getParameter("date");
			String date1 = request.getParameter("date1");
			String date2 = request.getParameter("date2");
			String query = request.getParameter("query");

			int pageno 		 = ValidateField.getPageNo(request.getParameter("pageno"));
			int per_page 	 = 10;
			int page_current = (pageno * per_page) - per_page;

			PreparedStatement stmt = ValidateField.checkTSDate(pref, date, date1, date2, query, page_current, per_page);

		%>
		<div id="wrapper">
	
			<jsp:include page="/ea/view/admin_navigation.jsp"></jsp:include>        
	
	        <div id="page-wrapper">
	
	            <div class="container-fluid">

	                <!-- Page Heading -->
	                <div class="row">
	                    <div class="col-lg-12">
	                        <h2 class="page-header">Tests</h2>
	                    </div>
	                </div>
	                <!-- /.row -->
		        <%
			        if(stmt == null){
		        %>
                    <div class="container col-lg-12">
	                    <form onsubmit="return checkTSDate();">
		                    <div class="col-lg-2">
			                    <label for="date_pref">Date preference</label>
			                    <select name="pref" class="form-control" id="date_pref" required="required">
				                    <option selected disabled>-- Select --</option>
				                    <option value="on">On</option>
				                    <option value="after">After</option>
				                    <option value="before">Before</option>
				                    <option value="between">Between</option>
			                    </select>
		                    </div>
		                    <div class="col-lg-2 hidden" id="date">
			                    <label for="on-after-before-date">Date</label>
			                    <input type="text" name="date" class="form-control date-selector" id="on-after-before-date">
		                    </div>
		                    <div class="col-lg-2 hidden" id="date1">
			                    <label for="between-date1">First date</label>
			                    <input type="text" name="date1" class="form-control date-selector" id="between-date1">
		                    </div>
		                    <div class="col-lg-2 hidden" id="date2">
			                    <label for="between-date2">Second date</label>
			                    <input type="text" name="date2" class="form-control date-selector" id="between-date2">
		                    </div>
		                    <div class="col-lg-3 hidden" id="search-query">
			                    <label for="query">Test name(optional)</label>
			                    <input type="text" name="query" class="form-control" id="query">
		                    </div>
		                    <div class="col-lg-2 hidden" id="search">
			                    <label for="search-test">&nbsp;</label>
			                    <input type="submit" class="form-control btn btn-primary" value="Search" id="search-test">
		                    </div>
	                    </form>
                    </div>
                <%
	                }else{
                %>
					<div class="container col-lg-12">
						<table class="table table-striped">
							<thead>
								<tr>
									<th scope="col">#</th>
									<th scope="col">Test name</th>
									<th scope="col">Date</th>
									<th scope="col">Time</th>
									<th scope="col">View</th>
								</tr>
							</thead>
							<tbody>
				<%
						ResultSet result = stmt.executeQuery();
						while(result.next()){
							int tid  = result.getInt("tid");
							String n = result.getString("name");
							String d = result.getString("date");
							String t = result.getString("time");
							out.println("<tr><th scope='row'>" + tid + "</th>");
							out.println("<td>" + n + "</td>");
							out.println("<td>" + d + "</td>");
							out.println("<td>" + t + "</td>");
							out.println("<td><a href='../ea/test_details.jsp?tid=" + tid + "'><i class='fas fa-link'></i></a></td></tr>");
						}
						stmt.close();
				%>
							</tbody>
						</table>
					</div>
		        <%
			            int count   = ValidateField.countTest(pref, date, date1, date2, query);
						Pager pager = new Pager(pageno, per_page, count);
						out.println(pager.getPager());
			        }
		        %>
	            </div>
	            <!-- /.container-fluid -->

	        </div>
	        <!-- /#page-wrapper -->

            <script type="text/javascript">
                $(function() {
                    $(".date-selector").datepicker({
                        format: 'yyyy-mm-dd',
                        autoclose: true
                    });
                });
            </script>
	    </div>
	    <!-- /#wrapper -->
	    <jsp:include page="/ea/view/admin_footer.jsp"></jsp:include>
	</body>
</html>