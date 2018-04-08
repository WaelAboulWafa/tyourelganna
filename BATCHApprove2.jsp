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

   String controlmsisdn ="";
   String[] msgcontrol =  new String[pagesize];
   controlmsisdn = request.getParameter("controlmsisdn");

   
   out.println(controlmsisdn); 
   
for (int i=0; i < pagesize;i++)
{
   ischeck[i] = request.getParameter("ischeck"+ Integer.toString(i+theoffset) );
   id[i] = request.getParameter("id"+ Integer.toString(i+theoffset));
   
   country[i] = request.getParameter("country"+ Integer.toString(i+theoffset));
   
   tel[i] = request.getParameter("tel"+ Integer.toString(i+theoffset));
   msg[i] = request.getParameter("msg"+ Integer.toString(i+theoffset));
   messagelogic[i] = request.getParameter("messagelogic"+ Integer.toString(i+theoffset));   
   
   msgcontrol[i] = request.getParameter("msgcontrol"+ Integer.toString(i+theoffset));
  
   
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
   msg[i] = msg[i].replaceAll("'", "''").replaceAll("\r", "").replaceAll("\n", "").trim();  
   msg[i] = (new String(msg[i].getBytes("Cp1252"),"Cp1256"));
   
   msgcontrol[i] = msgcontrol[i].replaceAll("'", "''").replaceAll("\r", "").replaceAll("\n", "").trim();  
   msgcontrol[i] = (new String(msgcontrol[i].getBytes("Cp1252"),"Cp1256"));
   
   try{
         if (messagelogic[i].equalsIgnoreCase("nickname"))
         {
          con.createStatement().execute("delete from chatNickNames where msisdn='" + tel[i]+"'");          
          con.createStatement().execute("insert into chatNickNames(originalid,msisdn,messagecontents) values (" + id[i] + ",'" + tel[i] + "', N'" + msg[i].substring(3).trim() + "' )" );         
         }
         else
         {
          con.createStatement().execute("insert into chatArabic2(msisdn,messagecontents,country) values ('" + tel[i] + "', N'" + msg[i] + "',N'" + country[i]+ "')" );         
          
          //control replay
          if ( msgcontrol[i].length() > 0)
          {
		con.createStatement().execute("insert into chatArabic2(msisdn,messagecontents,country) values ('" + controlmsisdn + "', N'" + msgcontrol[i] + "',N'" + country[i]+ "')" );                   
          }
          
         }
        

         con.createStatement().execute("update CDRs set FilerationAgent=N'" + session.getAttribute("username").toString().replaceAll("'", "''") + "', ApprovedContent= N'" + msg[i] + "' , status=1, Update_Time=getdate() ,  FiltrationIP= '" + request.getRemoteAddr() + "'  where id=" + id[i]);                
         con.createStatement().execute("delete from NewSMS where originalid=" + id[i]); 
         
          if( country[i].indexOf("control") == -1 )
          {          
           con.createStatement().execute("insert into chatReplay(msisdn,messagecontents) values ('" + tel[i] + "', N'" + msg[i] + "')" );          
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
                      
     response.sendRedirect("filteration.jsp?filtertheshortcode="+thefilter + "&offset=" + offset); 
 
%>


 