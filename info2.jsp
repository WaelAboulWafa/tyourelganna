<%@ page contentType="text/html;charset=windows-1256"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>


  

<%!
   
 public boolean isallowed(String requestedpage,String[] thepagesallowed,int[] theflag)
 {
  for(int k =0;k< thepagesallowed.length ; k++)
  {
    
    if(requestedpage.equalsIgnoreCase(thepagesallowed[k]))
    {
      if(theflag[k] == 1){return true;}
    } 
  }
  
  return false;
 }

            
%>




 





<%
String userid;try{ userid =  session.getAttribute("userid").toString();}catch(Exception e){userid=null;}
String username;try{ username =  session.getAttribute("username").toString();}catch(Exception e){username=null;}
String password;try{password =  session.getAttribute("password").toString();}catch(Exception e){password=null;}
if(userid==null) //user not logged in
{
session.invalidate();
response.sendRedirect("login.jsp");
}

else
{

  /////get user authorities/////////////
  Connection con=null;
  InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();
  ResultSet rs = null;
  int phoneallowed = 0;
  try
  {
   rs = con.createStatement().executeQuery("SELECT phone from Users where userID=" + userid);
   while(rs.next()){phoneallowed=rs.getInt(1);}
   rs.close();rs = null;
  }catch(Exception e){}
  
  

  



  int reccount1 = 0 ;
  rs = null;
  try
  {
   rs = con.createStatement().executeQuery("SELECT count(*) from UsersAuthorities where userID=" + userid);             
   while(rs.next()){reccount1 = rs.getInt(1);} 
   rs.close();rs = null;
  }catch(Exception e){}
  
  
  String[] thepage = new String[reccount1];
  int[] allowed = new int[reccount1];
  
  rs = null;
  int z =0;
  try
  {
   rs = con.createStatement().executeQuery("SELECT page, allowed from UsersAuthorities where userID=" + userid);             
   while(rs.next()){thepage[z]=rs.getString(1);allowed[z]=rs.getInt(2);z=z+1;}
   rs.close();rs = null;
  }catch(Exception e){}
    










  rs = null;
  String indate=""; 
  String intime="";
  try
  {
   rs = con.createStatement().executeQuery("SELECT  CONVERT(char(10), lastlogintime, 101), convert(varchar,lastlogintime, 8)  from Users where userID=" + userid);             
   while(rs.next()){indate=rs.getString(1);intime=rs.getString(2);}
   rs.close();rs = null;
  }catch(Exception e){}







  
  boolean allowedaccess = false;
  for(int k =0;k< thepage.length ; k++)
  {
//   if(thepage[k].equalsIgnoreCase("filteration.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("send.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("nicknames.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("smsonair.jsp")){if(allowed[k] == 1){allowedaccess =true;}}         
//   if(thepage[k].equalsIgnoreCase("search.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("badwords.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("operatorsproviders.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("upperinfo.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
   if(thepage[k].equalsIgnoreCase("info2.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("instructions.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("smscount.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("smsdistribution.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("autorities.jsp")){if(allowed[k] == 1){allowedaccess =true;}}                           
  }
  
  


  /////get media name/////////////
  String medianame="";
  String bgcolor="";
  try
  {
   rs = con.createStatement().executeQuery("SELECT medianame, bgcolor from webconfig");             
   while(rs.next()){medianame = rs.getString(1);bgcolor = rs.getString(2);}
   rs.close();rs = null;
  }catch(Exception e){}
  
// out.println(allowedaccess);

if(allowedaccess ==false)
{
response.sendRedirect("login_logout.jsp");
return;
}

else
{

  rs = null;





















  int reccount = 0;
     String[] id = null;
     String[] msg = null;
     String[] aired = null;

     int visiblecount = 0 ;

int whenrejectcount = 0;    








//-----------------------------------
String query1 = "SELECT count(*) from info2";
String query2 = "SELECT ID from info2 order by ID";
String query3 = "select ID, TheText, Selected from info2 order by ID";

String filtershortcode = "ALL";
///-----------------------------------




















    
       int count= 0;
      rs = con.createStatement().executeQuery(query1);            
      if(rs.next())
      {
     	 count = rs.getInt(1);
      }
        rs.close(); rs = null;
   
  
    visiblecount =  reccount;
  
       
       rs = con.createStatement().executeQuery(query2);            
       while(rs.next())
       {
     	 String tmp = rs.getString(1);
     	 visiblecount = visiblecount + 1 ;
       }
        rs.close(); rs = null;
        
   
   rs = null;
   rs = con.createStatement().executeQuery(query3);

   
     id = new String[visiblecount];
     msg = new String[visiblecount];
     aired = new String[visiblecount];
   
   rs.next();
   //int theCounter = 0;
   //while(rs.next())
for (int theCounter=0;theCounter<visiblecount;theCounter++)
    {
     id[theCounter] = rs.getString(1).trim();
     msg[theCounter] = rs.getString(2).trim(); 
     aired[theCounter] = rs.getString(3).trim(); 
     rs.next();
    // theCounter = theCounter + 1 ;
   }
   rs.close(); 
   rs = null;
   
   
   
   

   
   

























   
 

   
con.close();   
   

             
%>



































<html dir='rtl'>
<HEAD>


<script LANGUAGE="JavaScript" type="text/javascript">

function correctinvoke(target)
{
if(target == 0) {document.thisfrm.action="info2batchupdate.jsp";document.thisfrm.submit();}
if(target == 1) {document.thisfrm.action="info2batchdelete.jsp";document.thisfrm.submit();}
}



function selectall(k)
{
	for( i=0; i< k; i++ )
	{ 
	 if( document.getElementById('ischeck' + i) != null )  
     { 
	   document.getElementById('ischeck' + i).checked = true; 
	 }
	}
}





</script>














<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000;background-color: #<%=bgcolor%>; }</style>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
<title> ‰ÊÌÂ«  2 ... <%= medianame %></title>

</head>


<BODY>





<table border='1' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%' height='80'>
  <tr>
    <td width='21%' align='center'><b><i><font color='#A36103' size='6'> ‰ÊÌÂ«  2</font></i></b></td>
    <td width='35%' align='center'>
    <table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%'>
      <tr><td width='100%' align='center'><font color='#000000' face='Arial' size='4'><b> Êﬁ‹‹  «·œŒÊ·  <%= intime %> </b></font></td></tr>
      <tr><td width='100%' align='center'><font color='#000000' face='Arial' size='4'><b> &nbsp;</b></font></td></tr>
      <tr><td width='100%' align='center'><font color='#000000' face='Arial' size='4'><b>  «—Ì‹‹Œ «·œŒÊ·  <%= indate %> </b></font></td></tr>
    </table>
    </td>
    <td width='19%' align='center'>
    	<table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%'>
 		<form action='MainPage.jsp' method='post'>                
     		 <tr><td align='center'><input type='submit' name='subMain' value='«·ﬁ«∆„… «·—∆Ì”Ì…' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
                </form>
 		<form name='theform' action='info2.jsp' method='post'>
     		<tr><td align='center'><input type='submit' name='subRefresh' value='«⁄«œ…  Õ„Ì·' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
               </form>
    	</table>
    </td>
<td bgcolor='#ffffff' width='15%' align='center'><IMG src='logo.png'></td>
  </tr>
</table>




<br>
 <br>

 

            <table border='1' bgcolor=#DCDCDC align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#AAAAAA' width='50%'>
                    <form action='info2new.jsp' method='post'>
                                 <tr>
                                           <td width='25%' align="center"><b>‰’ ÃœÌœ</b></td>
                                      


                                    </tr>

                  <tr>
                    <td width='100%'><textarea rows='3' cols='60' dir='rtl' name='themsg' style='FONT-WEIGHT: bold; FONT-SIZE: 14pt'></textarea></td>
                    </tr>

                                 <tr>
                                 <td width='25%' align="right">
                            <input type='submit' name='Rejectsingle' value='Õ›Ÿ' style='font-weight:bold ; width:6em ; height:2em'>

                                          </td>


                                    </tr>
   
                                             </form>                        
                 
            </table>

















            <table border='1' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='70%'>
                  <tr>
                        <td>
                              <table border='0' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                    <tr>
                                          <td width='5%' align='center'>
                                                <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                                      <input type='hidden' name='uid' value='41'>
                                                      <input type='hidden' name='cur_page' value='1'>
                                                      <input type='hidden' name='selc' value=''>
                                                      <tr><td align='center'><input type='submit' name='subSelectAll' value='«·ﬂ·' style='font-weight:bold ; width:8em ; height:2em' onClick="selectall(<%= count %>)"></td></tr>
                                                </table>
                                          </td>
                                          <td width='5%' align='center'>&nbsp;</td>
                                          <td width='15%' align='center'><input type='submit' name='subApproveSMSSel' value=' ⁄œÌ·' style='font-weight:bold ; width:11em ; height:2em' onClick="correctinvoke(0)"></td>
                                          <td width='15%' align='center'><input type='submit' name='subDeclineSMSSel' value='Õ–›' style='font-weight:bold ; width:11em ; height:2em'  onClick="correctinvoke(1)"></td>
                                          <td width='35%' align='center'>
                                                <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                                      <tr align="center">
                                                       <td align='center'>

                                            </td>
                                                      </tr>
                                                </table>
                                          </td>
                                          <td width='15%' align='center'>

                                          </td>

                                    </tr>
                              </table>
                        </td>
                  </tr>
            </table>










     <table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#cccccc' width='70%'>
             <tr bgcolor=#DCDCDC>
                  <td width='5%' align='center'><b>«Œ Ì«—</b></td>

                  <td width='50%' align='center'><b>«·‰’</b></td>
                  <td width='5%' align='center'><b>⁄·Ì «·ÂÊ«¡ ø</b></td>

            </tr>
     


<form name=thisfrm method=post action="" >

<INPUT style="display: none;" NAME=count SIZE=10  value="<%= count %>" > 

<% for (int l =0; l < count ; l ++)
{

if(aired[l].equalsIgnoreCase("0"))
{
%>        
           <tr bgcolor=#FCE3E4>

<%
}
else
{
%>
           <tr bgcolor=#E3FCF0> 
<%
}
%>
            <td align='center'>  <INPUT  id="ischeck<%= l %>" NAME=ischeck<%= l %> TYPE=CHECKBOX >  </td>
    	    <INPUT type='hidden' NAME=id<%= l %> SIZE=6  READONLY value="<%= id[l] %>" >
            <td align='center'>  <TEXTAREA dir="RTL" style="FONT-WEIGHT: bold; FONT-SIZE: 12pt" NAME=msg<%= l %>  COLS=65 ROWS=2 ><%=  msg[l]  %></TEXTAREA></td>    	    
<%
if (aired[l].equalsIgnoreCase("1"))
{
%>
   	    <td align=center>  <INPUT TYPE=CHECKBOX  checked NAME=selected<%= l %>    > </td> 
<%
}
else
{
%>

   	    <td align=center>  <INPUT TYPE=CHECKBOX  NAME=selected<%= l %>    > </td> 
   	    
   	    </tr>
<%
}
%>


<%
}
%>
  

</form> 

 </table>



















<br>
<br>
<br>


</BODY>
</HTML>
























<%
}
}
%>
