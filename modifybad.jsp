<%@ page contentType="text/html;charset=Cp1252"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>




<%

  Connection con=null;
 InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();
  
  try{
   String bid = "0";try{bid= request.getParameter("bid").replaceAll("'", "''");  }catch(Exception e){bid = "0";}
   if( request.getParameter("bid").replaceAll("'", "''").trim().length() == 0 ){bid = "0";}
   
   String btext = request.getParameter("btext").replaceAll("'", "''");
   
   con.createStatement().execute("update badwords set word= N'"+ btext+ "' where id= " + bid); 

    }catch(Exception e){}

       con.close();
  response.sendRedirect("badwords.jsp");    



   		          
 
%>


