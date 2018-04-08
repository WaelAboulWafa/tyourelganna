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
   String[] themsisdn = new String[count];  
   String[] themsisdnorig = new String[count];     
   String[] thenickname = new String[count];
   String[] theimage = new String[count];

for (int i=0; i < count;i++)
{
   ischeck[i] = request.getParameter("ischeck"+ Integer.toString(i) );
   id[i] = request.getParameter("id"+ Integer.toString(i));
   themsisdn[i] = request.getParameter("themsisdn"+ Integer.toString(i));
   themsisdnorig[i] = request.getParameter("themsisdnorig"+ Integer.toString(i));
   thenickname[i] = request.getParameter("thenickname"+ Integer.toString(i));
   theimage[i] = request.getParameter("theimage"+ Integer.toString(i));


  try{thenickname[i] = (new String(thenickname[i].getBytes("Cp1252"),"Cp1256")).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim();}catch(Exception e){}

  
   
    
//  out.println(ischeck[i]); 
//  out.println(id[i]); 
   
//  out.println("<br><br>");
   
}
 	
	
ResultSet rs = null; 	

for (int i =0;i< count ;i ++)
{
  if(ischeck[i] != null)
  {
      try{

          String query= "update  chatNickNames set msisdn=N'" + themsisdn[i] +"', MessageContents=N'" + thenickname[i].replaceAll("'", "''") + "' where MSISDN=N'" +themsisdnorig[i] +"'";
            con.createStatement().execute(query); 
            
            out.println(query);                
            
//         }catch(Exception e){out.println(e.toString());}
         }catch(Exception e){out.println(e.toString());}         
   
        try{
            con.createStatement().execute("update ControlNicks  set nickname=N'" + thenickname[i] + "' where MSISDN_ID = N'"+ themsisdnorig[i] + "'");
//           }catch(Exception e){out.println(e.toString());}
         }catch(Exception e){out.println(e.toString());}           
                                 
       


  }

}

    response.sendRedirect("nicknames.jsp");    



   		          
 
%>


