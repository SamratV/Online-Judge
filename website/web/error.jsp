<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="./view/logo.png">
    <title>Codepad</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="js/jquery.min.js"></script>
    <script src="js/popper.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/fontawesome-all.min.js"></script>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark" id="navigation">
        <a class="navbar-brand" href="./"><img src="./view/logo.png" width="35px" alt="logo" /></a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
    </nav>
    <%
        response.setHeader("Cache-Control","no-cache");
        response.setHeader("Cache-Control","no-store");
        response.setHeader("Pragma","no-cache");
        response.setDateHeader("Expires", 0);
    %>
    <div class="container-fluid">
        <br>
        <div class="container">
            <h5>Error</h5>
            <hr>
            <div class="alert alert-danger text-center" role="alert" style="width: 300px; margin: 0px auto;">
                Click <a href="index.jsp">here</a> to go to homepage.
            </div>
            <br>
            <div style="margin: 0px auto;" class="row">
                <%@ page isErrorPage="true"%>
                <%=exception %>
            </div>
        </div>
    </div>
    <footer class="footer">
        <div class="container">
            <span class="text-muted">&copy; <small>Codepad 2019</small></span>
        </div>
    </footer>
</body>
</html>