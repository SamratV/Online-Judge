<jsp:include page="/view/header.jsp"></jsp:include>
<jsp:include page="/view/navigation.jsp"></jsp:include>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);

	if(ValidateField.checkUser(session)){
		response.sendRedirect("./");
		return;
	}

%>
<%@ page errorPage="error.jsp"%>
<%@ page import="admin.ValidateField"%>

<div class="container-fluid" id="coding-area">
	<br><br>

	<div class="container alert alert-light" id="note-java">
		Note: Java users must declare the class with main() method as "Solution".
	</div>
	<br>

	<div class="container" id="ide">

		<div class="dropdown" id="settings">
			<button id="setting-option" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				<i class="fas fa-sliders-h"></i>
			</button>
			<div class="dropdown-menu" id="setting-option-dropdown" aria-labelledby="setting-option">
				<form onsubmit="return save_pref()">
					<div class="input-group setting-style">
						<span class="setting-name">Theme</span>
						<span class="setting-style-x">Light&nbsp;&nbsp;<input type="radio" name="theme" value="ace/theme/xcode"></span>
						<span class="setting-style-x">Dark&nbsp;&nbsp;<input type="radio" name="theme" value="ace/theme/monokai"></span>
					</div>
					<div class="input-group setting-style">
						<span class="setting-name">Font</span>
						<span class="setting-style-x">14&nbsp;<input type="radio" name="font" value="14px"></span>
						<span class="setting-style-x">16&nbsp;<input type="radio" name="font" value="16px"></span>
						<span class="setting-style-x">18&nbsp;<input type="radio" name="font" value="18px"></span>
						<span class="setting-style-x">20&nbsp;<input type="radio" name="font" value="20px"></span>
					</div>
					<div class="input-group setting-style">
						<span class="setting-name">Tab space</span>
						<span class="setting-style-x">2&nbsp;&nbsp;<input type="radio" name="tab-space" value="2"></span>
						<span class="setting-style-x">4&nbsp;&nbsp;<input type="radio" name="tab-space" value="4"></span>
						<span class="setting-style-x">8&nbsp;&nbsp;<input type="radio" name="tab-space" value="8"></span>
					</div>
					<button type="submit" id="editor-setting-submit" class="btn btn-success ">Save</button>
				</form>
			</div>
		</div>

		<div class="input-group" id="lang-select">
			<select class="custom-select" id="lang-list">
				<option class="lang" value="c">C</option>
				<option class="lang" value="cpp">C++</option>
				<option class="lang" value="java">Java</option>
				<option class="lang" value="python">Python</option>
			</select>
		</div>

		<pre id="editor"></pre>

		<div class="input-group col-lg-2" id="exec">
			<button type="button" id="run-btn" class="btn">Run code</button>
		</div>

	</div>

	<div class="container" id="custom-input">
		<textarea id="input-text" maxlength="1048576" placeholder="Enter your input text here..."></textarea>
	</div>

	<div class="container" id="output">
		<div id="myProgress" class="hidden"></div>
		<div id="destination" class="alert alert-secondary hidden">Loading...</div>
	</div>

</div>
<br>
<%
	Cookie [] prefs = request.getCookies();
	String theme = "ace/theme/xcode";
	String font  = "16px";
	String tab	 = "4";
	if(prefs != null){
		for(Cookie c: prefs){
			String pref_name = c.getName();
			if(pref_name.equals("editor_theme")){
				theme = c.getValue();
			}else if(pref_name.equals("editor_font")){
				font = c.getValue();
			}else if(pref_name.equals("editor_tab")){
				tab = c.getValue();
			}
		}
	}
%>
<input type="hidden" id="editor-theme-name" value="<%=theme %>">
<input type="hidden" id="editor-font-value" value="<%=font %>">
<input type="hidden" id="editor-tab-value" value="<%=tab %>">

<!-- Modal -->
<div class="modal fade" id="editor-modal" tabindex="-1" role="dialog" aria-labelledby="editor-modal-title" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header" id="editor-modal-header">
				<h5 class="modal-title" id="editor-modal-title">Modal title</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" id="editor-modal-body">
				<!-- Modal text content -->
			</div>
			<div class="modal-footer" id="editor-modal-footer">
				<button type="button" class="btn" id="editor-modal-close" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>

<script src="ace/src-noconflict/ace.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	$(document).on('keydown', function(e){
		var $target = $(e.target);
		if(e.which === 8 && !$target.is('input, [contenteditable="true"], textarea'))   e.preventDefault();
	});

	$(document).ready(function(){
		var theme = $("#editor-theme-name").val();
		var font  = $("#editor-font-value").val();
		var tab   = parseInt($("#editor-tab-value").val());
		var mode  = "ace/mode/c_cpp";

		$("select#lang-list > option").each(function() {
			if($(this).val() === "c")	        $(this).prop("selected", true);
			else 						        $(this).prop("selected", false);
		});
		$("input[name=theme]").each(function(){
			if($(this).val() === theme)		    $(this).prop("checked", true);
			else								$(this).prop("checked", false);
		});
		$("input[name=font]").each(function(){
			if($(this).val() === font)			$(this).prop("checked", true);
			else								$(this).prop("checked", false);
		});
		$("input[name=tab-space]").each(function(){
			if(parseInt($(this).val()) === tab)	$(this).prop("checked", true);
			else								$(this).prop("checked", false);
		});

		var editor = ace.edit("editor");
		editor.setTheme(theme);
		editor.session.setMode(mode);
		editor.session.setUseWrapMode(true);
		editor.session.setTabSize(tab);
		document.getElementById('editor').style.fontSize = font;
	});

	$(".lang").click(function(){
		var lang = $(this).val();
		ace.edit("editor").session.setMode(getEditorMode(lang));
	});
	$("#run-btn").click(function(){
		$(this).blur();
		execute();
	});

	function getEditorMode(lang){
		if(lang === "c" || lang === "cpp")	return "ace/mode/c_cpp";
		else 								return "ace/mode/" + lang;
	}

	function save_pref(){
		var editor_theme = $("input[name=theme]:checked").val();
		var editor_font  = $("input[name=font]:checked").val();
		var editor_tab   = $("input[name=tab-space]:checked").val();

		ace.edit("editor").setTheme(editor_theme);
		document.getElementById('editor').style.fontSize = editor_font;
		ace.edit("editor").session.setTabSize(editor_tab);

		$.ajax({
			type: "POST",
			url: "save_prefs.jsp",
			data: {editor_theme: editor_theme, editor_font: editor_font, editor_tab: editor_tab},
			error: function(){
				console.log("Save pref failed!");
			}
		});

		return false;
	}

	function showModal(title, content){
		$("#editor-modal-title").html(title);
		$("#editor-modal-body").html(content);
		$("#editor-modal").modal("show");
	}

	function execute(){
		var src = ace.edit("editor").getValue().trim();

		if(src.length === 0){
			// No code
			showModal("No code", "Please write some code.");
			return;
		}else if(src.length > 51200){
			// Code size limit exceeded
			showModal("Size limit exceeded", "The written code is more than 50KB in size.");
			return;
		}

		var lang  = $("option.lang:selected").val();
		var input = $("textarea#input-text").val();

		$("#destination").addClass("hidden");
		$("#destination").html("");
		$("#myProgress").removeClass("hidden");
		$("#run-btn").prop("disabled", true);


		$.ajax({
			type: "POST",
			url: "Tester",
			data: {source: src, lang: lang, input: input},
			success: function(data){
				setTimeout(function(){
					$("#destination").html(data);
					$("#myProgress").addClass("hidden");
					$("#destination").removeClass("hidden");
					$('html,body').animate({
						scrollTop: $("#destination").offset().top
					}, 'slow');
					$("#run-btn").prop("disabled", false);
				}, 1000);
			}
		});
	}
</script>
<jsp:include page="/view/footer.jsp"></jsp:include>