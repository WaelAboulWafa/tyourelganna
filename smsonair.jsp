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
   if(thepage[k].equalsIgnoreCase("smsonair.jsp")){if(allowed[k] == 1){allowedaccess =true;}}         
//   if(thepage[k].equalsIgnoreCase("search.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("badwords.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("operatorsproviders.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
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










%>



<%



rs = null;
int arabiccount1= 0;
String[] id1 = null;
String[] msisdn1 =  null;
String[] nickname1 = null;
String[] messagecontents1 = null;
String[] senttoair1 = null;

String query1 = "SELECT count(*) from chatArabic";
String  query2 = "select chatArabic.AiringID,chatArabic.msisdn,        (case when chatNickNames.MessageContents is not null then  chatNickNames.MessageContents else '' end )AS NickName ,                 chatArabic.MessageContents,chatArabic.senttoair FROM     chatArabic LEFT OUTER JOIN      chatNickNames ON chatArabic.MSISDN = chatNickNames.MSISDN order by  chatArabic.AiringID";    
rs = con.createStatement().executeQuery(query1);            
if(rs.next()){arabiccount1 = rs.getInt(1);}
rs.close(); rs = null;
id1 = new String[arabiccount1];
msisdn1 =  new String[arabiccount1];
nickname1 = new String[arabiccount1];
messagecontents1 = new String[arabiccount1];
senttoair1 = new String[arabiccount1];
rs = con.createStatement().executeQuery(query2);

int theCounter1 = 0;
while(rs.next())
{
 id1[theCounter1] = rs.getString(1).trim();
 msisdn1[theCounter1] =  rs.getString(2).trim();
 nickname1[theCounter1] = rs.getString(3).trim();
 messagecontents1[theCounter1] = rs.getString(4).trim();
 senttoair1[theCounter1] = rs.getString(5).trim();
 theCounter1 = theCounter1 + 1 ;
}
rs.close();rs = null;
   
 










 
 
 
             
%>

<html dir=rtl>
<HEAD>
<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000;background-color: #<%=bgcolor%>; }</style>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
<title>—”«∆· ⁄·Ï «·‘«‘… ... <%= medianame %></title>

<script LANGUAGE="JavaScript" type="text/javascript">


function correctinvoke1(target)
{
if(target == 0) {document.thisfrm1.action="smsonairmodify1.jsp";document.thisfrm1.submit();}
if(target == 1) {document.thisfrm1.action="smsonairdelete1.jsp";document.thisfrm1.submit();}
}

function correctinvoke2(target)
{
if(target == 0) {document.thisfrm2.action="smsonairmodify2.jsp";document.thisfrm2.submit();}
if(target == 1) {document.thisfrm2.action="smsonairdelete2.jsp";document.thisfrm2.submit();}
}



function correctinvoke3(target)
{
if(target == 0) {document.thisfrm3.action="smsonairmodify3.jsp";document.thisfrm3.submit();}
if(target == 1) {document.thisfrm3.action="smsonairdelete3.jsp";document.thisfrm3.submit();}
}


 



function selectall1(k)
{
	for( i=0; i< k; i++ )
	{ 
	 if( document.getElementById('ischeck1_' + i) != null )  
     { 
	   document.getElementById('ischeck1_' + i).checked = true; 
	 }
	}
}


function selectall2(k)
{
	for( i=0; i< k; i++ )
	{ 
	 if( document.getElementById('ischeck2_' + i) != null )  
     { 
	   document.getElementById('ischeck2_' + i).checked = true; 
	 }
	}
}




function selectall3(k)
{
	for( i=0; i< k; i++ )
	{ 
	 if( document.getElementById('ischeck3_' + i) != null )  
     { 
	   document.getElementById('ischeck3_' + i).checked = true; 
	 }
	}
}






</script>


</HEAD>
<BODY>




<table border='1' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%' height='80'>
  <tr>
    <td width='21%' align='center'><b><i><font color='#A36103' size='6'>—”«∆· ⁄·Ì «·‘«‘Â 1</font></i></b></td>
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
     		 <tr><td align='center'> <input type='submit' name='subMain' value='«·ﬁ«∆„… «·—∆Ì”Ì…' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
                </form>
 		<form name='theform' action='smsonair.jsp' method='post'>
     		<tr><td align='center'><input type='submit' name='subRefresh' value='«⁄«œ…  Õ„Ì·' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
               </form>
    	</table>
    </td>
<td bgcolor='#ffffff' width='15%' align='center'><IMG src='logo.png'></td>
  </tr>
</table>




































<br>
<br>


























<br>

<table align='center' border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#AAAAAA' width='80%'>
<tr height='25' bgcolor=#DCDCDC>
<td width='20%' align='center'><b>—”«∆· «·œ—œ‘Â</b></td>
</tr>
</table>

<table align='center' border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#AAAAAA' width='80%'>

<tr height='25' bgcolor=#DCDCDC>
 <td width='100%' align='center'><b><font color='#000000' face='Arial' size='4'>⁄œœ&nbsp;&nbsp;<%=arabiccount1%></font></b></td>
</tr>
</table>




<table align='center' border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#AAAAAA' width='80%'>

<tr height='25' bgcolor=#DCDCDC>
 <td width='40%' align='right'><input type='submit' name='subApproveSMSSel' value='«·ﬂ·' style='font-weight:bold ; width:11em ; height:2em' onClick='selectall1(<%= arabiccount1 %>)'></td>
 <td width='30%' align='center'><input type='submit' name='subApproveSMSSel' value=' ⁄œÌ·' style='font-weight:bold ; width:11em ; height:2em' onClick="correctinvoke1(0)"></td>
 <td width='30%' align='center'><input type='submit' name='subDeclineSMSSel' value='„”Õ' style='font-weight:bold ; width:11em ; height:2em' onClick="correctinvoke1(1)"></td>

</tr>

</table>


  <table align='center' border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#AAAAAA' width='80%'>
                              <tr height='25' bgcolor=#DCDCDC>
                                    <td width='10%' align='center'><b>&nbsp;</b></td>
                                    <td width='20%' align='center'><b>«”„ „” ⁄«—</b></td>
                                    <td width='60%' align='center'><b>‰’ «·—”«·Â</b></td>
                              </tr>

<form name=thisfrm1 method=post action="">
<INPUT type='hidden' NAME=count SIZE=6  READONLY value="<%= arabiccount1 %>" > 
<% for (int l =0 ; l < arabiccount1 ; l ++)
{
if(Integer.parseInt(senttoair1[l]) == 0)
{
%>        
           <tr height='25' bgcolor=#FCE3E4>

<%
}
else
{
%>
           <tr height='25' bgcolor=#E3FCF0> 
<%
}
%>
            <INPUT type='hidden' NAME=msisdn<%= l %> SIZE=6  READONLY value="<%= msisdn1[l] %>" >
            <INPUT type='hidden' NAME=id1_<%= l %> SIZE=6  READONLY value="<%= id1[l] %>" >
            <td width='10%' align='center'><b><INPUT  id="ischeck1_<%= l %>"  NAME=ischeck1_<%= l %> TYPE=CHECKBOX > </b></td>
    	    <td width='20%' align='center'><b> <%=  nickname1[l]  %> </b></td>    	    
            <td width='70%' align='center'><b>  <TEXTAREA dir="RTL" style="FONT-WEIGHT: bold; FONT-SIZE: 12pt" NAME=msg1_<%= l %>  COLS=65 ROWS=2 ><%=  messagecontents1[l]  %></TEXTAREA></b></td>    	    


      
           </tr>  
           
<%
}
%>
</form>

</table>



      









       
   
<BR>
<hr size=2>
<BR>























<%



rs = null;
int arabiccount3= 0;
String[] id3 = null;
String[] msisdn3 =  null;
String[] nickname3 = null;
String[] nameone = null;
String[] nametwo = null;
String[] perc = null;
String[] senttoair3 = null;

query1 = "SELECT count(*) from loveonair";
query2 = "select loveonair.AiringID,loveonair.msisdn,        (case when chatNickNames.MessageContents is not null then  chatNickNames.MessageContents else '' end )AS NickName ,                 loveonair.first, loveonair.second, loveonair.percentage,loveonair.senttoair FROM     loveonair LEFT OUTER JOIN      chatNickNames ON loveonair.MSISDN = chatNickNames.MSISDN order by  loveonair.AiringID";    
rs = con.createStatement().executeQuery(query1);            
if(rs.next()){arabiccount3 = rs.getInt(1);}
rs.close(); rs = null;
id3 = new String[arabiccount3];
msisdn3 =  new String[arabiccount3];
nickname3 = new String[arabiccount3];
nameone = new String[arabiccount3];
nametwo = new String[arabiccount3];
perc = new String[arabiccount3];
senttoair3 = new String[arabiccount3];
rs = con.createStatement().executeQuery(query2);

theCounter1 = 0;
while(rs.next())
{
 id3[theCounter1] = rs.getString(1).trim();
 msisdn3[theCounter1] =  rs.getString(2).trim();
 nickname3[theCounter1] = rs.getString(3).trim();
 nameone[theCounter1] = rs.getString(4).trim();
 nametwo[theCounter1] = rs.getString(5).trim();
 perc[theCounter1] = rs.getString(6).trim();
 senttoair3[theCounter1] = rs.getString(7).trim();
 theCounter1 = theCounter1 + 1 ;
}
rs.close();rs = null;
            
%>



<table align='center' border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#AAAAAA' width='80%'>
<tr height='25' bgcolor=#DCDCDC>
<td width='20%' align='center'><b>—”«∆· «·„Ì“«‰</b></td>
</tr>
</table>

<table align='center' border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#AAAAAA' width='80%'>

<tr height='25' bgcolor=#DCDCDC>
 <td width='100%' align='center'><b><font color='#000000' face='Arial' size='4'>⁄œœ&nbsp;&nbsp;<%=arabiccount3%></font></b></td>
</tr>
</table>


<table align='center' border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#AAAAAA' width='80%'>

<tr height='25' bgcolor=#DCDCDC>
 <td width='40%' align='right'><input type='submit' name='subApproveSMSSel' value='«·ﬂ·' style='font-weight:bold ; width:11em ; height:2em' onClick='selectall3(<%= arabiccount3 %>)'></td>
 <td width='20%' align='center'><input type='submit' name='subApproveSMSSel' value=' ⁄œÌ·' style='font-weight:bold ; width:11em ; height:2em' onClick="correctinvoke3(0)"></td>
 <td width='20%' align='center'><input type='submit' name='subDeclineSMSSel' value='„”Õ' style='font-weight:bold ; width:11em ; height:2em' onClick="correctinvoke3(1)"></td>

</tr>

</table>








  <table align='center' border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#AAAAAA' width='50%'>
                              <tr height='25' bgcolor=#DCDCDC>
                                    <td width='10%' align='center'><b>&nbsp;</b></td>

                                    <td width='10%' align='center'><b>«·«Ê·</b></td>
                                    <td width='10%' align='center'><b>«·À«‰Ì</b></td>
                                    <td width='5%' align='center'><b>‰”»Â</b></td>
                              </tr>

<form name=thisfrm3 method=post action="">
<INPUT type='hidden' NAME=count SIZE=6  READONLY value="<%= arabiccount3 %>" > 
<% for (int l =0 ; l < arabiccount3 ; l ++)
{
if(Integer.parseInt(senttoair3[l]) == 0)
{
%>        
           <tr height='25' bgcolor=#FCE3E4>

<%
}
else
{
%>
           <tr height='25' bgcolor=#E3FCF0> 
<%
}
%>
            <INPUT type='hidden' NAME=msisdn<%= l %> SIZE=6  READONLY value="<%= msisdn3[l] %>" >
            
            <INPUT type='hidden' NAME=id3_<%= l %> SIZE=6  READONLY value="<%= id3[l] %>" >
            <td width='10%' align='center'><b><INPUT id="ischeck3_<%= l %>" NAME=ischeck3_<%= l %> TYPE=CHECKBOX > </b></td>
  

            <td width='10%' align='center'> <INPUT dir='rtl' style='font-size:12pt;color:#0000AA;font-weight:bold;width:15em;height:1.7em' id="nameone<%= l %>" NAME=nameone<%= l %> value='<%= nameone[l]  %>' ></td>   	    
            <td width='10%' align='center'> <INPUT dir='rtl' style='font-size:12pt;color:#0000AA;font-weight:bold;width:15em;height:1.7em' id="nametwo<%= l %>" NAME=nametwo<%= l %> value='<%= nametwo[l]  %>' ></td>   	    
            <td width='10%' align='center'> <INPUT dir='rtl' style='font-size:12pt;color:#0000AA;font-weight:bold;width:3em;height:1.7em' id="perc<%= l %>" NAME=perc<%= l %> value=<%= perc[l]  %> ></td>   	                


      
           </tr>  
           
<%
}
%>
</form>

</table>




         
   
<BR>














</BODY>
</HTML>











<%
}
}
%>
