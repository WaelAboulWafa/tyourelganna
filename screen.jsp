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
  if(thepage[k].equalsIgnoreCase("screen.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("send.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("nicknames.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("smsonair.jsp")){if(allowed[k] == 1){allowedaccess =true;}}         
//   if(thepage[k].equalsIgnoreCase("search.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("badwords.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("operatorsproviders.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("upperinfo.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("lowerinfo.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("instructions.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("smscount.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("smsdistribution.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("fakesend.jsp")){if(allowed[k] == 1){allowedaccess =true;}}                           
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











             
%>






















<html dir='rtl'>
<HEAD>


<script LANGUAGE="JavaScript" type="text/javascript">

function correctinvoke(target)
{
if(target == 0) {document.thethisfrm.action="updatevotes.jsp";document.thethisfrm.submit();}
if(target == 1) {document.thethisfrm.action="deletevotes.jsp";document.thethisfrm.submit();}
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








function inscreasebalance(theID,appat)
{
var theid = document.getElementById('id' + theID).value;


 var rep = prompt("\u0627\u062F\u062E\u0644\u0020\u0627\u0644\u0642\u064A\u0645\u0647\u0020\u0627\u0644\u0645\u0631\u0627\u062F\u0020\u0632\u064A\u0627\u062F\u062A\u0647\u0627\u0020\u0644\u0631\u0635\u064A\u062F\u0020\u0627\u0644\u0627\u0635\u0648\u0627\u062A",1);
 if(rep != null)
 {
 window.location.href= appat + "?increase=" + rep + "&id="+ theid;
 }
}




</script>














<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000;background-color: #<%=bgcolor%>; }</style>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
<title>«·‘«‘Â ... <%= medianame %></title>

</head>


<BODY>




<%
String applicationAt = "http://" + request.getHeader("Host") +request.getContextPath() + "/addvote.jsp";
//out.println(applicationAt);
%>



<table border='1' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%' height='80'>
  <tr>
    <td width='21%' align='center'><b><i><font color='#A36103' size='6'>«·‘«‘Â</font></i></b></td>
    

    
    
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
     		 <tr><td><input type='submit' name='subMain' value='«·ﬁ«∆„… «·—∆Ì”Ì…' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
                </form>
 		<form name='theform' action='screen.jsp' method='post'>
     		<tr><td><input type='submit' name='subRefresh' value='«⁄«œ…  Õ„Ì·' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
               </form>
    	</table>
    </td>
    <td bgcolor='#ffffff' width='15%' align='center'><IMG src='logo.png'></td>
  </tr>
</table>




<br>





 
  
 
 		    
		    <table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                  <tr>
				  
				  
				  
				  
					<!-- SMS -->
                    <td width='3%'>&nbsp;</td>
                    <td width='10%' valign='top'>
                    <table border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                        <tr bgcolor=#646464>
                              <td width='100%' align='center' height='30'><b><font size='4' color=white>‘—Ìÿ «·—”«∆·</font></b></td>
                        </tr>
                        
                        




                     <tr bgcolor=#DCDCDC>
                              <form action='webcommands.jsp' method='post'>
                                <td width='100%' height='40'><p align='center'><input type='submit' name='subApprove' value='«ŸÂ«—' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
                                <INPUT type='hidden' NAME=command value="showsms" > 
                  		      </form>
                        </tr>
                 
                        
            


                     <tr bgcolor=#DCDCDC>
                              <form action='webcommands.jsp' method='post'>
                                <td width='100%' height='40'><p align='center'><input type='submit' name='subApprove' value='«Œ›«¡' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
                                <INPUT type='hidden' NAME=command value="hidesms" > 
                  		      </form>
                        </tr>
                 
                 		</table>

			       </td>
			
			
			
			
			


					<!--  Info1 -->
                    <td width='3%'>&nbsp;</td>
                    <td width='10%' valign='top'>
                    <table border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                        <tr bgcolor=#646464>
                              <td width='100%' align='center' height='30'><b><font size='4' color=white> ‰ÊÌÂ«  1</font></b></td>
                        </tr>
                        
                        




                     <tr bgcolor=#DCDCDC>
                              <form action='webcommands.jsp' method='post'>
                                <td width='100%' height='40'><p align='center'><input type='submit' name='subApprove' value='«ŸÂ«—' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
                                <INPUT type='hidden' NAME=command value="showinfo1" > 
                  		      </form>
                        </tr>
                 
                        
            


                     <tr bgcolor=#DCDCDC>
                              <form action='webcommands.jsp' method='post'>
                                <td width='100%' height='40'><p align='center'><input type='submit' name='subApprove' value='«Œ›«¡' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
                                <INPUT type='hidden' NAME=command value="hideinfo1" > 
                  		      </form>
                        </tr>
                 
                 		</table>

			       </td>
			
			





					<!-- Info2 -->
                    <td width='3%'>&nbsp;</td>
                    <td width='10%' valign='top'>
                    <table border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                        <tr bgcolor=#646464>
                              <td width='100%' align='center' height='30'><b><font size='4' color=white> ‰ÊÌÂ«  2</font></b></td>
                        </tr>
                        
                        




                     <tr bgcolor=#DCDCDC>
                              <form action='webcommands.jsp' method='post'>
                                <td width='100%' height='40'><p align='center'><input type='submit' name='subApprove' value='«ŸÂ«—' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
                                <INPUT type='hidden' NAME=command value="showinfo2" > 
                  		      </form>
                        </tr>
                 
                        
            


                     <tr bgcolor=#DCDCDC>
                              <form action='webcommands.jsp' method='post'>
                                <td width='100%' height='40'><p align='center'><input type='submit' name='subApprove' value='«Œ›«¡' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
                                <INPUT type='hidden' NAME=command value="hideinfo2" > 
                  		      </form>
                        </tr>
                 
                 		</table>

			       </td>
			
			






                    <td width='3%'>&nbsp;</td>
                    <td width='10%' valign='top'>
                    <table border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                        <tr bgcolor=#646464>
                              <td width='100%' align='center' height='30'><b><font size='4' color=white> ‰ÊÌÂ«  3</font></b></td>
                        </tr>
                        
                        




                     <tr bgcolor=#DCDCDC>
                              <form action='webcommands.jsp' method='post'>
                                <td width='100%' height='40'><p align='center'><input type='submit' name='subApprove' value='«ŸÂ«—' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
                                <INPUT type='hidden' NAME=command value="showinfo3" > 
                  		      </form>
                        </tr>
                 
                        
            


                     <tr bgcolor=#DCDCDC>
                              <form action='webcommands.jsp' method='post'>
                                <td width='100%' height='40'><p align='center'><input type='submit' name='subApprove' value='«Œ›«¡' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
                                <INPUT type='hidden' NAME=command value="hideinfo3" > 
                  		      </form>
                        </tr>
                 
                 		</table>

			       </td>
			
			
			
			
			
                    <td width='3%'>&nbsp;</td>
                    <td width='10%' valign='top'>
                    <table border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                        <tr bgcolor=#646464>
                              <td width='100%' align='center' height='30'><b><font size='4' color=white>„Ì“«‰ «·Õ»</font></b></td>
                        </tr>
                        
                        




                     <tr bgcolor=#DCDCDC>
                              <form action='webcommands.jsp' method='post'>
                                <td width='100%' height='40'><p align='center'><input type='submit' name='subApprove' value='«ŸÂ«—' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
                                <INPUT type='hidden' NAME=command value="showlove" > 
                  		      </form>
                        </tr>
                 
                        
            


                     <tr bgcolor=#DCDCDC>
                              <form action='webcommands.jsp' method='post'>
                                <td width='100%' height='40'><p align='center'><input type='submit' name='subApprove' value='«Œ›«¡' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
                                <INPUT type='hidden' NAME=command value="hidelove" > 
                  		      </form>
                        </tr>
                 
                 		</table>

			       </td>			
			
			

			
                    <td width='3%'>&nbsp;</td>
                    <td width='10%' valign='top'>
                    <table border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                        <tr bgcolor=#646464>
                              <td width='100%' align='center' height='30'><b><font size='4' color=white>·ÊÃÊ</font></b></td>
                        </tr>
                        
                        




                     <tr bgcolor=#DCDCDC>
                              <form action='webcommands.jsp' method='post'>
                                <td width='100%' height='40'><p align='center'><input type='submit' name='subApprove' value='«ŸÂ«—' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
                                <INPUT type='hidden' NAME=command value="showlogo" > 
                  		      </form>
                        </tr>
                 
                        
            


                     <tr bgcolor=#DCDCDC>
                              <form action='webcommands.jsp' method='post'>
                                <td width='100%' height='40'><p align='center'><input type='submit' name='subApprove' value='«Œ›«¡' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
                                <INPUT type='hidden' NAME=command value="hidelogo" > 
                  		      </form>
                        </tr>
                 
                 		</table>

			       </td>

					<td width='3%'>&nbsp;</td>
				</tr>

					
                    <tr>
						<td width='3%'>&nbsp;</td>
					</tr>

				<tr>

				
				
                    <td width='3%'>&nbsp;</td>
                    <td colspan=3 width='40%' valign='top'>
                    <table border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                        <tr bgcolor=#646464>
                              <td width='100%' align='center' height='30'><b><font size='4' color=white> «Ê«„— ⁄«„Â</font></b></td>
                        </tr>
                        
                        




                     <tr bgcolor=#DCDCDC>
                              <form action='webcommands.jsp' method='post'>
                                <td width='100%' height='40'><p align='center'><input type='submit' name='subApprove' value='«Œ›«¡ «·ﬂ· „« ⁄œ« «··ÊÃÊ' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:15em ; height:2.0em'></td>
                                <INPUT type='hidden' NAME=command value="hideallexceptlogo" > 
                  		      </form>
                        </tr>
                 
                        
            


                 
                 		</table>

			       </td>			
							
				    
				</tr>



</BODY>
</HTML>
























<%
}
con.close();
}
%>
