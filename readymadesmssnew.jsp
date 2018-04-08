<%@ page contentType="text/html;charset=Cp1252"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>

 


<%

  Connection con=null;
 InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();

String themsg= (request.getParameter("themsg").trim()).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim();

themsg = (new String(themsg.getBytes("Cp1252"),"Cp1256")).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim();	

String userid = "0"; try{userid =  request.getParameter("userid" );}catch(Exception e){userid="0";}
            
String query =  "insert into readymadesmss(TheText,theuserid) values (N'" + themsg  + "','" + userid + "')";             
con.createStatement().execute(query);

con.close();

response.sendRedirect("readymadesmss.jsp");

%>
 