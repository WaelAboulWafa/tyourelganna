<%@ page contentType="text/html;charset=windows-1256"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*,AppClasses.*" %>


 

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

 

 public boolean ispageallowed(String[] thepage,String[] theright,String pagerequired)
 {

  for(int k=0;k<thepage.length;k++)
  {
    if(thepage[k].equalsIgnoreCase(pagerequired))
    {
     if(theright[k].equalsIgnoreCase("1")){return true;}  
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
//   if(thepage[k].equalsIgnoreCase("lowerinfo.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("instructions.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("smscount.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("smsdistribution.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
   if(thepage[k].equalsIgnoreCase("autorities.jsp")){if(allowed[k] == 1){allowedaccess =true;}}                           
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















//user pressed modify
if( request.getParameter("subUpdate")!=null) 
{
rs=null;
if( request.getParameter("filteration")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='filteration.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else{con.createStatement().execute("update UsersAuthorities set allowed=0 where page='filteration.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }

if( request.getParameter("filterationlove")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='filterationlove.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else{con.createStatement().execute("update UsersAuthorities set allowed=0 where page='filterationlove.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }


if( request.getParameter("smsonair")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='smsonair.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else {con.createStatement().execute("update UsersAuthorities set allowed=0 where page='smsonair.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }

if( request.getParameter("send")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='send.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else{con.createStatement().execute("update UsersAuthorities set allowed=0 where page='send.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }

if( request.getParameter("nicknames")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='nicknames.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else {con.createStatement().execute("update UsersAuthorities set allowed=0 where page='nicknames.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }

if( request.getParameter("replay")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='replay.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else  {con.createStatement().execute("update UsersAuthorities set allowed=0 where page='replay.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }

if( request.getParameter("search")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='search.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else {con.createStatement().execute("update UsersAuthorities set allowed=0 where page='search.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }




if( request.getParameter("operatorsproviders")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='operatorsproviders.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else  {con.createStatement().execute("update UsersAuthorities set allowed=0 where page='operatorsproviders.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }

if( request.getParameter("badwords")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='badwords.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else {con.createStatement().execute("update UsersAuthorities set allowed=0 where page='badwords.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }

if( request.getParameter("forbiddennumbers")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='forbiddennumbers.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else  {con.createStatement().execute("update UsersAuthorities set allowed=0 where page='forbiddennumbers.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }


if( request.getParameter("info1")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='info1.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else  {con.createStatement().execute("update UsersAuthorities set allowed=0 where page='info1.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }

if( request.getParameter("info2")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='info2.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else  {con.createStatement().execute("update UsersAuthorities set allowed=0 where page='info2.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }

if( request.getParameter("info3")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='info3.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else  {con.createStatement().execute("update UsersAuthorities set allowed=0 where page='info3.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }



if( request.getParameter("smscount")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='smscount.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else  {con.createStatement().execute("update UsersAuthorities set allowed=0 where page='smscount.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }


if( request.getParameter("smsdistribution")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='smsdistribution.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else  {con.createStatement().execute("update UsersAuthorities set allowed=0 where page='smsdistribution.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }


if( request.getParameter("smsdistributionmonthly")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='smsdistributionmonthly.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else  {con.createStatement().execute("update UsersAuthorities set allowed=0 where page='smsdistributionmonthly.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }

if( request.getParameter("msisdntrace")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='msisdntrace.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else  {con.createStatement().execute("update UsersAuthorities set allowed=0 where page='msisdntrace.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }






if( request.getParameter("autorities")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='autorities.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else  {con.createStatement().execute("update UsersAuthorities set allowed=0 where page='autorities.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }


if( request.getParameter("trustedips")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='trustedips.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else  {con.createStatement().execute("update UsersAuthorities set allowed=0 where page='trustedips.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }


if( request.getParameter("screen")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='screen.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else  {con.createStatement().execute("update UsersAuthorities set allowed=0 where page='screen.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }


if( request.getParameter("readymadesmss")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='readymadesmss.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else  {con.createStatement().execute("update UsersAuthorities set allowed=0 where page='readymadesmss.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }

if( request.getParameter("filteration_hold")!=null) {con.createStatement().execute("update UsersAuthorities set allowed=1 where page='filteration_hold.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else  {con.createStatement().execute("update UsersAuthorities set allowed=0 where page='filteration_hold.jsp' and userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }


//phone numbers
if( request.getParameter("phone")!=null) {con.createStatement().execute("update Users set phone=1 where userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }
else  {con.createStatement().execute("update Users set phone=0 where userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  }



//allowed IPs
if( request.getParameter("iplist")!=null) 
{
       con.createStatement().execute("update Users set originatingIP='" + request.getParameter("iplist") + "' where userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')");  
}



}




 

 



//user pressed add
if( request.getParameter("subAdd")!=null ) 
{
    
   int userFnd = 0;
   rs = con.createStatement().executeQuery("SELECT  count(*) as thecnt from Users where username=N'" + request.getParameter("uname").trim() +"'");             
   while(rs.next()){userFnd=rs.getInt(1);}rs.close();rs = null;
   


if(userFnd == 0 && request.getParameter("uname").trim().length() > 0 )
{
 int theID = 0; 
 String _uname = request.getParameter("uname");
 String _pword = request.getParameter("pword");
 String _oname = request.getParameter("oname");

 try{_uname = (new String(_uname.getBytes("Cp1252"),"Cp1256")).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim();}catch(Exception e){}
 try{_pword = (new String(_pword.getBytes("Cp1252"),"Cp1256")).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim();}catch(Exception e){}
 try{_oname = (new String(_oname.getBytes("Cp1252"),"Cp1256")).replaceAll("'", "''").replaceAll("\r", " ").replaceAll("\n", " ").trim();}catch(Exception e){}
 		 	
	
 
 theID=Validator.adduser(_uname, _pword, _oname);           
 
 if(theID != 0)
 {
  
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'filteration.jsp',0)");
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'filterationlove.jsp',0)");  
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'smsonair.jsp',0)");  
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'send.jsp',0)"); 
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'nicknames.jsp',0)"); 
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'replay.jsp',0)");     
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'search.jsp',0)"); 
 
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'operatorsproviders.jsp',0)"); 
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'badwords.jsp',0)"); 
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'forbiddennumbers.jsp',0)");   
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'info1.jsp',0)"); 
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'info2.jsp',0)");   
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'info3.jsp',0)");   
    
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'smscount.jsp',0)"); 
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'smsdistribution.jsp',0)"); 
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'smsdistributionmonthly.jsp',0)"); 
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'msisdntrace.jsp',0)"); 
 
 
 
 
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'autorities.jsp',0)"); 
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'trustedips.jsp',0)");   
     
  con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'screen.jsp',0)");  
    
   con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'readymadesmss.jsp',0)");  
   
   con.createStatement().execute("insert into  UsersAuthorities(userid, page, allowed) values("+ theID  + ",'filteration_hold.jsp',0)");  
 
 
 }
} 
 


}



///user pressed delete
if( request.getParameter("subDelete")!=null) 
{
//oname
//uname
//pword
con.createStatement().execute("delete from Users where username =N'"+ request.getParameter("uname") + "'"); 
con.createStatement().execute("delete from UsersAuthorities where userid=(select userid from users where username=N'"+ request.getParameter("uname") + "')"); 

}





///user pressed update password
if( request.getParameter("subpasswordupdate")!=null) 
{
//oname
//uname
//pword
Validator.setpwd( request.getParameter("uname") , request.getParameter("pword"));
//out.println(t_query);
//con.createStatement().execute("update Users set password=N'" + Validator.setpwd(request.getParameter("uname"),request.getParameter("pword")) + "' where username =N'"+ request.getParameter("uname") + "'"); 

}



///user pressed release Msg
if( request.getParameter("subReleaseMsg")!=null) 
{
con.createStatement().execute("update NewSMS set hold=0 where hold=(select userid from users where username=N'"+ request.getParameter("uname") + "')"); 

}








///////////////THE Users

/// -------------------
int theuserscount = 0;
String[] theuserid = null;
String[] theusername = null;

String[] thedescrption = null;
String[] phoneallowed = null;

rs = con.createStatement().executeQuery("SELECT count(*) from Users");            
if(rs.next()){theuserscount = rs.getInt(1);}rs.close(); rs = null;
rs = con.createStatement().executeQuery("SELECT     userID, username, description,phone FROM         Users ORDER BY userID");

theuserid = new String[theuserscount];
theusername = new String[theuserscount];

thedescrption = new String[theuserscount];
phoneallowed = new String[theuserscount];
   
int theCounterrr1 = 0;
   while(rs.next())
    {
         theuserid[theCounterrr1] = rs.getString(1);
         theusername[theCounterrr1] = rs.getString(2);
         thedescrption[theCounterrr1] = rs.getString(3);
         phoneallowed[theCounterrr1] = rs.getString(4);         
         
        theCounterrr1 = theCounterrr1 + 1 ;
   }
   rs.close(); 
   rs = null;
/// ------------------




String filteusername = "";
if( request.getParameter("filteusername")!=null) 
{
  filteusername = request.getParameter("filteusername");
}
///-----------------------------------


             



















%>







<html dir='rtl'>

<head>
<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000;background-color: #<%=bgcolor%>; }</style>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
<title>„” Œœ„Ì‰ ... <%= medianame %></title>
</head>

<body>

 

 

<form action='MainPage.jsp' method='post'>
<input type='hidden' name='uid' value='41'>
<input type='hidden' name='cur_page' value=''>
<table border='1' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%' height='80'>
  <tr>
    <td width='21%' align='center'><b><i><font color='#A36103' size='6'>„” Œœ„Ì‰</font></i></b></td>
    <td width='35%' align='center'>
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
			<form action='autorities.jsp' method='post'>

    		<tr align='center' ><td><input type='submit' name='subRefresh' value='«⁄«œ…  Õ„Ì·' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
    	</table>
    </td>
    <td bgcolor='#FFFFFF' width='15%' align='center'><IMG src='logo.png'></td>
  </tr>
</table>


<br>
		<table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='60%'>
		  <tr>
		    <td width='30%' height='170' align='center' valign='top'>


<select name='filteusername' size='8' style='font-family:arial black; font-style:bold; font-size:16; color:#000 ;background:#DCDCDC;width:12em' onChange='javascript:this.form.submit();'>


<% 
for (int l =0  ; l < theuserid.length ; l ++)
{
  if (theusername[l].equalsIgnoreCase(filteusername)) 
  {
  
%>
    	        <option selected><%=  theusername[l]  %></option>       	        
<%
  }
  else
  {
%>       	        
    	        <option ><%=  theusername[l]  %></option>
<%
  }    	        
}
%> 


</select>








		    </td>
		    <td width='55%' height='200' rowspan='2'>
		    <table border='1' bgcolor=#DCDCDC align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='90%'>

<%
   int accuid=0;
   String accountowner="";
   String accusername="";
   String accpassword="";
   String accphone="";   
   String accip="";  
   

   rs = null;
   rs = con.createStatement().executeQuery("SELECT    top 1  userid,username, description,phone,originatingIP  FROM Users  where username=N'"+filteusername+"' order by userID");  
   while(rs.next())
   {
        accuid=rs.getInt(1);
        accusername=rs.getString(2);
//        try{accpassword = Validator.getpwd(accuid);}catch(Exception e){}
        accpassword="";
        accountowner=rs.getString(3);
        accphone=rs.getString(4);
        accip=rs.getString(5);
   }rs.close();rs=null;
%>

		      <tr>
		        <td width='50%' align='center' height='30'><b>«”„ ’«Õ» «·Õ”«»</b></td>

				<td width='50%' align='center' height='30'><input type='text' name='oname' value='<%= accountowner %>' style='width:14em' size='20'></td>

				
		      </tr>
		      <tr>
		        <td width='50%' align='center' height='30'><b>«”„ «·„” Œœ„</b></td>


				<td width='50%' align='center' height='30'><input type='text' name='uname' value='<%= accusername %>' style='width:14em' size='20'></td>


		        

				
		      </tr>
		      <tr>
		        <td width='50%' align='center' height='30'><b>ﬂ·„… «·„—Ê—</b></td>

				<td width='50%' align='center' height='30'><input type='password' name='pword' value='<%= accpassword %>' style='width:14em' size='20'></td>		        

				
				
		      </tr>

		      <tr>
		        <td width='50%' align='center' height='30'><font color='#000000' size='3'><b>«—ﬁ«„ «·ÂÊ« ›</b></font></td>
		        



<% 
if(accphone.equalsIgnoreCase("1"))
{
%>

<%
 if(filteusername.equalsIgnoreCase("admin"))
{
%>			        
             <td width='50%' align='center' height='30'><input disabled type='checkbox' name='phone' value='1' CHECKED></td>
<%
}
else
{
%>
             <td width='50%' align='center' height='30'><input type='checkbox' name='phone' value='1' CHECKED></td>
<%
}
%>



             
             
<%
}
else
{
%>

<%
 if(filteusername.equalsIgnoreCase("admin"))
{
%>			        
             <td width='50%' align='center' height='30'><input disabled type='checkbox' name='phone' value='0'></td>
<%
}
else
{
%>
             <td width='50%' align='center' height='30'><input type='checkbox' name='phone' value='0'></td>
<%
}
%>




             
             
<%
}
%>




		      </tr>


		<tr>
		 <td width='50%' align='center' height='30'><font color='#000000' size='3'> <b>„’œ—</b></font></td>
			<td width='50%' height=30 align='center'>
<%
if(accip.equalsIgnoreCase("any"))
{
%>			


<%
 if(filteusername.equalsIgnoreCase("admin"))
{
%>			        
			 <input disabled type='radio' checked  name='iplist' value='any'><font size='3'>&nbsp;«Ì „ﬂ«‰</font>
			 <input disabled type='radio'  name='iplist' value='list'><font size='3'>&nbsp;„Ã„Ê⁄… IP</font>
<%
}
else
{
%>
			 <input type='radio' checked  name='iplist' value='any'><font size='3'>&nbsp;«Ì „ﬂ«‰</font>
			 <input type='radio'  name='iplist' value='list'><font size='3'>&nbsp;„Ã„Ê⁄… IP</font>
<%
}
%>


			 
			 
			 
			 
<%
}
else
{
	
%>

	        
			 <input  type='radio'   name='iplist' value='any'><font size='3'>&nbsp;«Ì „ﬂ«‰</font>
			 <input  type='radio' checked name='iplist' value='list'><font size='3'>&nbsp;„Ã„Ê⁄… IP</font>
<%

}
%>




			 
			 
			 
		 
			 
			</td>
		</tr>



		    </table>
		    <br>
		    <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='60%' height='17'>
		      <tr>


		        
<%
 if(filteusername.equalsIgnoreCase("admin"))
{
%>		      
		        <td width='33%' height='30'><input type='submit' name='subAdd' value='«÷«›…' style='font-weight:bold ; width:6em ; height:2.2em'></td>
		        <td width='34%' height='30'><input type='submit' disabled name='subDelete' value='Õ–›' style='font-weight:bold ; width:6em ; height:2.2em'></td>
		        <td width='33%' height='30'><input type='submit' disabled name='subUpdate' value=' ⁄œÌ· ’·«ÕÌ« ' style='font-weight:bold ; width:8em ; height:2.2em'></td>		        
		        
		        <td width='34%' height='30'><input type='submit' name='subpasswordupdate' value=' ⁄œÌ· ﬂ·„… «·„—Ê—' style='font-weight:bold ; width:10em ; height:2.2em'></td>		        		        
		        
		        
		        <td width='33%' height='30'><input type='submit' name='subReleaseMsg' value=' Õ—Ì— Ã„Ì⁄ «·—”«∆·' style='font-weight:bold ; width:8em ; height:2.2em'></td>		        		        
		        		        

<%
}
else
{
%>
		        <td width='33%' height='30'><input type='submit' name='subAdd' value='«÷«›…' style='font-weight:bold ; width:6em ; height:2.2em'></td>
		        <td width='34%' height='30'><input type='submit' name='subDelete' value='Õ–›' style='font-weight:bold ; width:6em ; height:2.2em'></td>
		        <td width='33%' height='30'><input type='submit' name='subUpdate' value=' ⁄œÌ· ’·«ÕÌ« ' style='font-weight:bold ; width:8em ; height:2.2em'></td>		        		        
		        
		        <td width='34%' height='30'><input type='submit' name='subpasswordupdate' value=' ⁄œÌ· ﬂ·„… «·„—Ê—' style='font-weight:bold ; width:10em ; height:2.2em'></td>		        		        
		        
		        
		        <td width='33%' height='30'><input type='submit' name='subReleaseMsg' value=' Õ—Ì— Ã„Ì⁄ «·—”«∆·' style='font-weight:bold ; width:8em ; height:2.2em'></td>		        		        
		        
<%
}
%>

		        
		        
		        
		        
		        
		        

		        
		        
		        
		        

		        
		        

		      </tr>
		    </table>
		    <br>
		    </td>
		  </tr>
		</table>

<br>








<%
 if(!filteusername.equalsIgnoreCase("admin"))
{
%>		      






<%
   int autoritiescount = 0;
   rs = con.createStatement().executeQuery("select count(*) from UsersAuthorities where userid=(select userid from users where username=N'"+filteusername+"')");  
   while(rs.next()){autoritiescount = rs.getInt(1);}rs.close();rs=null;
   
   String[] thepages = new String[autoritiescount];
   String[] isallowed = new String[autoritiescount];
   
   int ttt =0;
   rs = con.createStatement().executeQuery("select page, allowed from UsersAuthorities where userid=(select userid from users where username=N'"+filteusername+"')");  
   while(rs.next()){thepages[ttt]=rs.getString(1);isallowed[ttt]=rs.getString(2);ttt=ttt+1;}rs.close();rs=null;
%>



		<table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='95%'>
			<tr>

				<td width='25%' valign='top'>

				    <table align='center' border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='60%'>
				      <tr bgcolor=#646464><td width='100%' colspan='1' align='center' height='30'><b><font size='4' color=white>«·—”«∆· «·ﬁ’Ì—Â</font></b></td></tr>














<% 
if(ispageallowed(thepages,isallowed,"filteration_hold.jsp") )
{
%>
<tr><td width='25%' bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='filteration_hold' value='1' CHECKED>&nbsp;<b><font size='3'>—”«∆· ›Ì «·«‰ Ÿ«—</font></b></td></tr>
<%
}
else
{
%>
<tr><td width='25%' bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='filteration_hold' value='0' >&nbsp;<b><font size='3'>—”«∆· ›Ì «·«‰ Ÿ«—</font></b></td></tr>
<%
}
%>



<% 
if(ispageallowed(thepages,isallowed,"filteration.jsp") )
{
%>
<tr><td width='25%' bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='filteration' value='1' CHECKED>&nbsp;<b><font size='3'>„ «»⁄… «·—”«∆·</font></b></td></tr>
<%
}
else
{
%>
<tr><td width='25%' bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='filteration' value='0' >&nbsp;<b><font size='3'>„ «»⁄… «·—”«∆·</font></b></td></tr>
<%
}
%>




<% 
if(ispageallowed(thepages,isallowed,"filterationlove.jsp") )
{
%>
<tr><td width='25%' bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='filterationlove' value='1' CHECKED>&nbsp;<b><font size='3'>„ «»⁄… «·„Ì“«‰</font></b></td></tr>
<%
}
else
{
%>
<tr><td width='25%' bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='filterationlove' value='0' >&nbsp;<b><font size='3'>„ «»⁄… «·„Ì“«‰</font></b></td></tr>
<%
}
%>








<% 
if(ispageallowed(thepages,isallowed,"smsonair.jsp") )
{
%>
                      <tr><td width='25%' bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='smsonair' value='1' CHECKED>&nbsp;<b><font size='3'>&nbsp;—”«∆· ⁄·Ï «·‘«‘…</font></b></td></tr>
<%
}
else
{
%>
                      <tr><td width='25%' bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='smsonair' value='0' >&nbsp;<b><font size='3'>&nbsp;—”«∆· ⁄·Ï «·‘«‘…</font></b></td></tr>
<%
}
%>










<% 
if(ispageallowed(thepages,isallowed,"send.jsp") )
{
%>
                      <tr><td width='25%' bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='send' value='1' CHECKED>&nbsp;<b><font size='3'>&nbsp;—”«·Â œ«Œ·ÌÂ</font></b></td></tr>
<%
}
else
{
%>
                      <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='send' value='0' >&nbsp;<b><font size='3'>&nbsp;—”«·Â œ«Œ·ÌÂ</font></b></td></tr>
<%
}
%>









<% 
if(ispageallowed(thepages,isallowed,"nicknames.jsp") )
{
%>
                      <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='nicknames' value='1' CHECKED>&nbsp;<b><font size='3'>&nbsp;«·«”„«¡ «·„” ⁄«—Â</font></b></td></tr>
<%
}
else
{
%>
                      <tr><td width='25%' bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='nicknames' value='0' >&nbsp;<b><font size='3'>&nbsp;«·«”„«¡ «·„” ⁄«—Â</font></b></td></tr>
<%
}
%>







<% 
if(ispageallowed(thepages,isallowed,"replay.jsp") )
{
%>
                      <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='replay' value='1' CHECKED>&nbsp;<b><font size='3'>&nbsp;≈⁄«œÂ</font></b></td></tr>
<%
}
else
{
%>
                      <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='replay' value='0' >&nbsp;<b><font size='3'>&nbsp;≈⁄«œÂ</font></b></td></tr>
<%
}
%>









<% 
if(ispageallowed(thepages,isallowed,"readymadesmss.jsp") )
{
%>
                      <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='readymadesmss' value='1' CHECKED>&nbsp;<b><font size='3'>&nbsp;—«”«∆· Ã«Â“Â</font></b></td></tr>
<%
}
else
{
%>
                      <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='readymadesmss' value='0' >&nbsp;<b><font size='3'>&nbsp;—«”«∆· Ã«Â“Â</font></b></td></tr>
<%
}
%>


























<% 
if(ispageallowed(thepages,isallowed,"search.jsp") )
{
%>
                      <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='search' value='1' CHECKED>&nbsp;<b><font size='3'>&nbsp;«·»ÕÀ</font></b></td></tr>
<%
}
else
{
%>
                      <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='search' value='0' >&nbsp;<b><font size='3'>&nbsp;«·»ÕÀ</font></b></td></tr>
<%
}
%>











                    </table>
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    

				</td>
				
				
				



				<td width='25%' valign='top'>

				    <table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='60%'>
				      <tr bgcolor=#646464><td width='100%' colspan='1' align='center' height='30'><b><font size='4' color=white> ‰ÊÌÂ« </font></b></td></tr>






<% 
if(ispageallowed(thepages,isallowed,"info1.jsp") )
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='info1' value='1' CHECKED>&nbsp;<b><font size='3'>&nbsp; ‰ÊÌÂ«  1</font></b></td></tr>
<%
}
else
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='info1' value='0' >&nbsp;<b><font size='3'>&nbsp; ‰ÊÌÂ«  1</font></b></td></tr>
<%
}
%>




<% 
if(ispageallowed(thepages,isallowed,"info2.jsp") )
{
%>
                              <tr><td width='25%' bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='info2' value='1' CHECKED>&nbsp;<b><font size='3'>&nbsp; ‰ÊÌÂ«  2</font></b></td></tr>
<%
}
else
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='info2' value='0' >&nbsp;<b><font size='3'>&nbsp; ‰ÊÌÂ«  2</font></b></td></tr>
<%
}
%>





<% 
if(ispageallowed(thepages,isallowed,"info3.jsp") )
{
%>
                              <tr><td width='25%' bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='info3' value='1' CHECKED>&nbsp;<b><font size='3'>&nbsp; ‰ÊÌÂ«  3</font></b></td></tr>
<%
}
else
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='info3' value='0' >&nbsp;<b><font size='3'>&nbsp; ‰ÊÌÂ«  3</font></b></td></tr>
<%
}
%>







				    </table>

				</td>
			
				
				
				
				
				
				
				
				
				

				<td width='25%' valign='top'>
				    <!-- ........................ Entry Table .................... -->
				    <table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='60%'>
				      <tr bgcolor=#646464><td width='100%' colspan='1' align='center' height='30'><b><font size='4' color=white>÷»ÿ</font></b></td></tr>










<% 
if(ispageallowed(thepages,isallowed,"operatorsproviders.jsp") )
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='operatorsproviders' value='1' CHECKED>&nbsp;<b><font size='3'>&nbsp;‘—ﬂ«  «·« ’«·« </font></b></td></tr>
<%
}
else
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='operatorsproviders' value='0' >&nbsp;<b><font size='3'>&nbsp;‘—ﬂ«  «·« ’«·« </font></b></td></tr>
<%
}
%>













<% 
if(ispageallowed(thepages,isallowed,"badwords.jsp") )
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='badwords' value='1' CHECKED>&nbsp;<b><font size='3'>&nbsp;ﬁ«„Ê” «·„„‰Ê⁄« </font></b></td></tr>
<%
}
else
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='badwords' value='0' >&nbsp;<b><font size='3'>&nbsp;ﬁ«„Ê” «·„„‰Ê⁄« </font></b></td></tr>
<%
}
%>







<% 
if(ispageallowed(thepages,isallowed,"forbiddennumbers.jsp") )
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='forbiddennumbers' value='1' CHECKED>&nbsp;<b><font size='3'>&nbsp;«·«—ﬁ«„ «·„ÕŸÊ—Â</font></b></td></tr>
<%
}
else
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='forbiddennumbers' value='0' >&nbsp;<b><font size='3'>&nbsp;«·«—ﬁ«„ «·„ÕŸÊ—Â</font></b></td></tr>
<%
}
%>









<% 
if(ispageallowed(thepages,isallowed,"autorities.jsp") )
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='autorities' value='1' CHECKED>&nbsp;<b><font size='3'>&nbsp;„” Œœ„Ì‰</font></b></td></tr>
<%
}
else
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='autorities' value='0' >&nbsp;<b><font size='3'>&nbsp;„” Œœ„Ì‰</font></b></td></tr>
<%
}
%>





<% 
if(ispageallowed(thepages,isallowed,"trustedips.jsp") )
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='trustedips' value='1' CHECKED>&nbsp;<b><font size='3'>&nbsp;„Ã„Ê⁄… IP</font></b></td></tr>
<%
}
else
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='trustedips' value='0' >&nbsp;<b><font size='3'>&nbsp;„Ã„Ê⁄… IP</font></b></td></tr>
<%
}
%>




<% 
if(ispageallowed(thepages,isallowed,"screen.jsp") )
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='screen' value='1' CHECKED>&nbsp;<b><font size='3'>&nbsp;«·‘«‘Â</font></b></td></tr>
<%
}
else
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='screen' value='0' >&nbsp;<b><font size='3'>&nbsp;«·‘«‘Â</font></b></td></tr>
<%
}
%>




















				    </table>

				</td>

				</td>

				<td width='25%' valign='top'>
				    <!-- ........................ Reports Table .................... -->
				    <table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='60%'>
				      <tr bgcolor=#646464><td width='100%' colspan='1' align='center' height='30'><b><font size='4' color=white> ﬁ«—Ì— «·—”«∆·</font></b></td></tr>




<% 
if(ispageallowed(thepages,isallowed,"smscount.jsp") )
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='smscount' value='1' CHECKED>&nbsp;<b><font size='3'>&nbsp;√⁄‹œ«œ</font></b></td></tr>
<%
}
else
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='smscount' value='0' >&nbsp;<b><font size='3'>&nbsp;√⁄‹œ«œ</font></b></td></tr>
<%
}
%>










<% 
if(ispageallowed(thepages,isallowed,"smsdistribution.jsp") )
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='smsdistribution' value='1' CHECKED>&nbsp;<b><font size='3'>&nbsp; Ê“Ì⁄ ÌÊ„Ì</font></b></td></tr>
<%
}
else
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='smsdistribution' value='0' >&nbsp;<b><font size='3'>&nbsp; Ê“Ì⁄ ÌÊ„Ì</font></b></td></tr>
<%
}
%>







<% 
if(ispageallowed(thepages,isallowed,"smsdistributionmonthly.jsp") )
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='smsdistributionmonthly' value='1' CHECKED>&nbsp;<b><font size='3'>&nbsp; Ê“Ì⁄ ‘Â—Ì</font></b></td></tr>
<%
}
else
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='smsdistributionmonthly' value='0' >&nbsp;<b><font size='3'>&nbsp; Ê“Ì⁄ ‘Â—Ì</font></b></td></tr>
<%
}
%>





<% 
if(ispageallowed(thepages,isallowed,"msisdntrace.jsp") )
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='msisdntrace' value='1' CHECKED>&nbsp;<b><font size='3'>&nbsp;«·—«”·</font></b></td></tr>
<%
}
else
{
%>
                              <tr><td width='25%'  bgcolor=#DCDCDC>&nbsp;<input type='checkbox' name='msisdntrace' value='0' >&nbsp;<b><font size='3'>&nbsp;«·—«”·</font></b></td></tr>
<%
}
%>







				    </table>


			</tr>
		</table>
		</form>

<%
}
%>


<br>
		
</body>

</html>























<%
}
}
%>




