<%@ page contentType="text/html;charset=Cp1252"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>



<%
Connection con=null;
 InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();

 
  String nick = request.getParameter("nick");
  
  String userid = request.getParameter("userid");
 	
 	out.println(userid);
	
  try{
          nick = nick.replaceAll("'", "''").trim();

          ResultSet rs = con.prepareStatement("insert into ControlNicks(nickname,theuserid) values (N'" + nick + "',"+ userid +")  select @@IDENTITY" ).executeQuery();  
          int theID = 0;            
          while(rs.next()){ theID = rs.getInt(1);}rs.close();rs = null;
                             
          con.createStatement().execute("insert into chatNickNames(originalid,msisdn,messagecontents) values (0,'" + Integer.toString(theID) + "', N'" + nick + "' )" );
          
        }catch(Exception e){out.println(e.toString()); return;}


        con.close();

     response.sendRedirect("filteration.jsp"); 
 
%>


