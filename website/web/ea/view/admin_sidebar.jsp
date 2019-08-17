<%@ page import="admin.ValidateField"%>
<div class="collapse navbar-collapse navbar-ex1-collapse">
    <ul class="nav navbar-nav side-nav">
        <li>
            <a href="../ea"><i class="fas fa-search"></i> Dashboard</a>
        </li>
        <li>
            <a href="javascript:;" data-toggle="collapse" data-target="#demo"><i class="fas fa-users"></i> Users <i class="fa fa-fw fa-caret-down"></i></a>
            <ul id="demo" class="collapse">
                <li>
                    <a href="users.jsp">Find users</a>
                </li>
                <li>
                    <a href="disapproved.jsp">Disapproved users</a>
                </li>
                <li>
                    <a href="unconfirmed.jsp">Unconfirmed users</a>
                </li>
                <%
                    if(ValidateField.isAdmin(session)){
                %>
                <li>
                    <a href="mass_approve.jsp">Mass approve</a>
                </li>
                <li>
                    <a href="mass_disapprove.jsp">Mass disapprove</a>
                </li>
                <%
                    }
                %>
            </ul>
        </li>
        <li>
            <a href="javascript:;" data-toggle="collapse" data-target="#demo1"><i class="fas fa-book"></i> Tests <i class="fa fa-fw fa-caret-down"></i></a>
            <ul id="demo1" class="collapse">
                <li>
                    <a href="tests.jsp">Find tests</a>
                </li>
                <li>
                    <a href="pending_tests.jsp">Pending test uploads</a>
                </li>
                <li>
                    <a href="add_test.jsp">Add test</a>
                </li>
            </ul>
        </li>
        <li>
            <a href="categories.jsp"><i class="fa fa-list"></i> Categories</a>
        </li>
        <li>
        	<a href="javascript:;" data-toggle="collapse" data-target="#demo2"><i class="fas fa-question"></i> Questions <i class="fa fa-fw fa-caret-down"></i></a>
            <ul id="demo2" class="collapse">
                <li>
                    <a href="questions.jsp">Find practice questions</a>
                </li>
	            <li>
		            <a href="find_tq.jsp">Find test questions</a>
	            </li>
	            <li>
		            <a href="find_by_title.jsp">Find questions by title</a>
	            </li>
                <li>
                    <a href="pending_questions.jsp">All pending uploads</a>
                </li>
                <li>
                    <a href="add_tq.jsp">Add a test question</a>
                </li>
	            <li>
		            <a href="add_question.jsp">Add a practice question</a>
	            </li>
            </ul>
        </li>
        <li>
            <a href="user_details.jsp?u=<%=session.getAttribute("username").toString()%>"><i class="fas fa-user"></i> Your profile</a>
        </li>
    </ul>
</div>