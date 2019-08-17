$(".cat_edit").click(function(e){
	e.preventDefault();

	var value = $(this).attr("href").split(",");
	$("#update_cat_id").val(value[0]);
	$("#update_cat_name").val(value[1]);

	$("#update_cat_lang > option").each(function() {
		if($(this).val() === value[2])	$(this).prop("selected", true);
		else 							$(this).prop("selected", false);
	});
	$("#update_cat_form").removeClass("hidden");
});

$("#update_cat_cancel").click(function(){
	$("#update_cat_form").addClass("hidden");
});

$(".cat_delete").click(function(e){
	e.preventDefault();

	var value	= $(this).attr("href").split(",");
	var title, message, action, url;
	if(value[0] === "true"){
		title 	= "Confirm category deletion";
		message = "Are you sure about deleting this category?";
		action	= "cat_delete";
		url		= "../Category";
		$("#admin-modal-confirm").removeClass("hidden");
	}else{
		title 	= "Cannot delete category";
		message = "This category contains one or more sub-categories.";
		action	= "";
		url		= "";
		$("#admin-modal-confirm").addClass("hidden");
	}
	showModal(title, message, action, url, value[1]);
});

$(".scat_edit").click(function(e){
	e.preventDefault();

	var value = $(this).attr("href").split(",");
	$("#update_scat_id").val(value[0]);
	$("#update_scat_name").val(value[1]);
	$("#update_scat_form").removeClass("hidden");
});

$("#update_scat_cancel").click(function(){
	$("#update_scat_form").addClass("hidden");
});

$(".scat_delete").click(function(e){
	e.preventDefault();

	var value	= $(this).attr("href").split(",");
	var title, message, action, url;
	if(value[0] === "true"){
		title 	= "Confirm sub-category deletion";
		message = "Are you sure about deleting this sub-category?";
		action	= "scat_delete";
		url		= "../Subcategory";
		$("#admin-modal-confirm").removeClass("hidden");
	}else{
		title 	= "Cannot delete sub-category";
		message = "This sub-category contains one or more questions.";
		action	= "";
		url		= "";
		$("#admin-modal-confirm").addClass("hidden");
	}
	showModal(title, message, action, url, value[1]);
});

$(".question_delete").click(function(e){
	e.preventDefault();

	var qid     = $(this).attr("href");
	var title 	= "Confirm question deletion";
	var message = "Are you sure about deleting this question?";
	var action	= "del_qid";
	var url		= "../DeleteQ";
	$("#admin-modal-confirm").removeClass("hidden");
	showModal(title, message, action, url, qid);
});

$("a#test_delete").click(function(e){
	e.preventDefault();

	var tid     = $(this).attr("href");
	var title 	= "Confirm test deletion";
	var message = "Are you sure about deleting this test?";
	var action	= "del_tid";
	var url		= "../DeleteTest";
	$("#admin-modal-confirm").removeClass("hidden");
	showModal(title, message, action, url, tid);
});

$("a#delete_user").click(function(e){
	e.preventDefault();

	var user    = $(this).attr("href");
	var title 	= "Confirm user deletion";
	var message = "Are you sure about deleting this user?";
	var action	= "del_user";
	var url		= "../DeleteUser";
	$("#admin-modal-confirm").removeClass("hidden");
	showModal(title, message, action, url, user);
});

$("#admin-modal-confirm").click(function(){
	var ldr      = "<div id='load-screen'><div id='loading'></div></div>";
	var action 	 = $("#admin-modal-action").val();
	var url		 = $("#admin-modal-action-url").val();
	var value 	 = $("#admin-modal-confirm").val();
	var data	 = {};

	data[action] = value;

	$("body").prepend(ldr);

	$.post(url, data).done(function(){
		$("#load-screen").delay(290).fadeOut(10, function(){
			$(this).remove();

			if(action === "del_user"){
				window.location.replace("../ea/message.jsp?action=1");
			}else if(action === "del_tid"){
				window.location.replace("../ea/message.jsp?action=2");
			}else{
				location.reload();
			}
		});
	});

	$("#admin-modal").modal("hide");
});

function showModal(title, message, action, url, value){
	$("#admin-modal-title").html(title);
	$("#admin-modal-body").html(message);
	$("#admin-modal-action").val(action);
	$("#admin-modal-action-url").val(url);
	$("#admin-modal-confirm").val(value);
	$("#admin-modal").modal("show");
}

$("select#select_cat option").click(function(){
	var ldr = "<div id='load-screen'><div id='loading'></div></div>";
	$("body").prepend(ldr);

	$("div#select_scat_div").html("");
	$("div#search_query").addClass("hidden");
	$("div#question_link").addClass("hidden");
	$("input#query").val("");

	var id = $(this).val();
	$.ajax({
		type: "POST",
		url: "../ea/view/dynamic_scat.jsp",
		data: {cat: id},
		success:function(data){
			$("div#select_scat_div").html(data);
			$("div#search_query").removeClass("hidden");
			$("div#question_link").removeClass("hidden");
			$("#load-screen").delay(290).fadeOut(10, function(){
				$(this).remove();
			});
		}
	});
});

$("select#qcat option").click(function(){
	var ldr = "<div id='load-screen'><div id='loading'></div></div>";
	$("body").prepend(ldr);

	var id = $(this).val();
	$.ajax({
		type: "POST",
		url: "../ea/view/dynamic_subcat.jsp",
		data: {cat: id},
		success:function(data){
			$("select#qscat").html(data);
			$("select#qscat").prop("disabled", false);
			$("#load-screen").delay(290).fadeOut(10, function(){
				$(this).remove();
			});
		}
	});
});

$(document).ready(function(){
	CKEDITOR.replace( 'qstatement', {
	    on: {
	        instanceReady: function( ev ) {
	            this.dataProcessor.writer.setRules( 'p', {
	                indent: true,
	                breakBeforeOpen: false,
	                breakAfterOpen: false,
	                breakBeforeClose: false,
	                breakAfterClose: false
	            });
	        }
	    }
	} );
});

function checkQuestion(){
	var title = $("input#qtitle").val();
	var stmt  = CKEDITOR.instances["qstatement"].getData().trim();
	var t1    = stmt.length === 0 || stmt.length > 102400;
	var t2    = !checkField(title);

	if(t1 || t2){
		var message = "";
		if(t1)	message += "Question statement can neither be empty nor too large.";
		if(t2)	message += (t1 ? "<br><br>" : "")
                        +  "Question title can contain characters a-z A-Z 0-9 _ : + - or whitespaces only. And it must start with an alphabet.";
		$("#admin-modal-confirm").addClass("hidden");
		showModal("Error", message, "", "", "");
		return false;
	}
	
	return true;
}

function checkField(name){
	var regex = /^[a-zA-Z]+([a-zA-Z0-9_:+-]|[\s])*$/;
	return regex.test(name);
}

$("#add_cat_form").submit(function(){
    var name = $("form#add_cat_form input[name=cat_name]").val();
    if(!checkField(name)){
    	$("#admin-modal-confirm").addClass("hidden");
    	var message = "Category name can contain characters a-z A-Z 0-9 _ : + - or whitespaces only. And it must start with an alphabet.";
		showModal("Error", message, "", "", "");
    	return false;
    }
    return true;
});

$("#update_cat_form").submit(function(){
    var name = $("form#update_cat_form input[name=update_cat_name]").val();
    if(!checkField(name)){
    	$("#admin-modal-confirm").addClass("hidden");
    	var message = "Category name can contain characters a-z A-Z 0-9 _ : + - or whitespaces only. And it must start with an alphabet.";
		showModal("Error", message, "", "", "");
    	return false;
    }
    return true;
});

$("#add_scat_form").submit(function(){
    var name = $("form#add_scat_form input[name=scat_name]").val();
    if(!checkField(name)){
    	$("#admin-modal-confirm").addClass("hidden");
    	var message = "Sub-category name can contain characters a-z A-Z 0-9 _ : + - or whitespaces only. And it must start with an alphabet.";
		showModal("Error", message, "", "", "");
    	return false;
    }
    return true;
});

$("#update_scat_form").submit(function(){
    var name = $("form#update_scat_form input[name=update_scat_name]").val();
    if(!checkField(name)){
    	$("#admin-modal-confirm").addClass("hidden");
    	var message = "Sub-category name can contain characters a-z A-Z 0-9 _ : + - or whitespaces only. And it must start with an alphabet.";
		showModal("Error", message, "", "", "");
    	return false;
    }
    return true;
});

function checkDate(date){
    var d = new Date(date);
    if(Object.prototype.toString.call(d) === "[object Date]"){
        // it is a date
        return !isNaN(d.getTime());
    }else{
        // not a date
        return false;
    }
}

function checkTest(){
    var name = $("input#tname").val();
    var date = $("input#tdatepicker").val();
    var desc = $("textarea#tdesc").val().trim();
    var t1   = !checkField(name);
    var t2   = !checkDate(date);
    var t3   = desc.length > 102400;

    if(t1 || t2 || t3){
        var message = "";
        if(t1)  message += "Test name can contain characters a-z A-Z 0-9 _ : + - or whitespaces only. And it must start with an alphabet.";
        if(t2)  message += (t1 ? "<br><br>" : "") + "The entered date is invalid.";
        if(t3)  message += (t1 || t2 ? "<br><br>" : "") + "Test description is too large.";

        $("#admin-modal-confirm").addClass("hidden");
        showModal("Error", message, "", "", "");
        return false;
    }

    return true;
}

$("select#date_pref option").click(function(){
	var pref = $(this).val();

	$("div#date, div#date1, div#date2, div#search-query, div#search").addClass("hidden");
	$("input#on-after-before-date, input#between-date1, input#between-date2").attr("required", false);
	$("input#on-after-before-date, input#between-date1, input#between-date2, input#query").val("");

	if(pref === "on" || pref === "after" || pref === "before"){
		$("input#on-after-before-date").attr("required", true);
		$("div#date, div#search-query, div#search").removeClass("hidden");
	}else if(pref === "between"){
		$("input#between-date1, input#between-date2").attr("required", true);
		$("div#date1, div#date2, div#search-query, div#search").removeClass("hidden");
	}
});

function compareDate(date1, date2){
	var one = new Date(date1);
	var two = new Date(date2);
	return one - two <= 0;
}

function checkTSDate(){
	var pref  = $("select#date_pref option:selected").val();
	var date  = $("input#on-after-before-date").val();
	var date1 = $("input#between-date1").val();
	var date2 = $("input#between-date2").val();

	if(pref === "on" || pref === "after" || pref === "before"){
		if(!checkDate(date)){
			$("#admin-modal-confirm").addClass("hidden");
			showModal("Error", "Inappropriate search date.", "", "", "");
			return false;
		}
	}else if(pref === "between"){
		if(!checkDate(date1) || !checkDate(date2) || !compareDate(date1, date2)){
			$("#admin-modal-confirm").addClass("hidden");
			showModal("Error", "Invalid date range.", "", "", "");
			return false;
		}
	}

	return true;
}

function pager(number){
	$("#pageno").val(number);
	$("#pager-form").submit();
}

$(".pager-links").click(function(){
	var pageno = $(this).html();
	pager(pageno);
});

$("#page-prev").click(function(){
	var prev = parseInt($("#pageno").val()) - 1;
	pager(prev);
});

$("#page-next").click(function(){
	var next = parseInt($("#pageno").val()) + 1;
	pager(next);
});