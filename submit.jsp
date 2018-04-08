<%@ page language="java" pageEncoding="Cp1252" contentType="text/html; charset=Cp1252" import="java.util.*,java.text.*,java.sql.*,javax.naming.*,javax.sql.*,java.net.*,java.util.regex.*"  %><%!

       public String msisdndetector(String msg) 
       {
       String retval = "";
       Matcher matcher = Pattern.compile("[0-9]{7,20}").matcher(msg);
       if (matcher.find()){retval = matcher.group();}
       return retval;
       }
             


public String replaceWord(String inputStr,String patternStr,String replacementStr) throws Exception{return Pattern.compile(patternStr).matcher(inputStr).replaceAll(replacementStr);}
public String badword(String inputstr,Connection thecon )throws Exception
{
 String newStr =inputstr;
 ResultSet rs = thecon.createStatement().executeQuery("SELECT word,modifiedto from badwords order by id");
 while (rs.next())
 {
        newStr = replaceWord(newStr,rs.getString(1).trim(),rs.getString(2).trim());
 }
 rs.close();rs=null;
 return newStr;
}



    
 public String getReadable(String theUnicode,String thelang)
 {
   if( thelang.equalsIgnoreCase("E") ){return theUnicode;}
   
   if(theUnicode.length() < 4){return "";}
   try 
    {
     byte[] by = new byte[theUnicode.length()/2];
     for(int i=0;i<theUnicode.length()/2;i++)
     by[i] = (new Integer(Integer.parseInt(theUnicode.substring(i*2,i*2 + 2),16))).byteValue();
     String theReadable = new String(by,"UTF-16");
     //return (new String(theReadable.getBytes("Cp1256"),"Cp1252"));
     return theReadable;
    }catch(Exception e){return "";}

 }




public boolean forbiddenmsisdn(String themsisdn,Connection thecon)throws Exception
{

 int thiscount= 0;
 ResultSet thers;
 thers = thecon.createStatement().executeQuery("SELECT count(*) as thecnt from ForbiddenNumbers where msisdn='"+ themsisdn + "'");            
 while(thers.next()){thiscount=thers.getInt(1);}thers.close();thers = null;
 
 if (thiscount > 0){return true;}
 
 return false;
 
}


public int insertcdr(String themsisdn,String theshortcode,String theoperator,
                     String thecountry,String theprovider,String thelang,
                     String thecontents, String theoriginatingip, String thesmslogic,String themedia,
                     Connection thecon ) throws Exception
{

String thereadable = "";
String themodifiedcontents  = thecontents.replaceAll("'", "''");

thereadable =  getReadable(thecontents,thelang).replaceAll("'", "''");

ResultSet rs = thecon.prepareStatement("insert into CDRs(msisdn,shortcode,operator,country,provider,lang,contents,readable,originatingip,messagelogic,destination_media) values ('" + themsisdn + "','" + theshortcode + "', '" + theoperator + "', '" + thecountry + "', '" + theprovider  + "','" + thelang + "','"+  themodifiedcontents + "',N'" + thereadable + "','" + theoriginatingip +"','" + thesmslogic +"','" + themedia + "')  select @@IDENTITY" ).executeQuery();  
int theID = 0;            
while(rs.next()){ theID = rs.getInt(1);}rs.close();rs = null;

return theID;              
}



public int insertcdrforbidden(String themsisdn,String theshortcode,String theoperator,
                     String thecountry,String theprovider,String thelang,
                     String thecontents, String theoriginatingip, String thesmslogic,
                     Connection thecon ) throws Exception
{

String thereadable = "";
String themodifiedcontents  = thecontents.replaceAll("'", "''");

thereadable =  getReadable(thecontents,thelang).replaceAll("'", "''");

ResultSet rs = thecon.prepareStatement("insert into CDRs(msisdn,shortcode,operator,country,provider,lang,contents,readable,originatingip,messagelogic,status,FilerationAgent,ApprovedContent,Update_Time,FiltrationIP) values ('" + themsisdn + "','" + theshortcode + "', '" + theoperator + "', '" + thecountry + "', '" + theprovider  + "','" + thelang + "','"+  themodifiedcontents + "',N'" + thereadable + "','" + theoriginatingip +"','" + thesmslogic +"','-1','system',N'" + thereadable + "',getdate(),'localhost')  select @@IDENTITY" ).executeQuery();  
int theID = 0;            
while(rs.next()){ theID = rs.getInt(1);}rs.close();rs = null;

return theID;              
}



            
%><%

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
       	if(!istrustedip){out.print("Rejected . IP " + OriginatingIP + " Forbidden");out.close();return;}
       	    
        if(ActiveProvider == 0){out.print("<b>Rejected</b>.provider <u>" + provider + "</u>,country <u>" + country + "</u>,operator <u>" + operator + "</u>,shortcode <u>" + shortcode + "</u> <b>FORBIDDEN</b>");out.close();return;}       	
       	    
       	
        if(! (lang.equalsIgnoreCase("A") || lang.equalsIgnoreCase("E") ))
        {
              out.print("Rejected. unknown language");
              out.close();
              return;         	   	
        }

       	
        if( lang.equalsIgnoreCase("A") )
        {
        
        try{
             StringBuffer stb = new StringBuffer();
             for(int i=0;i< contents.length();i=i+4)
             {
              if(contents.substring(i,i+3).equalsIgnoreCase("066")){stb.append("003");stb.append( contents.substring(i+3,i+4) );}
              else{stb.append(contents.substring(i,i+4));}
             }
             contents = stb.toString();
           }catch(Exception e){contents = contents;}
        
        }



     ///////////////forbidden///////////////
       if( forbiddenmsisdn(msisdn,con))
       {
         int thereturnedid=0;
            try{
               thereturnedid = insertcdrforbidden(msisdn,shortcode,operator,country,provider,lang,contents,OriginatingIP,"chat-forbidden",con);

             }catch(Exception e)
             {
               thereturnedid =  -1;
             }
             if(thereturnedid > 0) {out.print("OK");out.close();return;}
             else{out.print("-1");out.close();return;}
       }
      ///////////////////////////////////////
      
    
       String MessageLogic = "chat";    




  
       String NickNameregirstrationkeyword = "0633062C06440020" ; //sagel space
       if( contents.toLowerCase().startsWith(NickNameregirstrationkeyword.toLowerCase())){MessageLogic= "nickname";}
       
	   String themedia = "1";
       String whichmedia = "0628064A0628064A0020" ; //baby space
       if( contents.toLowerCase().startsWith(whichmedia.toLowerCase())){themedia= "2";}

	   

       
       //normal sms
       int thereturnedid_ =  -1;
         try{
              thereturnedid_ = insertcdr(msisdn,shortcode,operator,country,provider,lang,contents,OriginatingIP,MessageLogic,themedia,con);
         
            String thetempSMS = badword(getReadable(contents,lang).replaceAll("'", "''"),con).trim();
            
            con.createStatement().execute("insert into NewSMS(OriginalID, msisdn, shortcode, thesms,Providername, country, operator,MessageLogic,the_media) values (" + thereturnedid_ + ",'" + msisdn + "','" + shortcode +  "',N'" + thetempSMS + "','"+ provider +"','"+ country +"','" + operator +"','" + MessageLogic + "','" + themedia + "')");              
             
             
           }catch(Exception e){out.print(e.toString());thereturnedid_ =  -1;}
             
             
              if(request.getParameter("controlmessage") != null){ if(request.getParameter("controlmessage").equalsIgnoreCase("controlpass")){ response.sendRedirect("send.jsp");return;}}     
              else{
                   
                    if(thereturnedid_ > 0) {out.print("OK");out.close();return;}
                    else{out.print("-1");out.close();return;}
                  }

            
  
            
            
            
            
            
            %>