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
   String[] nameone =  new String[pagesize];
   String[] nametwo =  new String[pagesize];
   String[] perc =  new String[pagesize];

for (int i=0; i < pagesize;i++)
{
   ischeck[i] = request.getParameter("ischeck"+ Integer.toString(i+theoffset) );
   id[i] = request.getParameter("id"+ Integer.toString(i+theoffset));
   
   country[i] = request.getParameter("country"+ Integer.toString(i+theoffset));
   
   tel[i] = request.getParameter("tel"+ Integer.toString(i+theoffset));
   msg[i] = request.getParameter("msg"+ Integer.toString(i+theoffset));
   messagelogic[i] = request.getParameter("messagelogic"+ Integer.toString(i+theoffset));   
   
   nameone[i] = request.getParameter("nameone"+ Integer.toString(i+theoffset));   
   nametwo[i] = request.getParameter("nametwo"+ Integer.toString(i+theoffset));   
   perc[i] = request.getParameter("perc"+ Integer.toString(i+theoffset));   
   
   try{nameone[i] = (new String(nameone[i].getBytes("Cp1252"),"Cp1256")).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim();}catch(Exception e){}
   try{nametwo[i] = (new String(nametwo[i].getBytes("Cp1252"),"Cp1256")).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim(); }catch(Exception e){}
   try{perc[i] = (new String(perc[i].getBytes("Cp1252"),"Cp1256")).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim(); }catch(Exception e){}
   try{msg[i]= (new String(msg[i].getBytes("Cp1252"),"Cp1256")).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim(); }catch(Exception e){}
   
  
  
  
   
//  out.println(ischeck[i]); 
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
   msg[i] = msg[i].replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim();  
   try{

          con.createStatement().execute("insert into loveonair(msisdn, first, second, percentage) values ('" + tel[i] + "', N'" + nameone[i] + "',N'" + nametwo[i]+ "','" + perc[i] + "')" );         
       

         con.createStatement().execute("update CDRs set FilerationAgent=N'" + session.getAttribute("username").toString().replaceAll("'", "''") + "', ApprovedContent= N'" + msg[i] + "' , status=1, Update_Time=getdate() ,  FiltrationIP= '" + request.getRemoteAddr() + "'  where id=" + id[i]);                
         con.createStatement().execute("delete from newLove where originalid=" + id[i]); 
          
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
                      
    response.sendRedirect("filterationlove.jsp?filtertheshortcode="+thefilter + "&offset=" + offset); 
 
%>


 