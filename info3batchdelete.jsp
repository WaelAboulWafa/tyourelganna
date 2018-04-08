<%@ page contentType="text/html;charset=Cp1252"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>




<%

  Connection con=null;
 InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();

int count = 0 ;


 count = Integer.parseInt(request.getParameter("count"));
 
  out.println("count : " + count);  
  out.println("<br><br>");

   String[] ischeck = new String[count];
   String[] id = new String[count];
   String[] msg = new String[count];
   String[] selected  =  new String[count];
   

for (int i=0; i < count;i++)
{
   ischeck[i] = request.getParameter("ischeck"+ Integer.toString(i) );
   id[i] = request.getParameter("id"+ Integer.toString(i));
   msg[i] = request.getParameter("msg"+ Integer.toString(i));
   selected[i] = request.getParameter("selected"+ Integer.toString(i));
   
   if ( selected[i] != null) {selected[i] = "1";}
   else {selected[i] = "0";}
   
  out.println(ischeck[i]); 
  out.println(id[i]); 
  
 out.println("<br><br>");
   
}
 	


for (int i =0;i< count ;i ++)
{
  if(ischeck[i] != null)
  {
        con.createStatement().execute("delete from info3 where id=" + id[i]);        
  }
}


       con.close();

 response.sendRedirect("info3.jsp");

 
%>


