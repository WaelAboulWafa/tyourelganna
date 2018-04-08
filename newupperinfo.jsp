<%@ page contentType="text/html;charset=Cp1252"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>

 


<%

  Connection con=null;
 InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();

String themsg= (request.getParameter("themsg").trim()).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim();

            
String query =  "insert into UpperInfo(TheText,selected) values (N'" + themsg + "',1)";             
con.createStatement().execute(query);

con.close();

response.sendRedirect("upperinfo.jsp");

%>
 