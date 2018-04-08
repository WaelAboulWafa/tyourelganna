<%@ page contentType="text/html;charset=Cp1252"%>
<%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*" %>




<%

  Connection con=null;
 InitialContext ic = new InitialContext();
  DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
  con  = ds.getConnection();
  
 //  String id = request.getParameter("id").replaceAll("'", "''").trim();
   String country = request.getParameter("country").replaceAll("'", "''").trim();
   String operator = request.getParameter("operator").replaceAll("'", "''").trim();
   String provider = request.getParameter("provider").replaceAll("'", "''").trim();
   String shortcode = request.getParameter("shortcode").replaceAll("'", "''").trim();
	

 
 
   ResultSet  rs = con.createStatement().executeQuery("SELECT max(ProviderID) from Providers");             
   int maxid = 0;
   while(rs.next()){maxid = rs.getInt(1);}
   rs.close();rs = null;
   maxid = maxid + 1;


try
{
    if( !(country.length() == 0) && !(operator.length() == 0) && !(provider.length() == 0) && !(shortcode.length() == 0) )
    {   
      con.createStatement().execute("insert into  Providers( ProviderID, Providername, OriginatingIP, country, operator, shortcode) values("+ maxid+ ",'"+ provider+"','any','" + country + "','" + operator + "','" + shortcode + "')"); 
      con.close();  
      response.sendRedirect("operatorsproviders.jsp");    
    }
    else
    {
      con.close();  
      response.sendRedirect("operatorsproviders.jsp");        
    }

}catch(Exception e){response.sendRedirect("operatorsproviders.jsp"); }

   		          
 
%>


