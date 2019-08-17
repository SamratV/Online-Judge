<jsp:include page="/view/header.jsp"></jsp:include>
<jsp:include page="/view/navigation.jsp"></jsp:include>
<%
	response.setHeader("Cache-Control","no-cache"); //Forces caches to obtain a new copy of the page from the origin server
	response.setHeader("Cache-Control","no-store"); //Directs caches not to store the page under any circumstance
	response.setHeader("Pragma","no-cache"); //HTTP 1.0 backward compatibility
	response.setDateHeader("Expires", 0); //Causes the proxy cache to see the page as "stale"
	if(!ValidateField.checkUser(session)){
		response.sendRedirect("home.jsp");
		return;
	}
%>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>
<script type="text/javascript">

	$(document).ready(function(){
		$(document).click(function(){
			$("input").popover('dispose');
		});
		
		$("#user-name").on('focus keydown', function(){
			var content = 'Length : 6-100 characters<br><br>'
					    + 'Must start with an alphabet, and end with an alphabet or a number<br><br>'
					    + 'Can contain characters a-z, A-Z, 0-9 and _ only<br><br>'
					    + 'Should not contain two continuous _';

			showTooltip(this, content);
		});
		
		$("#password").on('focus keydown', function(){
			if($("#status").val() === "1"){
				showTooltip(this, "Length : 6-100 characters");
			}
		});

		var error = $("input#auth-error").val();
		if(error !== "null"){
			switch(parseInt(error)){
				case 1:	showModal("Unregistered email address.");
					break;
				case 2: showModal("Wrong password.");
					break;
				case 3: showModalOnSE("Invalid username format.");
					break;
				case 4: showModalOnSE("Used username. Try a different username.");
					break;
				case 5: showModalOnSE("Invalid email address.");
					break;
				case 6: showModalOnSE("Used email address. Try a different email address.");
					break;
				case 7: showModalOnSE("Inappropriate password length.");
					break;
				case 8: showModal("Your account is temporarily suspended. Please contact admin if needed.");
			}
		}
	});

	function isTooltipActive(selector){
		return $(selector).data && $(selector).data('bs.tooltip');
	}
	
	function showModalOnSE(content){
		$("#status").val("1");
		$("#username").removeClass("hidden");
        $("#toggle-auth").html("Login");
        $("#submit").html("Sign up");
        $("#auth_title").html("Sign up");
        showModal(content);
	}
	
	function validate(){
		var status   = $("#status").val();
		var username = $("#user-name").val();
		var email    = $("#email").val();
		var password = $("#password").val();
		var flag     = true;
		var one		 = status === "1";

		if(one && username.length === 0){
			flag = showPopover("#user-name", "Username field cannot be empty.");
		}else if(one && !isValidUsername(username)){
			flag = showPopover("#user-name", "Invalid username format.");
		}else if(email.length === 0){
			flag = showPopover("#email", "Email field cannot be empty.");
		}else if(one && !isValidEmail(email)){
			flag = showPopover("#email", "Invalid email address.");
		}else if(password.length === 0){
			flag = showPopover("#password", "Password field cannot be empty.");
		}else if(one && !isValidPassword(password)){
			flag = showPopover("#password", "Inappropriate password length.");
		}
		
		return flag;
	}
	
	function isValidUsername(username){
		var regex = /^[a-zA-Z]+(?:[_]?[a-zA-Z0-9])*$/;
		var t1 = regex.test(username);
		var t2 = username.length >= 6 && username.length <= 100;
		
		return t1 && t2;
	}
	
	function isValidEmail(email){
		var t1 = email.indexOf("@") !== -1 && email.indexOf("@@") === -1;
		var t2 = email.length >= 3 && email.length <= 320;
		var t3 = email.charAt(0) !== "@" && email.charAt(email.length - 1) !== "@";
		var t4 = email.indexOf('\'') === -1 && email.indexOf('"') === -1;
		
		return  t1 && t2 && t3 && t4;
	}
	
	function isValidPassword(password){
		return password.length >= 6 && password.length <= 100;
	}
	
	function showPopover(selector, content){
		dispose();
		$(document).ready(function(){
			$(selector).popover({
				html: true,
			    title: 'Oops!',
			    content: content,
			    placement: 'right'
			}).popover('show');   
		});
		
		return false;
	}
	
	function showTooltip(selector, content){
		if(!isTooltipActive(selector))	dispose();
		$(selector).tooltip({
			html: true,
		    title: content,
		    placement: 'right'
		}).tooltip('show');
	}
	
	function showModal(content){
		$("#auth-modal-body").html(content);
		$("#auth-modal").modal("show");
	}
	
	function dispose(){
		$("input").popover('dispose');
		$("input").tooltip('dispose');
	}
</script>

	<input type="hidden" id="auth-error" value="<%=request.getParameter("auth_error")%>">

	<div class="container-fluid" id="auth-area">
   		<div class="conatiner">
	   		<div id="loginform" class="col-lg-3 border">
				<form action="auth" method="post" onsubmit="return validate()" accept-charset="UTF-8">
					<h5 id="auth_title" class="mb-3 text-center border-bottom pb-lg-2">Login</h5>
					<div id="username" class="form-group hidden">
						<label class="sr-only" for="user-name">Username</label>
						<div class="input-group mb-2">
							<div class="input-group-prepend">
								<div class="input-group-text"><i class="fas fa-user"></i></div>
							</div>
							<input id="user-name" maxlength=100 name="username" class="form-control auth-input" placeholder="Username" type="text">
						</div>
					</div>
					<div class="form-group">
						<label class="sr-only" for="email">Email</label>
						<div class="input-group mb-2">
							<div class="input-group-prepend">
								<div class="input-group-text"><i class="fas fa-envelope"></i></div>
							</div>
							<input id="email" maxlength=320 class="form-control auth-input" name="email" placeholder="Email address" type="text">
						</div>
					</div>
					<div class="form-group">
						<label class="sr-only" for="password">Password</label>
						<div class="input-group mb-2">
							<div class="input-group-prepend">
								<div class="input-group-text"><i class="fas fa-lock"></i></div>
							</div>
							<input id="password" maxlength=100 name="password" class="form-control auth-input" placeholder="Password" type="password">
						</div>
					</div>
					<div class="checkbox mb-3">
						<small>
							<input value="remember" name="cookie" type="checkbox" id="cookie">
							<label  class="align-middle" for="cookie">
								&nbsp;Remember me
							</label>
						</small>
						<small class="float-right">
							<a href="email.jsp" class="text-success align-middle">Forgot password?</a>
						</small>
					</div>
					<input type="hidden" value="0" name="status" id="status">
					<div class="text-right">
						<br>
						<button id="toggle-auth" class="btn border" type="button">Sign up</button>&nbsp;&nbsp;&nbsp;
						<button class="btn btn-success" id="submit" type="submit">Login</button>
					</div>
				</form>
		   </div>
	   </div>
   </div>

	<div id="auth-modal" class="modal" tabindex="-1" role="dialog">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header" id="auth-modal-header">
	        <h5 class="modal-title">Error!</h5>
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
	          <span aria-hidden="true">&times;</span>
	        </button>
	      </div>
	      <div id="auth-modal-body" class="modal-body text-center">
				<!-- Modal text content -->
	      </div>
	      <div class="modal-footer" id="auth-modal-footer">
	        <button type="button" class="btn" id="auth-modal-close" data-dismiss="modal">Close</button>
	      </div>
	    </div>
	  </div>
	</div>
   
<jsp:include page="/view/footer.jsp"></jsp:include>