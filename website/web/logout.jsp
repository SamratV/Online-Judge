<%@ page errorPage="error.jsp"%>
<%
	try{
        session.invalidate();

		Cookie [] cookies = request.getCookies();
		for(Cookie c: cookies){
            if(c.getName().equals("username")){
                c.setMaxAge(0);
                response.addCookie(c);
            }
		}
	}catch(Exception e){
	    e.printStackTrace();
    }finally {
        response.sendRedirect("./");
    }
%>