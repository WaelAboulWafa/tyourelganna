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
   String[] tel =  new String[pagesize];
   String[] msg =  new String[pagesize];
   String[] messagetarget =  new String[pagesize];
   String[] media =  new String[pagesize];
    

for (int i=0; i < pagesize;i++)
{
   ischeck[i] = request.getParameter("ischeck"+ Integer.toString(i+theoffset) );
   id[i] = request.getParameter("id"+ Integer.toString(i+theoffset));
   tel[i] = request.getParameter("tel"+ Integer.toString(i+theoffset));
   msg[i] = request.getParameter("msg"+ Integer.toString(i+theoffset));
   messagetarget[i] = request.getParameter("messagetarget"+ Integer.toString(i+theoffset));   
   media[i] = request.getParameter("media"+ Integer.toString(i+theoffset));   

   
//  out.println(ischeck[i]); 
//  out.println(id[i]); 
//  out.println(tel[i]); 
//  out.println(msg[i]);
//   out.println(messagetarget[i]);
//   out.println("<br><br>");
   
}
 	
 
	

   try{
       
         con.createStatement().execute("delete from chatReplay "); 

         
        }catch(Exception e){out.println(e.toString()); return;}





       String offset ="0";
       String thefilter ="ALL";
       try{ 
           offset = request.getParameter("thebase");
           }catch(Exception e){offset ="0";}
         try
         {             
           thefilter = URLEncoder.encode(request.getParameter("countrysc"));
           }catch(Exception e){thefilter ="ALL";}
                      
     response.sendRedirect("replay.jsp?filtertheshortcode="+thefilter + "&offset=" + offset + "&fdate=" + URLEncoder.encode(request.getParameter("fdate")) + "&tdate=" + URLEncoder.encode(request.getParameter("tdate")) ); 
 
%>


 