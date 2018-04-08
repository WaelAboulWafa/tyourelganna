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
//   if(thepage[k].equalsIgnoreCase("operatorsproviders.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("upperinfo.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("lowerinfo.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("instructions.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
   if(thepage[k].equalsIgnoreCase("smscountaccounting.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
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

   

   
   
   
   
   
   

/*
int thecountrecords=0;
int theTOTALcnt = 0;
int theTOTALrevenu = 0 ;
int theTOTALmediashare = 0;

   rs = null;
   rs = con.createStatement().executeQuery("select   sum(case when cdrs.sms_length is not null then cdrs.sms_length else '0' end) as TotalCount , convert(nvarchar, ROUND(convert(float,(sum(case when cdrs.sms_length is not null then (cdrs.sms_length * Providers.Tarrif) else '0' end))),2) ) as TotalRevenue , convert(nvarchar,  ROUND(convert(float,(sum(case when cdrs.sms_length is not null then (cdrs.sms_length * Mediashare) else '0' end))),2) ) as TheMediaShare  from  providers LEFT OUTER JOIN   cdrs  on providers.Providername = cdrs.Provider and  providers.operator = cdrs.Operator  and  providers.shortcode= cdrs.ShortCode and  providers.country = cdrs.Country     where providers.providerid not in ('0','-1') and (convert(char(10),cdrs.In_Time,112) between '"+ fdate + "' and '"+ tdate + "')");  
while(rs.next())
{
 thecountrecords =1;
 theTOTALcnt = rs.getInt(1);theTOTALrevenu= rs.getInt(2); theTOTALmediashare =rs.getInt(3);
}
rs.close();rs=null;   
*/
             
             
             
int thecountrecords=0;
int theTOTALcnt = 0;
double theTOTALrevenu = 0.00 ;
double theTOTALmediashare = 0.00;

   rs = null;
   rs = con.createStatement().executeQuery("select   sum(case when cdrs.sms_length is not null then cdrs.sms_length else '0' end) as TotalCount , convert(nvarchar, ROUND(convert(float,(sum(case when cdrs.sms_length is not null then (cdrs.sms_length * Providers.Tarrif) else '0' end))),2) ) as TotalRevenue , convert(nvarchar,  ROUND(convert(float,(sum(case when cdrs.sms_length is not null then (cdrs.sms_length * Mediashare) else '0' end))),2) ) as TheMediaShare  from  providers LEFT OUTER JOIN   cdrs  on providers.Providername = cdrs.Provider and  providers.operator = cdrs.Operator  and  providers.shortcode= cdrs.ShortCode and  providers.country = cdrs.Country     where providers.providerid not in ('0','-1') and (convert(char(10),cdrs.In_Time,112) between '"+ fdate + "' and '"+ tdate + "')");  
while(rs.next())
{
 thecountrecords =1;
 theTOTALcnt = rs.getInt(1); theTOTALrevenu=  rs.getDouble(2); theTOTALmediashare = rs.getDouble(3);
}
rs.close();rs=null;   





%>





























































<html dir=rtl>

<head>


<script LANGUAGE="JavaScript" type="text/javascript">

function correctinvoke(target)
{
if(target == 1) {document.tosheet.action="SavetoExcel.jsp";document.tosheet.submit();}
}
</script>


<link rel="stylesheet" type="text/css" href="datepicker.css"/>
<script type="text/javascript" src="datepicker.js"></script>
<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000;background-color: #<%=bgcolor%>; }</style>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
<title>«·Õ”«»«  ...<%=medianame%></title>
</head>

<body>

 

 

<form action='MainPage.jsp' method='post'>
<input type='hidden' name='uid' value='41'>
<table border='1' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%' height='80'>
  <tr>
    <td width='21%' align='center'><b><i><font color='#A36103' size='6'>«·Õ”«»« </font></i></b></td>
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
		<form action='smscountaccounting.jsp' method='post'>
		<input type='hidden' name='uid' value='41'>
            
    		<tr><td align='center'><input type='submit' name='subRefresh' value='«⁄«œ…  Õ„Ì·' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
    	</table>
    </td>
    <td bgcolor='#FFFFFF' width='15%' align='center'><IMG src='logo.png'></td>
  </tr>
</table>
<br>
            <table border='1' align='center' bgcolor=#F9DEA9 cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='70%'>
                  <tr>
                        <td>
                              <table border='0' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                          <td width='10%' align='center'><b><input type=button value=" «—ÌŒ „‰" onclick="displayDatePicker('fdate', this);"></td>
                                          <td width='20%' align='center'><input  type="text" readonly name="fdate" id="idate" value='<%=fdate%>' ></td>
                                          <td width='10%' align='center'>&nbsp;</td>
                                          <td width='10%' align='center'><b><input type=button value=" «—ÌŒ ≈·Ì" onclick="displayDatePicker('tdate', this);"></b></td>
                                          <td width='20%' align='center'><input  type="text"  readonly name="tdate" id="idate" value='<%=tdate%>'></td>
                                          <td width='20%' align='center'>&nbsp;</td>
                                          <td width='10%' align='right'><input type='submit' name='subReport' value=' ﬁ—Ì—' STYLE='font-weight:bold ; color:#000000; width:8em; height:3em'></td>
                              </table>
                        </td>
                  </tr>
            </table>


            </form>







<br>


<table border='0' align='center' bgcolor=#<%=bgcolor%> cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='90%' height='40' >
  <tr>
   <td align='center'><font color=#000000 size='5'><b>«· ﬁ—Ì— «·„Õ«”»Ì ·ﬁ‰«… &nbsp;<i><u><%=medianame%></u></i> „‰ &nbsp;&nbsp;<%=fdate.substring(0,4)%>-<%=fdate.substring(4,6)%>-<%=fdate.substring(6,8)%>&nbsp;&nbsp; «·Ì &nbsp;&nbsp;<%=tdate.substring(0,4)%>-<%=tdate.substring(4,6)%>-<%=tdate.substring(6,8)%></b></font></td>
  </tr>
 </table>
<br>



<table border='1' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='90%' height='40' >
  <tr>
    <td width='15%' height='40' align='center'><font color='#000000' size='5' ><font color='#000000' face='Arial' size='4'><b>«·‘—ﬂ… «·Ê”Ìÿ…</b></font></td>  
     
    <td width='25%' colspan=2 height='40' align='center'><font color='#000000' face='Arial' size='4'><b>«⁄œ«œ «·—”«∆·</b></font></td>     

           
    <td width='25%' colspan=2  height='40' align='center'><font face='Arial' color='#000000' size='4' ><b>«Ã„«·Ì «·«—«œ«  »«·œÊ·«—</b></font></td>    

        
    <td width='25%'  colspan=2  height='40' align='center'><font face='Arial' color='#000000' size='4' ><b>Õ’… «·ﬁ‰«Â »«·œÊ·«—</b></font></td>

    
    
  </tr>
  
  
  
  

<%	    
   rs = null;
   rs = con.createStatement().executeQuery("select  providers.Providername, convert(int,(sum(case when cdrs.sms_length is not null then cdrs.sms_length else '0' end))) as TotalCount , convert(nvarchar, ROUND(convert(float,(sum(case when cdrs.sms_length is not null then (cdrs.sms_length * Providers.Tarrif) else '0' end))),2) ) as TotalRevenue , convert(nvarchar,  ROUND(convert(float,(sum(case when cdrs.sms_length is not null then (cdrs.sms_length * Mediashare) else '0' end))),2) ) as TheMediaShare  from  providers LEFT OUTER JOIN   cdrs  on providers.Providername = cdrs.Provider and  providers.operator = cdrs.Operator  and  providers.shortcode= cdrs.ShortCode and  providers.country = cdrs.Country     where providers.providerid not in ('0','-1') and (convert(char(10),cdrs.In_Time,112) between '"+ fdate + "' and '"+ tdate + "') group by providers.Providername order by providers.Providername");  
while(rs.next())
{
String theprv = rs.getString(1);String TCount = rs.getString(2); String TRevenu = rs.getString(3); String tmshare =rs.getString(4);
if(theprv == null){theprv="-";} if(TCount == null){TCount="-";} if(TRevenu == null){TRevenu="-";} if(tmshare == null){tmshare="-";}
%>	    
 <tr>
	    <td width='15%' height='30' align='center'><font color='#000000' size='4'><b><%=theprv%></b></font></td>
	    
	    <td width='16%' height='30' align='center'><font color='#000000' size='4'><%=TCount%></font></td>	    
<%
if(theTOTALcnt != 0)
{

%>
   <td width='9%' height='30' align='center'><font color='#000000' size='4'><%= new Double((new DecimalFormat( "#,###,###,##0.00" )).format(((double)(Integer.parseInt(TCount)*100) /(double)theTOTALcnt))).doubleValue() %>&nbsp;&nbsp;%</font></td>
<%
}
else
{
%>
   <td width='9%' height='30' align='center'><font color='#000000' size='4'>0&nbsp;&nbsp;%</font></td>

<%
}
%>





	    
	    
		<td width='16%' height='30' align='center'><font color='#000000'size='4'><%=TRevenu%></font></td>	    
		
		
<%
if(theTOTALrevenu != 0)
{

%>
   <td width='9%' height='30' align='center'><font color='#000000' size='4'><%= new Double((new DecimalFormat( "#,###,###,##0.00" )).format(((double)(new Double(TRevenu)*100) /(double)theTOTALrevenu))).doubleValue() %>&nbsp;&nbsp;%</font></td>
<%
}
else
{
%>
   <td width='9%' height='30' align='center'><font color='#000000' size='4'>0&nbsp;&nbsp;%</font></td>

<%
}
%>

		


		
		<td width='16%' height='30' align='center'><font color='#000000'size='4'><%=tmshare%></font></td>
		
		
<%
if(theTOTALmediashare != 0)
{

%>
   <td width='9%' height='30' align='center'><font color='#000000' size='4'><%= new Double((new DecimalFormat( "#,###,###,##0.00" )).format(((double)(new Double(tmshare)*100) /(double)theTOTALmediashare))).doubleValue() %>&nbsp;&nbsp;%</font></td>
<%
}
else
{
%>
   <td width='9%' height='30' align='center'><font color='#000000' size='4'>0&nbsp;&nbsp;%</font></td>

<%
}
%>


		

 </tr>
	
<%

}
%>		



<%	    
   rs = null;
   rs = con.createStatement().executeQuery("select   sum(case when cdrs.sms_length is not null then cdrs.sms_length else '0' end) as TotalCount , convert(nvarchar, ROUND(convert(float,(sum(case when cdrs.sms_length is not null then (cdrs.sms_length * Providers.Tarrif) else '0' end))),2) ) as TotalRevenue , convert(nvarchar,  ROUND(convert(float,(sum(case when cdrs.sms_length is not null then (cdrs.sms_length * Mediashare) else '0' end))),2) ) as TheMediaShare  from  providers LEFT OUTER JOIN   cdrs  on providers.Providername = cdrs.Provider and  providers.operator = cdrs.Operator  and  providers.shortcode= cdrs.ShortCode and  providers.country = cdrs.Country     where providers.providerid not in ('0','-1') and (convert(char(10),cdrs.In_Time,112) between '"+ fdate + "' and '"+ tdate + "')");  
while(rs.next())
{
int tcnt1 = rs.getInt(1);String trev1 =rs.getString(2);String tshare1 = rs.getString(3);
if(trev1 == null){trev1="-";}if(tshare1 == null){tshare1="-";}
%>	    
	    <td width='10%' align='center'><font color='#000000' face='Arial' size='4'><b>«·„Ã„Ê⁄</b></font></td>
		<td width='25%' colspan=2 align='center'><font color='#000000' face='Arial' size='4'><b><%=tcnt1%></b></font></td>	    
		<td width='25%' colspan=2  align='center'><font color='#000000' face='Arial' size='4'><b><%=trev1%></b></font></td>
		<td width='25%' colspan=2  align='center'><font color='#000000' face='Arial' size='4'><b><%=tshare1%></b></font></td>
<%

}
%>


	
  
</table>    

<br>





<br>
            <table border='1' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='90%'>
                  <tr height=30>
                        <td width='15%' align='center'><font size='4'>«·‘—ﬂ… «·Ê”Ìÿ…</font></td>                  
                        <td width='15%' align='center'><font size='4'>«·œÊ·…</font></td>
                        <td width='15%' align='center'><font size='4'>‘—ﬂ… «·« ’«·« </font></td>
                        <td width='5%' align='center'><font size='4'>«·—ﬁ„ «·„Œ ’—</font></td>
                        <td width='10%' align='center'><font size='4'> ⁄—Ì›… «·—ﬁ„ »⁄„·… »·œÂ«</font></td>
                        
                         <td width='10%' align='center'><font size='4'> ⁄—Ì›… «·—ﬁ„ »«·œÊ·«—</font></td>
                                               
                        <td width='10%' align='center'><font size='4'>√⁄œ«œ «·—”«∆·</font></td>
                        <td width='10%' align='center'><font size='4'>«Ã„«·Ì «·œŒ· »«·œÊ·«—</font></td>
                        <td width='10%' align='center'><font size='4'>œŒ· «·ﬁ‰«Â »«·œÊ·«—</font></td>
                        
                  </tr>

<%

int thetot = 0;
double TotalRevenutot = 0.0;
double mediarevenutot = 0.0;

   rs = null;
   rs = con.createStatement().executeQuery("select  providers.country ,  providers.operator, providers.Providername,providers.shortcode, providers.NativeTarrif, convert(nvarchar, ROUND(convert(float,((case when providers.Tarrif is not null then (providers.Tarrif) else '0' end))),2) ) as TarrifDollar , sum(case when cdrs.sms_length is not null then cdrs.sms_length else '0' end) as thecnt , convert(nvarchar, ROUND(convert(float,(sum(case when cdrs.sms_length is not null then (cdrs.sms_length * Providers.Tarrif) else '0' end))),2) ) as TotalRevenue , convert(nvarchar,  ROUND(convert(float,(sum(case when cdrs.sms_length is not null then (cdrs.sms_length * Mediashare) else '0' end))),2) ) as TheMediaShare  from providers LEFT OUTER JOIN       cdrs  on providers.Providername = cdrs.Provider and  providers.operator = cdrs.Operator and  providers.shortcode= cdrs.ShortCode and  providers.country = cdrs.Country     where providers.providerid not in ('0','-1')   and (convert(char(10),cdrs.In_Time,112) between '"+ fdate + "' and '"+ tdate + "') group by providers.ProviderID,providers.Providername,providers.operator,providers.shortcode,providers.country ,providers.NativeTarrif,providers.Tarrif order by providers.Providername");  
while(rs.next())
{
String co =rs.getString(1);
String op =rs.getString(2);
String prov = rs.getString(3);
String sc =rs.getString(4);
String nativetarrif =rs.getString(5);

String tarrifdollar =rs.getString(6);

int thecnt = rs.getInt(7);
String TotalRevenu = rs.getString(8);
String mediarevenu = rs.getString(9);

TotalRevenutot = TotalRevenutot + (new Double(TotalRevenu)).parseDouble(TotalRevenu);
mediarevenutot = mediarevenutot + (new Double(mediarevenu)).parseDouble(mediarevenu);

thetot = thetot + thecnt;
%>
			  <tr height=30 bgcolor=#ffffff>
				<td width='15%' align='center'><font size='4'><%=prov%></font></td>			  
				<td width='15%' align='center'><font size='4'><%=co%></font></td>
				<td width='15%' align='center'><font size='4'><%=op%></font></td>
				<td width='5%' align='center'><font size='4'><%=sc%></font></td>
				<td width='10%' align='center'><font size='4'><%=nativetarrif%></font></td>
				
				<td width='10%' align='center'><font size='4'><%=tarrifdollar%></font></td>
								
				<td width='10%' align='center'><font size='4'><%=thecnt%></font></td>
				<td width='10%' align='center'><font size='4'><%=TotalRevenu%></font></td>
				<td width='10%' align='center'><font size='4'><%=mediarevenu%></font></td>
			
				
			  </tr>
<%
}
rs.close();rs=null;

TotalRevenutot = Math.round(TotalRevenutot);
mediarevenutot = Math.round(mediarevenutot);
%>


	  <tr height=30>
	    <td width='60%' align='center' colspan=6><font size='4'>«·„Ã„Ê⁄</font></td>
<%	    
   rs = null;
   rs = con.createStatement().executeQuery("select   sum(case when cdrs.sms_length is not null then cdrs.sms_length else '0' end) as TotalCount , convert(nvarchar, ROUND(convert(float,(sum(case when cdrs.sms_length is not null then (cdrs.sms_length * Providers.Tarrif) else '0' end))),2) ) as TotalRevenue , convert(nvarchar,  ROUND(convert(float,(sum(case when cdrs.sms_length is not null then (cdrs.sms_length * Mediashare) else '0' end))),2) ) as TheMediaShare  from  providers LEFT OUTER JOIN   cdrs  on providers.Providername = cdrs.Provider and  providers.operator = cdrs.Operator  and  providers.shortcode= cdrs.ShortCode and  providers.country = cdrs.Country     where providers.providerid not in ('0','-1') and (convert(char(10),cdrs.In_Time,112) between '"+ fdate + "' and '"+ tdate + "')");  
while(rs.next())
{
int tcnt = rs.getInt(1);String trev =rs.getString(2);String tshare = rs.getString(3);
if(trev == null){trev="-";}if(tshare == null){tshare="-";}
%>	    
	    <td width='10%' align='center'><font size='4'><%=tcnt%></font></td>
		<td width='10%' align='center'><font size='4'><%=trev%></font></td>
		<td width='10%' align='center'><font size='4'><%=tshare%></font></td>
<%

}
%>		
 </tr>
	
</table>	
		
		



<br>

<br>






















<%
String thequery="select   convert(nvarchar,cdrs.In_Time,112) as Day ";
int providerscount=0;
   rs = null;
   rs = con.createStatement().executeQuery("SELECT    Providername,country, operator, shortcode  FROM         Providers  WHERE     (Providername <> 'control')  ORDER BY ProviderID");  
while(rs.next())
{
String prov1 = rs.getString(1);
String co1 =rs.getString(2);
String op1=rs.getString(3);
String sc1 =rs.getString(4);
thequery= thequery + ",convert(int,sum(case when Provider='" + prov1+"' and Country='"+ co1 + "' and Operator='" + op1+"' and ShortCode='" + sc1+"'   then  SMS_length else 0 end )) as '" + prov1 + "-" + co1 + "-" + op1 + "-" + sc1+"' ";
providerscount = providerscount + 1;
}
thequery= thequery+ "from cdrs   where  convert(nvarchar,cdrs.In_Time,112) between '"+ fdate + "' and '"+ tdate + "'  group by convert(nvarchar,cdrs.In_Time,112)  order by convert(nvarchar,cdrs.In_Time,112)";

rs.close();rs=null;
rs = null;
rs = con.createStatement().executeQuery(thequery);  
ResultSetMetaData rsMetaData = rs.getMetaData();
int numberOfColumns = rsMetaData.getColumnCount();
String alldata="";

 for (int i = 1; i <= numberOfColumns; i++) 
 {
  alldata=alldata +   rsMetaData.getColumnName(i) + ";" ;
 }   
  alldata=alldata+ "\n";                 
  
 while(rs.next())
{
 for (int i = 1; i <= numberOfColumns; i++) 
 {
  String temprec=rs.getString(i);
  alldata=alldata +  temprec + ";" ;
 } 
   alldata=alldata+ "\n";                  
}rs.close();rs=null;
%>









            <table border='2' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='50%'>
              <tr align='left'> 
                
              <td width='10%' align='center'><input type='submit' name='subApproveSMSSel' value='Õ›Ÿ «· ›«÷Ì·' style='font-weight:bold ; color:#0000FF; width:50em ; height:2.5em' onClick="correctinvoke(1)"></td>

             </tr>    
             
         </table>
               <form name=tosheet method="POST" action="" >            
                 <TEXTAREA  Style="visibility:hidden" dir='ltr' readonly NAME=data COLS=1 ROWS=1 ><%= alldata %></TEXTAREA>
               </form>
           
      


































</body>

</html>
























<%
}
}
%>


