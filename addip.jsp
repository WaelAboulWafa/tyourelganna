<%@ page contentType="text/html;charset=Cp1252"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>




<%

  Connection con=null;
 InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();
  
   String country = request.getParameter("country").replaceAll("'", "''").trim();
 
  try{country = (new String(country.getBytes("Cp1252"),"Cp1256")).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim();}catch(Exception e){}
 		
 
   ResultSet  rs = con.createStatement().executeQuery("SELECT count(*) as thec from TrustedIPs where IP=N'"+ country + "'");             
   int foundbefore = 0;
   while(rs.next()){foundbefore = rs.getInt(1);}
   rs.close();rs = null;

    if( !(country.length() == 0) && (foundbefore == 0) )
    {   
      con.createStatement().execute("insert into  TrustedIPs(IP) values(N'"+ country+ "')"); 
      response.sendRedirect("trustedips.jsp");    
    }
    else
    {
      response.sendRedirect("trustedips.jsp");        
    }


   		          
 
%>


