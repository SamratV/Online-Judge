<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
	<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
	<body>
		<%@ page errorPage="error.jsp"%>
		<%@ page import="admin.ValidateField"%>
		<%@ page import="link.Link"%>
		<%@ page import="java.sql.*"%>
		<%@ page import="admin.Pager" %>
		<%! public Connection link = Link.getConnection(); %>
		<%
			response.setHeader("Cache-Control", "no-cache");
			response.setHeader("Cache-Control", "no-store");
			response.setHeader("Pragma", "no-cache");
			response.setDateHeader("Expires", 0);

			if(ValidateField.checkSession(session)){
				response.sendRedirect("../");
				return;
			}

			String profession = request.getParameter("profession");
			String fullname   = ValidateField.getLikeExpr(request.getParameter("fullname"));
			String username   = ValidateField.getLikeExpr(request.getParameter("username"));
			String roll       = ValidateField.getLikeExpr(request.getParameter("roll"));
			String email      = ValidateField.getLikeExpr(request.getParameter("email"));
			String sess       = request.getParameter("session");
			String dept       = request.getParameter("dept");
			String confirmed  = request.getParameter("cnf");
			String approved   = request.getParameter("app");
			String role       = request.getParameter("role");
			String query;

			PreparedStatement stmt = null;
			ResultSet result = null;

			int pageno 		 = ValidateField.getPageNo(request.getParameter("pageno"));
			int per_page 	 = 10;
			int page_current = (pageno * per_page) - per_page;
			int count        = 0;

			if(profession != null){
				if(sess != null){
					query  = "SELECT COUNT(u.username) AS num FROM users AS u WHERE u.profession=? AND u.fullname LIKE ? AND u.username LIKE ? AND u.rollno LIKE ? AND u.email LIKE ? AND u.session=? AND u.dept_id=? AND u.confirmed=? AND u.approved=? AND u.role=?";
					stmt   = link.prepareStatement(query);
					stmt.setString(1, profession);
					stmt.setString(2, fullname);
					stmt.setString(3, username);
					stmt.setString(4, roll);
					stmt.setString(5, email);
					stmt.setString(6, sess);
					stmt.setInt(7, Integer.parseInt(dept));
					stmt.setInt(8, Integer.parseInt(confirmed));
					stmt.setInt(9, Integer.parseInt(approved));
					stmt.setString(10, role);
					result = stmt.executeQuery();
					count  = result.next() ? result.getInt("num") : 0;
					stmt.close();

					query  = "SELECT u.fullname, u.username, (SELECT dept_name FROM dept WHERE dept_id=u.dept_id) AS dept FROM users AS u WHERE u.profession=? AND u.fullname LIKE ? AND u.username LIKE ? AND u.rollno LIKE ? AND u.email LIKE ? AND u.session=? AND u.dept_id=? AND u.confirmed=? AND u.approved=? AND u.role=? LIMIT ?, ?";
					stmt   = link.prepareStatement(query);
					stmt.setString(1, profession);
					stmt.setString(2, fullname);
					stmt.setString(3, username);
					stmt.setString(4, roll);
					stmt.setString(5, email);
					stmt.setString(6, sess);
					stmt.setInt(7, Integer.parseInt(dept));
					stmt.setInt(8, Integer.parseInt(confirmed));
					stmt.setInt(9, Integer.parseInt(approved));
					stmt.setString(10, role);
					stmt.setInt(11, page_current);
					stmt.setInt(12, per_page);
					result = stmt.executeQuery();
				}else{
					query  = "SELECT COUNT(u.username) AS num FROM users AS u WHERE u.profession=? AND u.fullname LIKE ? AND u.username LIKE ? AND u.email LIKE ? AND u.dept_id=? AND u.confirmed=? AND u.approved=? AND u.role=?";
					stmt   = link.prepareStatement(query);
					stmt.setString(1, profession);
					stmt.setString(2, fullname);
					stmt.setString(3, username);
					stmt.setString(4, email);
					stmt.setInt(5, Integer.parseInt(dept));
					stmt.setInt(6, Integer.parseInt(confirmed));
					stmt.setInt(7, Integer.parseInt(approved));
					stmt.setString(8, role);
					result = stmt.executeQuery();
					count  = result.next() ? result.getInt("num") : 0;
					stmt.close();

					query = "SELECT u.fullname, u.username, (SELECT dept_name FROM dept WHERE dept_id=u.dept_id) AS dept FROM users AS u WHERE u.profession=? AND u.fullname LIKE ? AND u.username LIKE ? AND u.email LIKE ? AND u.dept_id=? AND u.confirmed=? AND u.approved=? AND u.role=? LIMIT ?, ?";
					stmt  = link.prepareStatement(query);
					stmt.setString(1, profession);
					stmt.setString(2, fullname);
					stmt.setString(3, username);
					stmt.setString(4, email);
					stmt.setInt(5, Integer.parseInt(dept));
					stmt.setInt(6, Integer.parseInt(confirmed));
					stmt.setInt(7, Integer.parseInt(approved));
					stmt.setString(8, role);
					stmt.setInt(9, page_current);
					stmt.setInt(10, per_page);
					result = stmt.executeQuery();
				}
			}
		%>
		<div id="wrapper">
	
			<jsp:include page="/ea/view/admin_navigation.jsp"></jsp:include>        
	
	        <div id="page-wrapper">
	
	            <div class="container-fluid">
	
	                <!-- Page Heading -->
	                <div class="row">
	                    <div class="col-lg-12">
	                        <h2 class="page-header">
	                            Users
	                        </h2>
	                    </div>
	                </div>
	                <!-- /.row -->
	                <%
		                if(profession == null){
		            %>
		            <div class="col-lg-12">
			            <div>
							<span style="margin-left: 30px">
								Student <input class="search-mode" type="checkbox" value="1"  checked>
							</span>
				            <span style="margin-left: 30px">
								Teacher <input class="search-mode" type="checkbox" value="2">
							</span>
			            </div>
			            <br><br>
			            <div>
				            <form method="post">
					            <input type="hidden" name="profession" id="profession" value="student">
					            <div class="form-group">
						            <label for="fullname">Fullname (optional)</label>
						            <input type="text" class="form-control" id="fullname" maxlength=100 name="fullname" placeholder="Fullname">
					            </div>
					            <div class="form-group">
						            <label for="username">Username (optional)</label>
						            <input type="text" class="form-control" id="username" maxlength=100 name="username" placeholder="Username">
					            </div>
					            <div class="form-group" id="rollno">
						            <label for="roll">Roll number (optional)</label>
						            <input type="number" class="form-control" id="roll" maxlength=20 name="roll" placeholder="Roll number">
					            </div>
					            <div class="form-group">
						            <label for="email">Email (optional)</label>
						            <input type="text" class="form-control" id="email" maxlength=100 name="email" placeholder="Email">
					            </div>
					            <div class="form-group" id="sess">
						            <label for="session">Session</label>
						            <select name="session" id="session" class="form-control" required="required">
							            <option selected disabled>-- Select --</option>
							            <%
								            for(int i = 15; i <= 26; ++i){
									            String value = "20" + i + "-" + (i + 4);
									            out.println("<option value='" + value + "'>" + value + "</option>");
								            }
							            %>
						            </select>
					            </div>
					            <div class="form-group">
						            <label for="dept">Department</label>
						            <select name="dept" id="dept" class="form-control" required="required">
							            <option selected disabled>-- Select --</option>
							            <%
								            stmt = link.prepareStatement("SELECT * FROM dept");
								            result = stmt.executeQuery();
								            while(result.next()){
									            int dept_id = result.getInt("dept_id");
									            String dept_name = result.getString("dept_name");
									            out.println("<option value='" + dept_id + "'>" + dept_name + "</option>");
								            }
							            %>
						            </select>
					            </div>
					            <div class="form-group">
						            <label for="cnf">Account confirmed by user</label>
						            <select name="cnf" id="cnf" class="form-control" required="required">
							            <option selected disabled>-- Select --</option>
							            <option value="1">Yes</option>
							            <option value="0">No</option>
						            </select>
					            </div>
					            <div class="form-group">
						            <label for="app">Account approved by admin</label>
						            <select name="app" id="app" class="form-control" required="required">
							            <option selected disabled>-- Select --</option>
							            <option value="1">Yes</option>
							            <option value="0">No</option>
						            </select>
					            </div>
					            <div class="form-group">
						            <label for="role">Role</label>
						            <select name="role" id="role" class="form-control" required="required">
							            <option selected disabled>-- Select --</option>
							            <option value="admin">Admin</option>
							            <option value="editor">Editor</option>
							            <option value="user">Normal user</option>
						            </select>
					            </div>
					            <br><br>
					            <button type="submit" class="btn btn-primary">Search</button>
				            </form>
				            <br><br><br><br>
			            </div>
		            </div>
		            <%
		                }else{
		            %>
		            <div class="col-lg-12">
			            <table class="table table-striped">
				            <thead>
				            <tr>
					            <th scope="col" class="text-center">#</th>
					            <th scope="col" class="text-center">Fullname</th>
					            <th scope="col" class="text-center">Username</th>
					            <th scope="col" class="text-center">Department</th>
					            <th scope="col" class="text-center">Profession</th>
					            <th scope="col" class="text-center">User details</th>
				            </tr>
				            </thead>
				            <tbody>
				            <%
					            int i = (pageno - 1) * per_page + 1;
					            while(result.next()){
						            String fname     = result.getString("fullname");
						            String uname     = result.getString("username");
						            String dept_name = result.getString("dept");
				            %>
				            <tr>
					            <td class="text-center"><%=i%></td>
					            <td class="text-center"><%=fname%></td>
					            <td class="text-center"><%=uname%></td>
					            <td class="text-center"><%=dept_name%></td>
					            <td class="text-center"><%=ValidateField.capitalize(profession)%></td>
					            <td class="text-center">
						            <a href="user_details.jsp?u=<%=uname%>">
							            <i style="color: #28a745; font-size: 150%;" class="fas fa-info-circle"></i>
						            </a>
					            </td>
				            </tr>

				            <%
						            ++i;
					            }
					            stmt.close();
				            %>
				            </tbody>
			            </table>
		            </div>
		            <%
			                Pager pager = new Pager(pageno, per_page, count);
			                out.println(pager.getPager());
		                }
		            %>
	            </div>
	            <!-- /.container-fluid -->
	
	        </div>
	        <!-- /#page-wrapper -->
	
	    </div>
	    <!-- /#wrapper -->

		<script type="text/javascript">
			$(".search-mode").click(function(){
				if(this.checked){
					var value = $(this).val();

					$(".search-mode").each(function(){
						if($(this).val() !== value){
							$(this).prop("checked", false);
						}
					});

					if(value === "1"){
						$("div#rollno").removeClass("hidden");
						$("div#sess").removeClass("hidden");
						$("select#session").prop("required", true);
						$("input#profession").val("student");
					}else{
						$("div#rollno").addClass("hidden");
						$("div#sess").addClass("hidden");
						$("select#session").prop("required", false);
						$("input#profession").val("teacher");
					}
				}else{
					this.checked = !this.checked;
				}
			});
		</script>

	    <jsp:include page="/ea/view/admin_footer.jsp"></jsp:include>
	</body>
</html>