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

if(userid==null ) //user not logged in
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

  



  int reccount = 0 ;
  rs = null;
  try
  {
   rs = con.createStatement().executeQuery("SELECT count(*) from UsersAuthorities where userID=" + userid);               
   while(rs.next()){reccount = rs.getInt(1);} 
   rs.close();rs = null;
  }catch(Exception e){}
  
  
  String[] thepage = new String[reccount];
  int[] allowed = new int[reccount];
  
  rs = null;
  int z =0;
  try
  {
   rs = con.createStatement().executeQuery("SELECT page, allowed from UsersAuthorities where userID=" + userid);             
   while(rs.next()){thepage[z]=rs.getString(1);allowed[z]=rs.getInt(2);z=z+1;}
   rs.close();rs = null;
  }catch(Exception e){}
    


  
  
  
  /////get media name/////////////
  String medianame="";
  String bgcolor="";
  try
  {
   rs = con.createStatement().executeQuery("SELECT medianame, bgcolor from webconfig");             
   while(rs.next()){medianame = rs.getString(1);bgcolor = rs.getString(2);}
   rs.close();rs = null;
  }catch(Exception e){}
    
%>

 
 


<html dir='rtl'>

<head>
<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000;background-color: #<%=bgcolor%>; }</style>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
<title>«·ﬁ«∆„… «·—∆Ì”Ì… ... <%= medianame %></title>
</head>
<body>



		    
<table border='0' bgcolor=#<%=bgcolor%> cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%' height='80'>
  <tr>
	  <td width='21%' align='center'><font size='4' Color=darkred><b>„—Õ»« ,</b></font><font size='4' ><b> <%= (new String(username.getBytes("Cp1252"),"Cp1256")) %> </b></font></td>
    <td width='35%' align='center'>&nbsp;
    </td>
    <td width='19%' align='center'>
    	<table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%'>
    	&nbsp;
    	</table>
    </td>
    <td bgcolor='#<%=bgcolor%>' width='15%' align='center'><IMG src='logo.png'></td>
  </tr>
</table>

<br>

		    
		    
		    
		    
		    <table align='center' border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='95%'>
                  <tr align='center'>
          
                    
                    <td width='25%' valign='top'>
                    <table border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='60%'>
                        <tr bgcolor=#646464>
                              <td width='100%' colspan='1' align='center' height='30'><b><font size='4' color=white>«·—”«∆· «·ﬁ’Ì—Â</font></b></td>
                        </tr>
                        
                        



                        
<%
if(isallowed("filteration_hold.jsp",thepage,allowed))
{
%>
                        <tr bgcolor=#DCDCDC>
                              <form action='filteration_hold.jsp' method='post'>

                                <td width='80%' height='40'><p align='center'><input type='submit' name='subApprove' value='—”«∆· ›Ì «·«‰ Ÿ«—' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
                  		      </form>
                        </tr>
<%
}
else
{
}
%>
                        
                        




                        
<%
if(isallowed("filteration.jsp",thepage,allowed))
{
%>
                        <tr bgcolor=#DCDCDC>
                              <form action='filteration.jsp' method='post'>

                                <td width='80%' height='40'><p align='center'><input type='submit' name='subApprove' value='„ «»⁄… «·—”«∆·' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
                  		      </form>
                        </tr>
<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='5'><b>„ «»⁄… «·—”«∆·</b></font></td>
</tr>

<%
*/
}
%>
                        
                        



                        
<%
if(isallowed("filterationlove.jsp",thepage,allowed))
{
%>
                        <tr bgcolor=#DCDCDC>
                              <form action='filterationlove.jsp' method='post'>

                                <td width='80%' height='40'><p align='center'><input type='submit' name='subApprove' value='„ «»⁄… «·„Ì“«‰' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
                  		      </form>
                        </tr>
<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='5'><b>„ «»⁄… «·„Ì“«‰</b></font></td>
</tr>

<%
*/
}
%>
                        
                        




   









			      
<%
if(isallowed("smsonair.jsp",thepage,allowed))
{
%>			      
			      <tr bgcolor=#DCDCDC><form action='smsonair.jsp' method='post'>

			                  <td width='80%' height='40'><p align='center'><input type='submit' name='subHawa' value='—”«∆· ⁄·Ï «·‘«‘…' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
						      </form>
			      </tr>

<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='5'><b>—”«∆· ⁄·Ï «·‘«‘…</b></font></td>
</tr>

<%
*/
}
%>
   	




			      
<%
if(isallowed("smsonair.jsp",thepage,allowed))
{
%>			      
			      <tr bgcolor=#DCDCDC><form action='smsonair2.jsp' method='post'>

			                  <td width='80%' height='40'><p align='center'><input type='submit' name='subHawa' value='—”«∆· ⁄·Ì «·‘«‘Â 2' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
						      </form>
			      </tr>

<%
}
else
{
}
%>
  





<%
if(isallowed("send.jsp",thepage,allowed))
{
%>
                        
			      <tr bgcolor=#DCDCDC>
			       <form action='send.jsp' method='post'>

			                    <td width='80%' height='40'><p align='center'><input type='submit' name='subSend' value='—”«·Â œ«Œ·ÌÂ' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
				   </form>
  		         </tr>
<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='5'><b>—”«·Â œ«Œ·ÌÂ</b></font></td>
</tr>

<%
*/
}
%>
   			      

			      
	






			      

<%
if(isallowed("nicknames.jsp",thepage,allowed))
{
%>
		      
			      <tr bgcolor=#DCDCDC>
			        <form action='nicknames.jsp' method='post'>

				       <td width='80%' height='40'><p align='center'><input type='submit' name='subNick' value='«·√”„«¡ «·„” ⁄«—Â' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
				    </form>
			      </tr>
			      
<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='5'><b>«·√”„«¡ «·„” ⁄«—Â</b></font></td>
</tr>

<%
*/
}
%>
   			      




<%
if(isallowed("replay.jsp",thepage,allowed))
{
%>
                        
			      <tr bgcolor=#DCDCDC>
			       <form action='replay.jsp' method='post'>

			                    <td width='80%' height='40'><p align='center'><input type='submit' name='subSend' value='≈⁄«œÂ' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
				   </form>
  		         </tr>
<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='5'><b>≈⁄«œÂ</b></font></td>
</tr>

<%
*/
}
%>
   			


  




  
<%
if(isallowed("readymadesmss.jsp",thepage,allowed))
{
%>
                        
			      <tr bgcolor=#DCDCDC>
			       <form action='readymadesmss.jsp' method='post'>

			                    <td width='80%' height='40'><p align='center'><input type='submit' name='subSend' value='—”«∆· Ã«Â“Â' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
				   </form>
  		         </tr>
<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='5'><b>—”«∆· Ã«Â“Â</b></font></td>
</tr>

<%
*/
}
%>
   			

  





<%
if(isallowed("search.jsp",thepage,allowed))
{
%>			      
			      <tr bgcolor=#DCDCDC><form action='search.jsp' method='post'>
						      <input type='hidden' name='uid' value='41'>

				                <td width='80%' height='40'><p align='center'><input type='submit' name='subSrch' value='«·»Õ‹À' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
						      </form>
			      </tr>
<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='5'><b>«·»Õ‹À</b></font></td>
</tr>

<%
*/
}
%>
			      













































			      
			</table>
			
			
			
			
			
			
			


















			
			
			
			
			
			
			
                  <!-- ........................ Reserved Table .................... -->
	    				</td>

























          

	    				<td width='25%' valign='top'>

					    <!-- ........................ Report Table .................... -->
					    <table border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='60%'>
					      <tr bgcolor=#646464>
					        <td width='100%' colspan='1' align='center' height='30'><b><font size='4' color=white> ‰ÊÌÂ« </font></b></td>
					      </tr>
					      
					      
					      
					      
					      
					      
					      
			      
					      
					      
					      
<%
if(isallowed("info1.jsp",thepage,allowed))
{
%>					      
					      
					      
					      <tr bgcolor=#DCDCDC> <form action='info1.jsp' method='post'>

						                  <td width='80%' height='40'><p align='center'><input type='submit' name='subInfo' value=' ‰ÊÌÂ«  1' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
								      </form>
								     
					      </tr>
					      
<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='5'><b> ‰ÊÌÂ«  1</b></font></td>
</tr>

<%
*/
}
%>
							      


				      
					      
					      
		





	




					      
<%
if(isallowed("info2.jsp",thepage,allowed))
{
%>					      
					      
					      
					      <tr bgcolor=#DCDCDC> <form action='info2.jsp' method='post'>

						                  <td width='80%' height='40'><p align='center'><input type='submit' name='subInfo' value=' ‰ÊÌÂ«  2' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
								      </form>
								     
					      </tr>
					      
<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='5'><b> ‰ÊÌÂ«  2</b></font></td>
</tr>

<%
*/
}
%>
							      
















					      
<%
if(isallowed("info3.jsp",thepage,allowed))
{
%>					       
					      
					      
					      <tr bgcolor=#DCDCDC> <form action='info3.jsp' method='post'>

						                  <td width='80%' height='40'><p align='center'><input type='submit' name='subInfo' value=' ‰ÊÌÂ«  3' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
								      </form>
								     
					      </tr>
					      
<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='5'><b> ‰ÊÌÂ«  3</b></font></td>
</tr>

<%
*/
}
%>
							      






					    </table>


	    				</td>






















	    				<td width='25%' valign='top'>

					    <!-- ........................ News Table .................... -->
					    <table border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='60%'>
					      <tr bgcolor=#646464>
      					       <td width='100%' colspan='1' align='center' height='30'><b><font size='4' color=white>÷»ÿ</font></b></td>
					      </tr>
					      
					      
					      













<%
if(isallowed("operatorsproviders.jsp",thepage,allowed))
{
%>

					      
					      <tr bgcolor=#DCDCDC> <form action='operatorsproviders.jsp' method='post'>

						                  <td width='80%' height='40'><p align='center'><input type='submit' name='subProvider' value='‘—ﬂ«  «·« ’«·« ' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
								      </form>
								     
					      </tr>
					      
<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='5'><b>‘—ﬂ«  «·« ’«·« </b></font></td>
</tr>

<%
*/
}
%>
						      
					      
		
		
		
		












<%
if(isallowed("badwords.jsp",thepage,allowed))
{
%>	
					      
					      <tr bgcolor=#DCDCDC> <form action='badwords.jsp' method='post'>

						                  <td width='80%' height='40'><p align='center'><input type='submit' name='subBadWord' value='ﬁ«„Ê” «·„„‰Ê⁄« ' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
								      </form>
								     
					      </tr>
					      
<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='5'><b>ﬁ«„Ê” «·„„‰Ê⁄« </b></font></td>
</tr>

<%
*/
}
%>
						      




<%
if(isallowed("forbiddennumbers.jsp",thepage,allowed))
{
%>	
					      
					      <tr bgcolor=#DCDCDC> <form action='forbiddennumbers.jsp' method='post'>

						                  <td width='80%' height='40'><p align='center'><input type='submit' name='forbiddennumbers' value='«·«—ﬁ«„ «·„ÕŸÊ—Â' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
								      </form>
								     
					      </tr>
					      
<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='5'><b>«·«—ﬁ«„ «·„ÕŸÊ—Â</b></font></td>
</tr>

<%
*/
}
%>
		
						      










			      
					      
	
					      
					      
					      
					      
					      
<%
if(isallowed("autorities.jsp",thepage,allowed))
{
%>						      
						      
					      
					      <tr bgcolor=#DCDCDC> <form action='autorities.jsp' method='post'>

						              <td width='80%' height='40'><p align='center'><input type='submit' name='subAdmin' value='„” Œœ„Ì‰' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
								      </form>
								     
					      </tr>


					      
					      
<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='4'><b>„” Œœ„Ì‰</b></font></td>
</tr>

<%
*/
}
%>
							      
	



					      
<%
if(isallowed("trustedips.jsp",thepage,allowed))
{
%>						      
						      
					      
					      <tr bgcolor=#DCDCDC> <form action='trustedips.jsp' method='post'>

						              <td width='80%' height='40'><p align='center'><input type='submit' name='subAdmin' value='„Ã„Ê⁄… IP' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
								      </form>
								     
					      </tr>


					      
					      
<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='5'><b>„Ã„Ê⁄… IP</b></font></td>
</tr>

<%
*/
}
%>
	













					      
<%
if(isallowed("screen.jsp",thepage,allowed))
{
%>						      
						      
					      
					      <tr bgcolor=#DCDCDC> <form action='screen.jsp' method='post'>

						              <td width='80%' height='40'><p align='center'><input type='submit' name='subAdmin' value='«·‘«‘Â' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
								      </form>
								     
					      </tr>


					      
					      
<%
}
%>
	


				      





				      
			

				      
					      
					      
		





	





			      
					      
					      
					      




			      
				      
					      
					      
					      
	






						      
					      
	













					      
					      
					      
					      
					      
					      
					      
					      
					      
					      
					      
					      				      
					    </table>
					    


	    				</td>

	    				<td width='25%' valign='top'>

					    <!-- ........................ News Table .................... -->
					    <table border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='60%'>
					      <tr bgcolor=#646464>
      					       <td width='100%' colspan='1' align='center' height='30'><b><font size='4' color=white> ﬁ«—Ì— «·—”«∆·</font></b></td>
					      </tr>
					      
					      
					      
					      
					      
					      
					      
					      
					      
					      
					      
					      
					      
					      
<%
if(isallowed("smscount.jsp",thepage,allowed))
{
%>					      
						      
					      <tr bgcolor=#DCDCDC> <form action='smscount.jsp' method='post'>

						                  <td width='80%' height='40'><p align='center'><input type='submit' name='subSMSCount' value='√⁄‹œ«œ' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
								      </form>
								     
					      </tr>
					      
					      
<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='5'><b>√⁄‹œ«œ</b></font></td>
</tr>

<%
*/
}
%>
							      
						      
							      
					      
							      
					      
					      
					      
					      
					      
					      
<%
if(isallowed("smsdistribution.jsp",thepage,allowed))
{
%>						      
					      
					      <tr bgcolor=#DCDCDC> <form action='smsdistribution.jsp' method='post'>

						                  <td width='80%' height='40'><p align='center'><input type='submit' name='subSMSDistr' value=' Ê“Ì⁄ ÌÊ„Ì' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
								      </form>
								     
					      </tr>
					      
					      
					      
<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='5'><b> Ê“Ì⁄ ÌÊ„Ì</b></font></td>
</tr>

<%
*/
}
%>
							      
							      















					      
<%
if(isallowed("smsdistributionmonthly.jsp",thepage,allowed))
{
%>						      
					      
					      <tr bgcolor=#DCDCDC> <form action='smsdistributionmonthly.jsp' method='post'>

						                  <td width='80%' height='40'><p align='center'><input type='submit' name='subSMSDistr' value=' Ê“Ì⁄ ‘Â—Ì' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
								      </form>
								     
					      </tr>
					      
					      
					      
<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='5'><b> Ê“Ì⁄ ‘Â—Ì</b></font></td>
</tr>

<%
*/
}
%>
							      









					      
<%
if(isallowed("msisdntrace.jsp",thepage,allowed))
{
%>						      
					      
					      <tr bgcolor=#DCDCDC> <form action='msisdntrace.jsp' method='post'>

						                  <td width='80%' height='40'><p align='center'><input type='submit' name='subSMSDistr' value='«·—«”·' STYLE='font-family:Arabic Transparent;font-weight:bold; font-size:12pt ; width:8em ; height:2.0em'></td>
								      </form>
								     
					      </tr>
					      
					      
					      
<%
}
else
{
/*
%>
<tr bgcolor=#DCDCDC>
 <td width='20%' height='40' align='center'></td>
 <td width='80%' height='40'><p align='center'><font face='Arabic Transparent' size='5'><b>«·—«”·</b></font></td>
</tr>

<%
*/
}
%>
	
	
	
		      
					      
					      
					      
					      
					      
					      
					      
					      
					    </table>



	    				</td>

	    				<td width='20%' valign='top'>




	    				</td>

	  				</tr>
	  				
	  				
	  				<tr>
	  				

	  				
				</table>


			    <br>
				<table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='95%'>
	  				<tr align='center'>

	    				<td width='25%' valign='top'>&nbsp;</td>
	    				<td width='25%' valign='top'>&nbsp;</td>
	    				<td width='25%' valign='top'>&nbsp;</td>
	    				<td width='25%' valign='top'>
					    	<table border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='60%'>
						      <tr bgcolor=#DCDCDC align='center'>
								<form action='login_logout.jsp' method='post'>
					                  <td width='80%' height='40'><p align='center'><input type='submit' name='subLogOff' value='Œ‹‹—ÊÃ' STYLE='font-family:Arabic Transparent;font-weight:bold; color:#FF0000; font-size:12pt ; width:8em ;  height:2.0em'></td>
							    </form>
						      </tr>
							</table>
	    				</td>

	  				</tr>
				</table>



<br>

	
				
</body>

</html>



<%
}
%>
