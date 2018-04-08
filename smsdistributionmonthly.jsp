<%@ page contentType="text/html;charset=windows-1256"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="org.jfree.chart.*" %>
<%@ page import="org.jfree.chart.*" %>
<%@ page import="org.jfree.chart.*" %>
<%@ page import="org.jfree.chart.plot.*"%>
<%@ page import="org.jfree.data.*" %>
<%@ page import="org.jfree.data.jdbc.*"%>
<%@ page import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>

 

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
//   if(thepage[k].equalsIgnoreCase("smscount.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
   if(thepage[k].equalsIgnoreCase("smsdistribution.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
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
   
 
String fdate = "";try{fdate = request.getParameter("fdate").trim();}catch(Exception e){fdate = theSdate;}

//String requiredyear = "2010"; String requiredmonth = "01";

String requiredyear = (new SimpleDateFormat("yyyy")).format(new java.util.Date((new java.util.Date()).getTime())).trim(); String requiredmonth = (new SimpleDateFormat("MM")).format(new java.util.Date((new java.util.Date()).getTime())).trim();

if( request.getParameter("theyear")!=null){requiredyear= request.getParameter("theyear");} 
if( request.getParameter("themonth")!=null){requiredmonth= request.getParameter("themonth");}
String thisMonth= requiredyear + requiredmonth;
String query = "select  right(convert(nvarchar,cdrs.In_Time,112),2)  as TheDay , sum(sms_length) as TheCount  from cdrs  where  left(CONVERT(char(10), In_Time, 112) , 6) = '"+ thisMonth +"' and provider <> 'control'  group by convert(nvarchar,cdrs.In_Time,112) order by convert(nvarchar,cdrs.In_Time,112)";


//-----------------------------------
String filtershortcode = "ALL";

if( request.getParameter("filtertheshortcode")!=null) 
{
 if( !(request.getParameter("filtertheshortcode").trim().equalsIgnoreCase("ALL")) ) 
 { 
  filtershortcode= request.getParameter("filtertheshortcode");
StringTokenizer st = new StringTokenizer(filtershortcode,"-");
String thecountry="";String theoperator="";String theprovider="";String theshortcode="";
try{thecountry=st.nextToken().trim();}catch(Exception e){thecountry="";}
try{theoperator=st.nextToken().trim();}catch(Exception e){theoperator="";}
try{theprovider=st.nextToken().trim();}catch(Exception e){theprovider="";}
try{theshortcode=st.nextToken().trim();}catch(Exception e){theshortcode="";}
query = "select  right(convert(nvarchar,cdrs.In_Time,112),2)  as TheDay , sum(sms_length) as TheCount   from cdrs  where  left(CONVERT(char(10), In_Time, 112) , 6) = '"+ thisMonth +"'   and Country='"+thecountry+"' and Operator ='"+theoperator+"' and Provider ='"+theprovider+"' and ShortCode ='"+theshortcode+"' group by convert(nvarchar,cdrs.In_Time,112) order by convert(nvarchar,cdrs.In_Time,112)"; 
 }
}
///-----------------------------------

   

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



   

             
%>




























































<html dir=rtl>

<head>
<link rel="stylesheet" type="text/css" href="datepicker.css"/>
<script type="text/javascript" src="datepicker.js"></script>
<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000;background-color: #<%=bgcolor%>; }</style>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
<title> Ê“Ì⁄ ‘Â—Ì ... <%= medianame %></title>
</head>

<body>

 

 

<form action='MainPage.jsp' method='post'>
<input type='hidden' name='uid' value='41'>
<table border='1' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%' height='80'>
  <tr>
    <td width='21%' align='center'><b><i><font color='#A36103' size='6'> Ê“Ì⁄ ‘Â—Ì</font></i></b></td>
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
		<form action='smsdistributionmonthly.jsp' method='post'>
		<input type='hidden' name='uid' value='41'>
                <tr><td align='center'><input type='submit' name='subRefresh' value='«⁄«œ…  Õ„Ì·' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
                </form>
    	</table>
    </td>
    <td bgcolor='#ffffff' width='15%' align='center'><IMG src='logo.png'></td>
  </tr>
</table>
<br>       
            <table border='1' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='50%'>
                  <tr>
                        <td>
                              <table border='0' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                    <tr>
<td width='25%' align='center'>


<form name=thescform method=post action="smsdistributionmonthly.jsp" >

<select name='filtertheshortcode' style='font-weight:bold ; color:#000000'  >
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



</td>










 
<td width='25%' align='center'>
<select dir=rtl  name='themonth' style='font-size:12pt;color:#000000;font-weight:bold;width:5em;height:1.7em' dir='rtl'>

<%
if( requiredmonth.equalsIgnoreCase("01"))
{
%>
        <option value='01' selected>Ì‰«Ì—</option>
<%
}
else
{
%>     
   <option value='01' >Ì‰«Ì—</option>
<%
}
%>




<%
if( requiredmonth.equalsIgnoreCase("02"))
{
%>
        <option value='02' selected>›»—«Ì—</option>
<%
}
else
{
%>     
   <option value='02' >›»—«Ì—</option>
<%
}
%>



<%
if( requiredmonth.equalsIgnoreCase("03"))
{
%>
        <option value='03' selected>„«—”</option>
<%
}
else
{
%>     
   <option value='03' >„«—”</option>
<%
}
%>



<%
if( requiredmonth.equalsIgnoreCase("04"))
{
%>
        <option value='04' selected>«»—Ì·</option>
<%
}
else
{
%>     
   <option value='04' >«»—Ì·</option>
<%
}
%>



<%
if( requiredmonth.equalsIgnoreCase("05"))
{
%>
        <option value='05' selected>„«ÌÊ</option>
<%
}
else
{
%>     
   <option value='05' >„«ÌÊ</option>
<%
}
%>



<%
if( requiredmonth.equalsIgnoreCase("06"))
{
%>
        <option value='06' selected>ÌÊ‰ÌÂ</option>
<%
}
else
{
%>     
   <option value='06' >ÌÊ‰ÌÂ</option>
<%
}
%>



<%
if( requiredmonth.equalsIgnoreCase("07"))
{
%>
        <option value='07' selected>ÌÊ·ÌÊ</option>
<%
}
else
{
%>     
   <option value='07' >ÌÊ·ÌÊ</option>
<%
}
%>



<%
if( requiredmonth.equalsIgnoreCase("08"))
{
%>
        <option value='08' selected>«€”ÿ”</option>
<%
}
else
{
%>     
   <option value='08' >«€”ÿ”</option>
<%
}
%>



<%
if( requiredmonth.equalsIgnoreCase("09"))
{
%>
        <option value='09' selected>”» „»—</option>
<%
}
else
{
%>     
   <option value='09' >”» „»—</option>
<%
}
%>



<%
if( requiredmonth.equalsIgnoreCase("10"))
{
%>
        <option value='10' selected>«ﬂ Ê»—</option>
<%
}
else
{
%>     
   <option value='10' >«ﬂ Ê»—</option>
<%
}
%>



<%
if( requiredmonth.equalsIgnoreCase("11"))
{
%>
        <option value='11' selected>‰Ê›„»—</option>
<%
}
else
{
%>     
   <option value='11' >‰Ê›„»—</option>
<%
}
%>


<%
if( requiredmonth.equalsIgnoreCase("12"))
{
%>
        <option value='12' selected>œÌ”„»—</option>
<%
}
else
{
%>     
   <option value='12' >œÌ”„»—</option>
<%
}
%>



      
                        
</select>
</td>
                          
<td width='25%' align='center'>
<select dir=rtl  name='theyear' style='font-size:12pt;color:#000000;font-weight:bold;width:5em;height:1.7em' dir='rtl'>



<%
for(int ll=2009;ll<=2025;ll++)
{
if( requiredyear.equalsIgnoreCase(Integer.toString(ll)))
{
%>
               <option value='<%=ll%>' selected><%=ll%></option>
<%
}
else
{
%>     
               <option value='<%=ll%>' ><%=ll%></option>
<%
}
}
%>



      

                        
</select>
</td>



                                          <td width='5%' align='center'>&nbsp;</td>
                                          <td width='25%' align='center'><input type='submit' name='subReport' value=' Ê“Ì⁄' STYLE='font-weight:bold ; color:#000000; width:8em; height:2em'></td>
                                    </tr>
                              </table>
                        </td>
                  </tr>
            </table>

</form>




















<%

JDBCCategoryDataset dataset= new JDBCCategoryDataset(con);
dataset.executeQuery(query);
JFreeChart chart = ChartFactory .createBarChart3D(" ","","",dataset,PlotOrientation.VERTICAL,true, true, false);

try
{
ChartUtilities.saveChartAsJPEG(new File("C:\\Tomcat7\\webapps\\"+request.getContextPath()+"\\chartmonthly.png"), chart, 1000, 500);
}
catch (IOException e)
{
out.println("Problem in creating chart.");return;
}

%>

   
      <center>  <IMG SRC="chartmonthly.png" WIDTH="1000" HEIGHT="500" BORDER="0" USEMAP="#chart"> </center>
       <br>







</body>

</html>
















<%
}
}
%>


