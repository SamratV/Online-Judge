<nav class="navbar navbar-expand-lg navbar-dark bg-dark" id="navigation">
	<a class="navbar-brand" href="./"><img src="./view/logo.png" width="35px" alt="logo" /></a>
	<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
	  <span class="navbar-toggler-icon"></span>
	</button>
	<div class="collapse navbar-collapse" id="navbarSupportedContent">
		<%@ page import="admin.ValidateField"%>
		<%
		    if(!ValidateField.checkUser(session)){
		    	String url = request.getRequestURI();
		    	String n1 = url.contains("home.jsp") ? "active" : "";
		    	String n2 = url.contains("exam.jsp") ? "active" : "";
			    String n3 = url.contains("environment.jsp") ? "active" : "";
		    	String n4 = url.contains("code_tester.jsp") ? "active" : "";
    	%>
    	<ul class="navbar-nav mr-auto">
    		<li class="nav-item <%= n1 %>"><a class="nav-link" href="home.jsp">Practice</a></li>
    		<li class="nav-item <%= n2 %>"><a class="nav-link" href="exam.jsp">Tests</a></li>
		    <li class="nav-item <%= n3 %>"><a class="nav-link" href="environment.jsp">Environment</a></li>
			<li class="nav-item <%= n4 %>"><a class="nav-link" href="code_tester.jsp">CodeTester</a></li>
			<% if(!session.getAttribute("role").equals("user")){
				String xrole = session.getAttribute("role").toString();
				String xlink = xrole.equals("admin") ? "<i class='fas fa-shield-alt'></i> Admin" : "<i class='fa fa-edit'></i> Editor";
			%>
			<li class="nav-item"><a class="nav-link" href="ea/"><%= xlink %></a></li>
			<% } %>
		</ul>
		<ul class="nav navbar-nav navbar-right" id="nav-dropdown-menu">
		    <li class="nav-item dropdown">
		      <a class="nav-link dropdown-toggle" href="#" id="bd-versions" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
		        <img src="./view/user.png" id="nav-user-image" width="25px" alt="user" /><%= " " + session.getAttribute("username") %>
		      </a>
		      <div class="dropdown-menu dropdown-menu-right" id="nav-dropdown-items" aria-labelledby="bd-versions">
		        <a class="dropdown-item" href="profile.jsp"><i class="fa fa-fw fa-user"></i> Profile</a>
			    <div class="dropdown-divider"></div>
			    <a class="dropdown-item" href="logout.jsp"><i class="fa fa-fw fa-power-off"></i> Log Out</a>
		      </div>
		    </li>
		</ul>
		<%	} %>
	</div>
</nav>