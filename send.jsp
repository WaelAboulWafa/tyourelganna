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
   if(thepage[k].equalsIgnoreCase("send.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
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
  
if(allowedaccess ==false)
{
response.sendRedirect("login_logout.jsp");
return;
}

else
{
%>



<html dir=rtl>

<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000;background-color: #<%=bgcolor%>; }</style>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
<title>—”«·Â œ«Œ·ÌÂ ... <%= medianame %></title>

<script LANGUAGE="JavaScript" type="text/javascript">










function toHexsend(theapp)
{

 var someselected = false;
 
 if( (document.theform.themessage.value.length) > 0 )
   {
     someselected = true;
   }

 if(someselected == false)
 {
 alert ("\u0627\u062F\u062E\u0644\u0020\u0646\u0635\u0020\u0627\u0644\u0631\u0633\u0627\u0644\u0647\u0020\u062B\u0645\u0020\u0627\u0636\u063A\u0637\u0020\u0627\u0631\u0633\u0627\u0644");
 return ;
 }

 




var Unicodesymbols = "";
Unicodesymbols = Unicodesymbols +"\u060C\u061B\u061F\u0621\u0622\u0623\u0624\u0625\u0626\u0627\u0628\u0629\u062A\u062B\u062C\u062D\u062E\u062F";
Unicodesymbols = Unicodesymbols +"\u0630\u0631\u0632\u0633\u0634\u0635\u0636\u0637\u0638\u0639\u063A\u063A\u063A\u063A\u063A\u063A\u0640\u0641\u0642\u0643\u0644\u0645\u0646";
Unicodesymbols = Unicodesymbols +"\u0647\u0648\u0649\u064A\u064B\u064C\u064D\u064E\u064F\u0650\u0651\u0652\u0653\u0654\u0655\u0655\u0655\u0655\u0655\u0655\u0655\u0655\u0655\u0655\u0655\u0660\u0661\u0662";
Unicodesymbols = Unicodesymbols +"\u0663\u0664\u0665\u0666\u0667\u0668\u0669\u066A\u066B\u066C\u066D\u066E\u066F\u0670\u0671\u0672\u0673\u0674";
Unicodesymbols = Unicodesymbols +"\u0675\u0676\u0677\u0678\u0679\u067A\u067B\u067C\u067D\u067E\u067F\u0680\u0681\u0682\u0683\u0684\u0685\u0686";
Unicodesymbols = Unicodesymbols +"\u0687\u0688\u0689\u068A\u068B\u068C\u068D\u068E\u068F\u0690\u0691\u0692\u0693\u0694\u0695\u0696\u0697\u0698";
Unicodesymbols = Unicodesymbols +"\u0699\u069A\u069B\u069C\u069D\u069E\u069F\u06A0\u06A1\u06A2\u06A3\u06A4\u06A5\u06A6\u06A7\u06A8\u06A9\u06AA";
Unicodesymbols = Unicodesymbols +"\u06AB\u06AC\u06AD\u06AE\u06AF\u06B0\u06B1\u06B2\u06B3\u06B4\u06B5\u06B6\u06B7\u06B8\u06B9\u06BA\u06BB\u06BC";
Unicodesymbols = Unicodesymbols +"\u06BD\u06BE\u06BF\u06C0\u06C1\u06C2\u06C3\u06C4\u06C5\u06C6\u06C7\u06C8\u06C9\u06CA\u06CB\u06CC\u06CD\u06CE";
Unicodesymbols = Unicodesymbols +"\u06CF\u06D0\u06D1\u06D2\u06D3\u06D4\u06D5\u06D6\u06D7\u06D8\u06D9\u06DA\u06DB\u06DC\u06DD\u06DE\u06DF\u06E0";
Unicodesymbols = Unicodesymbols +"\u06E1\u06E2\u06E3\u06E4\u06E5\u06E6\u06E7\u06E8\u06E9\u06EA\u06EB\u06EC\u06ED\u06ED\u06ED\u06F0\u06F1\u06F2\u06F3\u06F4";
Unicodesymbols = Unicodesymbols +"\u06F5\u06F6\u06F7\u06F8\u06F9\u06FA\u06FB\u06FC\u06FD\u06FE";

var symbols = " !\"#$%&'()*+'-./0123456789:;<=>?@";
var loAZ = "abcdefghijklmnopqrstuvwxyz";
symbols+= loAZ.toUpperCase();
symbols+= "[\\]^_`";
symbols+= loAZ;
symbols+= "{|}~";


	var valueStr = document.theform.themessage.value;
	var themsisdnorig =  document.theform.themsisdn.value; 
	var thetarget =  document.theform.target.value; 
	if(document.theform.nickchecked.checked == true){themsisdnorig="xxx";}
		
	
	var hexChars = "0123456789abcdef";
	var text = "";
	
	var isUnicode = false;
	

	for( i=0; i<valueStr.length; i++ )
	{
		var oneChar = valueStr.charAt(i);
        if (Unicodesymbols.indexOf(oneChar) != -1)
                 {
                   isUnicode = true;
 	             }
	}
		
	
 if(isUnicode == true)
 {	
	for( i=0; i<valueStr.length; i++ )
	{
		var oneChar = valueStr.charAt(i);

                if (Unicodesymbols.indexOf(oneChar) != -1)
                 {
 		  var asciiValue = Unicodesymbols.indexOf(oneChar) + 30;
		  var index1 = asciiValue % 16;
		  var index2 = (asciiValue - index1)/16;
		  text += "06";
		  text += hexChars.charAt(index2);
		  text += hexChars.charAt(index1);	
		  text= text.toUpperCase(); 		
                 }
                 else
                 {
 		  var asciiValue = symbols.indexOf(oneChar) + 32;
		  var index1 = asciiValue % 16;
		  var index2 = (asciiValue - index1)/16;
		  text += "00";
		  text += hexChars.charAt(index2);
		  text += hexChars.charAt(index1);
          text= text.toUpperCase(); 

                 }
	}
 }
 else
 {
  text = escape(valueStr);
 }	
	


if(isUnicode == true)
{ 
text = text.replace(/001F001F/gi,"000A")
window.location.href= theapp + "?provider=control&msisdn=" + themsisdnorig + "&shortcode=0&operator=control&country=control&lang=A&controlmessage=controlpass&contents=" + text;
  
}

else
{
window.location.href= theapp + "?provider=control&msisdn=" + themsisdnorig + "&shortcode=0&operator=control&country=control&lang=E&controlmessage=controlpass&contents=" + text;
  
}

}




























function disablenick()
{

if( document.theform.nickchecked.checked == true)
{ 
document.theform.themsisdn.disabled=true;
}
else
{ 
document.theform.themsisdn.disabled=false;
}



}


</script>


</HEAD>
<BODY>




<%
String applicationAt = "http://" + request.getHeader("Host") +request.getContextPath() + "/" +"submit.jsp";
%>



<table border='1' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%' height='80'>
  <tr>
    <td width='21%' align='center'><b><i><font color='#A36103' size='6'>—”«·Â œ«Œ·ÌÂ</font></i></b></td>
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
 		<form  action='send.jsp' method='post'>
     		<tr><td align='center'> <input type='submit' name='subRefresh' value='«⁄«œ…  Õ„Ì·' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
               </form>
    	</table>
    </td>
<td bgcolor='#ffffff' width='15%' align='center'><IMG src='logo.png'></td>
  </tr>
</table>

<br>



          <form action='addcontrolnickname.jsp' method='post'> 
            <table border='1' bgcolor=#DCDCDC align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='50%'>
              <tr>
                <td width='30%' height='40' align='center'><b><font size='3'>«”„ „” ⁄«— ÃœÌœ</font></b></td>
                <td width='40%' align='center'><input type='text' name='nick' STYLE='font-family:arial ; font-size:18 ; color:#000000; width:11em; height:2em'></td>
                <td width='30%' align='center'><input type='submit' name='subAdd' value='«÷«›…' STYLE='font-family:arial ; font-size:18; color:#000000; width:8em; height:2em'></td>
              </tr>
            </table>
                  <input type='hidden' name='userid' value='<%= userid %>'>
            </form>





             <form name=theform> 
            <table border='1' bgcolor=#DCDCDC align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='70%'>
              <tr>
                 <td  width='5%' align='center'> &nbsp;</td>
                <td width='20%' height='30' align='center'><b><font size='3'>«”„ „” ⁄«—</font></b></td>
                <td width='40%' height='30' align='center'>
                 <select name='themsisdn' style='font-size:12pt;font-weight:bold;width:15em;height:3em'>

<% 
   rs = con.createStatement().executeQuery("SELECT MSISDN_ID,nickname from ControlNicks where theuserid="+ userid +" ORDER BY  MSISDN_ID");             
while(rs.next())
  {
  
%>       	        
    	        <option value='<%=rs.getString(1)%>'><%= rs.getString(2) %></option>
<%
  	        
}rs.close();rs=null;
con.close();
%>

              </select>
                </td>
                 <td  width='5%' align='center'  colspan='2'><INPUT NAME=nickchecked TYPE=CHECKBOX onClick="disablenick()" ><b><font size='3'>»œÊ‰ «”„ „” ⁄«—</font></b></td>
              </tr>
              <tr>
                <td width='21%' align='center'><b><font size='3'>—”«·…</font></b></td>
                <td width='79%' align='center' colspan='4'>
                <textarea rows='4' cols='64' name='themessage' dir='rtl' style='FONT-WEIGHT: bold; FONT-SIZE: 14pt'></textarea>
                </td>
              </tr>
              <tr>
                <td width='21%' align='center'><input type='button' onClick="toHexsend('<%=applicationAt%>')" name='subPush' value='«—”«·' STYLE='font-weight:bold ; color:#000000; width:9em; height:3em'></td>
                <td width='79%' align='center' colspan='4'></td>
              </tr>
            </table>
            </form>
















   
<BR>
</BODY>
</HTML>




<%
}
}
%>

