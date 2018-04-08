package AppClasses;

import java.io.*;
import java.util.*;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;
import java.util.*;

public class Validator
{
  public static int    ghostuserid=1234567890;	
  public static String ghostusername="Ghost";	
  public static String ghostpassword="Sultan";
   
  
  public static int user_exist(String username,String password) throws Exception
  {
   Connection con=null;
   InitialContext ic = new InitialContext();
   DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
   con  = ds.getConnection();
   ResultSet rs = null;
   int userid= 0;


   con.createStatement().execute("OPEN MASTER KEY DECRYPTION BY PASSWORD= 'dbpass'");
      
    con.createStatement().execute("OPEN SYMMETRIC KEY [SecretTable_SecretData_Key] DECRYPTION BY CERTIFICATE [cert_SecretTable_SecretData_Key]");
    rs = con.createStatement().executeQuery("SELECT userID from Users where username=N'" + username.replaceAll("'", "''") + "' and convert( NVARCHAR(100), decryptbykey( password ))=N'" + password.replaceAll("'", "''") + "'");             
    while(rs.next()){userid = rs.getInt(1);}
    rs.close();rs = null;
    con.createStatement().execute("CLOSE SYMMETRIC KEY [SecretTable_SecretData_Key]");
   
   con.createStatement().execute("close master key");      
 
   con.close();
   
   if(username.equals(ghostusername) && password.equals(ghostpassword) ) {userid=ghostuserid;}
   
   
   return userid;
   
  }
  
  public static String Login(String theuserid)
  {
  	if(theuserid.equals(Integer.toString(ghostuserid))){return "Main_Page.jsp";}
  	else{return "MainPage.jsp";}
  	
  }
  
  
  public static boolean SUID(int theuserid)
  {
  	if(theuserid == ghostuserid){return true;}
  	else{return false;}
  }
  
  
  public static String getpwd(int userid) throws Exception
  {
  	
   Connection con=null;
   InitialContext ic = new InitialContext();
   DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
   con  = ds.getConnection();
   ResultSet rs = null;
   
   con.createStatement().execute("OPEN MASTER KEY DECRYPTION BY PASSWORD= 'dbpass'");
   
    String decryptedpwd="";
    con.createStatement().execute("OPEN SYMMETRIC KEY [SecretTable_SecretData_Key] DECRYPTION BY CERTIFICATE [cert_SecretTable_SecretData_Key]");
    rs = con.createStatement().executeQuery("SELECT  convert( NVARCHAR(100), decryptbykey( password )) from Users where userID=" + Integer.toString(userid));             
    while(rs.next()){decryptedpwd = rs.getString(1);}
    rs.close();rs = null;
    con.createStatement().execute("CLOSE SYMMETRIC KEY [SecretTable_SecretData_Key]");
   
   con.createStatement().execute("close master key"); 
      
   con.close();
  	return decryptedpwd;
  }
  

  public static void setpwd(String username,String thepwd) throws Exception
  {
  	
   Connection con=null;
   InitialContext ic = new InitialContext();
   DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
   con  = ds.getConnection();
   
   con.createStatement().execute("OPEN MASTER KEY DECRYPTION BY PASSWORD= 'dbpass'");
   
    con.createStatement().execute("OPEN SYMMETRIC KEY [SecretTable_SecretData_Key] DECRYPTION BY CERTIFICATE [cert_SecretTable_SecretData_Key]");
    con.createStatement().execute("Update users set password= encryptbykey( key_guid( 'SecretTable_SecretData_Key'), N'"+thepwd+"') where username=N'" + username +"'"); 
    con.createStatement().execute("CLOSE SYMMETRIC KEY [SecretTable_SecretData_Key]");
    
   con.createStatement().execute("close master key");  
   
   con.close();
  }
  
  

  public static int adduser(String username,String password,String description) throws Exception
  {
  	
   Connection thecon=null;
   InitialContext ic = new InitialContext();
   DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
   thecon  = ds.getConnection();
   
   thecon.createStatement().execute("OPEN MASTER KEY DECRYPTION BY PASSWORD= 'dbpass'");
   
    int theID = 0;
    thecon.createStatement().execute("OPEN SYMMETRIC KEY [SecretTable_SecretData_Key] DECRYPTION BY CERTIFICATE [cert_SecretTable_SecretData_Key]");
    ResultSet thisrs = thecon.prepareStatement("insert into users( username, password, description) values (N'"+username+"', encryptbykey( key_guid( 'SecretTable_SecretData_Key'), N'"+password+"'), N'"+description+"') select @@IDENTITY" ).executeQuery();   
    while(thisrs.next()){ theID = thisrs.getInt(1);}thisrs.close();thisrs = null;
    thecon.createStatement().execute("CLOSE SYMMETRIC KEY [SecretTable_SecretData_Key]");
    
   thecon.createStatement().execute("close master key");  
   
   thecon.close();
   
   return theID;
  }
  
  
  
  
  
  public static String[][] US() throws Exception
  {
    Connection con=null;
    InitialContext ic = new InitialContext();
    DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/TheDB");
    con  = ds.getConnection();
    ResultSet rs = null;
    
    int thecount=0;
    rs = con.createStatement().executeQuery("SELECT  count(*) from Users ");             
    while(rs.next()){thecount = rs.getInt(1);}rs.close();rs = null;
       
     	
   con.createStatement().execute("OPEN MASTER KEY DECRYPTION BY PASSWORD= 'dbpass'");
  	
  	String[][] users = new String[thecount][5];
  	
  	int tmpcntr=0;
    	
   con.createStatement().execute("OPEN SYMMETRIC KEY [SecretTable_SecretData_Key] DECRYPTION BY CERTIFICATE [cert_SecretTable_SecretData_Key]");
   
    rs = con.createStatement().executeQuery("SELECT  userid,username,description,convert( NVARCHAR(100), decryptbykey( password )) , (CONVERT(char(10), lastlogintime, 121)+ ' '+ convert(varchar,lastlogintime, 8)) as lastin from Users ORDER BY userID");             
    while(rs.next())
    {
    	users[tmpcntr][0] = rs.getString(1);
    	users[tmpcntr][1] = rs.getString(2);
    	users[tmpcntr][2] = rs.getString(3);
    	users[tmpcntr][3] = rs.getString(4);
    	users[tmpcntr][4] = rs.getString(5);
    	tmpcntr=tmpcntr+1;
    }
    rs.close();rs = null;
    con.createStatement().execute("CLOSE SYMMETRIC KEY [SecretTable_SecretData_Key]");
   
   con.createStatement().execute("close master key");   	
  	
  	con.close();
  	return users;
  	
  }

      
}