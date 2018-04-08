<%@ page contentType="text/html;charset=Cp1252"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>

 

<%
Connection con=null;
 InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();


int pagesize = 50 ;


 int theoffset = Integer.parseInt(request.getParameter("theoffset"));
 
//  out.println("theoffset : " + theoffset);  
//  out.println("<br><br>");

   String[] ischeck = new String[pagesize];
   String[] id = new String[pagesize];
   
   String[] country = new String[pagesize];   
   
   String[] tel =  new String[pagesize];
   String[] msg =  new String[pagesize];
   String[] messagelogic =  new String[pagesize];


   String userid = request.getParameter("userid").trim();
   String[] hold_userid =  new String[pagesize];
   String[] hold_username =  new String[pagesize];
   
for (int i=0; i < pagesize;i++)
{
   ischeck[i] = request.getParameter("ischeck"+ Integer.toString(i+theoffset) );
   id[i] = request.getParameter("id"+ Integer.toString(i+theoffset));
   
   country[i] = request.getParameter("country"+ Integer.toString(i+theoffset));
   
   tel[i] = request.getParameter("tel"+ Integer.toString(i+theoffset));
   msg[i] = request.getParameter("msg"+ Integer.toString(i+theoffset));
   messagelogic[i] = request.getParameter("messagelogic"+ Integer.toString(i+theoffset));   
   
   hold_userid[i] = request.getParameter("hold_userid"+ Integer.toString(i+theoffset));   
   hold_username[i] = request.getParameter("hold_username"+ Integer.toString(i+theoffset));   
  
   
 // out.println(ischeck[i]); 
//  out.println(id[i]); 
//  out.println(tel[i]); 
//  out.println(msg[i]);
//   out.println(messagetarget[i]);
//   out.println("<br><br>");
   
}
 	

	
for (int i =0;i< pagesize ;i ++)
{
  if(ischeck[i] != null)
  {
   msg[i] = msg[i].replaceAll("'", "''").replaceAll("\r", "").replaceAll("\n", "").trim();  
   msg[i] = (new String(msg[i].getBytes("Cp1252"),"Cp1256"));
   
   
   try{
         if ( hold_userid[i].equalsIgnoreCase(userid) )
         {
          con.createStatement().execute("update NewSMS set hold=0 where originalid=" + id[i]);          
         }
                  
          
        }catch(Exception e){out.println(e.toString()); return;}

  }

}



       String offset ="0";
       String thefilter ="ALL";
       try{ 
           offset = request.getParameter("thebase");
           }catch(Exception e){offset ="0";}
         try
         {             
           thefilter = URLEncoder.encode(request.getParameter("countrysc"));
           }catch(Exception e){thefilter ="ALL";}

con.close();
                      
     response.sendRedirect("filteration_hold.jsp?filtertheshortcode="+thefilter + "&offset=" + offset); 
 
%>


 