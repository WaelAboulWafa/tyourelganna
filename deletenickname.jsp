<%@ page contentType="text/html;charset=Cp1252"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>



<%
Connection con=null;
 InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();


  String nick="";
  try{ nick = request.getParameter("nick");}catch(Exception e){nick="";}
  
  String tel="";
  try{ tel = request.getParameter("tel");}catch(Exception e){tel="";}
  
  out.println(nick);out.println(tel);  
  
 
  if(nick.length() >0 || tel.length() > 0)
  {
        nick = nick.replaceAll("'", "''"); tel = tel.replaceAll("'", "''");
        con.createStatement().execute("delete from  chatNickNames where MessageContents = N'"+ nick + "' or MSISDN='" + tel + "'");
        try{con.createStatement().execute("delete from  ControlNicks where MSISDN_ID = '"+ tel + "'");}catch(Exception e){}
                
        
   }       

con.close();
     
    response.sendRedirect("nicknames.jsp"); 


 
%>



