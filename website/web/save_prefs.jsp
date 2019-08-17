<%!
    private Cookie createPrefCookie(String name, String value){
        Cookie x = new Cookie(name, value);
        x.setMaxAge(30*24*60*60);
        return x;
    }

    private boolean isValidTheme(String t){
        return t != null && (t.equals("ace/theme/xcode") || t.equals("ace/theme/monokai"));
    }

    private boolean isValidFont(String f){
        return f != null && (f.equals("14px") || f.equals("16px") || f.equals("18px") || f.equals("20px"));
    }

    private boolean isValidTab(String t){
        return t != null && (t.equals("2") || t.equals("4") || t.equals("8"));
    }
%>
<%
    String theme = request.getParameter("editor_theme");
    String font  = request.getParameter("editor_font");
    String tab   = request.getParameter("editor_tab");

    if(isValidTheme(theme) && isValidFont(font) && isValidTab(tab)){
        response.addCookie(createPrefCookie("editor_theme", theme));
        response.addCookie(createPrefCookie("editor_font", font));
        response.addCookie(createPrefCookie("editor_tab", tab));
    }
%>