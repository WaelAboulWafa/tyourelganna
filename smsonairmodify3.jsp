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
   String[] nameone = new String[count];  
   String[] nametwo = new String[count];  
   String[] perc = new String[count];  

for (int i=0; i < count;i++)
{
   ischeck[i] = request.getParameter("ischeck3_"+ Integer.toString(i) );
   id[i] = request.getParameter("id3_"+ Integer.toString(i));
   nameone[i] = request.getParameter("nameone"+ Integer.toString(i)).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim();
   nametwo[i] = request.getParameter("nametwo"+ Integer.toString(i)).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim();
   perc[i] = request.getParameter("perc"+ Integer.toString(i)).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim();

   try{nameone[i] = (new String(nameone[i].getBytes("Cp1252"),"Cp1256")).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim();}catch(Exception e){}
   try{nametwo[i] = (new String(nametwo[i].getBytes("Cp1252"),"Cp1256")).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim(); }catch(Exception e){}
   try{perc[i] = (new String(perc[i].getBytes("Cp1252"),"Cp1256")).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim(); }catch(Exception e){}
   
     
   
  out.println(ischeck[i]); 
  out.println(id[i]); 
   
  out.println("<br><br>");
   
}
 	
	
ResultSet rs = null; 	

for (int i =0;i< count ;i ++)
{
  if(ischeck[i] != null)
  {
        con.createStatement().execute(" update loveonair set first=N'"+ nameone[i] +"' , second=N'" +nametwo[i] + "' , percentage=N'"+ perc[i]+ "' where  AiringID=" + id[i]); 
  }

}

con.close();
       response.sendRedirect("smsonair.jsp");    


 
   		          
 
%>


