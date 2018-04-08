<%@ page contentType="text/html;charset=Cp1252"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>



<%
Connection con=null;
 InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();


   String themsisdn = request.getParameter("themsisdn");
   String nickchecked = request.getParameter("nickchecked");
   String themessage = request.getParameter("themessage");
   String  userid = request.getParameter("userid"); 

//  out.println(themessage);  

	

   themessage = themessage.replaceAll("'", "''").replaceAll("\r", "").replaceAll("\n", "").trim();  
  if(nickchecked == null)
  {

   try{
          con.createStatement().execute("insert into chatArabic(MSISDN,MessageContents,country) values ('" + themsisdn + "', N'" + themessage + "','control' )" );         
        
      }catch(Exception e){out.println(e.toString()); return;}

  }
  else
  {
  
   try{
          con.createStatement().execute("insert into chatArabic(MSISDN,MessageContents,country) values ('xxx', N'" + themessage + "','control' )" );         
        
      }catch(Exception e){out.println(e.toString()); return;}
        
   
  }







con.close();
                      
    response.sendRedirect("filteration.jsp"); 
 
%>


 