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
   if(thepage[k].equalsIgnoreCase("badwords.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("forbiddennumbers.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
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





String filtertheprovider = "ALL";
if( request.getParameter("filtertheprovider")!=null) {filtertheprovider=request.getParameter("filtertheprovider");}




   
 

 int count=0;

if (filtertheprovider.equalsIgnoreCase("ALL"))  
{
 rs = con.createStatement().executeQuery("select count(*) from badwords");            
}



if(rs.next()){count = rs.getInt(1);}
rs.close(); rs = null;

   

   

             
%>



































<html dir='rtl'>
<HEAD>


<script LANGUAGE="JavaScript" type="text/javascript">

function correctinvoke(target)
{
if(target == 0) {document.thisfrm.action="badwordadd.jsp";document.thisfrm.submit();}
if(target == 1) {document.thisfrm.action="modifyprov.jsp";document.thisfrm.submit();}
if(target == 2) {document.thisfrm.action="deleteprov.jsp";document.thisfrm.submit();}

if(target == 3) {document.accountingfrm.action="addprovaccountingfrm.jsp";document.accountingfrm.submit();}
if(target == 4) {document.accountingfrm.action="modifyprovaccountingfrm.jsp";document.accountingfrm.submit();}
if(target == 5) {document.accountingfrm.action="deleteprovaccountingfrm.jsp";document.accountingfrm.submit();}


}


function viewarabicurl(theID,theapp)
{
var thecountry = document.getElementById('thecountry' + theID).value;
var thecoperator = document.getElementById('thecoperator' + theID).value;
var theprovidername = document.getElementById('theprovidername' + theID).value;
var theshortcode = document.getElementById('theshortcode' + theID).value;
prompt('\u0645\u062B\u0627\u0644\u0020\u0644\u0631\u0627\u0628\u0637\u0020\u0627\u0644\u0631\u0633\u0627\u0626\u0644\u0020\u0627\u0644\u0639\u0631\u0628\u064A', theapp + '?provider=' + theprovidername + '&country=' + thecountry +'&operator='+ thecoperator + '&shortcode=' +theshortcode +'&msisdn=20121234567&lang=A&contents=062A062C0631064A0628');

  
}


function viewURLEnglish(theID,theapp)
{
var thecountry = document.getElementById('thecountry' + theID).value;
var thecoperator = document.getElementById('thecoperator' + theID).value;
var theprovidername = document.getElementById('theprovidername' + theID).value;
var theshortcode = document.getElementById('theshortcode' + theID).value;
prompt('\u0645\u062B\u0627\u0644\u0020\u0644\u0631\u0627\u0628\u0637\u0020\u0627\u0644\u0631\u0633\u0627\u0626\u0644\u0020\u0627\u0644\u0627\u0646\u062C\u0644\u064A\u0632\u064A', theapp + '?provider=' + theprovidername + '&country=' + thecountry +'&operator='+ thecoperator + '&shortcode=' +theshortcode +'&msisdn=20121234567&lang=E&contents=test');
}





function thecorrectinvoke(whattocall)
{

if(whattocall == 0) {document.thethisfrm.action="badbatchmodify.jsp";document.thethisfrm.submit();}
if(whattocall == 1) {document.thethisfrm.action="badbatchdelete.jsp";document.thethisfrm.submit();}

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
<title>ﬁ«„Ê” «·„„‰Ê⁄«  ... <%= medianame %></title>

</head>


<BODY>




<%
String applicationAt = "http://" + request.getHeader("Host") +request.getContextPath() + "/" +"submit.jsp";
%>



<table border='1' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%' height='80'>
  <tr>
    <td width='21%' align='center'><b><i><font color='#A36103' size='6'>ﬁ«„Ê” «·„„‰Ê⁄« </font></i></b></td>
    
 
    
    
    
    
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
 		<form name='theform' action='badwords.jsp' method='post'>
     		<tr><td align='center'><input type='submit' name='subRefresh' value='«⁄«œ…  Õ„Ì·' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
               </form>
    	</table>
    </td>
    <td bgcolor='#ffffff' width='15%' align='center'><IMG src='logo.png'></td>
  </tr>
</table>




<br>
<br>

 
      <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
 <form name=thisfrm  action="" method='get'>
 
        <tr>
          <td width='100%' height='369' valign='top'>
      	    <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#ffffff' width='30%'>
      	    

       	    
      	      <tr height='25' bgcolor=#DCDCDC>
      	      

      	        <td width='100%' colspan=2 align='center'><b>ﬂ·„Â</b></td>



      	              	        
      	      </tr>
      	      <tr >

      	        <td width='75%' align='center'><input type='text' style='font-size:12pt;color:#000000;font-weight:bold;width:15em;height:1.7em' dir='rtl' name='country' ></td>
      	        <td width='25%' align='right'><input type='button' name='subAdd' value='«÷«›…' style='font-weight:bold ; width:7em ; height:2.0em' onClick="correctinvoke(0)"></td>
      	              	        
      	      </tr>
</form>
      	    </table>


<br>






<table align='center' border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#AAAAAA' width='40%'>

<tr height='25' bgcolor=#DCDCDC>
 <td width='10%' align='center'><input type='submit'  name='subApproveSMSSel' value='«·ﬂ·' style='font-weight:bold ; width:9em ; height:2em' onClick='selectall(<%= count %>)'></td>
 <td width='10%' align='center'><input type='submit' name='subApproveSMSSel' value=' ⁄œÌ·' style='font-weight:bold ; width:9em ; height:2em' onClick="thecorrectinvoke(0)"></td>
 <td width='10%' align='center'><input type='submit' name='subApproveSMSSel' value='Õ–›' style='font-weight:bold ; width:9em ; height:2em' onClick="thecorrectinvoke(1)"></td> 
 <td width='15%' align='center'>
 
 
 
 
 

 
 
 
 
 
 
 </td>
 <td width='30%' align='center'>&nbsp;</td>
  
 <td align='center'><b>⁄œœ</b>&nbsp;&nbsp;&nbsp;&nbsp;<font color=#000099><b><%= count %></b></font></td>


 
 </tr>

</table>






     <table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#cccccc' width='30%'>

           	      <tr bgcolor=#DCDCDC height='25'>
           	      
           	      <td width='1%' align='center'><b>&nbsp;</b></td>
        	      <td width='29%' align='center'><b>ﬂ·„Â</b></td>
        	      <td width='29%' align='center'><b> ” »œ· «·Ì</b></td>        	      

      	        
              </tr>

<form name=thethisfrm method=post action="">
<INPUT type='hidden' NAME=count SIZE=6  READONLY value="<%= count %>" > 

<% 

   rs = null;
   
if (filtertheprovider.equalsIgnoreCase("ALL"))  
{   
   rs = con.createStatement().executeQuery("SELECT     id, word,modifiedto FROM         badwords ORDER BY word");  
}
      


 int therownnum =0;  
while(rs.next())
{
%>


<%
 
String targetSC = "";


String providerid = rs.getString(1);
String thecountry = rs.getString(2);
String modifiedto = rs.getString(3);


%>

     
       <td width='1%' align='center'>  <INPUT  id="ischeck<%= therownnum %>" NAME=ischeck<%= therownnum %> TYPE=CHECKBOX >  </td>
       
  <INPUT type='hidden' NAME=id<%= therownnum %> value="<%= providerid %>" > 
 <td width='10%' align='center'><INPUT dir='rtl' style='font-size:12pt;color:#AA0000;font-weight:bold;width:11em;height:1.7em' NAME=thecountry<%= therownnum %> value='<%= thecountry %>' ></td>
 <td width='10%' align='center'><INPUT dir='rtl' style='font-size:12pt;color:#0000AA;font-weight:bold;width:11em;height:1.7em' NAME=modifiedto<%= therownnum %> value='<%= modifiedto %>' ></td> 
                  


                   

                
 
                                     
                    
 </tr>
 

<%
therownnum = therownnum + 1;
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
