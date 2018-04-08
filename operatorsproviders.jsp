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
   if(thepage[k].equalsIgnoreCase("operatorsproviders.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
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





String filtertheprovider = "1";
if( request.getParameter("filtertheprovider")!=null) {filtertheprovider=request.getParameter("filtertheprovider");}




   
 

 int count=0;

if (filtertheprovider.equalsIgnoreCase("ALL"))  
{
 rs = con.createStatement().executeQuery("select count(*) from providers ");            
}

if (filtertheprovider.equalsIgnoreCase("0"))  
{
 rs = con.createStatement().executeQuery("select count(*) from providers where  Active=0");            
}

if (filtertheprovider.equalsIgnoreCase("1"))  
{
 rs = con.createStatement().executeQuery("select count(*) from providers where  Active=1");            
}




if(rs.next()){count = rs.getInt(1);}
rs.close(); rs = null;

   

   

             
%>



































<html dir='rtl'>
<HEAD>


<script LANGUAGE="JavaScript" type="text/javascript">

function correctinvoke(target)
{
if(target == 0) {document.thisfrm.action="addprov.jsp";document.thisfrm.submit();}
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

if(whattocall == 0) {document.thethisfrm.action="thebatchprovidermodify.jsp";document.thethisfrm.submit();}
if(whattocall == 1) {document.thethisfrm.action="thebatchproviderdelete.jsp";document.thethisfrm.submit();}

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






function disableip(k)
{

if( document.getElementById('ipchecked' + k).checked==true )  
{ 
document.getElementById('theip' + k).disabled=true;
}
else
{ 
document.getElementById('theip' + k).disabled=false;
}

}

</script>














<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000;background-color: #<%=bgcolor%>; }</style>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
<title>‘—ﬂ«  «·« ’«·«  ... <%= medianame %></title>

</head>


<BODY>




<%
String applicationAt = "http://" + request.getHeader("Host") +request.getContextPath() + "/" +"submit.jsp";
%>



<table border='1' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%' height='80'>
  <tr>
    <td width='21%' align='center'><b><i><font color='#A36103' size='6'>‘—ﬂ«  «·« ’«·« </font></i></b></td>
    
 
    
    
    
    
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
 		<form name='theform' action='operatorsproviders.jsp' method='post'>
     		<tr><td align='center'><input type='submit' name='subRefresh' value='«⁄«œ…  Õ„Ì·' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
               </form>
    	</table>
    </td>
<td bgcolor='#ffffff' width='15%' align='center'><IMG src='logo.png'></td>
  </tr>
</table>




<br>
<br>

 
      <table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
 <form name=thisfrm  action="" method='get'>
 
        <tr>
          <td width='100%' height='369' valign='top'>
      	    <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#ffffff' width='80%'>
      	    

       	    
      	      <tr height='25' bgcolor=#DCDCDC>
 

      	      

      	        <td width='15%' align='center'><b>œÊ·…</b></td>
      	        <td width='15%' align='center'><b>‘—ﬂ… «·« ’·« </b></td>
      	        <td width='15%' align='center'><b>«·‘—ﬂ… «·Ê”Ìÿ…</b></td>
      	        <td width='15%' align='center'><b>«·—ﬁ„ «·„Œ ’—</b></td>

      	              	        
      	      </tr>
      	      <tr>

      	        <td width='15%' align='center'><input type='text' style='font-size:12pt;color:#000000;font-weight:bold;width:8em;height:1.7em' dir='ltr' name='country' ></td>
      	        <td width='15%' align='center'><input type='text' style='font-size:12pt;color:#000000;font-weight:bold;width:8em;height:1.7em' dir='ltr' name='operator' ></td>
      	        <td width='15%' align='center'><input type='text' style='font-size:12pt;color:#000000;font-weight:bold;width:8em;height:1.7em' dir='ltr' name='provider' ></td>
      	        <td width='15%' align='center'><input type='text' style='font-size:12pt;color:#000000;font-weight:bold;width:8em;height:1.7em' dir='ltr' name='shortcode'></td>      	        
      	        


      	        <td width='20%' align='right'><input type='button' name='subAdd' value='«÷«›…' style='font-weight:bold ; width:9em ; height:2.5em' onClick="correctinvoke(0)"></td>
      	              	        
      	      </tr>
</form>
      	    </table>


<br>






<table align='center' border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#AAAAAA' width='98%'>

<tr height='25' bgcolor=#DCDCDC>
 <td width='10%' align='center'><input type='submit' name='subApproveSMSSel' value='«·ﬂ·' style='font-weight:bold ; width:6em ; height:2.0em' onClick='selectall(<%= count %>)'></td>
 <td width='10%' align='center'><input type='submit' name='subApproveSMSSel' value=' ⁄œÌ·' style='font-weight:bold ; width:6em ; height:2.0em' onClick="thecorrectinvoke(0)"></td>
 <td width='10%' align='center'><input type='submit' name='subApproveSMSSel' value='Õ–›' style='font-weight:bold ; width:6em ; height:2.0em' onClick="thecorrectinvoke(1)"></td> 
 <td width='15%' align='center'>
 
 
 
 
 
 
 
 
 

 <form name=theactiveprovsform method=post action="operatorsproviders.jsp" >
<select name='filtertheprovider' style='font-size:12pt;color:#000099;font-weight:bold;width:8em;height:1.7em' dir='rtl'  onChange='javascript:document.theactiveprovsform.submit();'> 

<%
  if (filtertheprovider.equalsIgnoreCase("ALL")) 
  {
%>  
   <option selected value='ALL'>«·ﬂ·</option>
<%
}
else
{
%>
   <option value='ALL'>«·ﬂ·</option>
<%
}
%>
 

<%
  if (filtertheprovider.equalsIgnoreCase("1")) 
  {
%>  
 <option selected value='1'>«·‰‘ÿ</option>
<%
}
else
{
%>
 <option value='1'>«·‰‘ÿ</option>
<%
}
%>


<%
  if (filtertheprovider.equalsIgnoreCase("0")) 
  {
%>  
<option selected value='0'>«·€Ì— ‰‘ÿ</option>  
<%
}
else
{
%>
<option value='0'>«·€Ì— ‰‘ÿ</option>  
<%
}
%>
 

 
 
 
 
</select>


</form>



 
 
 
 
 
 
 
 </td>
 <td width='30%' align='center'>&nbsp;</td>
  



 
 </tr>

</table>






     <table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#cccccc' width='98%'>









           	      <tr bgcolor=#DCDCDC height='25'>
         	            	      <td width='5%' align='center'><b>&nbsp;</b></td>
      	        <td width='1%' align='center'><b>„”·”·</b></td>
      	        <td width='1%' align='center'><b>œÊ·…</b></td>
                <td width='10%' align='center'><b>‘—ﬂ… «·« ’«·« </b></td>
                <td width='10%' align='center'><b>«·‘—ﬂ… «·Ê”Ìÿ…</b></td>
      	        <td width='10%' align='center'><b>«·—ﬁ„ «·„Œ ’—</b></td>
      	        
      	        <td width='10%' align='center'><b>„’œ— IP</b></td>

      	        <td width='10%' align='center'><b>“„‰ «Œ— —”«·Â</b></td>    
      	        <td width='5%' align='center'><b>«·ÌÊ„</b></td>
      	        <td width='5%' align='center'><b>«·”«⁄…</b></td>
      	        <td width='5%' align='center'><b>œﬁÌﬁ…</b></td>
      	        <td width='5%' align='center'><b>À«‰Ì…</b></td>
      	        <td width='5%' colspan=2 align='center'><b>—Ê«»ÿ «·—”«∆·</b></td>
       	        <td width='5%' align='center'><b>«”„ ⁄·Ì «·‘«‘Â</b></td>
      	        <td width='5%' align='center'><b>‰‘ÿ</b></td>
      	        
              </tr>


<form name=thethisfrm method=post action="">
<INPUT type='hidden' NAME=count SIZE=6  READONLY value="<%= count %>" > 

<% 

   rs = null;
   
if (filtertheprovider.equalsIgnoreCase("ALL"))  
{   
   rs = con.createStatement().executeQuery("select providers.ProviderID,  providers.country ,  providers.operator, providers.Providername,providers.shortcode,providers.OriginatingIP,  (case when        max(CONVERT(char(10), in_time, 111)+ ' '+ convert(varchar,in_time, 8)) is not null then         max(CONVERT(char(10), in_time, 111)+ ' '+ convert(varchar,in_time, 8)) else '-' end ) AS lastmessage,providers.Active ,providers.nameonscreen  from providers LEFT OUTER JOIN       cdrs on providers.Providername = cdrs.Provider and providers.operator = cdrs.Operator and providers.shortcode= cdrs.ShortCode and providers.country = cdrs.Country  group by providers.OriginatingIP,providers.ProviderID,providers.Providername,providers.operator,providers.shortcode,providers.country , providers.Active,providers.nameonscreen order by providers.ProviderID");  
}
      
if (filtertheprovider.equalsIgnoreCase("0"))  
{
   rs = con.createStatement().executeQuery("select providers.ProviderID,  providers.country ,  providers.operator, providers.Providername,providers.shortcode,providers.OriginatingIP,  (case when        max(CONVERT(char(10), in_time, 111)+ ' '+ convert(varchar,in_time, 8)) is not null then         max(CONVERT(char(10), in_time, 111)+ ' '+ convert(varchar,in_time, 8)) else '-' end ) AS lastmessage,providers.Active ,providers.nameonscreen  from providers LEFT OUTER JOIN       cdrs on providers.Providername = cdrs.Provider and providers.operator = cdrs.Operator and providers.shortcode= cdrs.ShortCode and providers.country = cdrs.Country   where providers.Active=0 group by providers.OriginatingIP,providers.ProviderID,providers.Providername,providers.operator,providers.shortcode,providers.country , providers.Active,providers.nameonscreen order by providers.ProviderID");  
}


if (filtertheprovider.equalsIgnoreCase("1"))  
{
   rs = con.createStatement().executeQuery("select providers.ProviderID,  providers.country ,  providers.operator, providers.Providername,providers.shortcode,providers.OriginatingIP,  (case when        max(CONVERT(char(10), in_time, 111)+ ' '+ convert(varchar,in_time, 8)) is not null then         max(CONVERT(char(10), in_time, 111)+ ' '+ convert(varchar,in_time, 8)) else '-' end ) AS lastmessage,providers.Active ,providers.nameonscreen  from providers LEFT OUTER JOIN       cdrs on providers.Providername = cdrs.Provider and providers.operator = cdrs.Operator and providers.shortcode= cdrs.ShortCode and providers.country = cdrs.Country   where providers.Active=1 group by providers.OriginatingIP,providers.ProviderID,providers.Providername,providers.operator,providers.shortcode,providers.country , providers.Active,providers.nameonscreen order by providers.ProviderID");  
}


 int therownnum =0;  
while(rs.next())
{
%>


<%
 
String targetSC = "";


String providerid = rs.getString(1);
String thecountry = rs.getString(2);
String thecoperator = rs.getString(3);
String theprovidername = rs.getString(4);
String theshortcode = rs.getString(5);
String theip = rs.getString(6);

%>

<%
      if(!theprovidername.equalsIgnoreCase("control"))
      {
%>      

<tr>
     
       <td width='1%' align='center'>  <INPUT id="ischeck<%= therownnum %>" NAME=ischeck<%= therownnum %> TYPE=CHECKBOX >  </td>
       
                   <td width='1%' align='center'><b><%=providerid%></b></td>
                   <INPUT type='hidden' NAME=id<%= therownnum %> value="<%= providerid %>" > 


                   
                   
                   <td width='10%' align='center'><INPUT dir='ltr' style='font-size:12pt;color:#000000;font-weight:bold;width:8em;height:1.7em' id="thecountry<%= therownnum %>" NAME=thecountry<%= therownnum %> value=<%=thecountry%> ></td>
                   <td width='10%' align='center'><INPUT dir='ltr' style='font-size:12pt;color:#000000;font-weight:bold;width:8em;height:1.7em' id="thecoperator<%= therownnum %>" NAME=thecoperator<%= therownnum %> value=<%=thecoperator%> ></td>
                   <td width='10%' align='center'><INPUT dir='ltr' style='font-size:12pt;color:#000000;font-weight:bold;width:8em;height:1.7em' id="theprovidername<%= therownnum %>" NAME=theprovidername<%= therownnum %> value=<%=theprovidername%> ></td>
                   <td width='10%' align='center'><INPUT dir='ltr' style='font-size:12pt;color:#000000;font-weight:bold;width:8em;height:1.7em' id="theshortcode<%= therownnum %>" NAME=theshortcode<%= therownnum %> value=<%=theshortcode%> ></td>
                   


                    <td width='10%' align='center'>
                     <table>

<%
      if(theip.equalsIgnoreCase("any"))
      {
%>                      
                     
                       <tr>
                          <td  width='5%' align='center'  colspan='2'><INPUT checked id="ipchecked<%= therownnum %>" NAME=ipchecked<%= therownnum %> TYPE=CHECKBOX  onClick="disableip(<%= therownnum %>)" ><b><font size='3'>«Ì „ﬂ«‰</font></b></td>
                        </tr>     
                        <tr>
                          <td width='10%' align='center'><INPUT disabled dir='ltr' style='font-size:10pt;color:#000000;font-weight:bold;width:8em;height:1.7em' id="theip<%= therownnum %>" NAME=theip<%= therownnum %> value=<%=theip%> ></td>                          
                        </tr> 
<%
}
else
{
%>                          

                       <tr>
                          <td  width='5%' align='center'  colspan='2'><INPUT id="ipchecked<%= therownnum %>" NAME=ipchecked<%= therownnum %> TYPE=CHECKBOX onClick="disableip(<%= therownnum %>)" ><b><font size='3'>«Ì „ﬂ«‰</font></b></td>
                        </tr>     
                        <tr>
                          <td width='10%' align='center'><INPUT dir='ltr' style='font-size:10pt;color:#000000;font-weight:bold;width:8em;height:1.7em' id="theip<%= therownnum %>" NAME=theip<%= therownnum %> value=<%=theip%> ></td>                          
                        </tr> 
                        
<%
}
%>
                      </table>       
                    </td>


                   
                   
                      	  
<%
String ThelastMessageTime = rs.getString(7);

int activeprov = rs.getInt(8);

String nameonscreen=rs.getString(9);

      long lastMessageTime  = -1;
      long NowTime  = -1;
      long diffinseconds = -1;
      long diffinminiutes = -1;
      long diffinhours = -1;
      long diffindays = -1;
      if(!ThelastMessageTime.equalsIgnoreCase("-"))
      {
       lastMessageTime= ((new SimpleDateFormat("yyyy/MM/dd HH:mm:ss")).parse(ThelastMessageTime)).getTime();
       NowTime = (new java.util.Date()).getTime();
            
       diffindays= ((NowTime - lastMessageTime)/1000)/(60*60*24);   
       diffinhours=  ((NowTime - lastMessageTime)/1000)/(60*60) - diffindays * 24;
       diffinminiutes=  ((NowTime - lastMessageTime)/1000)/(60) - diffindays * 24 * 60  - diffinhours * 60;      
       diffinseconds = ((NowTime - lastMessageTime)/1000)%60;
      
      }
      


%> 
                   
                   <td width='10%' align='center'><font color=#000000><b><%=ThelastMessageTime%></font></b>
                   
                   
                   
                   
<%
      if(!ThelastMessageTime.equalsIgnoreCase("-"))
      {
%>                   
                   <td width='5%' align='center'><font color=#AA0000 size=5><b><%=diffindays%></font></b>
<%
}
else
{
%>
                  <td width='5%' align='center'><font color=#AA0000><b>-</font></b>
<%
}
%>





<%
      if(!ThelastMessageTime.equalsIgnoreCase("-"))
      {
%>                   
                   <td width='5%' align='center'><font color=#AA0000 size=5><b><%=diffinhours%></font></b>
<%
}
else
{
%>
                  <td width='5%' align='center'><font color=#AA0000><b>-</font></b>
<%
}
%>









<%
      if(!ThelastMessageTime.equalsIgnoreCase("-"))
      {
%>                   
                   <td width='5%' align='center'><font color=#AA0000 size=5><b><%=diffinminiutes%></font></b>
<%
}
else
{
%>
                  <td width='5%' align='center'><font color=#AA0000><b>-</font></b>
<%
}
%>







<%
      if(!ThelastMessageTime.equalsIgnoreCase("-"))
      {
%>                   
                   <td width='5%' align='center'><font color=#AA0000 size=5><b><%=diffinseconds%></font></b>
<%
}
else
{
%>
                  <td width='5%' align='center'><font color=#AA0000><b>-</font></b>
<%
}
%>





                   
                   
                   
                   
                   
 <td width='5%' align='center'>  <input STYLE='font-weight:bold;font-family:arial;font-size:15;color:#000000;width:3.3em;height:1.8em' TYPE="BUTTON" VALUE='⁄—»Ì' onClick="viewarabicurl('<%=therownnum%>','<%=applicationAt%>')" > </td>   	                 
 <td width='5%' align='center'>  <input STYLE='font-weight:bold;font-family:arial;font-size:15;color:#000000;width:3.3em;height:1.8em' TYPE="BUTTON" VALUE='«‰Ã·Ì“Ì' onClick="viewURLEnglish('<%=therownnum%>','<%=applicationAt%>')" > </td>   	                  

 
<td align='center'>  <TEXTAREA dir="RTL" style="FONT-WEIGHT: bold; FONT-SIZE: 10pt" NAME=nameonscreen<%= therownnum %>  COLS=10 ROWS=4 ><%=  (new String(nameonscreen.getBytes("Cp1252"),"Cp1256")) %></TEXTAREA></td>    	    


<%
if(activeprov == 0)
{
%>
 <td width='5%' align='center'><INPUT TYPE=CHECKBOX  id="activeprov<%= therownnum %>" NAME=activeprov<%= therownnum %>    > </td> 
 
<%
}
else
{
%>
 <td width='5%' align='center'><INPUT TYPE=CHECKBOX  checked id="activeprov<%= therownnum %>" NAME=activeprov<%= therownnum %>    > </td> 
 
<%
}
%>
                       
                                                
                    
 </tr>
 

<%
}
%>



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
