<%@ page contentType="text/html;charset=windows-1256"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>


 
<%

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
  
  
%>

<html dir='rtl'>
<head>
<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000;background-color: #<%=bgcolor%>; }</style>
<meta http-equiv="Content-Language" content="en-ar">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
<title>دخــول ... <%= medianame %></title>
</head>

<body >
<table border='2' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#BBBBBB' width='100%'>
	<tr>
		<td bgcolor='#FFFFFF' width='15%' align='center'><IMG src='logo.png'></td>
		<td bgcolor='#E6E6E6' width='85%' align='center'>
		       <font size='5'>
		         صفحة المرور لموقع قناة&nbsp;&nbsp;<b><i><%= medianame %></i></b>&nbsp;الرسمي للتعامل مع الرسائل القصيره
		       </font></td>
	</tr>
</table>	
<br><br><br>
<table border='0' bgcolor='#E6E6E6' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#BBBBBB' width='25%' height='100'>
<form action="Authenticate.jsp" method="post">
	<tr height=80 align="center">
		<td width='80%'><font color=#000000><b>اسـم المسـتخدم&nbsp;&nbsp;</b></font><input type="text" name="username"><font color=#000000></font></td>
	</tr>
	<tr height=80 align="center">
		<td><font color=#000000><b>كلمـة المــرور&nbsp;&nbsp;</b></font><input type="password" name="password"><font color=#000000></font></td>
	</tr>
	<tr height='40'>
		<td colspan='3' align='center'><input type="submit" value="دخـول" style="font-weight:bold;font-size:14pt;width:8em;height:2.0em"></td>
	</tr>
</form>
</table>

<br>

<table border='0' bgcolor='#<%=bgcolor%>' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse'  >
<tr>
<td>
  <applet code=credits CODEBASE=./Applets/ width=250 height=60 ></applet>
</td>
</tr>  
</table> 
        

<br>







</body>
</html>
