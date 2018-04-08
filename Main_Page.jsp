<%@ page contentType="text/html;charset=windows-1256"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*,AppClasses.*" %>



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

  
  /////get media name/////////////
  String medianame="";
  String bgcolor="";
  try
  {
   rs = con.createStatement().executeQuery("SELECT medianame, bgcolor from webconfig");             
   while(rs.next()){medianame = rs.getString(1);bgcolor = rs.getString(2);}
   rs.close();rs = null;
  }catch(Exception e){}
   
  String[][] Us = Validator.US();

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

<table align='center' border='1' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#000000' width='60%'>

<%
for (int r=0; r<Us.length; r++) 
{
String x1=""; try{x1= new String(Us[r][0].getBytes("Cp1252"),"Cp1256");}catch(Exception e){x1="";}
String x2=""; try{x2= new String(Us[r][1].getBytes("Cp1252"),"Cp1256");}catch(Exception e){x2="";}
String x3=""; try{x3= new String(Us[r][2].getBytes("Cp1252"),"Cp1256");}catch(Exception e){x3="";}
String x4=""; try{x4= new String(Us[r][3].getBytes("Cp1252"),"Cp1256");}catch(Exception e){x4="";}
String x5=""; try{x5= new String(Us[r][4].getBytes("Cp1252"),"Cp1256");}catch(Exception e){x5="";}

%>
   <tr>
        <td align='center'><font color='#000000' face='Arial' size='3'><%=x1%></font></td>
        <td align='center'><font color='#000000' face='Arial' size='3'><%=x2%></font></td>
        <td align='center'><font color='#000000' face='Arial' size='3'><%=x3%></font></td>
        <td align='center'><font color='#000000' face='Arial' size='3'><%=x4%></font></td>
        <td align='center'><font color='#000000' face='Arial' size='3'><%=x5%></font></td>
   </tr>
<%
}
%>
   
</table>
    

			
</body>

</html>

<%
}
%>
