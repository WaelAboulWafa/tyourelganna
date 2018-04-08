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
   if(thepage[k].equalsIgnoreCase("nicknames.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("smsonair.jsp")){if(allowed[k] == 1){allowedaccess =true;}}         
//   if(thepage[k].equalsIgnoreCase("search.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("badwords.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("operatorsproviders.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("upperinfo.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("lowerinfo.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("instructions.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("smscount.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("smsdistribution.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("Sub_Admin.jsp")){if(allowed[k] == 1){allowedaccess =true;}}                           
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




String searchbyphone = "";try{searchbyphone = request.getParameter("searchbyphone").trim();}catch(Exception e){searchbyphone = "1";}
String searchbynick = ""; try {searchbynick = request.getParameter("searchbynick").trim(); }catch(Exception e){searchbynick = "1"; }
String searchbyimage = "";try{searchbyimage = request.getParameter("searchbyimage").trim();}catch(Exception e){searchbyimage = "2";}
String searchorderby = "";try{searchorderby = request.getParameter("searchorderby").trim();}catch(Exception e){searchorderby = "3";}

String msisdnsearchkeyword = "";try{msisdnsearchkeyword = request.getParameter("the_msisdn").trim();}catch(Exception e){msisdnsearchkeyword = "";}
String nicknamesearchkeyword = "";try{nicknamesearchkeyword = request.getParameter("the_nickname").trim();}catch(Exception e){nicknamesearchkeyword = "";}

msisdnsearchkeyword = (new String(msisdnsearchkeyword.getBytes("Cp1252"),"Cp1256"));
nicknamesearchkeyword = (new String(nicknamesearchkeyword.getBytes("Cp1252"),"Cp1256"));


//user pressed Add subscriber
if( request.getParameter("subadd")!=null) 
{

String the_msisdn  =request.getParameter("the_msisdn").replaceAll("'", "''").trim();
String the_nickname  =request.getParameter("the_nickname").replaceAll("'", "''").trim();


//check existance

   int msisdn_foundbefore=0;
   rs = con.createStatement().executeQuery("SELECT count(*) from chatNickNames where MSISDN=N'" + the_msisdn+"'");             
   while(rs.next()){msisdn_foundbefore = rs.getInt(1);} rs.close();rs = null;
   
   
   int nickname_foundbefore=0;
   rs = con.createStatement().executeQuery("SELECT count(*) from chatNickNames where MessageContents=N'" + the_nickname+"'");             
   while(rs.next()){nickname_foundbefore = rs.getInt(1);} rs.close();rs = null;
   


      
   if(msisdn_foundbefore ==0 && nickname_foundbefore ==0 && the_msisdn.length() >0 &&  the_nickname.length() >0 )
   {
    try{
        con.createStatement().execute("insert into chatNickNames(originalid,msisdn,messagecontents) values (0,'" + the_msisdn + "', N'" + the_nickname + "')" );
       }catch(Exception e){}
   }
  

}






   

             
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




function thecorrectinvoke(whattocall)
{

if(whattocall == 0) {document.thethisfrm.action="thebatchNICKNAMESmodify.jsp";document.thethisfrm.submit();}
if(whattocall == 1) {document.thethisfrm.action="thebatchNICKNAMESdelete.jsp";document.thethisfrm.submit();}

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




function checkIt(evt) {
    evt = (evt) ? evt : window.event
    var charCode = (evt.which) ? evt.which : evt.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57)) 
    {

        alert("\u0627\u0631\u0642\u0627\u0645\u0020\u0641\u0642\u0637");
        return false
    }

    return true
}







function inscreasebalance(theID,appat)
{
var theusername = document.getElementById('id' + theID).value;


 var rep = prompt("\u0627\u062F\u062E\u0644\u0020\u0627\u0644\u0642\u064A\u0645\u0647\u0020\u0627\u0644\u0645\u0631\u0627\u062F\u0020\u0627\u0636\u0627\u0641\u062A\u0647\u0627\u0020\u0644\u0644\u0631\u0635\u064A\u062F",10);
 if(rep != null)
 {
 window.location.href= appat + "?increase=" + rep + "&id="+ theusername;
 }
}


</script>














<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000;background-color: #<%=bgcolor%>; }</style>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
<title>«·«”„«¡ «·„” ⁄«—Â ... <%= medianame %></title>

</head>


<BODY>




<%
String applicationAt = "http://" + request.getHeader("Host") +request.getContextPath() + "/addbalance.jsp";
//out.println(applicationAt);
%>



<table border='1' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%' height='80'>
  <tr>
    <td width='21%' align='center'><b><i><font color='#A36103' size='6'>«·«”„«¡ «·„” ⁄«—Â</font></i></b></td>
    

    
    
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
     		 <tr align='center'><td><input type='submit' name='subMain' value='«·ﬁ«∆„… «·—∆Ì”Ì…' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
                </form>
 		<form name='theform' action='nicknames.jsp' method='post'>
     		<tr align='center'><td><input type='submit' name='subRefresh' value='«⁄«œ…  Õ„Ì·' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
               </form>
    	</table>
    </td>
<td bgcolor='#ffffff' width='15%' align='center'><IMG src='logo.png'></td>
  </tr>
</table>


<br>







 


 
      	    <table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#000000' width='65%'>
      	    
 <form name=addfrm method='post' action="addnickname.jsp">


      	      <tr height='25' bgcolor=#DCDCDC>
       	        <td width='15%' align='center' bgcolor=#DCDCDC><b>—ﬁ„ «· ·Ì›Ê‰</b></td>
      	        <td width='45%' align='center' bgcolor=#DCDCDC><b>«·«”„ «·„” ⁄«—</b></td>
      	        <td width='10%' align='center' rowspan=2 bgcolor=#DCDCDC><input type='submit' name='subadd' value='«÷«›…' style='font-weight:bold ; width:5.5em ; height:2.5em' ></td>
      	      </tr>
      	      <tr>
      	        <td width='15%' align='center'><input type='text' style='font-size:12pt;color:#000000;font-weight:bold;width:10em;height:1.7em' dir='ltr' name='the_msisdn' ></td>
      	        <td width='55%' align='center'><input type='text' style='font-size:12pt;color:#000000;font-weight:bold;width:30em;height:1.7em' dir='rtl' name='the_nickname' ></td>
      	      </tr>
                </form>
      	    </table>
     
           
<br>












 
      	    <table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#000000' width='65%'>
      	    
 <form name=thisfrm method='post'>

      	      <tr height='25' bgcolor=#DCDCDC>
      	      <td colspan=3 width='15%' align='center' bgcolor=#DCDCDC><b>»ÕÀ</b></td>
      	      </tr>
      	      <tr height='25' bgcolor=#DCDCDC>
      	        <td width='15%' align='center' bgcolor=#DCDCDC><b>—ﬁ„ «· ·Ì›Ê‰</b></td>
      	        <td width='15%' align='center' bgcolor=#DCDCDC><b>«·«”„ «·„” ⁄«—</b></td>
      	        <td width='15%' align='center' rowspan=4 bgcolor=#DCDCDC><input type='submit' name='subsearch' value='»ÕÀ' style='font-weight:bold ; width:5.5em ; height:2.5em' ></td>      	        
      	      </tr>
      	      <tr>
      	        <td width='20%' align='center'>
      	        
      	          <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#000000' width='100%'>
      	            <tr>
      	                  <td width='50%' height=30 align='center'>
      	                  
      	                  <%
      	                  if(searchbyphone.equalsIgnoreCase("1"))
      	                  {
      	                  %>
                           <input type='radio' checked  name='searchbyphone' value='1'><font size='3'>&nbsp;ÌÕ ÊÌ ⁄·Ì</font>                             
                          <%
                          }
                          else
                          {
                          %>
                           <input type='radio' name='searchbyphone' value='1'><font size='3'>&nbsp;ÌÕ ÊÌ ⁄·Ì</font>                             
                          <%
                          }
                          %>                            
                           
                          </td>
                          
                          
                          <td width='50%' align='center'>
      	                  <%
      	                  if(searchbyphone.equalsIgnoreCase("2"))
      	                  {
      	                  %>
                          
                             <input type='radio' checked name='searchbyphone' value='2'><font size='3'>&nbsp;Ì»œ√ »</font>
                          <%
                          }
                          else
                          {
                          %>
                             <input type='radio'name='searchbyphone' value='2'><font size='3'>&nbsp;Ì»œ√ »</font>
                          <%
                          }
                          %>                            


                          </td>
      	            </tr>    
      	          </table>
      	              
      	        </td>
      	        
      	        
      	        
      	        
      	        
      	        
      	        
      	        
      	        
      	        
      	        <td width='20%' align='center'>
      	        
      	          <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#000000' width='100%'>
      	            <tr>
      	                  <td width='50%' height=30 align='center'>

      	                  <%
      	                  if(searchbynick.equalsIgnoreCase("1"))
      	                  {
      	                  %>
                           <input type='radio' checked  name='searchbynick' value='1'><font size='3'>&nbsp;ÌÕ ÊÌ ⁄·Ì</font>  
                          <%
                          }
                          else
                          {
                          %>
                           <input type='radio' name='searchbynick' value='1'><font size='3'>&nbsp;ÌÕ ÊÌ ⁄·Ì</font>  
                          <%
                          }
                          %>     


                           
                                                      
                          </td>
                          
                          <td width='50%' align='center'>
                          
                          
      	                  <%
      	                  if(searchbynick.equalsIgnoreCase("2"))
      	                  {
      	                  %>
                             <input type='radio' checked name='searchbynick' value='2'><font size='3'>&nbsp;Ì»œ√ »</font>
                          <%
                          }
                          else
                          {
                          %>
                             <input type='radio'name='searchbynick' value='2'><font size='3'>&nbsp;Ì»œ√ »</font>
                          <%
                          }
                          %>     

                          

                             
                             
                          </td>
      	            </tr>    
      	          </table>
      	          
      	        </td>
      	        
      	        

      	      </tr>
      	      


      	      <tr>
      	        <td width='15%' align='center'><input type='text' style='font-size:12pt;color:#000000;font-weight:bold;width:10em;height:1.7em' dir='ltr' name='the_msisdn' value='<%=msisdnsearchkeyword%>'></td>
      	        <td width='20%' align='center'><input type='text' style='font-size:12pt;color:#000000;font-weight:bold;width:10em;height:1.7em' dir='rtl' name='the_nickname' value='<%=  nicknamesearchkeyword %>'></td>
      	 
      	      </tr>





      	      <tr>
      	        <td width='15%' align='center'>
      	          <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#000000' width='100%'>
      	            <tr>
      	                  <td width='50%' height=30 align='center'>

      	                  <%
      	                  if(searchorderby.equalsIgnoreCase("1"))
      	                  {
      	                  %>
                           <input type='radio' checked  name='searchorderby' value='1'><font size='3'>&nbsp; — Ì»  ’«⁄œÌ</font>  
                          <%
                          }
                          else
                          {
                          %>
                           <input type='radio' name='searchorderby' value='1'><font size='3'>&nbsp; — Ì»  ’«⁄œÌ</font>  
                          <%
                          }
                          %>   
                         
                           
                           
                          </td>
                          
                          <td width='50%' align='center'>
                          
      	                  <%
      	                  if(searchorderby.equalsIgnoreCase("2"))
      	                  {
      	                  %>
                           <input type='radio' checked  name='searchorderby' value='2'><font size='3'>&nbsp; — Ì»  ‰«“·Ì</font>  
                          <%
                          }
                          else
                          {
                          %>
                           <input type='radio' name='searchorderby' value='2'><font size='3'>&nbsp; — Ì»  ‰«“·Ì</font>  
                          <%
                          }
                          %>   
                             
                          </td>
      	            </tr>    
      	          </table>
      	         </td>
      	         
      	         
      	         
      	        <td width='20%' align='center'>
      	          <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#000000' width='100%'>
      	            <tr>
      	                  <td width='50%' height=30 align='center'>

      	                  <%
      	                  if(searchorderby.equalsIgnoreCase("3"))
      	                  {
      	                  %>
                           <input type='radio' checked  name='searchorderby' value='3'><font size='3'>&nbsp; — Ì»  ’«⁄œÌ</font>  
                          <%
                          }
                          else
                          {
                          %>
                           <input type='radio' name='searchorderby' value='3'><font size='3'>&nbsp; — Ì»  ’«⁄œÌ</font>  
                          <%
                          }
                          %>   
                           
                           
                          </td>
                          
                          <td width='50%' align='center'>
                          
      	                  <%
      	                  if(searchorderby.equalsIgnoreCase("4"))
      	                  {
      	                  %>
                           <input type='radio' checked  name='searchorderby' value='4'><font size='3'>&nbsp; — Ì»  ‰«“·Ì</font>  
                          <%
                          }
                          else
                          {
                          %>
                           <input type='radio' name='searchorderby' value='4'><font size='3'>&nbsp; — Ì»  ‰«“·Ì</font>  
                          <%
                          }
                          %>  
                             
                          </td>
      	            </tr>    
      	          </table>      	        
      	          
      	          </td>
      	          
      	          

      	      </tr>

      	      
                </form>
      	    </table>
     
           




<%
int count=0;

String query="select count(*) from chatNickNames ";


if(searchbyphone.equalsIgnoreCase("1")){query= query + " where MSISDN like N'%" + msisdnsearchkeyword+ "%' ";}
if(searchbyphone.equalsIgnoreCase("2")){query= query + " where MSISDN like N'" + msisdnsearchkeyword+ "%' ";}

if(searchbynick.equalsIgnoreCase("1")){query= query + " and MessageContents like N'%" + nicknamesearchkeyword+ "%' ";}
if(searchbynick.equalsIgnoreCase("2")){query= query + " and MessageContents like N'" + nicknamesearchkeyword+ "%' ";}


  
  

 rs = con.createStatement().executeQuery(query);            


if(rs.next()){count = rs.getInt(1);}
rs.close(); rs = null;
%>
   
<br>
<table align='center' border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#AAAAAA' width='70%'>

<tr height='25' bgcolor=#DCDCDC>
 <td width='10%' align='center'><input type='submit' name='subApproveSMSSel' value='«·ﬂ·' style='font-weight:bold ; width:11em ; height:2.2em' onClick='selectall(<%= count %>)'></td>
 <td width='10%' align='center'><input type='submit' name='subApproveSMSSel' value=' ⁄œÌ·' style='font-weight:bold ; width:11em ; height:2.2em' onClick="thecorrectinvoke(0)"></td>
 <td width='10%' align='center'><input type='submit' name='subApproveSMSSel' value='Õ–›' style='font-weight:bold ; width:11em ; height:2.2em' onClick="thecorrectinvoke(1)"></td> 

 <td width='30%' align='center'>&nbsp;</td>
  
 <td align='center'>⁄œœ&nbsp;:&nbsp;<font size=5 color=#000000><b><%= count %></b></font></td>


 
 </tr>



   
</table>



     <table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#cccccc' width='70%'>

           	      <tr bgcolor=#DCDCDC height='25'>
           	      
         	    <td width='5%' align='center'><b>&nbsp;</b></td>
                <td width='10%' align='center'><b>—ﬁ„ «· ·Ì›Ê‰</b></td>
      	        <td width='40%' align='center'><b>«·«”„ «·„” ⁄«—</b></td>
                <td width='20%' align='center'><b> «—ÌŒ «· ”ÃÌ·</b></td>                
              </tr>

<form name=thethisfrm method=post action="">
<INPUT type='hidden' NAME=count SIZE=6  READONLY value="<%= count %>" > 

<% 
  query ="select originalid,msisdn, MessageContents , (  CONVERT(char(10), lastmessage, 111) + ' ' + convert(varchar,lastmessage , 8) ) as TheDate  FROM  chatNickNames ";
  
if(searchbyphone.equalsIgnoreCase("1")){query= query + " where MSISDN like N'%" + msisdnsearchkeyword+ "%' ";}
if(searchbyphone.equalsIgnoreCase("2")){query= query + " where MSISDN like N'" + msisdnsearchkeyword+ "%' ";}

if(searchbynick.equalsIgnoreCase("1")){query= query + " and MessageContents like N'%" + nicknamesearchkeyword+ "%' ";}
if(searchbynick.equalsIgnoreCase("2")){query= query + " and MessageContents like N'" + nicknamesearchkeyword+ "%' ";}


if(searchorderby.equalsIgnoreCase("1")){query = query + "  order by  MSISDN asc ";}
if(searchorderby.equalsIgnoreCase("2")){query = query + "  order by  MSISDN desc ";}
if(searchorderby.equalsIgnoreCase("3")){query = query + "  order by  MessageContents asc ";}
if(searchorderby.equalsIgnoreCase("4")){query = query + "  order by  MessageContents desc ";}

  


   rs = null;
   rs = con.createStatement().executeQuery(query);  

 // out.println(query);
  
 int therownnum =0;  
while(rs.next())
{
%>

<%
if(therownnum%2 ==0)
{
%>
          <tr bgcolor=#ffffff height='25'>
<%
}
else
{
%>
          <tr bgcolor=#f4f4f4 height='25'>
<%
}
%>
          
<%
 
String theoriginalid = rs.getString(1);
String themsisdn = rs.getString(2);
String thenickname = rs.getString(3);
String theregistrationdate = rs.getString(4);


%>



                   <INPUT type='hidden' NAME=id<%= therownnum %> value="<%= theoriginalid %>" >        
                   <INPUT type='hidden' NAME=themsisdnorig<%= therownnum %> value='<%=themsisdn%>' >
     
                   <td width='1%' align='center'>  <INPUT id="ischeck<%= therownnum %>" NAME=ischeck<%= therownnum %> TYPE=CHECKBOX >  </td>
                   <td width='10%' align='center'><INPUT dir='ltr' style='font-size:12pt;color:#000000;font-weight:bold;width:12em;height:1.7em' NAME=themsisdn<%= therownnum %> value='<%=themsisdn%>' ></td>                   
                   <td width='40%' align='center'><INPUT dir='rtl' style='font-size:12pt;color:#000000;font-weight:bold;width:30em;height:1.7em' id="thenickname<%=therownnum%>" NAME=thenickname<%= therownnum %> value='<%= thenickname %>' ></td>                   
                   <td width='20%' align='center'><font size='4'><%=theregistrationdate%></font></td>                   


         
                                
                    
 </tr>
 

<%
therownnum = therownnum + 1;
}rs.close();rs=null;
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
