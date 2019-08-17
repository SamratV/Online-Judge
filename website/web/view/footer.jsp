<footer class="footer">
	<div class="container">
		<span class="text-muted">&copy; <small>AEC Codepad 2019</small></span>
	</div>
</footer>
<script src="js/custom.js"></script>
<script type="text/javascript">
	setInterval(function(){
		var user = "<%=session.getAttribute("username") %>";
		if(user !== "null")		$.get("online.jsp");
	},1000);
</script>
</body>
</html>