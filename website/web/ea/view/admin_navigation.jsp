<!-- Navigation -->
<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="../ea">Site manager</a>
    </div>
    <!-- Top Menu Items -->
    <ul class="nav navbar-right top-nav">
    	<li>
            <a>Users online: <span id="users_online"></span></a>
    	</li>
    	<li>
    		<a href="../index.jsp"><i class="fas fa-home"></i> Home</a>
    	</li>
        <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-user"></i> <%=session.getAttribute("username")%><b class="caret"></b></a>
            <ul class="dropdown-menu">
                <li>
                    <a href="user_details.jsp?u=<%=session.getAttribute("username").toString()%>"><i class="fa fa-fw fa-user"></i> Profile</a>
                </li>
                <li class="divider"></li>
                <li>
                    <a href="../logout.jsp"><i class="fa fa-fw fa-power-off"></i> Log Out</a>
                </li>
            </ul>
        </li>
    </ul>
    <!-- Sidebar Menu Items - These collapse to the responsive navigation menu on small screens -->
    <jsp:include page="/ea/view/admin_sidebar.jsp"></jsp:include>
    <!-- /.navbar-collapse -->
</nav>