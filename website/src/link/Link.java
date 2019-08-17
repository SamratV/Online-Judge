package link;

import java.sql.*;

public class Link {
    
    public static Connection getConnection(){
        String url = "jdbc:mysql://localhost:3306/codepad?autoReconnect=true&useSSL=false";
        String username = "root";
        String password = "1234";
        Connection con = null;
        try{  
            Class.forName("com.mysql.jdbc.Driver");  
            con = DriverManager.getConnection(url,username,password);               
        }catch(Exception e){
            System.err.println(e);
            return null;
        }
        return con;
    }
}