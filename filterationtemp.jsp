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
  int phoneallowed = 0;
  try
  {
   rs = con.createStatement().executeQuery("SELECT userID,phone from Users where username=N'" + username.replaceAll("'", "''") + "' and password=N'" + password.replaceAll("'", "''") + "'");             
   userid = 0;
   while(rs.next()){userid = rs.getInt(1);phoneallowed=rs.getInt(2);}
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
   if(thepage[k].equalsIgnoreCase("filteration.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
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



int offset=0;

if(request.getParameter("offset")!=null) 
{
 offset= Integer.parseInt(request.getParameter("offset").toString());
}

int pagesize = 50;
int count= 0;
int pages = 0;
int lowerbound = 0;
int upperbound = 0;






















  int reccount = 0;
     String[] id = null;
     String[] country =  null;     
     String[] sentdate =  null;
     String[] shortcode = null;
     String[] operator = null;
     String[] tel = null;
     String[] nickname = null;
     String[] msg = null;
     String[] messagelogic = null;
      
     int visiblecount = 0 ;

int whenrejectcount = 0;    








//-----------------------------------
String query1 = "SELECT count(*) from NewSMS_Temp";
String query2 = "SELECT OriginalID from NewSMS_Temp order by OriginalID";
String query3 = " select NewSMS_Temp.originalid, NewSMS_Temp.country as thecountry,(  CONVERT(char(10), NewSMS_Temp.SentDate, 101) + ' ' + convert(varchar,NewSMS_Temp.SentDate, 8) )  ,NewSMS_Temp.msisdn, (case when chatNickNames.MessageContents is not null then  chatNickNames.MessageContents else '' end )AS NickName , ( NewSMS_Temp.country + '-' + NewSMS_Temp.operator + '-' + NewSMS_Temp.shortcode ) as shortcode , NewSMS_Temp.thesms as SMS ,NewSMS_Temp.MessageLogic as MessageLogic FROM         NewSMS_Temp LEFT OUTER JOIN                chatNickNames ON NewSMS_Temp.MSISDN = chatNickNames.MSISDN order by  NewSMS_Temp.originalid";


String filtershortcode = "ALL";

if( request.getParameter("filtertheshortcode")!=null) 
{
 if( !(request.getParameter("filtertheshortcode").trim().equalsIgnoreCase("ALL")) ) 
 { 
  filtershortcode= request.getParameter("filtertheshortcode");
StringTokenizer st = new StringTokenizer(filtershortcode,"-");
String thecountry="";String theoperator="";String theshortcode="";
try{thecountry=st.nextToken().trim();}catch(Exception e){thecountry="";}
try{theoperator=st.nextToken().trim();}catch(Exception e){theoperator="";}
try{theshortcode=st.nextToken().trim();}catch(Exception e){theshortcode="";}

  query1 = "  SELECT count(*) from NewSMS_Temp where country='" +thecountry+ "' and operator = '" + theoperator + "' and shortcode='" + theshortcode + "' ";
  query2 =  " SELECT  OriginalID  from NewSMS_Temp where country='" +thecountry+ "' and operator = '" + theoperator + "' and shortcode='" + theshortcode + "'  order by OriginalID";
  query3 = "   select THENewMessages.originalid,THENewMessages.country,THENewMessages.theindate ,THENewMessages.msisdn , THENewMessages.NickName,THENewMessages.smsorigin ,THENewMessages.sms , THENewMessages.MessageLogic as MessageLogic  from  ( select  NewSMS_Temp.originalid,  NewSMS_Temp.Providername, NewSMS_Temp.country, NewSMS_Temp.operator, ( NewSMS_Temp.country + '-' + NewSMS_Temp.operator + '-' + NewSMS_Temp.shortcode )AS smsorigin,  (CONVERT(char(10), NewSMS_Temp.SentDate, 101) + ' ' + convert(varchar,NewSMS_Temp.SentDate, 8) )  as theindate, NewSMS_Temp.msisdn, (case when chatNickNames.MessageContents is not null then  chatNickNames.MessageContents else '' end ) AS NickName ,NewSMS_Temp.shortcode, NewSMS_Temp.thesms as SMS , NewSMS_Temp.MessageLogic as MessageLogic FROM         NewSMS_Temp LEFT OUTER JOIN  chatNickNames ON NewSMS_Temp.MSISDN = chatNickNames.MSISDN  ) as THENewMessages  left JOIN  Providers ON THENewMessages.smsorigin = (Providers.country + '-' + Providers.operator + '-' + Providers.shortcode )  where THENewMessages.country= '" +thecountry+ "' and  THENewMessages.operator = '" + theoperator + "' and THENewMessages.shortcode='" + theshortcode + "' order by THENewMessages.originalid ";   



    
 // out.print(filtershortcode);
 }
}
///-----------------------------------

















    

      rs = con.createStatement().executeQuery(query1);            
      if(rs.next())
      {
     	 reccount = rs.getInt(1);
      }
        rs.close(); rs = null;
   
  
    count =  reccount;
  
       
       rs = con.createStatement().executeQuery(query2);            
       while(rs.next())
       {
     	 String tmp = rs.getString(1);
     	 visiblecount = visiblecount + 1 ;
       }
        rs.close(); rs = null;
        
   
   rs = null;
   rs = con.createStatement().executeQuery(query3);

   
     id = new String[visiblecount];
     country = new String[visiblecount];
     sentdate =  new String[visiblecount];
     shortcode = new String[visiblecount];
     tel = new String[visiblecount];
     nickname = new String[visiblecount];
     msg = new String[visiblecount];
     messagelogic= new String[visiblecount];
   
   rs.next();
   //int theCounter = 0;
   //while(rs.next())
for (int theCounter=0;theCounter<visiblecount;theCounter++)
    {
     id[theCounter] = rs.getString(1).trim();
     country[theCounter] = rs.getString(2).trim();
     sentdate[theCounter] =  rs.getString(3).trim();
     tel[theCounter] = rs.getString(4).trim();
     nickname[theCounter] = rs.getString(5).trim();
     shortcode[theCounter] = rs.getString(6).trim();
     msg[theCounter] = rs.getString(7).trim(); 
     messagelogic[theCounter] = rs.getString(8).trim(); 
     rs.next();
    // theCounter = theCounter + 1 ;
   }
   rs.close(); 
   rs = null;
   
   
   
   

   
   




///////////////THE short codes

/// -------------------
int thescsccount = 0;
String[] thescs = null;

   try{
      rs = con.createStatement().executeQuery("SELECT count(*) from Providers");            
      if(rs.next())
      {
     	 thescsccount = rs.getInt(1);
      }
       rs.close(); rs = null;

   rs = null;
   rs = con.createStatement().executeQuery("SELECT     (country + '-' +  operator + '-' +   shortcode) as theprov FROM         Providers ORDER BY ProviderID");

 thescs = new String[thescsccount];
   
   
   int theCounterrr1 = 0;
   while(rs.next())
    {
     try{
         thescs[theCounterrr1] = rs.getString(1).trim();
        }catch(Exception ex){thescs[theCounterrr1]="";}
        

     theCounterrr1 = theCounterrr1 + 1 ;
   }
   rs.close(); 
   rs = null;
   
      }catch(Exception e){out.println(e);return;}

/// ------------------



















   if(count != 0 ) 
   {
     if(count%pagesize ==0)
      {
        pages = (count/pagesize);
      }
      else
      {  
        pages = (count/pagesize) + 1  ;
     }
   }
 
if(count != 0 )
{
if(pages == 1)
{
lowerbound = 0;
upperbound = count;
}
else
{

if( ( (offset) * pagesize) <= count)
{
 lowerbound = (offset * pagesize) ;

 if(   ((offset+1) * pagesize) > count )
  {
   upperbound = count;
  }
  else
  {
   upperbound = ( (offset+1) * pagesize);
  }
}
else
{
lowerbound = 0;
upperbound = 0;

}  
}  
  
 
}






   
   
    


   

   

             
%>



































<html dir='rtl'>
<HEAD>


<script LANGUAGE="JavaScript" type="text/javascript">


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



function correctinvoke(target)
{
if(target == 0) {document.mainform.action="BATCHApprove.jsp";document.mainform.submit();}
if(target == 1) {document.mainform.action="BATCHReject.jsp";document.mainform.submit();}
if(target == 2) {document.mainform.action="BATCHApproveBox.jsp";document.mainform.submit();}
if(target == 3) {document.mainform.action="BATCHApproveBoxANDBAR.jsp";document.mainform.submit();}

if(target == 4) {document.mainform.action="BATCHApprovePoetry.jsp";document.mainform.submit();}


}
 


 






















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
alert("\u0645\u0633\u0645\u0648\u062D\u0020\u0641\u0642\u0637\u0020\u0628\u0627\u0644\u0644\u063A\u0647\u0020\u0627\u0644\u0639\u0631\u0628\u064A\u0647");
  
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









function functioncall(target)
{
if(target == 0) {document.theform.action="senddirect.jsp";document.mainform.submit();}

}
 
 







</script>





























<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000;background-color: #<%=bgcolor%>; }</style>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
<title>—”«∆· €Ì— „ﬂ „·Â ...<%=medianame%></title>

</head>


<BODY>








<%
String applicationAt = "http://" + request.getHeader("Host") +request.getContextPath() + "/" +"submit.jsp";
%>



<table border='1' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%' height='80'>
  <tr>
    <td width='21%' align='center'><b><i><font color='#A36103' size='6'>—”«∆· €Ì— „ﬂ „·Â</font></i></b></td>
    
                        <td width='10%' height='10' align='center'>
                  <table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%' height='100%'>
            	<tr bgcolor=#CCFFC8><td align='center' width='10%'><font size='4'>—”«∆·</font></td></tr>                  
            	<tr bgcolor=#FFC8C8><td align='center' width='10%'><font size='4'>«”„«¡ „” ⁄«—Â</font></td></tr>
                  </table>
                </td>  
                
                
    
    <td width='30%' align='center'>
    <table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%'>
      <tr><td width='100%' align='center'><font color='#000000' face='Arial' size='4'><b> Êﬁ‹‹  «·œŒÊ·  <%= intime %> </b></font></td></tr>
      <tr><td width='100%' align='center'><font color='#000000' face='Arial' size='4'><b> &nbsp;</b></font></td></tr>
      <tr><td width='100%' align='center'><font color='#000000' face='Arial' size='4'><b>  «—Ì‹‹Œ «·œŒÊ·  <%= indate %> </b></font></td></tr>
    </table>
    </td>
    <td width='24%' align='center'>
    	<table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%'>
 		<form action='MainPage.jsp' method='post'>                
     		 <tr><td align='center'><input type='submit' name='subMain' value='«·ﬁ«∆„… «·—∆Ì”Ì…' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
                </form>
 		<form name='fform' action='filterationtemp.jsp' method='post'>
     		<tr><td align='center'><input type='submit' name='subRefresh' value='«⁄«œ…  Õ„Ì·' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
               </form>
    	</table>
    </td>
<td bgcolor='#ffffff' width='15%' align='center'><IMG src='logo.jpeg'></td>
  </tr>
</table>




<br>


















  









               


            <br>







            <table border='1' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='96%'>
                  <tr height='30'>
                    <td align='center' width='4%'>
<%
if(pages>0)
{
  for(int i=0;i<pages;i++)
  {
   if(i==offset)
    {
%>
                     <b><%= (offset +1)%></b>
<%
    }
    else
   {
%>
                  <b><a href=filteration.jsp?offset=<%= i %>&filtertheshortcode=<%= URLEncoder.encode(filtershortcode)%> ><%= Integer.toString(i+1) %> </a>&nbsp;</b>
<%
   }
   
  }
}
%>
                    </td>
                  </tr>
            </table>











            <table border='1' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='98%'>
                  <tr>
                        <td>
                              <table border='0' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                    <tr>
                                          <td width='5%' align='center'>
                                                <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                                      <input type='hidden' name='uid' value='41'>
                                                      <input type='hidden' name='cur_page' value='1'>
                                                      <input type='hidden' name='selc' value=''>
                                                      <tr><td align='center'><input type='submit' name='subSelectAll' value='«·ﬂ·' style='font-weight:bold ; width:8em ; height:2em' onClick="selectall(<%= reccount %>)"></td></tr>
                                                </table>
                                          </td>
                                          <td width='5%' align='center'>&nbsp;</td>
                                          <td width='10%' align='center'><input type='submit' name='subApproveSMSSel' value='„Ê«›ﬁ…' style='font-weight:bold ; color:#0000FF; width:11em ; height:2em' onClick="correctinvoke(0)"></td>
                                          <td width='15%' align='center'><input type='submit' name='subDeclineSMSSel' value='—›÷' style='font-weight:bold ; width:11em ; color:#FF0000; height:2em' onClick="correctinvoke(1)"></td>
                                          

                                          <td width='25%' align='center'>
                                                <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                                      <tr align="center" >
                                                       <td align='center' >

<form name=thescform method=post action="filteration.jsp" >
<select name='filtertheshortcode' style='font-weight:bold ; color:#000099'  onChange='javascript:document.thescform.submit();'>
 <option>ALL</option>
<% 
for (int l =0  ; l < thescs.length ; l ++)
{
  if (thescs[l].equalsIgnoreCase(filtershortcode)) 
  {
  
%>       	        
    	        <option selected><%= thescs[l] %></option>
<%
  }
  else
  {
%>       	        
    	        <option><%= thescs[l] %></option>
<%
  }    	        
}
%> 
</select>
</form>
                                                       </td>
                                                      </tr>
                                                </table>
                                          </td>
                                          <td width='15%' align='center'>
                                                <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                                      <tr>
                                                            <td align='center'><b>⁄œœ</b></td>
                                                            <td align='left'><font color=#000099><b><%= reccount %></b></font></td>
                                                      </tr>
                                                </table>
                                          </td>
                                          <td width='10%' align='center'>
                                          	<table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                                      <tr>
                                                            <td align='center'><b>’›Õ…</b></td>
                                                            <td align='left'><font color=#000099><b><%= (offset +1)%>&nbsp/&nbsp;<%= pages %></b></font></td>
                                                      </tr>
                                          	</table>
                                          </td>
                                    </tr>
                              </table>
                        </td>
                  </tr>
            </table>

   
















            
            
            
            
            





















     <table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#cccccc' width='98%'>
             <tr bgcolor=#DCDCDC>
                  <td width='5%' align='center'><b>«Œ Ì«—</b></td>

                  </td><td width='8%' align='center'><b>„”·”·</b></td>
                  <td width='50%' align='center'><b>—”«·…</b></td>
                  <td width='11%' align='center'><b> «—ÌŒ «·«—”«·</b></td>
                  <td width='10%' align='center'><b> ·Ì›Ê‰</b></td>
                  <td width='9%'  align='center'><b>„’œ— «·Œœ„…</b></td>
                  <td width='15%' align='center'><b>«·«”„ «·„” ⁄«—</b></td>
              
            </tr>
     


<form name=mainform method=post action="" >

<INPUT style="display: none;" NAME=theoffset SIZE=10  value="<%= lowerbound %>" > 
<INPUT style="display: none;" NAME=countrysc SIZE=10  value="<%= filtershortcode %>" > 
<INPUT style="display: none;" NAME=thebase SIZE=10  value="<%= offset %>" > 

<INPUT style="display: none;" NAME=count SIZE=10  value="<%= reccount %>" > 

<% for (int l =lowerbound ; l < upperbound ; l ++)
{
if( messagelogic[l].equalsIgnoreCase("chat"))
{
%>
<tr bgcolor=#CCFFC8>
<%
}
else
{
%>   
<tr bgcolor=#FFC8C8>
<%
}
%>


 
           <INPUT style="display: none;" NAME=messagelogic<%= l %>  value="<%= messagelogic[l] %>" >     

           <INPUT style="display: none;" NAME=country<%= l %>  value="<%= country[l] %>" >                



  
            <td align='center'>  <INPUT id="ischeck<%= l %>" NAME=ischeck<%= l %> TYPE=CHECKBOX >  </td>
    	    <td align='center'>  <INPUT NAME=id<%= l %> SIZE=6  READONLY value="<%= id[l] %>" > </td>
            <td align='center'>  <TEXTAREA dir="RTL" style="FONT-WEIGHT: bold; FONT-SIZE: 12pt" NAME=msg<%= l %>  COLS=55 ROWS=3 ><%= msg[l] %></TEXTAREA></td>    	    
    	    <td align='center'> <b><font color=#000000 size=4>  <%= sentdate[l] %> </td></font></b></td>




    	    
 <INPUT type='hidden' NAME=tel<%= l %> SIZE=17  READONLY value="<%= tel[l] %>" >

<%    	    
if(phoneallowed == 1)
{
%>
    	    <td align='center'><b><font color=#000000 size=4><%= tel[l] %></font></b></td>
<%
}
else
{
             if(tel[l].length() >= 4)
             {
%>
    	       <td align='center'><b><font color=#000000 size=4><%= tel[l].substring(tel[l].length()-4,tel[l].length()) %></font></b></td>
<%
             }
             else
             {
%>
    	       <td align='center'><b><font color=#000000 size=4><%= tel[l] %></font></b></td>
<%             
             }
}
%>





    	    <td align='center'> <b><font color=#000000 size=4>  <%= shortcode[l] %> </font></b></td>    	       	    

    	    <td align='center'> <b><font color=#000000 size=4> <%= nickname[l] %> </font></b></td>    	        
    	    
    	    	    


   	        	    





           </tr>            
<%
}
%>
</form>

 </table>




















<br>


</BODY>
</HTML>
























<%
con.close();   
}
}
%>

