<%@ page contentType="text/html;charset=Cp1252"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>




<%

  Connection con=null;
 InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();
  
   String btext = request.getParameter("btext").replaceAll("'", "''");
   
    if( !(request.getParameter("btext").replaceAll("'", "''").trim().length() == 0) )
    {
       con.createStatement().execute("insert into  badwords(word) values(N'"+ btext+ "')"); 
         
       con.close();
          response.sendRedirect("badwords.jsp");    
    }
    else
    {
       con.close();
          response.sendRedirect("badwords.jsp");    
    }






   		          
 
%>


