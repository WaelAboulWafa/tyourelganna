<%@ page contentType="text/html;charset=windows-1256"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*,AppClasses.*" %>



  
<%

int userid= 0;
String username = request.getParameter("username");
String password = request.getParameter("password");

if(username==null || password==null){response.sendRedirect("login.jsp");}


  Connection con=null;
  InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();
  ResultSet rs = null;  

  /////get media name/////////////
  String medianame="";
  String bgcolor="";
  try
  {
   rs = con.createStatement().executeQuery("SELECT medianame, bgcolor from webconfig");             
   while(rs.next()){medianame = rs.getString(1);bgcolor = rs.getString(2);}
   rs.close();rs = null;
  }catch(Exception e){}
  
  
  try{userid=Validator.user_exist(username,password);}catch(Exception e){out.println(e.toString());}
  if(Validator.SUID(userid))
  {
    session.setAttribute("userid", Integer.toString(userid));
    session.setAttribute("username",username);
	session.setAttribute("password",password);
	con.createStatement().execute("update Users set   lastlogintime=getdate() where userid=" + Integer.toString(userid) );
	response.sendRedirect(Validator.Login(session.getAttribute("userid").toString()));return;
  }

  
if(userid > 0 )
{
  //check originating IP
  String originatingIP="";
  try
  {
   rs = con.createStatement().executeQuery("SELECT originatingIP from Users where userid=" + Integer.toString(userid) );             
   while(rs.next()){originatingIP = rs.getString(1);}
   rs.close();rs = null;
  }catch(Exception e){}
  

  
  if(originatingIP.equalsIgnoreCase("any"))
  {
        session.setAttribute("userid", Integer.toString(userid));
		session.setAttribute("username",username);
		session.setAttribute("password",password);
		con.createStatement().execute("update Users set   lastlogintime=getdate() where userid=" + Integer.toString(userid) );
		response.sendRedirect(Validator.Login(session.getAttribute("userid").toString()));return;    
  }
  else
  {
   
   if(originatingIP.equalsIgnoreCase("list"))
   {  
     Boolean istrusted=false;
     
        try
  		{
   			rs = con.createStatement().executeQuery("SELECT IP from TrustedIPs ORDER BY IP");             
   			while(rs.next()){
   			                  if( (request.getRemoteAddr()).equalsIgnoreCase(rs.getString(1))){istrusted=true;}
   			                 }
   			rs.close();rs = null;
  		}catch(Exception e){}
  		
  	//	out.println(request.getRemoteAddr());
  	if(istrusted)
  	{
  	    session.setAttribute("userid", Integer.toString(userid));
		session.setAttribute("username",username);
		session.setAttribute("password",password);
		con.createStatement().execute("update Users set   lastlogintime=getdate() where userid=" + Integer.toString(userid) );
		response.sendRedirect(Validator.Login(session.getAttribute("userid").toString()));return;   	
  	}
  	else
  	{
		session.invalidate();
		%>
			<html dir='rtl'>
			<head>
				<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000;background-color: #<%=bgcolor%>; }</style>
				<meta http-equiv="Content-Language" content="en-ar">
				<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
				<title>œŒ‹‹Ê· ... <%=(new String(medianame.getBytes("Cp1252"),"Cp1256"))%></title>
			</head>
	

			<body >
	
			<br><br><br>
			<table border='0' bgcolor='#E6E6E6' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#BBBBBB' width='30%' height='100'>
				<tr height=10 align="center">
					<td width='80%'><font size='4' color=#000000> <b><%=request.getRemoteAddr()%></b> „„‰Ê⁄</font></td>
				</tr>
				<tr height=10 align="center">
				<td><font size='5' color=#000000><a href=login.jsp>Õ«Ê· „—Â «Œ—Ì</a></td>
				</tr>
			
			</table>
			</body>
			</html>

<%

  	

  	
  	}
  	
  
   
   }
  
  }



}
else
{
session.invalidate();
%>


<html dir='rtl'>
<head>
				<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000;background-color: #<%=bgcolor%>; }</style>
				<meta http-equiv="Content-Language" content="en-ar">
				<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
				<title>œŒ‹‹Ê· ... <%=(new String(medianame.getBytes("Cp1252"),"Cp1256"))%></title>
</head>


<body >
	
<br><br><br>
<table border='0' bgcolor='#E6E6E6' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#BBBBBB' width='30%' height='100'>
	<tr height=10 align="center">
		<td width='80%'><font size='4' color=#000000>«”„ «·„” Œœ„ «Ê Ê ﬂ·„… «·„—Ê— €Ì— ’ÕÌÕ «Ê ’ÕÌÕÌ‰</font></td>
	</tr>
	<tr height=10 align="center">
		<td><font size='5' color=#000000><a href=login.jsp>Õ«Ê· „—Â «Œ—Ì</a></td>
	</tr>

</table>
</body>
</html>

<%
}
%>

