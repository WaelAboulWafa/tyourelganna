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
   if(thepage[k].equalsIgnoreCase("search.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
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



String theSdate =(new SimpleDateFormat("yyyyMMdd")).format(new java.util.Date((new java.util.Date()).getTime())).trim();
String theEdate =(new SimpleDateFormat("yyyyMMdd")).format(new java.util.Date((new java.util.Date()).getTime())).trim();


String searchword = "";try{searchword = request.getParameter("searchword").trim();}catch(Exception e){searchword = "";}
String searchby= "2"; try{searchby = request.getParameter("searchby").trim();}catch(Exception e){searchby = "2";}
String countries = "";try{countries = request.getParameter("countries").trim();}catch(Exception e){countries = "";}
String fdate = "";try{fdate = request.getParameter("fdate").trim();}catch(Exception e){fdate = theSdate;}
String tdate = "";try{tdate = request.getParameter("tdate").trim();}catch(Exception e){tdate = theEdate;}
String theuser = "";try{theuser = request.getParameter("theuser").trim();}catch(Exception e){theuser = "";}
String messagetatus = "";try{messagetatus = request.getParameter("messagetatus").trim();}catch(Exception e){messagetatus = "";}
String thehour = "all";try{thehour = request.getParameter("thehour").trim();}catch(Exception e){thehour = "all";}

try{searchword = (new String(searchword.getBytes("Cp1252"),"Cp1256")).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim();}catch(Exception e){}



String thequery="";
thequery= thequery + " select (case when        (CONVERT(char(10), CDRs.Update_Time, 111)+ ' '+ convert(varchar,CDRs.Update_Time, 8)) is not null then         (CONVERT(char(10), CDRs.Update_Time, 111)+ ' '+ convert(varchar,CDRs.Update_Time, 8)) else '-' end ) AS MessageUpdateTime , (CDRs.Country + '-' +  CDRs.operator+ '-' +CDRs.provider + '-'+CDRs.shortcode) as smssource, CDRs.Readable,CDRs.ApprovedContent,CDRs.MSISDN,(case when chatNickNames.MessageContents is not null then  chatNickNames.MessageContents else '-' end )AS NickName,cdrs.shortcode , (  CONVERT(char(10), CDRs.In_Time, 111) + ' ' + convert(varchar,CDRs.In_Time, 8) ) as InTime,CDRs.FilerationAgent ,CDRs.OriginatingIP ,";
thequery= thequery + " ( convert(nvarchar, (convert(int, DATEDIFF(\"ss\", (CDRs.In_Time),(CDRs.Update_Time))) /3600   ) )+ ' : ' +convert(nvarchar, (case when      convert(int, DATEDIFF(\"ss\", (CDRs.In_Time),(CDRs.Update_Time))) /3600  > 0   ";
thequery= thequery + " then     convert(int, DATEDIFF(\"mi\", (CDRs.In_Time),(CDRs.Update_Time))) / 60     else    convert(int, DATEDIFF(\"mi\", (CDRs.In_Time),(CDRs.Update_Time))) % 60 end ))+ ' : ' +convert(nvarchar, (case when      convert(int, DATEDIFF(\"mi\", (CDRs.In_Time),(CDRs.Update_Time))) /3600  > 0   ";
thequery= thequery + " then     convert(int, DATEDIFF(\"ss\", (CDRs.In_Time),(CDRs.Update_Time))) / 60     else    convert(int, DATEDIFF(\"ss\", (CDRs.In_Time),(CDRs.Update_Time))) % 60 end ))) as waittime , cdrs.status from cdrs LEFT OUTER JOIN                chatNickNames ON cdrs.MSISDN = chatNickNames.MSISDN";
thequery= thequery + " where ";

if(searchby.equalsIgnoreCase("0")){thequery= thequery + " chatNickNames.MessageContents like N'%" + searchword + "%'";}
if(searchby.equalsIgnoreCase("1")){thequery= thequery + " CDRs.Readable like N'%" + searchword + "%'";}
if(searchby.equalsIgnoreCase("2")){thequery= thequery + " CDRs.MSISDN like N'%" + searchword + "%'";}
if(searchby.equalsIgnoreCase("3")){thequery= thequery + " CDRs.ApprovedContent like N'%" + searchword + "%'";}

if(!countries.equalsIgnoreCase(""))
{thequery= thequery + " and (cdrs. Country + '-' +  cdrs.operator+ '-' +cdrs.provider + '-'+cdrs.shortcode) like N'%" + countries + "%'";}


if(fdate.length() > 0 && tdate.length() > 0)
{
thequery= thequery + " and (convert(char(10),In_Time,112) between '"+ fdate + "' and '"+ tdate + "')";
}

if(!theuser.equalsIgnoreCase(""))
{
thequery= thequery + " and CDRs.FilerationAgent like N'%"+ theuser +"%'";
}

if(messagetatus.length() > 0 )
{
//thequery= thequery + " and cdrs.status = '%"+ messagetatus +"%'";
thequery= thequery + " and cdrs.status = '"+ messagetatus +"'";
}


if(!thehour.equalsIgnoreCase("all"))
{
thequery= thequery + " and substring ((CONVERT(nvarchar, CDRs.In_Time, 111) + ' ' + convert(varchar,CDRs.In_Time, 8)),12,2) = '"+ thehour +"'";
}


thequery= thequery + " order by CDRs.id";













int THECOUNT = 0 ;
   rs = null;
   rs = con.createStatement().executeQuery(thequery); 
while(rs.next())
{
THECOUNT = THECOUNT + 1;
String messageupdatetime1 = rs.getString(1);
String smssource1 = rs.getString(2);
String readable1 = rs.getString(3);
String ApprovedContent1 = rs.getString(4);
String msisdn1 = rs.getString(5);
String nickname1 = rs.getString(6);
String shortcode1 = rs.getString(7);
String theintime1 = rs.getString(8);
String filerationagent1 = rs.getString(9);
String orgip1 = rs.getString(10);
String waittime1 = rs.getString(11);
String status1 = rs.getString(12);
}
rs.close();rs=null;   




//out.println(thequery);  
%>



<html dir=rtl>

<head>
<link rel="stylesheet" type="text/css" href="datepicker.css"/>
<script type="text/javascript" src="datepicker.js"></script>
<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000;background-color: #<%=bgcolor%>; }</style>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
<title>«·»ÕÀ ... <%= medianame %></title>
</head>

<body>

 

 

            <form action='MainPage.jsp' method='post'>
            <input type='hidden' name='uid' value='41'>
            
            <table border='1' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%' height='80'>
              <tr>
                <td width='21%' align='center'><b><i><font color='#A36103' size='6'>«·»Õ‹‹‹À</font></i></b></td>
                <td width='10%' height='100' align='center'>
                  <table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' height='100%'>
            	<tr bgcolor=#CCFFC8><td align='center' width='100%'><font size='4'>„ﬁ»Ê·Â</font></td></tr>
            	<tr bgcolor=#FFC8C8><td align='center' width='100%'><font size='4'>„—›Ê÷Â</font></td></tr>
            	<tr bgcolor=#FFFCC8><td align='center' width='100%'><font size='4'>œ«Œ·ÌÂ</font></td></tr>
        	
                  </table>
                </td>
                <td width='30%' align='center'>
                <table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%'>
                  <tr><td width='100%' align='center'><font color='#000000' face='Arial' size='4'><b> Êﬁ‹‹  «·œŒÊ·  <%= intime %> </b></font></td></tr>
      <tr><td width='100%' align='center'><font color='#000000' face='Arial' size='4'><b> &nbsp;</b></font></td></tr>
      <tr><td width='100%' align='center'><font color='#000000' face='Arial' size='4'><b>  «—Ì‹‹Œ «·œŒÊ·  <%= indate %> </b></font></td></tr>
                </table>
                </td>
                <td width='19%' align='center'>
                	<table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%'>
                		<tr align='center' ><td><input type='submit' name='subMain' value='«·ﬁ«∆„… «·—∆Ì”Ì…' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
                		</form>
            		<form action='search.jsp' method='post'>
            		<input type='hidden' name='uid' value='41'>
              		<tr align='center' ><td><input type='submit' name='subRefresh' value='«⁄«œ…  Õ„Ì·' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
                        </form> 
                	</table>
                </td>
    <td bgcolor='#ffffff' width='15%' align='center'><IMG src='logo.png'></td>
              </tr>
            </table>

<br>
			<br>
			<table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#DCDCDC' width='70%'>
			  <tr height='30'>








<form method="post">



<td width='20%' align='center'>
 <input type='text' name='searchword' value='<%= searchword %>' style='font-weight:bold;font-size:12pt;width:15em;height:1.8em'>
</td>






<td width='10%' align='center'>
<%
if(searchby.equalsIgnoreCase("1"))
{
%>
 <input type='radio' checked  name='searchby' value='1'><font size='4'>&nbsp;√’· «·—”«·Â</font>
<%
}
else
{
%>
 <input type='radio'name='searchby' value='1'><font size='4'>&nbsp;√’· «·—”«·Â</font>
<%
}
%>

</td>



<td width='10%' align='center'>
<%
if(searchby.equalsIgnoreCase("3"))
{
%>
 <input type='radio' checked  name='searchby' value='3'><font size='4'>&nbsp;«·—”«·Â «·„›· —Â</font>
<%
}
else
{
%>
 <input type='radio'name='searchby' value='3'><font size='4'>&nbsp;«·—”«·Â «·„›· —Â</font>
<%
}
%>

</td>



<td width='10%' align='center'>

<%
if(searchby.equalsIgnoreCase("2"))
{
%>
 <input type='radio' checked  name='searchby' value='2'><font size='4'>&nbsp;«· ·Ì›Ê‰</font>
<%
}
else
{
%>
 <input type='radio'  name='searchby' value='2'><font size='4'>&nbsp;«· ·Ì›Ê‰</font>
<%
}
%>


</td>














			    <td width='15%' align='center'><input type='submit' name='Searchbutton' value='»ÕÀ' style='font-weight:bold;width:8em;height:2em'></td>
			  </tr>
			</table>
			<table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#DCDCDC' width='50%'>
			 <tr>
			 <td>
			 <table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#DCDCDC' width='100%'>
			  <tr height=30>
			      <td width='25%' align='center'>

<select name='countries' style='font-weight:bold ; color:#909090'>

<option value=''>ﬂ· «·œÊ·</option>

<% 
   rs = con.createStatement().executeQuery("SELECT     country + '-' + operator + '-' + Providername + '-' + shortcode AS thesccomb FROM         Providers order by providerid");             
while(rs.next())
  {
String tempsent=  rs.getString(1);
  if(tempsent.equalsIgnoreCase(countries))
{
%> 
<option selected><%= (new String(tempsent.getBytes("Cp1252"),"Cp1256")) %></option>
<%
}
else
{
%>
<option ><%= (new String(tempsent.getBytes("Cp1252"),"Cp1256")) %></option>
<%
}  	        
}rs.close();rs=null;
%>

</select>

</td>












			    <td width='14%' align='center'>
<input type=button value=" «—ÌŒ „‰" onclick="displayDatePicker('fdate', this);">

<input  type="text" readonly name="fdate" id="idate" value='<%=fdate%>' >
                            </td>

			    <td width='2%' align='center'>&nbsp;</td>

<td width='14%' align='center'>
<input type=button value=" «—ÌŒ ≈·Ì" onclick="displayDatePicker('tdate', this);">
<input  type="text"  readonly name="tdate" id="idate" value='<%=tdate%>'>
</td>

<td width='25%' align='center'>













<select name='theuser' style='font-weight:bold ; color:#909090'>
<option value=''>ﬂ· «·„” Œœ„Ì‰</option>

<% 
   rs = con.createStatement().executeQuery("SELECT     username FROM         Users ORDER BY userID");             
while(rs.next())
  {
String tempsent=  rs.getString(1);
  if(tempsent.equalsIgnoreCase(theuser))
{
%> 
<option selected><%= (new String(tempsent.getBytes("Cp1252"),"Cp1256")) %></option>
<%
}
else
{
%>
<option ><%= (new String(tempsent.getBytes("Cp1252"),"Cp1256")) %></option>
<%
}  	        
}rs.close();rs=null;
%>


</select>
</td>








<td width='25%' align='center'>
<select name='messagetatus' style='font-weight:bold ; color:#909090'>

<option value=''>ﬂ· «·—”«∆·</option>


<%
if(messagetatus.equalsIgnoreCase("1"))
{
%>
<option selected value='1'>—”«∆· „ﬁ»Ê·…</option>
<%
}
else
{
%>
<option value='1'>—”«∆· „ﬁ»Ê·…</option>
<%
}
%>



<%
if(messagetatus.equalsIgnoreCase("-1"))
{
%>
<option selected value='-1'>—”«∆· „—›Ê÷…</option>
<%
}
else
{
%>
<option value='-1'>—”«∆· „—›Ê÷…</option>
<%
}
%>





</select>
</td>


			      <td width='25%' align='center'>
                                      <select name='thehour' style='font-weight:bold ; color:#909090'>

                                       <option value='all'>ﬂ· «·”«⁄« </option>

 





<%
if(thehour.equalsIgnoreCase("00"))
{
%>
<option selected value='00'>„‰ 0 «·Ì 1</option>
<%
}
else
{
%>
<option value='00'>„‰ 0 «·Ì 1</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("01"))
{
%>
                                       <option selected value='01'>„‰ 1 «·Ì 2</option>
<%
}
else
{
%>
                                       <option value='01'>„‰ 1 «·Ì 2</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("02"))
{
%>
                                       <option selected value='02'>„‰ 2 «·Ì 3</option>
<%
}
else
{
%>
                                       <option value='02'>„‰ 2 «·Ì 3</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("03"))
{
%>
                                       <option selected value='03'>„‰ 3 «·Ì 4</option>
<%
}
else
{
%>
                                       <option value='03'>„‰ 3 «·Ì 4</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("04"))
{
%>
                                       <option selected value='04'>„‰ 4 «·Ì 5</option>
<%
}
else
{
%>
                                       <option value='04'>„‰ 4 «·Ì 5</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("05"))
{
%>
                                       <option selected value='05'>„‰ 5 «·Ì 6</option>
<%
}
else
{
%>
                                       <option value='05'>„‰ 5 «·Ì 6</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("06"))
{
%>
                                       <option selected value='06'>„‰ 6 «·Ì 7</option>
<%
}
else
{
%>
                                       <option value='06'>„‰ 6 «·Ì 7</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("07"))
{
%>
                                       <option selected value='07'>„‰ 7 «·Ì 8</option>
<%
}
else
{
%>
                                       <option value='07'>„‰ 7 «·Ì 8</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("08"))
{
%>
                                       <option selected value='08'>„‰ 8 «·Ì 9</option>
<%
}
else
{
%>
                                       <option value='08'>„‰ 8 «·Ì 9</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("09"))
{
%>
                                       <option selected value='09'>„‰ 9 «·Ì 10</option>
<%
}
else
{
%>
                                       <option value='9'>„‰ 9 «·Ì 10</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("10"))
{
%>
                                       <option selected value='10'>„‰ 10 «·Ì 11</option>
<%
}
else
{
%>
                                       <option value='10'>„‰ 10 «·Ì 11</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("11"))
{
%>
                                       <option selected value='11'>„‰ 11 «·Ì 12</option>
<%
}
else
{
%>
                                       <option value='11'>„‰ 11 «·Ì 12</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("12"))
{
%>
                                       <option selected value='12'>„‰ 12 «·Ì 13</option>
<%
}
else
{
%>
                                       <option value='12'>„‰ 12 «·Ì 13</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("13"))
{
%>
                                       <option selected value='13'>„‰ 13 «·Ì 14</option>
<%
}
else
{
%>
                                       <option value='13'>„‰ 13 «·Ì 14</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("14"))
{
%>
                                       <option selected value='14'>„‰ 14 «·Ì 15</option>
<%
}
else
{
%>
                                       <option value='14'>„‰ 14 «·Ì 15</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("15"))
{
%>
                                       <option selected value='15'>„‰ 15 «·Ì 16</option>
<%
}
else
{
%>
                                       <option value='15'>„‰ 15 «·Ì 16</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("16"))
{
%>
                                       <option selected value='16'>„‰ 16 «·Ì 17</option>
<%
}
else
{
%>
                                       <option value='16'>„‰ 16 «·Ì 17</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("17"))
{
%>
                                       <option selected value='17'>„‰ 17 «·Ì 18</option>
<%
}
else
{
%>
                                       <option value='17'>„‰ 17 «·Ì 18</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("18"))
{
%>
                                       <option selected value='18'>„‰ 18 «·Ì 19</option>
<%
}
else
{
%>
                                       <option value='18'>„‰ 18 «·Ì 19</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("19"))
{
%>
                                       <option selected value='19'>„‰ 19 «·Ì 20</option>
<%
}
else
{
%>
                                       <option value='19'>„‰ 19 «·Ì 20</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("20"))
{
%>
                                       <option selected value='20'>„‰ 20 «·Ì 21</option>
<%
}
else
{
%>
                                       <option value='20'>„‰ 20 «·Ì 21</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("21"))
{
%>
                                       <option selected value='21'>„‰ 21 «·Ì 22</option>
<%
}
else
{
%>
                                       <option value='21'>„‰ 21 «·Ì 22</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("22"))
{
%>
                                       <option selected value='22'>„‰ 22 «·Ì 23</option>
<%
}
else
{
%>
                                       <option value='22'>„‰ 22 «·Ì 23</option>
<%
}
%>



<%
if(thehour.equalsIgnoreCase("23"))
{
%>
                                       <option selected value='23'>„‰ 23 «·Ì 24</option>
<%
}
else
{
%>
                                       <option value='23'>„‰ 23 «·Ì 24</option>
<%
}
%>









</select>
</td>

			  </tr>
			 </table>
			 </td>
			 </tr>
			</table>
			<br>	

			 <br>	
			 
			 <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#cccccc' width='100%'>
                  <tr height=30 bgcolor=#DCDCDC>
                    <td align='center'><b>«·⁄œœ</b>&nbsp;&nbsp;&nbsp;<font color=#000099><b><%= THECOUNT %></b></font></td>
 			        <td width='75%' align='center'><b>&nbsp;</b></td>                    
                  </tr>
             </table>
			 
			 
			 
      					<table border='1' align='center' cellpadding='0' cellspacing='1' style='border-collapse: collapse' bordercolor='#cccccc' width='100%'>
      					  <tr bgcolor=#DCDCDC>
      					    <td width='20%' rowspan=2 align='center'><b>√’· «·—”«·Â</b></td>
      					    <td width='20%' rowspan=2 align='center'><b>«·—”«·Â «·„›· —Â</b></td>
      					    <td width='10%' rowspan=2 align='center'><b>—ﬁ„  ·Ì›Ê‰</b></td>
      					    <td width='10%' rowspan=2 align='center'><b>«·„’œ—</b></td>
      					    <td width='15%' rowspan=2 align='center'><b>Êﬁ  «·œŒÊ·</b></td>
      					    <td width='15%' rowspan=2 align='center'><b>Êﬁ  «·›· —Â</b></td>      					    
      					    <td width='10%' rowspan=2 align='center'><b>«·„” Œœ„</b></td>
      					    <td width='10%' rowspan=2 align='center'><b>—ﬁ„ IP</b></td>
      					    <td width='8%' colspan=4 align='center'><b>«·«‰ Ÿ«—</b></td>      					    
      					  </tr>

      					  <tr bgcolor=#DCDCDC>

      					    <td width='8%' colspan=4 align='center'>
      					    
			 <table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#ffffff' width='8%'>
                  <tr >
                    <td  width='2%' align='center'>ÌÊ„&nbsp;&nbsp;</td>
                    <td  width='2%' align='center'>”«⁄Â</td>
                    <td  width='2%' align='center'>&nbsp;œﬁÌﬁÂ</td>
                    <td  width='2%' align='center'>&nbsp;À«‰ÌÂ</td>                                        
                  </tr>
             </table>
             
      					    </td>      					    
   					          					          					          					    
      					  </tr>






<%

   rs = null;
   rs = con.createStatement().executeQuery(thequery);  
while(rs.next())
{
String messageupdatetime = rs.getString(1);
String smssource = rs.getString(2);
String readable = rs.getString(3);
String approvedContent = rs.getString(4);
String msisdn = rs.getString(5);
String nickname = rs.getString(6);
String shortcode = rs.getString(7);
String theintime = rs.getString(8);
String filerationagent = rs.getString(9);
String orgip = rs.getString(10);
String waittime = rs.getString(11);
String status = rs.getString(12);


      long diffinseconds = -1;
      long diffinminiutes = -1;
      long diffinhours = -1;
      long diffindays = -1;
      long IN_TIME = -1;
      long UPDATE_TIME = -1 ;
      
      if(!theintime.equalsIgnoreCase("-") && !messageupdatetime.equalsIgnoreCase("-"))
      {
       IN_TIME= ((new SimpleDateFormat("yyyy/MM/dd HH:mm:ss")).parse(theintime)).getTime();
       UPDATE_TIME= ((new SimpleDateFormat("yyyy/MM/dd HH:mm:ss")).parse(messageupdatetime)).getTime();
       
       diffindays= ((UPDATE_TIME - IN_TIME)/1000)/(60*60*24);   
       diffinhours=  ((UPDATE_TIME - IN_TIME)/1000)/(60*60) - diffindays * 24;
       diffinminiutes=  ((UPDATE_TIME - IN_TIME)/1000)/(60) - diffindays * 24 * 60  - diffinhours * 60;      
       diffinseconds = ((UPDATE_TIME - IN_TIME)/1000)%60;
              
      }     
            
 

if( shortcode.equalsIgnoreCase("0"))
{
%>
<tr height=25 bgcolor=#FFFCC8>
<%
}
else
{
 if( !shortcode.equalsIgnoreCase("0") && status.equalsIgnoreCase("1"))
 {
%>
<tr height=25 bgcolor=#CCFFC8>
<%
 }
 else
 {
  if( !shortcode.equalsIgnoreCase("0") && status.equalsIgnoreCase("2"))
  { 
%>
<tr height=25 bgcolor=#00C8C8>
<%
  }
  else
  {
   %>
    <tr height=25 bgcolor=#FFC8C8>
   <%  
  }
 } 
}
%>






  <td width='20%' align='center'><b><%=  readable  %></b></td>
<%
if (approvedContent != null)
{
%>

  <td width='20%' align='center'><b><%=  approvedContent   %></b></td>    				    
<%
}
else
{
%>
  <td width='20%' align='center'><b>&nbsp;</b></td>    					    
<%
}
%>					    
				    
      					    
<%    	    
if(phoneallowed == 1)
{
%>
    	    <td align='center'><b><font color=#000000 size=4><%= msisdn %></font></b></td>
<%
}
else
{
%>
    	    <td align='center'><b><font color=#000000 size=4> ·«  ÊÃœ ’·«ÕÌÂ</font></b></td>
<%
}
%>     	    
       

      					    
      				
      					    
      					    
      					    
      					    <td width='10%' align='center'><b><%= smssource %></b></td>
      					    <td width='15%' align='center'><b><%= theintime %></b></td>
      					    <td width='15%' align='center'><b><%= messageupdatetime %></b></td>      					    
      					    <%
      					    if(filerationagent != null)
      					    {
      					    %>    					    
      					    <td width='10%' align='center'><b><%= (new String(filerationagent.getBytes("Cp1252"),"Cp1256")) %></b></td>
      					    <%
      					    }
      					    else
      					    {
      					    %>
      					    <td width='10%' align='center'><b><%= filerationagent %></b></td>
      					    <%
      					    }
      					    %>
      					    <td width='10%' align='center'><b><%= orgip %></b></td>
      					    
<%
if(!theintime.equalsIgnoreCase("-") && !messageupdatetime.equalsIgnoreCase("-"))
      {
%>                   
                   <td width='2%' align='center'><b><%=diffindays%></b>
<%
}
else
{
%>
                  <td width='2%' align='center'><b>-</b>
<%
}
%>


<%
if(!theintime.equalsIgnoreCase("-") && !messageupdatetime.equalsIgnoreCase("-"))
      {
%>                   
                   <td width='2%' align='center'><b><%=diffinhours%></b>
<%
}
else
{
%>
                  <td width='2%' align='center'><b>-</b>
<%
}
%>


<%
if(!theintime.equalsIgnoreCase("-") && !messageupdatetime.equalsIgnoreCase("-"))
      {
%>                   
                   <td width='2%' align='center'><b><%=diffinminiutes%></b>
<%
}
else
{
%>
                  <td width='2%' align='center'><b>-</b>
<%
}
%>


<%
if(!theintime.equalsIgnoreCase("-") && !messageupdatetime.equalsIgnoreCase("-"))
      {
%>                   
                   <td width='2%' align='center'><b><%=diffinseconds%></b>
<%
}
else
{
%>
                  <td width='2%' align='center'><b>-</b>
<%
}
%>











      					    

</tr>
<%
}
rs.close();rs=null;
%>





















</table>








</form>



<br>





</html>








<%
}
}
%>
