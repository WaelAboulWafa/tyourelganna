<%@ page contentType="text/html;charset=Cp1252"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>



<%


String username = "";
String password = "";
String userid="";


Connection con=null;
 InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();

  try
  {
   userid =  session.getAttribute("userid").toString();
   con.createStatement().execute("update Users set   lastlogouttime= getdate() where userid=" + userid );             
  }catch(Exception e){}
  session.invalidate();
  response.sendRedirect(request.getContextPath());
  
  
%>
  
