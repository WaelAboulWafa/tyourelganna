<%@ page contentType="text/html;charset=Cp1252"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>



<%
Connection con=null;
 InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();


  String nick="";
  try{ nick = request.getParameter("nick");}catch(Exception e){}
  
  String tel="";
  try{ tel = request.getParameter("tel");}catch(Exception e){}

 String image="0";
  try{ image = request.getParameter("image");}catch(Exception e){image="0";}

 	
 	
 	
  if(nick.length() >0 && tel.length() > 0 && image.length() > 0)
  {
        nick = nick.replaceAll("'", "''");
 //      out.println("update chatNickNames set MessageContents =N'"+ nick + "' , animation = "+ image + " where MSISDN='" + tel + "'");
      con.createStatement().execute("update chatNickNames set MessageContents =N'"+ nick + "' , animation = "+ image + " where MSISDN='" + tel + "'");
   }       
  

con.close();
        
     response.sendRedirect("nicknames.jsp"); 

 
%>



