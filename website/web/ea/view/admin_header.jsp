<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
	<%
		String trole = session.getAttribute("role") == null ? "null" : session.getAttribute("role").toString();
		String tdisp = trole.equals("admin") ? "Admin" : "Editor";
	%>
	<link rel="icon" href="../view/logo.png">
    <title>AEC Codepad | <%=tdisp %></title>

    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/sb-admin.css" rel="stylesheet">
	<link href="css/admin-style.css" rel="stylesheet">
    <link href="font-awesome/css/font-awesome.min.css" rel="stylesheet">
	<link href="dp/css/bootstrap-datepicker3.min.css" rel="stylesheet">

	<script src="js/jquery.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script src="../js/fontawesome-all.min.js"></script>
	<script src="ckeditor/ckeditor.js"></script>
	<script src="dp/js/bootstrap-datepicker.min.js"></script>
</head>

<%@ page errorPage="../error.jsp"%>
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