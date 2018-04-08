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
   String[] thecountry = new String[count];  
   String[] thecoperator = new String[count];
   String[] theprovidername = new String[count];
   String[] theshortcode = new String[count];
//   String[] thescdirection = new String[count];
//   String[] thesccount = new String[count];
     

for (int i=0; i < count;i++)
{
   ischeck[i] = request.getParameter("ischeck"+ Integer.toString(i) );
   id[i] = request.getParameter("id"+ Integer.toString(i));
   thecountry[i] = request.getParameter("thecountry"+ Integer.toString(i));
   thecoperator[i] = request.getParameter("thecoperator"+ Integer.toString(i));
   theprovidername[i] = request.getParameter("theprovidername"+ Integer.toString(i));
   theshortcode[i] = request.getParameter("theshortcode"+ Integer.toString(i));
//   thescdirection[i] = request.getParameter("thescdirection"+ Integer.toString(i));
//   thesccount[i] = request.getParameter("thesccount"+ Integer.toString(i));
      
    
  out.println(ischeck[i]); 
  out.println(id[i]); 
   
  out.println("<br><br>");
   
}
 	
	
ResultSet rs = null; 	

for (int i =0;i< count ;i ++)
{
  if(ischeck[i] != null)
  {
      try{

           String query= "delete from Providers where providerid= " +id[i] ;
           con.createStatement().execute(query); 
//  out.println(query);           
         }catch(Exception e){}
  }

}

con.close();

     response.sendRedirect("operatorsproviders.jsp");    



   		          
 
%>


