<%@ page contentType="text/html;charset=Cp1252"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>


 
<%
Connection con=null;
 InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();


   try{
         String thec = request.getParameter("command");
         
         con.createStatement().execute("insert into webcommands(command)values ('"+thec+"')");
       
      }catch(Exception e){out.println(e.toString()); return;}

     con.close();

     response.sendRedirect("screen.jsp");  
 
%>


  