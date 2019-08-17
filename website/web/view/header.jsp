<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="description" content="">
	<meta name="author" content="">
	<link rel="icon" href="./view/logo.png">
	<title>AEC Codepad</title>
	<link rel="stylesheet" href="css/bootstrap.min.css">
	<link rel="stylesheet" href="css/style.css">
	<link rel="stylesheet" href="ace/css/editor.css">
	<link rel="stylesheet" href="ea/dp/css/bootstrap-datepicker3.min.css">
	<script src="js/jquery.min.js"></script>
	<script src="js/popper.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script src="js/fontawesome-all.min.js"></script>
	<script src="ea/dp/js/bootstrap-datepicker.min.js"></script>
</head>
<body>
	<%@ page import="link.Link"%>
	<%@ page import="java.sql.*"%>
	<%! public Connection link = Link.getConnection(); %>
	<%
		Cookie [] cookies = request.getCookies();
		if(cookies != null){
			for(Cookie c: cookies){
				if(c.getName().equals("username")){
					String cookie_username = c.getValue();
					try {
						PreparedStatement stmt = link.prepareStatement("SELECT email, role FROM users WHERE username=?");
						stmt.setString(1, cookie_username);
						ResultSet result = stmt.executeQuery();
						String db_email = "";
						String db_role = "";
						boolean flag = false;
						while (result.next()){
							db_email = result.getString("email");
							db_role = result.getString("role");
							flag = true;
						}
						if(flag){
							session.setAttribute("email", db_email);
							session.setAttribute("username", cookie_username);
							session.setAttribute("role", db_role);
						}
						stmt.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}
		}
	%>