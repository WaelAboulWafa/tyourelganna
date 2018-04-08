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
//   if(thepage[k].equalsIgnoreCase("lowerinfo.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("instructions.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
   if(thepage[k].equalsIgnoreCase("smscount.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
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








String theSdate =(new SimpleDateFormat("yyyyMMdd")).format(new java.util.Date((new java.util.Date()).getTime())).trim();
String theEdate =(new SimpleDateFormat("yyyyMMdd")).format(new java.util.Date((new java.util.Date()).getTime())).trim();

   
 
String fdate = "";try{fdate = request.getParameter("fdate").trim();}catch(Exception e){fdate = theSdate;}
String tdate = "";try{tdate = request.getParameter("tdate").trim();}catch(Exception e){tdate = theEdate;}

   

   

             
%>





























































<html dir=rtl>

<head>
<link rel="stylesheet" type="text/css" href="datepicker.css"/>
<script type="text/javascript" src="datepicker.js"></script>
<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000;background-color: #<%=bgcolor%>; }</style>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
<title>√⁄œ«œ ... <%= medianame %></title>
</head>

<body>

 

 

<form action='MainPage.jsp' method='post'>
<input type='hidden' name='uid' value='41'>
<table border='1' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%' height='80'>
  <tr>
    <td width='21%' align='center'><b><i><font color='#A36103' size='6'>√⁄œ«œ</font></i></b></td>
    <td width='35%' align='center'>
    <table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%'>
      <tr><td width='100%' align='center'><font color='#000000' face='Arial' size='4'><b> Êﬁ‹‹  «·œŒÊ·  <%= intime %> </b></font></td></tr>
      <tr><td width='100%' align='center'><font color='#000000' face='Arial' size='4'><b> &nbsp;</b></font></td></tr>
      <tr><td width='100%' align='center'><font color='#000000' face='Arial' size='4'><b>  «—Ì‹‹Œ «·œŒÊ·  <%= indate %> </b></font></td></tr>
    </table>
    </td>
    <td width='19%' align='center'>
    	<table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%'>
    		<tr><td align='center'><input type='submit' name='subMain' value='«·ﬁ«∆„… «·—∆Ì”Ì…' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
    		
    		</form>
		<form action='smscount.jsp' method='post'>
           
    		<tr><td align='center'><input type='submit' name='subRefresh' value='«⁄«œ…  Õ„Ì·' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
    	</form>	
    	</table>
    </td>
    <td bgcolor='#FFFFFF' width='15%' align='center'><IMG src='logo.png'></td>
  </tr>
</table>
<br>


<table border='0' align='center' bgcolor=#<%=bgcolor%> cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='90%' height='40' >
  <tr>
   <td align='center'><font color=#000000 size='5'><b> ﬁ—Ì— ⁄œ«œ«  «·—”«∆· ·ﬁ‰«… &nbsp;<i><u><%= medianame %></u></i> „‰ &nbsp;&nbsp;<%=fdate.substring(0,4)%>-<%=fdate.substring(4,6)%>-<%=fdate.substring(6,8)%>&nbsp;&nbsp; «·Ì &nbsp;&nbsp;<%=tdate.substring(0,4)%>-<%=tdate.substring(4,6)%>-<%=tdate.substring(6,8)%></b></font></td>
  </tr>
 </table>

<br>

            <table border='1' align='center' bgcolor=#F9DEA9 cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='70%'>
                 <form action='smscount.jsp' method='post'>
                  <tr>
                        <td>
                              <table border='0' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                          <td width='10%' align='center'><b><input type=button value="„‰" onclick="displayDatePicker('fdate', this);"></td>
                                          <td width='20%' align='center'><input  type="text" readonly name="fdate" id="idate" value='<%=fdate%>' ></td>
                                          <td width='20%' align='center'>&nbsp;</td>
                                          <td width='10%' align='center'><b><input type=button value="≈·Ì" onclick="displayDatePicker('tdate', this);"></b></td>
                                          <td width='20%' align='center'><input  type="text"  readonly name="tdate" id="idate" value='<%=tdate%>'></td>
                                          <td width='20%' align='center'>&nbsp;</td>
                                          <td width='10%' align='right'><input type='submit' name='subReport' value=' ﬁ—Ì—' STYLE='font-weight:bold ; color:#000000; width:8em; height:2.2em'></td>
                              </table>
                        </td>
                  </tr>
                </form>
            </table>




 





 
            <table border='1' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='80%'>
                  <tr height=30>
                        <td width='15%' align='center'><font size='4'>«·œÊ·…</font></td>
                        <td width='15%' align='center'><font size='4'>‘—ﬂ… «·« ’«·« </font></td>
                        <td width='15%' align='center'><font size='4'>«·‘—ﬂ… «·Ê”Ìÿ…</font></td>
                        <td width='15%' align='center'><font size='4'>«·—ﬁ„ «·„Œ ’—</font></td>
                        <td width='40%' align='center'><font size='4'>√⁄œ«œ «·—”«∆·</font></td>
                  </tr>

<%

int thetot = 0;
   rs = null;
   rs = con.createStatement().executeQuery("select  providers.country ,  providers.operator, providers.Providername,providers.shortcode,   sum(case when cdrs.sms_length is not null then cdrs.sms_length else '0' end) as thecnt from providers LEFT OUTER JOIN       cdrs  on providers.Providername = cdrs.Provider and  providers.operator = cdrs.Operator and  providers.shortcode= cdrs.ShortCode and  providers.country = cdrs.Country     where providers.shortcode not in ('0','1')   and (convert(char(10),cdrs.In_Time,112) between '"+ fdate + "' and '"+ tdate + "') group by providers.ProviderID,providers.Providername,providers.operator,providers.shortcode,providers.country  order by providers.ProviderID");  
while(rs.next())
{
String co =rs.getString(1);
String op =rs.getString(2);
String prov = rs.getString(3);
String sc =rs.getString(4);
int thecnt = rs.getInt(5);
thetot = thetot + thecnt;
%>
			  <tr height=30 bgcolor=#ffffff>
				<td width='15%' align='center'><font size='4'><%=co%></font></td>
				<td width='15%' align='center'><font size='4'><%=op%></font></td>
				<td width='15%' align='center'><font size='4'><%=prov%></font></td>
				<td width='15%' align='center'><font size='4'><%=sc%></font></td>
				<td width='40%' align='center'><font size='4'><%=thecnt%></font></td>
			  </tr>
<%
}
%>



	</table>

	<table border='1' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='80%'>
	  <tr height=30>
	    <td width='60%' align='center'><font size='4'>«·„Ã„Ê⁄</font></td>
	    <td width='40%' align='center'><font size='4'><%=thetot%></font></td>
	  </tr>
	</table>
</body>

</html>
























<%
}
}
%>


