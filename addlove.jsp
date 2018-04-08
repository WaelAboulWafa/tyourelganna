<%@ page contentType="text/html;charset=Cp1252"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>


 

<%

  Connection con=null;
 InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();
  
 //  String id = request.getParameter("id").replaceAll("'", "''").trim();
   String country = request.getParameter("country").replaceAll("'", "''").trim();
   String operator = request.getParameter("operator").replaceAll("'", "''").trim();
   String provider = request.getParameter("provider").replaceAll("'", "''").trim();
	
   try{country = (new String(country.getBytes("Cp1252"),"Cp1256")).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim(); }catch(Exception e){}
   try{operator = (new String(operator.getBytes("Cp1252"),"Cp1256")).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim(); }catch(Exception e){}
   try{provider= (new String(provider.getBytes("Cp1252"),"Cp1256")).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim(); }catch(Exception e){}
   
 
 
    if( !(country.length() == 0) && !(operator.length() == 0) && !(provider.length() == 0) )
    {   
      con.createStatement().execute("insert into  loveonair( first, second, percentage) values(N'" + country + "',N'" + operator + "',N'" + provider + "')"); 
      con.close();  
      response.sendRedirect("filterationlove.jsp");    
    }
    else
    {
      con.close();  
      response.sendRedirect("filterationlove.jsp");        
    }


   		          
 
%>


