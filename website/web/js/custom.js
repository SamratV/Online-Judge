$("#toggle-auth").click(function(){
    var status = $("#status").val();
    $("#user-name").val("");
    $("#email").val("");
    $("#password").val("");
    if(status === "0"){
        $("#status").val("1");
        $("#toggle-auth").html("Login");
        $("#submit").html("Sign up");
        $("#auth_title").html("Sign up");
    }else{
        $("#status").val("0");
        $("#toggle-auth").html("Sign up");
        $("#submit").html("Login");
        $("#auth_title").html("Login");
    }
    $("#username").toggleClass("hidden");
    dispose();
});

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