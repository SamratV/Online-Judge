<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
	<jsp:include page="/ea/view/admin_header.jsp"></jsp:include>
	<body>
		<%@ page errorPage="error.jsp"%>
		<%@ page import="admin.ValidateField"%>
		<%
			response.setHeader("Cache-Control", "no-cache");
			response.setHeader("Cache-Control", "no-store");
			response.setHeader("Pragma", "no-cache");
			response.setDateHeader("Expires", 0);

			if(ValidateField.checkSession(session)){
				response.sendRedirect("../");
				return;
			}
			
			String qid = request.getParameter("qid");
			if(!ValidateField.isValidQid(qid)){
				response.sendRedirect("../ea/");
				return;
			}
		%>
		<div id="wrapper">
	
			<jsp:include page="/ea/view/admin_navigation.jsp"></jsp:include>        
	
	        <div id="page-wrapper">
	
	            <div class="container-fluid">
				
	                <!-- Page Heading -->
	                <div class="row">
	                    <div class="col-lg-12">
	                      <h2 class="page-header">
	                      	 Add testcases
	                      </h2>
	                    </div>
	                </div>
	                <!-- /.row -->
	                <div class="container col-lg-12">
<pre>
<code>   
Note:
  1) The input and output files must be named in the sequence 1, 2, 3, ..., n.
  2) For every input file there should be an output file with the same name in the output directory.
  3) All input and output files must be .txt files.
  4) Public testcases must be uploaded in a file named public.zip and private testcases in a file named private.zip only.
  5) A single input/output file of a public testcase shouldn't be larger than 1 KB.
  6) A single input/output file of a private testcase shouldn't be larger than 1 MB.
  7) The sum of the sizes of both the ZIP archives shouldn't be greater than 5 MB.
  8) The ZIP archives must follow the following folder structure.

     --> PUBLIC TESTCASES
	      public
	         |_____input
	         |        |_____1.txt
	         |        |_____2.txt
	         |        |_____3.txt
	         |        ...
	         |        |_____n.txt	
	         |_____output
	                  |_____1.txt
	                  |_____2.txt
	                  |_____3.txt
	                  ...
	                  |_____n.txt
		
     --> PRIVATE TESTCASES
	      private
	         |_____input
	         |        |_____1.txt
	         |        |_____2.txt
	         |        |_____3.txt
	         |        ...
	         |        |_____n.txt	
	         |_____output
	                  |_____1.txt
	                  |_____2.txt
	                  |_____3.txt
	                  ...
	                  |_____n.txt
</code>
</pre>
						<br><br>
	                	<form id="uploadtc" method="post" action="../UploadTC" enctype="multipart/form-data">
							<div class="form-group">
								<label for="public_tc">Public testcases</label>
								<input type="file" id="public_tc" name="public" size="50" accept=".zip" required="required">
							</div>
							<br>
							<div class="form-group">
								<label for="private_tc">Private testcases</label>
								<input type="file" id="private_tc" name="private" size="50" accept=".zip" required="required">
							</div>
							<input type="hidden" name="qid" value="<%=qid %>">
							<br>
							<button type="submit" class="btn btn-default">Upload</button>
	                	</form>
		                <br><br><br><br><br><br>
	                </div>
	            </div>
	            <!-- /.container-fluid -->
	
	        </div>
	        <!-- /#page-wrapper -->
	
	    </div>
	    <!-- /#wrapper -->
	    <script type="text/javascript">
		    $('#uploadtc').submit(function(e){
		        e.preventDefault();
		        
		        var loader = "<div id='load-screen'><div id='loading'></div><span id='progress_percent'>0% complete.</span></div>";
		        $("body").prepend(loader);

		        $.ajax({
		            url: $(this).attr("action"),
		            type: "POST",
		            data: new FormData(this),
					cache: false,
		            processData: false,
		            contentType: false,
			        xhr: function(){
				        var myXhr = $.ajaxSettings.xhr();
				        if(myXhr.upload){
					        // For handling the progress of the upload
					        myXhr.upload.addEventListener("progress", function(e){
						        if(e.lengthComputable){
						        	var percent = (e.loaded / e.total) * 100;
							        $("span#progress_percent").html(Math.round(percent) + "% complete.");
						        }
					        }, false);
				        }
				        return myXhr;
			        }
		        }).done(function() {
		        	$("#load-screen").delay(3500).fadeOut(10, function(){
			        	$(this).remove();
						window.location.replace("../ea/verify_upload.jsp?qid=" + $("form#uploadtc input[name=qid]").val());
			        });
		        }).fail(function() {
		        	$("#load-screen").remove();
		        	$("#admin-modal-confirm").addClass("hidden");
		        	showModal("Upload failed!", "Looks like, your files are too large or there is some network issue.", "", "", "");
		        });
		    });
	    </script>
	    <jsp:include page="/ea/view/admin_footer.jsp"></jsp:include>
	</body>
</html>