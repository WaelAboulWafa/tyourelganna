<%@ page contentType="text/html;charset=Cp1252"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>



<%
Connection con=null;
 InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();


  String nick="";
  try{ nick = request.getParameter("the_nickname");}catch(Exception e){}
  try{nick = (new String(nick.getBytes("Cp1252"),"Cp1256")).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim();}catch(Exception e){}

  
  String tel="";
  try{ tel = request.getParameter("the_msisdn");}catch(Exception e){}


	
  if(nick.length() >0 && tel.length() > 0)
  {
        String query1 = "delete from chatNickNames where  MessageContents =N'"+ nick + "' and  MSISDN='" + tel + "'";
		String query2 = "insert into chatNickNames(originalid,msisdn,messagecontents,animation) values (0,'" + tel + "', N'" + nick + "','0')" ;
        con.createStatement().execute(query1);
        con.createStatement().execute(query2);
   }       
  

con.close();
        
     response.sendRedirect("nicknames.jsp"); 

 
%>



