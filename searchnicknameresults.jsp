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
//   if(thepage[k].equalsIgnoreCase("autorities.jsp")){if(allowed[k] == 1){allowedaccess =true;}}                           
  }
  
  


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











  int maxid= 0;
   rs = con.createStatement().executeQuery("SELECT     max(animation) FROM         chatNickNames");             
   while(rs.next()){maxid = rs.getInt(1);}
   rs.close();rs = null;
















  int reccount = 0;
     String[] id = null;
     String[] sentdate =  null;
     String[] shortcode = null;
     String[] operator = null;
     String[] tel = null;
     String[] nickname = null;
     String[] msg = null;

     String[] theimage=null;
          
     int visiblecount = 0 ;

int whenrejectcount = 0;    


String filtershortcode = "ALL";



  String nick="";
  try{ nick = request.getParameter("nick");}catch(Exception e){nick="";}
  
  String telrec="";
  try{ telrec = request.getParameter("tel");}catch(Exception e){telrec="";}

String query1 ="";String query2="";String query3="";

if( (nick.length() > 0) && (telrec.length() ==0) )
{
 query1 = "SELECT count(*) from chatNickNames where MessageContents like N'%"+ nick + "%'";
 query2 = "SELECT OriginalID from chatNickNames  where MessageContents like N'%"+ nick + "%' order by OriginalID";
 query3 = " select originalid,msisdn, MessageContents , (  CONVERT(char(10), lastmessage, 101) + ' ' + convert(varchar,lastmessage , 8) ) as TheDate , animation FROM  chatNickNames  where MessageContents like N'%"+ nick + "%' order by  lastmessage desc";
}

if( (nick.length() == 0) && (telrec.length()  > 0) )
{
 query1 = "SELECT count(*) from chatNickNames where MSISDN like N'%" + telrec + "%'";
 query2 = "SELECT OriginalID from chatNickNames  where MSISDN like N'%" + telrec + "%' order by OriginalID";
 query3 = " select originalid,msisdn, MessageContents , (  CONVERT(char(10), lastmessage, 101) + ' ' + convert(varchar,lastmessage , 8) ) as TheDate , animation FROM  chatNickNames  where MSISDN like N'%" + telrec + "%' order by  lastmessage desc";
}


if( (nick.length() > 0) && (telrec.length()  > 0) )
{
 query1 = "SELECT count(*) from chatNickNames where MessageContents like N'%"+ nick + "%' or MSISDN like N'%" + telrec + "%'";
 query2 = "SELECT OriginalID from chatNickNames  where MessageContents like N'%"+ nick + "%' or MSISDN like N'%" + telrec + "%' order by OriginalID";
 query3 = " select originalid,msisdn, MessageContents , (  CONVERT(char(10), lastmessage, 101) + ' ' + convert(varchar,lastmessage , 8) ) as TheDate , animation FROM  chatNickNames  where MessageContents like N'%"+ nick + "%' or MSISDN like N'%" + telrec + "%' order by  lastmessage desc";
}


if( (nick.length() == 0) && (telrec.length()  == 0) )
{
 query1 = "SELECT count(*) from chatNickNames ";
 query2 = "SELECT OriginalID from chatNickNames  order by OriginalID";
 query3 = " select originalid,msisdn, MessageContents , (  CONVERT(char(10), lastmessage, 101) + ' ' + convert(varchar,lastmessage , 8) ) as TheDate , animation FROM  chatNickNames  order by  lastmessage desc";
}

















    

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
     tel = new String[visiblecount];
     nickname = new String[visiblecount];
     sentdate =  new String[visiblecount];
     
     theimage =  new String[visiblecount];
   
   rs.next();
   //int theCounter = 0;
   //while(rs.next())
for (int theCounter=0;theCounter<visiblecount;theCounter++)
    {
     id[theCounter] = rs.getString(1).trim();
     tel[theCounter] = rs.getString(2).trim();
     nickname[theCounter] = rs.getString(3).trim();
     sentdate[theCounter] =  rs.getString(4).trim();

     theimage[theCounter] =  rs.getString(5).trim();
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
   rs = con.createStatement().executeQuery("SELECT     (country + '-' +  operator + '-' +  Providername + '-' +  shortcode) as theprov FROM         Providers ORDER BY ProviderID");

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






   
   
/*   
   String thefirstid = "0";
   String thefirstmessage="";
   String thefirstmsisdn = "";
   if(visiblecount > 0)
   { 
     thefirstid = id[lowerbound];
     thefirstmessage = msg[lowerbound];
     thefirstmsisdn =tel[lowerbound];
   }
*/


   
con.close();   
   

             
%>



































<html dir='rtl'>
<HEAD>


<script LANGUAGE="JavaScript" type="text/javascript">

function correctinvoke(target)
{
if(target == 0) {document.myform.action="addnickname.jsp";document.myform.submit();}
if(target == 1) {document.myform.action="modifynickname.jsp";document.myform.submit();}
if(target == 2) {document.myform.action="deletenickname.jsp"; document.myform.submit();}
if(target == 3) {document.myform.action="searchnicknameresults.jsp"; document.myform.submit();}
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



function deselectall(m)
{
	for( i=0; i < m; i++ )
	{ 
	 if( document.getElementById('ischeck' + i) != null )  
     { 
	  document.getElementById('ischeck' + i).checked = false; 
	 }
	}
}



function rejectselected(totalcount)
{
// alert(totalcount);
 var querystr = "";
 for( i=0; i< totalcount; i++ )
 {
 
   if( document.getElementById('ischeck' + i) != null )  
   {
    if( (document.getElementById('ischeck' + i).checked) == true )
    {
     querystr= querystr + "id" + i + "=" + document.getElementById('id' + i).value + "&";
    }
   }
 }

//alert(querystr);

if( validatexist(totalcount) == true )
{  
  //var TheURL = "http://217.52.28.154:7077/amaken/BATCHReject.jsp?" + "count="+ totalcount +"&"+ querystr;
  var TheURL = "http://localhost:7077/amaken/BATCHReject.jsp?" + "count="+ totalcount +"&"+ querystr;  

  
  var thecntry = document.getElementById('countrysc').value;
  
  var theb = document.getElementById('thebase').value;
  TheURL = TheURL + "&countrysc=" + thecntry+ "&thebase=" + theb;

// TheURL = TheURL + "&countrysc=" + thecntry;

  window.location.href= TheURL ;
}

}





function validatexist(totalcount)
{
var someselected = false;

 for( i= 0; i< totalcount; i++ )
 {
 
  if( document.getElementById('ischeck' + i) != null )  
  { 
   if( (document.getElementById('ischeck' + i).checked) == true )
   {
     someselected = true;
   }
  }
  
 }
 

 
 if(someselected == false)
 {
 alert ("\u0644\u0645\u0020\u064A\u062A\u0645\u0020\u0627\u062E\u062A\u064A\u0627\u0631\u0020\u0634\u0626");
 return (false);
 }
 else
 {return (true);}
 
  

  
}
</script>





























<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000 } Table {font:12pt } </style>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
<title>«·«”„«¡ «·„” ⁄«—Â ... ﬁ‰«… Â·« «·›÷«∆ÌÂ</title>

</head>


<BODY>



















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
     		 <tr><td align='center'> <input type='submit' name='subMain' value='«·ﬁ«∆„… «·—∆Ì”Ì…' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
                </form>
 		<form name='theform' action='nicknames.jsp' method='post'>
     		<tr><td align='center'><input type='submit' name='subRefresh' value='«⁄«œ…  Õ„Ì·' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
               </form>
    	</table>
    </td>
<td bgcolor='#ffffff' width='15%' align='center'><IMG src='logo.png'></td>
  </tr>
</table>




<br>





      <table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='15%'>

            <tr bgcolor=#DCDCDC>

                  <td width='60%' align='center'>
                    <b>
                       <font color='#000000'>«Œ— ﬂÊœ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font><font color='#000000' size=5><%=maxid%></font>
                    </b>
                  </td>


            </tr>
      </table>
      
      
      
      <br>








      <br>

      <table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#cccccc' width='50%'>
      <form  METHOD="post" NAME="myform" ACTION="">
            <tr bgcolor=#DCDCDC height='25'>
                  <td width='30%' align='center'><b>—ﬁ„ «· ·Ì›Ê‰</b></td>
                  <td width='70%' align='center'><b>«·«”„ «·„” ⁄«—</b></td>
                  <td width='10%' align='center'><b>«·’Ê—Â</b></td>                   
            </tr>
            <tr bgcolor=#FFFFFF>
                  <td width='30%' align='center'><b><input type='text' name='tel' value='' STYLE='width:11em'></b></td>
                  <td width='70%' align='center'><b><input type='text' name='nick' value='' STYLE='width:26em'></b></td>
                  <td width='10%' align='center'><b><input type='text' name='image' value='0' STYLE='width:4em'></b></td>                      
            </tr>
      </form>
      </table>

      
      <table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#cccccc' width='40%'>
            <tr bgcolor=#DCDCDC>
                  <td align='center'><b>-</b></td>
            </tr>
      </table>
      <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111'>
            <tr>

                        <td width='25%' align='center'><input type='submit' onClick="correctinvoke(0)" name='subAdd' value='«÷«›…' style='font-weight:bold ; width:6em ; height:3em'></td>
                        <td width='25%' align='center'><input type='submit' onClick="correctinvoke(1)"  name='subUpdate' value=' ⁄œÌ·' style='font-weight:bold ; width:6em ; height:3em'></td>
                        <td width='25%' align='center'><input type='submit' onClick="correctinvoke(2)"  name='subDelete' value='„”Õ' style='font-weight:bold ; width:6em ; height:3em'></td>
                        <td width='25%' align='center'><input type='submit' onClick="correctinvoke(3)" name='subSearch' value='»ÕÀ' style='font-weight:bold ; width:6em ; height:3em'></td>
                        
            </tr>
      </table>
      
	<br>


























            <br>







            <table border='1' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='80%'>
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
                  <b><a href=nicknames.jsp?offset=<%= i %>&filtertheshortcode=<%= URLEncoder.encode(filtershortcode)%> ><%= Integer.toString(i+1) %> </a>&nbsp;</b>
<%
   }
   
  }
}
%>
                    </td>
                  </tr>
            </table>







	
      <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='80%'>

            <tr bgcolor=#DCDCDC>
                  <td width='20%' align='left'>-</td>
                  <td width='60%' align='center'>
                    <b>
                       <font color='#000000'>⁄œœ «·«”„«¡ «·„” ⁄«—… = </font><font color='#FF0000'><%= reccount %></font><font color='#000000'> , ⁄œœ «·’›Õ«  = </font><font color='#FF0000'><%= pages %></font><font color='#000000'> , ’›Õ… </font><font color='#FF0000'><%= (offset +1)%></font><font color='#000000'> „‰ </font><font color='#FF0000'><%= pages %></font>
                    </b>
                  </td>

                  <td width='20%' align='right'>-</td>
            </tr>
      </table>


      <br>



































<table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#888888' width='80%'>
  <tr bgcolor=#FAA5A5 height=25>
    <td width='15%' align='center'><b>—ﬁ„ «· ·Ì›Ê‰</b></td>
    <td width='40%' align='center'><b>«·«”„ «·„” ⁄«—</b></td>
    <td width='20%' align='center'><b>Êﬁ  «Œ— —”«·… ﬁ’Ì—…</b></td>
    <td width='10%' align='center'><b>’Ê—Â</b></td>    

<form name=mainform method=post action="BATCHApprove.jsp" onsubmit="return validatexist(<%= visiblecount %>)">

<INPUT style="display: none;" NAME=theoffset SIZE=10  value="<%= lowerbound %>" > 
<INPUT style="display: none;" NAME=countrysc SIZE=10  value="<%= filtershortcode %>" > 
<INPUT style="display: none;" NAME=thebase SIZE=10  value="<%= offset %>" > 
 </tr>

<% for (int l =lowerbound ; l < upperbound ; l ++)
{
%>

                      <tr bgcolor=#F9D8D8  height=25>
                           <td width='20%' align='center'><b><%= tel[l] %> </b></td>
                           <td width='40%' align='center'><b><%= nickname[l] %></b></td>
                           <td width='20%' align='center'><b><%= sentdate[l] %></b></td>

                           <td width='10%' align='center'><b><font size='5'><%= theimage[l] %></font></b></td>                          
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
}
}
%>
