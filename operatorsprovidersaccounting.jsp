<%@ page contentType="text/html;charset=Cp1252"%>
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
String username;try{ username =  session.getAttribute("username").toString();}catch(Exception e){username=null;}
String password;try{password =  session.getAttribute("password").toString();}catch(Exception e){password=null;}
if(username==null || password==null) //user not logged in
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
  int userid= 0;
  try
  {
   rs = con.createStatement().executeQuery("SELECT userID from Users where username=N'" + username.replaceAll("'", "''") + "' and password=N'" + password.replaceAll("'", "''") + "'");             
   userid = 0;
   while(rs.next()){userid = rs.getInt(1);}
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
   if(thepage[k].equalsIgnoreCase("operatorsprovidersaccounting.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("upperinfo.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("lowerinfo.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
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









int count=0;
rs = con.createStatement().executeQuery("select count(*) from providers");            
if(rs.next()){count = rs.getInt(1);}
rs.close(); rs = null;

 
 

   

   

             
%>



































<html dir='rtl'>
<HEAD>


<script LANGUAGE="JavaScript" type="text/javascript">

function correctinvoke()
{
document.thisfrm.action="batchprovidermodify.jsp";document.thisfrm.submit();

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
<title>÷»ÿ «·Õ”«»«  ...<%=medianame%></title>

</head>


<BODY>





<table border='1' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%' height='80'>
  <tr>
    <td width='21%' align='center'><b><i><font color='#A36103' size='6'>÷»ÿ «·Õ”«»« </font></i></b></td>
    
 
    
    
    
    
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
 		<form name='theform' action='operatorsprovidersaccounting.jsp' method='post'>
     		<tr><td align='center'><input type='submit' name='subRefresh' value='«⁄«œ…  Õ„Ì·' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
               </form>
    	</table>
    </td>
<td bgcolor='#ffffff' width='15%' align='center'><IMG src='logo.png'></td>
  </tr>
</table>




<br>




 





<table align='center' border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#AAAAAA' width='85%'>

<tr height='25' bgcolor=#DCDCDC>
 <td width='10%' align='center'><input type='submit' name='subApproveSMSSel' value='«Œ Ì«— «·ﬂ·' style='font-weight:bold ; width:11em ; height:3em' onClick='selectall(<%= count %>)'></td>
 <td width='10%' align='center'><input type='submit' name='subApproveSMSSel' value=' ⁄œÌ· «·„Œ «—' style='font-weight:bold ; width:11em ; height:3em' onClick="correctinvoke(0)"></td>
 <td width='65%' align='center'>&nbsp;</td>
 </tr>

</table>

<br>




     <table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#cccccc' width='85%'>

           	      <tr bgcolor=#DCDCDC height='25'>
      	        <td width='3%' align='center'>&nbsp;</td>           	      

      	        <td width='10%' align='center'><b>œÊ·…</b></td>
                <td width='10%' align='center'><b>‘—ﬂ… «·« ’«·« </b></td>

      	        <td width='10%' align='center'><b>«·—ﬁ„ «·„Œ ’—</b></td>
      	        <td width='10%' align='center'><b> ⁄—Ì›… «·—ﬁ„ »⁄„·… »·œÂ«</b></td>      	        
      	        <td width='10%' align='center'><b> ⁄—Ì›… «·—ﬁ„ «·„Œ ’— »«·œÊ·«—</b></td>
      	        <td width='10%' align='center'><b>‰”»… «·ﬁ‰«Â »«·œÊ·«—</b></td>
      	          	        
              </tr>



<form name=thisfrm method=post action="">
<INPUT type='hidden' NAME=count SIZE=6  READONLY value="<%= count %>" > 

<% 
 int l = 0;
   rs = null;
   rs = con.createStatement().executeQuery("SELECT     ProviderID, country,operator,Providername, shortcode, NativeTarrif ,convert(  nvarchar, round(Tarrif,3) ) as TheTariff,convert(  nvarchar, round(Mediashare,3) ) as Mediashare  FROM         Providers where providerid not in ('0','-1')  ORDER BY ProviderID");  
while(rs.next())
{
l = l +1 ;
%>
          <tr bgcolor=#ffffff height='25'>
   
                  <td width='3%' align='center'>  <INPUT NAME=ischeck<%= l %> TYPE=CHECKBOX >  </td>
                   <input type='hidden' name='id<%= l %>' value='<%= rs.getString(1) %>'>  

                  <td width='10%' align='center'><b><%=rs.getString(2)%></b></td>

                   <td width='10%' align='center'><b><%=rs.getString(3)%></b></td>
    
    <%
                   String xxx=rs.getString(4);
    %>
    
                   <td width='10%' align='center'><b><%=rs.getString(5)%></td>
                   
                   <td width='10%' align='center'><INPUT dir='ltr' style='font-size:12pt;color:#000000;font-weight:bold;width:8em;height:1.7em' NAME=nativetarrif<%= l %> value='<%=rs.getString(6)%>' ></td>                                      
                   <td width='10%' align='center'><INPUT dir='ltr' style='font-size:12pt;color:#000000;font-weight:bold;width:8em;height:1.7em' NAME=tariff<%= l %> value=<%=rs.getString(7)%> ></td>
                   <td width='10%' align='center'><INPUT dir='ltr' style='font-size:12pt;color:#000000;font-weight:bold;width:8em;height:1.7em' NAME=mediashare<%= l %> value=<%=rs.getString(8)%> ></td>


<%
}rs.close();rs=null;
con.close();
%>

</form>  



 </table>









<br>




</BODY>
</HTML>
























<%
}
}
%>
