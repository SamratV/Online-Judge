<div id="admin-modal" class="modal fade" role="dialog">
  <div class="modal-dialog">
    <div id="admin-modal-content" class="modal-content">
      <div class="modal-header" id="admin-modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="text-center"><span id="admin-modal-title"></span></h4>
      </div>
      <div class="modal-body">
        <p id="admin-modal-body"></p>
      </div>
      <div class="modal-footer" id="admin-modal-footer">
      	<input type="hidden" id="admin-modal-action-url">
		<input type="hidden" id="admin-modal-action">
        <button type="button" id="admin-modal-confirm" class="btn btn-danger">Confirm</button>
        <button type="button" id="admin-modal-dismiss" class="btn" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<script src="js/admin-custom.js"></script>
<script type="text/javascript">
	setInterval(function(){
		var user = "<%=session.getAttribute("username") %>";
		if(user !== "null")		$.get("../online.jsp", function(data){$("#users_online").html(data);});
	},1000);
</script>