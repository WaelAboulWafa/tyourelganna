<%@ page language="java" pageEncoding="Windows-1256" contentType="text/html; charset=Windows-1256" %><%@ page language="java" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*,java.util.regex.*"  %><%!


public String replacestring(String inputStr,String patternStr,String replacementStr) throws Exception{return Pattern.compile(patternStr).matcher(inputStr).replaceAll(replacementStr);}
public String badword(String inputstr,Connection thecon )throws Exception
{
 String newStr =inputstr;
 ResultSet rs = thecon.createStatement().executeQuery("SELECT word from badwords order by id");
 while (rs.next())
 {
   String thebaddWord = rs.getString(1).trim();
   newStr = replacestring(newStr,thebaddWord,"[[ " + thebaddWord + " ]]");
 }rs.close();rs=null;
 return newStr;
}


 
 public String getReadable(String theUnicode)
 {
 
   /*
   if(theUnicode.length() < 4){return "";}
   try 
    {
     byte[] by = new byte[theUnicode.length()/2];
     for(int i=0;i<theUnicode.length()/2;i++)
     by[i] = (new Integer(Integer.parseInt(theUnicode.substring(i*2,i*2 + 2),16))).byteValue();
     String theReadable = new String(by,"UTF-16");
     return (new String(theReadable.getBytes("Cp1256"),"Cp1252"));
    }catch(Exception e){return "";}
    
   */
	return theUnicode;
 }





public int insertcdr(String themsisdn,String theshortcode,String theoperator,
                     String thecountry,String theprovider,String thelang,
                     String thecontents, String theoriginatingip, String thesmslogic,
                     Connection thecon ) throws Exception
{


String thereadable = "";
String themodifiedcontents  = thecontents.replaceAll("'", "''");
if( thelang.equalsIgnoreCase("Arabic") ){thereadable =  getReadable(thecontents).replaceAll("'", "''");}
else{thereadable =  thecontents.replaceAll("'", "''");}

ResultSet rs = thecon.prepareStatement("insert into CDRs(msisdn,shortcode,operator,country,provider,lang,contents,readable,originatingip,messagelogic) values ('" + themsisdn + "','" + theshortcode + "', '" + theoperator + "', '" + thecountry + "', '" + theprovider  + "','" + thelang.substring(0, 1).trim() + "',N'"+  (new String(themodifiedcontents.getBytes("Cp1256"),"Cp1252")) + "',N'" + (new String(thereadable.getBytes("Cp1256"),"Cp1252")) + "','" + theoriginatingip +"','" + thesmslogic +"')  select @@IDENTITY" ).executeQuery();  
int theID = 0;            
while(rs.next()){ theID = rs.getInt(1);}rs.close();rs = null;

return theID;              
}



public void insertnickname(int theorigID,String themsisdn,String theshortcode,String thecontents, String thelang, Connection thecon )throws Exception
{
 //delete previously existing nick
 //thecon.createStatement().execute("delete from chatNickNames where MSISDN='" + themsisdn + "'"); 
  
 //insert new nickname
 String thereadable = "";
 if( thelang.equalsIgnoreCase("Arabic") ){thereadable =  getReadable(thecontents).replaceAll("'", "''");}
 else{thereadable =  thecontents.replaceAll("'", "''");}
 
 thereadable = badword(thereadable,thecon);
 thecon.createStatement().execute("insert into NewNicknames(OriginalID, msisdn, shortcode, thesms) values (" + theorigID + ",'" + themsisdn + "','" + theshortcode +  "',N'" + (new String(thereadable.getBytes("Cp1256"),"Cp1252")) + "')");
 
}







public void insertsms(int theorigID,String themsisdn,String theshortcode,String operator, String country, String provider ,
					  String thelogic,	
					  String thecontents, String thelang, Connection thecon )throws Exception
{

 String thereadable = "";
 if( thelang.equalsIgnoreCase("Arabic") ){thereadable =  getReadable(thecontents).replaceAll("'", "''");}
 else{thereadable =  thecontents.replaceAll("'", "''");}
 
 thereadable = badword(thereadable,thecon);
 thecon.createStatement().execute("insert into NewSMS(OriginalID, msisdn, shortcode, thesms  ,Providername, country, operator, MessageLogic) values (" + theorigID + ",'" + themsisdn + "','" + theshortcode +  "',N'" + (new String(thereadable.getBytes("Cp1256"),"Cp1252")) + "','" + provider + "','" + country + "','" + operator +"','" + thelogic + "')"  );
 
}




            
%><%
 //		request.setCharacterEncoding("Windows-1256");

        String provider=null;
        String msisdn=null ;
        String shortcode=null;
        String country=null;
        String operator=null;        
        String lang=null;
        String contents = null;

         if(request.getParameter("provider") != null)   {provider = request.getParameter("provider");provider = provider.trim();} 
         if(request.getParameter("msisdn") != null)     {msisdn = request.getParameter("msisdn");msisdn = msisdn.trim();} 
         if(request.getParameter("shortcode") != null)  {shortcode = request.getParameter("shortcode");shortcode = shortcode.trim();} 
         if(request.getParameter("country") != null)    {country = request.getParameter("country");country = country.trim();}  
         if(request.getParameter("lang") != null)       {lang = request.getParameter("lang");lang = lang.trim();}           
         if(request.getParameter("contents") != null)   {contents = request.getParameter("contents");contents = contents.trim();}                    
         if(request.getParameter("operator") != null)   {operator = request.getParameter("operator");operator = operator.trim();}                    
           
        if ( (provider == null)    ||
             (msisdn == null)      ||
             (shortcode == null)   ||
             (country == null)     ||
             (lang == null)        ||
             (contents == null)    ||
             (operator == null)   
           )
        {
          out.print("Rejected. parameter(s) missing.");
          out.close();
          return;    
       	}       	
       	























        Connection con=null;
        InitialContext ic = new InitialContext();
        DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
        con  = ds.getConnection();
        ResultSet rs = con.createStatement().executeQuery("SELECT originatingip,Active from Providers where providername='" + provider + "' and country='" + country + "' and operator='" + operator + "' and shortcode='" + shortcode+ "'");            

       	String OriginatingIP = request.getRemoteAddr();  
       	      
        boolean istrustedip = false;
        boolean trustedprovider = false;
        
        int ActiveProvider = 0;
        
        while(rs.next())
        {
        	trustedprovider = true;
          	String TrustedIP = rs.getString(1).trim();ActiveProvider = rs.getInt(2);
          	
            if( (OriginatingIP).equalsIgnoreCase(TrustedIP) || (TrustedIP).equalsIgnoreCase("any") ) istrustedip= true;
        }
        rs.close(); rs = null;
        
      	if(!trustedprovider){out.print("<b>Rejected</b>. provider <u>" + provider + "</u> unknown And/Or country <u>" + country + "</u> unknown And/Or operator <u>" + operator + "</u> unknown And/Or shortcode <u>" + shortcode + "</u> unknown");out.close();return;}       	
       	if(!istrustedip){out.print("Rejected. IP " + OriginatingIP + " Forbidden");out.close();return;}
       	    
        if(ActiveProvider == 0){out.print("<b>Rejected</b>.provider <u>" + provider + "</u>,country <u>" + country + "</u>,operator <u>" + operator + "</u>,shortcode <u>" + shortcode + "</u> <b>FORBIDDEN</b>");out.close();return;}       	
       	    
       	
        if(! (lang.equalsIgnoreCase("A") || lang.equalsIgnoreCase("E") ))
        {
              out.print("Rejected. Unknown language. Allowed values are : <b>A</b> or <b>E</b>");
              out.close();
              return;         	   	
        }

       	
       	



























 



             String retrun_Str="-1";

    
        /*
        //if English SMS , log only & no action is done.....
        if( lang.equalsIgnoreCase("E") )
        {
         int thereturnedid_ =  -1;
         try{thereturnedid_ = insertcdr(msisdn,shortcode,operator,country,provider,lang,contents,OriginatingIP,"chat",con);}catch(Exception e){out.println(e.toString()); return;}
         out.print(thereturnedid_);out.close();return;
        }
       
       */
       
       //////////////////////////////////////////////////////////////////////////////////////////////////////////////////       
       String NickNameregirstrationkeyword = "ÓÌá " ; //sagel space
       String MessageLogic = "";  
           
       //nick name registration    
       if( contents.toLowerCase().startsWith(NickNameregirstrationkeyword.toLowerCase()))
       {
         int thereturnedid =  -1;
         try{
              thereturnedid = insertcdr(msisdn,shortcode,operator,country,provider,lang,contents,OriginatingIP,"nickname",con);
              insertnickname(thereturnedid,msisdn,shortcode, contents.substring(NickNameregirstrationkeyword.length(),contents.length()) ,lang, con);

             }catch(Exception e)
             {
               thereturnedid =  -1;
             }
             
             

             if(thereturnedid > 0){  retrun_Str="OK"; }
             if(request.getParameter("controlmessage") != null){ if(request.getParameter("controlmessage").equalsIgnoreCase("controlpass")){ response.sendRedirect("send.jsp");return;}else{return;}}     
             else{out.print(retrun_Str);out.close();return;}

             
             
             
       }
       






       
       
       //normal sms
       int thereturnedid_ =  -1;
         try{
              thereturnedid_ = insertcdr(msisdn,shortcode,operator,country,provider,lang,contents,OriginatingIP,"chat",con);
              insertsms(thereturnedid_,msisdn,shortcode, operator,country,provider , "chat", contents , lang,con);
             }catch(Exception e)
             {
               thereturnedid_ =  -1;
             }

			   if(thereturnedid_ > 0){  retrun_Str="OK"; }
               if(request.getParameter("controlmessage") != null){ if(request.getParameter("controlmessage").equalsIgnoreCase("controlpass")){ response.sendRedirect("send.jsp");return;}else{return;}}     
               else{out.print(retrun_Str);out.close();return;}



        
        
     %>