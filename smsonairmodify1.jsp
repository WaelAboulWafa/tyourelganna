<%@ page contentType="text/html;charset=Cp1252"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>


 

<%

  Connection con=null;
 InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();

 
int count = 0 ;


 count = Integer.parseInt(request.getParameter("count"));
 
   String[] ischeck = new String[count];
   String[] id = new String[count];
   String[] newtext = new String[count];  

for (int i=0; i < count;i++)
{
   ischeck[i] = request.getParameter("ischeck1_"+ Integer.toString(i) );
   id[i] = request.getParameter("id1_"+ Integer.toString(i));
   newtext[i] = request.getParameter("msg1_"+ Integer.toString(i));
  out.println(ischeck[i]); 
  out.println(id[i]); 
   
  out.println("<br><br>");
   
}
 	
	
ResultSet rs = null; 	

for (int i =0;i< count ;i ++)
{
  if(ischeck[i] != null)
  {
  newtext[i] = (new String(newtext[i].getBytes("Cp1252"),"Cp1256"));
        con.createStatement().execute(" update chatarabic set MessageContents=N'"+ newtext[i].replaceAll("'", "''") +" ' where  AiringID=" + id[i]); 
  }

}

con.close();
       response.sendRedirect("smsonair.jsp");    



   		          
 
%>


