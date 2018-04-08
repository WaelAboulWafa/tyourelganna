<%@ page contentType="text/html;charset=Cp1252"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>



 
<%

  Connection con=null;
 InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();
  
 //  String id = request.getParameter("id").replaceAll("'", "''").trim();
   String country = request.getParameter("country").replaceAll("'", "''").trim();


 try{country = (new String(country.getBytes("Cp1252"),"Cp1256")).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim();}catch(Exception e){}
 	

 
try{
 
   ResultSet  rs = con.createStatement().executeQuery("SELECT count(*) as thecnt from badwords where word=N'"+ country + "'");             
   int found = 0;
   while(rs.next()){found = rs.getInt(1);}
   rs.close();rs = null;

    if( (found == 0) && (country.length() > 0)) 
    {   
      con.createStatement().execute("insert into  badwords( word) values(N'"+ country + "')"); 
      con.close();  
      response.sendRedirect("badwords.jsp");    
    }
    else
    {
      con.close();  
      response.sendRedirect("badwords.jsp");        
    }

}catch(Exception e){response.sendRedirect("badwords.jsp");}
   		          
 
%>


 