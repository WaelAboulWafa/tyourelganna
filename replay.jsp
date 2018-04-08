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
   if(thepage[k].equalsIgnoreCase("replay.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
//   if(thepage[k].equalsIgnoreCase("filterationtemp.jsp")){if(allowed[k] == 1){allowedaccess =true;}}      
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














String theSdate =(new SimpleDateFormat("yyyyMMdd")).format(new java.util.Date((new java.util.Date()).getTime() - (1000 * 60 * 60 * 24 * 1) )).trim();
String theEdate =(new SimpleDateFormat("yyyyMMdd")).format(new java.util.Date((new java.util.Date()).getTime())).trim();

   
 
String fdate = "";try{fdate = request.getParameter("fdate").trim();}catch(Exception e){fdate = theSdate;}
String tdate = "";try{tdate = request.getParameter("tdate").trim();}catch(Exception e){tdate = theEdate;}

   



















  int reccount = 0;
     String[] id = null;
     String[] sentdate =  null;
     String[] shortcode = null;
     String[] operator = null;
     String[] tel = null;
     String[] nickname = null;
     String[] msg = null;
     String[] messagetarget = null;
     
     String[] media = null;
     String[] themedianame = null;
     String[] barname = null;
     
          
     int visiblecount = 0 ;

int whenrejectcount = 0;    




String filtertheshortcode = "ALL";try{filtertheshortcode = request.getParameter("filtertheshortcode").trim();}catch(Exception e){filtertheshortcode = "ALL";}

String filterthemediacode = "4";try{filterthemediacode = request.getParameter("filterthemediacode").trim();}catch(Exception e){filterthemediacode = "4";}

//out.println(filterthemediacode);

String today =    ((new SimpleDateFormat ("yyyyMMdd")).format(new java.util.Date(((new java.util.Date().getTime()) )))).trim();


//-----------------------------------
String query1 = "SELECT count(*) from chatReplay where CONVERT(char(10), approvedat, 112) between '"+ fdate + "' and '"+ tdate+ "' " ;
String query2 = "SELECT ID from chatReplay where CONVERT(char(10), approvedat, 112) between '"+ fdate + "' and '"+ tdate+ "' " ;
String query3 = " select ID, MSISDN, MessageContents, CONVERT(char(10), approvedat, 101) + ' ' + CONVERT(varchar, approvedat, 8) AS approvedat  FROM         chatReplay where CONVERT(char(10), approvedat, 112)  between '"+ fdate + "' and '"+ tdate+ "' " ;


if(!filtertheshortcode.equalsIgnoreCase("all"))
{
query1= query1 + " and substring ((CONVERT(nvarchar, approvedat, 111) + ' ' + convert(varchar,approvedat, 8)),12,2) = '"+ filtertheshortcode +"'";
query2= query2 + " and substring ((CONVERT(nvarchar, approvedat, 111) + ' ' + convert(varchar,approvedat, 8)),12,2) = '"+ filtertheshortcode +"'";
query3= query3 + " and substring ((CONVERT(nvarchar, approvedat, 111) + ' ' + convert(varchar,approvedat, 8)),12,2) = '"+ filtertheshortcode +"'";

}



query2 = query3 + " ORDER BY ID";
query3 = query3 + " ORDER BY ID";
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
     sentdate =  new String[visiblecount];
     shortcode = new String[visiblecount];
     tel = new String[visiblecount];
     nickname = new String[visiblecount];
     msg = new String[visiblecount];
    
   
   rs.next();
   //int theCounter = 0;
   //while(rs.next())
for (int theCounter=0;theCounter<visiblecount;theCounter++)
    {
     id[theCounter] = rs.getString(1).trim();
     tel[theCounter] = rs.getString(2).trim();
     msg[theCounter] = rs.getString(3).trim(); 
     sentdate[theCounter] =  rs.getString(4).trim();       
 
     
     
     rs.next();
    // theCounter = theCounter + 1 ;
   }
   rs.close(); 
   rs = null;
   
   
   
   

   
   






















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






   
   


   
//con.close();   
   









             
%>



































<html dir='rtl'>
<HEAD>

<link rel="stylesheet" type="text/css" href="datepicker.css"/>
<script type="text/javascript" src="datepicker.js"></script>
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
if(target == 1) {document.mainform.action="replayBATCHApprove.jsp";document.mainform.submit();}
if(target == 80) {document.mainform.action="replayBATCHApprovethendelete.jsp";document.mainform.submit();}
if(target == 2) {document.mainform.action="replayBATCHReject.jsp";document.mainform.submit();}
if(target == 251) {document.mainform.action="replaydeleteall.jsp";document.mainform.submit();}

}


 





</script>





























<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000;background-color: #<%=bgcolor%>; }</style>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
<title>≈⁄«œÂ... <%= medianame %></title>

</head>


<BODY>





<table border='1' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%' height='80'>
  <tr>
    <td width='21%' align='center'><b><i><font color='#A36103' size='6'>≈⁄«œÂ</font></i></b></td>
    
   
    
    
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
     		 <tr align='center' ><td><input type='submit' name='subMain' value='«·ﬁ«∆„… «·—∆Ì”Ì…' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
                </form>
 		<form name='theform' action='replay.jsp' method='post'>
     		<tr align='center' ><td><input type='submit' name='subRefresh' value='«⁄«œ…  Õ„Ì·' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
               </form>
    	</table>
    </td>
    <td bgcolor='#FFFFFF' width='15%' align='center'><IMG src='logo.png'></td>
  </tr>
</table>


  

<br>


 

  






























<%
if(pages>0)
{
%>


            <table border='1' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='90%'>
                  <tr height='20'>
                    <td align='center' width='4%'>

<%
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
                  <b><a href=replay.jsp?offset=<%= i %>&filtertheshortcode=<%= URLEncoder.encode(filtertheshortcode)%>&filterthemediacode=<%= URLEncoder.encode(filterthemediacode)%>&fdate=<%= URLEncoder.encode(fdate)%>&tdate=<%= URLEncoder.encode(tdate)%> ><%= Integer.toString(i+1) %> </a>&nbsp;</b>
<%
   }
   
  }
%>
                    </td>
                  </tr>
            </table>





            <table border='0' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='90%'>
                  <tr>
                             <td width='15%' align='center'><b>⁄œœ</b></td>
                             <td width='15%' align='center'><font color=#000099><b><%= reccount %></b></font></td>
                             <td width='40%' align='center'>&nbsp;</td>
                             <td width='15%' align='center'><b>’›Õ…</b></td>
                             <td width='15%' align='center'><font color=#000099><b><%= (offset +1)%>&nbsp/&nbsp;<%= pages %></b></font></td>
                                                            
                   </tr>                                         

            </table>

  

<%
}
%>          











<br>



























            <table border='1' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='70%'>
                  <tr>
                  
                  
                        <td>
                              <table border='0' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                    <tr>
                                          <td align='center'>
                                                      
                                                       
<form name=thesearchform method=post action="replay.jsp" >

 

                                                     

                                           </td>
                                       </tr>
                                   </table>
                                   
                                          </td>
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          
                                          


                        <td>
                              <table border='0' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                    <tr >
                                          <td align='center'>
                                                      
                                                       

<select name='filtertheshortcode' style='font-weight:bold ; color:#000099'  onChange='javascript:document.thesearchform.submit();'>


                                       <option value='ALL'>«·ﬂ· «·”«⁄« </option>







<%
if(filtertheshortcode.equalsIgnoreCase("00"))
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
if(filtertheshortcode.equalsIgnoreCase("01"))
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
if(filtertheshortcode.equalsIgnoreCase("02"))
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
if(filtertheshortcode.equalsIgnoreCase("03"))
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
if(filtertheshortcode.equalsIgnoreCase("04"))
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
if(filtertheshortcode.equalsIgnoreCase("05"))
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
if(filtertheshortcode.equalsIgnoreCase("06"))
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
if(filtertheshortcode.equalsIgnoreCase("07"))
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
if(filtertheshortcode.equalsIgnoreCase("08"))
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
if(filtertheshortcode.equalsIgnoreCase("09"))
{
%>
                                       <option selected value='09'>„‰ 9 «·Ì 10</option>
<%
}
else
{
%>
                                       <option value='09'>„‰ 9 «·Ì 10</option>
<%
}
%>



<%
if(filtertheshortcode.equalsIgnoreCase("10"))
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
if(filtertheshortcode.equalsIgnoreCase("11"))
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
if(filtertheshortcode.equalsIgnoreCase("12"))
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
if(filtertheshortcode.equalsIgnoreCase("13"))
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
if(filtertheshortcode.equalsIgnoreCase("14"))
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
if(filtertheshortcode.equalsIgnoreCase("15"))
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
if(filtertheshortcode.equalsIgnoreCase("16"))
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
if(filtertheshortcode.equalsIgnoreCase("17"))
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
if(filtertheshortcode.equalsIgnoreCase("18"))
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
if(filtertheshortcode.equalsIgnoreCase("19"))
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
if(filtertheshortcode.equalsIgnoreCase("20"))
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
if(filtertheshortcode.equalsIgnoreCase("21"))
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
if(filtertheshortcode.equalsIgnoreCase("22"))
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
if(filtertheshortcode.equalsIgnoreCase("23"))
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

                                          
                                          
   
   
   
   
                           <td>
                              <table border='0' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='80%'>
                                          <td width='10%' align='center'><b><input type=button value="„‰" onclick="displayDatePicker('fdate', this);"></td>
                                          <td width='20%' align='center'><input  style='font-weight:bold ; color:#000099;width:6em' dir='ltr' type="text"  name="fdate" id="idate" value='<%=fdate%>' ></td>
                                          <td width='10%' align='center'>&nbsp;</td>
                                          <td width='10%' align='center'><b><input type=button value="≈·Ì" onclick="displayDatePicker('tdate', this);"></b></td>
                                          <td width='20%' align='center'><input  style='font-weight:bold ; color:#000099;width:6em' dir='ltr' type="text"  readonly name="tdate" id="idate" value='<%=tdate%>'></td>
                                          <td width='20%' align='center'>&nbsp;</td>
                                          <td width='20%' align='right'><input type='submit' name='subReport' value='»ÕÀ' STYLE='font-weight:bold ; color:#00; width:8em; height:2em'></td>
                              </table>
                        </td>
                                                               
                                          
                                          
 </form>                                         

                                    </tr>
                                    
                                    
                              </table>


  













<br>



















            <table border='1' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='50%'>
                  <tr>
                        <td>
                              <table border='0' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                    <tr>
                                          <td width='5%' align='center'>
                                                <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>

                                                      <tr>
                                                      <td align='center'>
                                                          <input type='submit' name='subSelectAll' value='«·ﬂ·' style='font-weight:bold ; width:8em ; height:2em' onClick="selectall(<%= reccount %>)">
                                                      </td>
                                                      </tr>
                                                </table>
                                          </td>


                                          <td width='25%' align='center'>&nbsp;</td>
                                          <td width='10%' align='center'><input type='submit' name='subApproveSMSSel' value='≈⁄«œÂ »œÊ‰ Õ–›' style='font-weight:bold ; color:#0000AA; width:11em ; height:2em' onClick="correctinvoke(1)"></td>
                                          <td width='10%' align='center'><input type='submit' name='subApproveSMSSel' value='≈⁄«œÂ À„ Õ–›' style='font-weight:bold ; color:#AA0000; width:11em ; height:2em' onClick="correctinvoke(80)"></td>
                                          
                                          <td width='15%' align='center'><input type='submit' name='subDeclineSMSSel' value='Õ–›' style='font-weight:bold ; width:6em ; color:#FF0000; height:2em' onClick="correctinvoke(2)"></td>
                                           
                                          <td width='25%' align='center'></td>

                                          <td width='50%' align='center'>&nbsp;</td>
                                          
                                    </tr>
                              </table>
                        </td>
                  </tr>
            </table>

  















            <table border='1' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='50%'>
                  <tr>
                        <td>
                              <table border='0' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                    <tr>

                                          <td width='15%' align='center'><input type='submit' name='subDeclineSMSSel' disabled value='Õ–› «·ﬂ·' style='font-weight:bold ; width:10em ; color:#FF0000; height:2em' onClick="correctinvoke(251)"></td>
                                          
                                    </tr>
                              </table>
                        </td>
                  </tr>
            </table>




















            
            
            
            
            
            
            
            

      <br>



































     <table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#cccccc' width='80%'>
             <tr bgcolor=#DCDCDC>
                  <td width='5%' align='center'><b>&nbsp;</b></td>

         
                  <td width='35%' align='center'><b>‰’ «·—”«·Â</b></td>
                  <td width='10%' align='center'><b> «—ÌŒ «·«—”«·</b></td>
                  <td width='10%' align='center'><b> ·Ì›Ê‰</b></td>


               
            </tr>
     


<form name=mainform method=post action="" >

<INPUT style="display: none;" NAME=theoffset SIZE=10  value="<%= lowerbound %>" > 
<INPUT style="display: none;" NAME=countrysc SIZE=10  value="<%= filtertheshortcode %>" > 
<INPUT style="display: none;" NAME=thebase SIZE=10  value="<%= offset %>" > 


<INPUT style="display: none;" NAME=fdate SIZE=10  value="<%= fdate %>" > 
<INPUT style="display: none;" NAME=tdate SIZE=10  value="<%= tdate %>" > 

<INPUT style="display: none;" NAME=count SIZE=10  value="<%= reccount %>" > 

<% int therownnum =0; %>

<% for (int l =lowerbound ; l < upperbound ; l ++)
{
%>

<%
if(therownnum%2 ==0)
{
%>
          <tr bgcolor=#ffffff>
<%
}
else
{
%>
          <tr bgcolor=#f4f4f4>
<%
}
%>
           


             <INPUT type='hidden' NAME=id<%= l %> SIZE=6  READONLY value="<%= id[l] %>" >
             <input type='hidden' NAME=msg<%= l %>  value="<%=  msg[l]  %>" >
             <INPUT type='hidden' NAME=tel<%= l %> SIZE=17  READONLY value="<%= tel[l] %>" >

  
            <td align='center'>  <INPUT  id="ischeck<%= l %>" NAME=ischeck<%= l %> TYPE=CHECKBOX >  </td>
    
            <td align='center' dir='rtl'>  <b><font color=#000000 size=4>  <%= msg[l]  %> </td></font></b></td>   	    
    	    <td align='center' dir='ltr'> <b><font color=#000000 size=4>  <%= sentdate[l] %> </td></font></b></td>
    	    
    	    
    	    





    	    


<%    	    
if(phoneallowed == 1)
{
%>
    	    <td align='center' dir='ltr'><b><font color=#000000 size=4><%= tel[l] %></font></b></td>
<%
}
else
{
%>
    	    <td align='center' dir='rtl'><b><font color=#000000 size=4> ·«  ÊÃœ ’·«ÕÌÂ</font></b></td>
<%
}
%>




 




           </tr>            
<%
therownnum = therownnum + 1;
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

