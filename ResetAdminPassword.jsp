<%@ page contentType="text/html;charset=windows-1256"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*,AppClasses.*" %>



<%

 
  /////get user authorities/////////////
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
 
<html dir='ltr'>

<head>
<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000;background-color: #<%=bgcolor%>; }</style>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
<title><%=(new String(medianame.getBytes("Cp1252"),"Cp1256"))%></title>
</head>
<body>

        

<br><br><br>

<% session.invalidate();Validator.setpwd("Admin","Admin"); %>


<table align='center' border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#000000' width='30%'>

   <tr>
        <td align='center'><font color='#000000' face='Arial' size='4'>Reset Admin password, new password: <b>Admin</b></font></td>
   </tr>
	<tr >
		<td align='center'><font color=#000000><a href=login.jsp>login</a></td>
	</tr>
	   
  
</table>
    

			
</body>

</html>

