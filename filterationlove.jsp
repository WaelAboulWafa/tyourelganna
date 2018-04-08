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
   if(thepage[k].equalsIgnoreCase("filterationlove.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
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
//   if(thepage[k].equalsIgnoreCase("smsdistribution.jsp")){if(allowed[k] == 1){allowedaccess =true;}}
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



int offset=0;

if(request.getParameter("offset")!=null) 
{
 offset= Integer.parseInt(request.getParameter("offset").toString());
}

int pagesize = 50;
int count= 0;
int pages = 0;
int lowerbound = 0;
int upperbound = 0;






















  int reccount = 0;
     String[] id = null;
     String[] country =  null;     
     String[] sentdate =  null;
     String[] shortcode = null;
     String[] operator = null;
     String[] tel = null;
     String[] nickname = null;
     String[] msg = null;
     String[] messagelogic = null;
     String[] nameone = null;
     String[] nametwo = null;
     String[] perc = null;
      
     int visiblecount = 0 ;

int whenrejectcount = 0;    







//-----------------------------------
String query1 = "SELECT count(*) from newLove";
String query2 = "SELECT OriginalID from newLove order by OriginalID";
String query3 = " select newLove.originalid, newLove.country as thecountry,(  CONVERT(char(10), newLove.SentDate, 101) + ' ' + convert(varchar,newLove.SentDate, 8) )  ,newLove.msisdn, (case when chatNickNames.MessageContents is not null then  chatNickNames.MessageContents else '' end )AS NickName , ";
query3 = query3+ " ( newLove.Providername + '-' + newLove.country + '-' + newLove.operator + '-' + newLove.shortcode ) as shortcode , newLove.thesms as SMS ,newLove.MessageLogic as MessageLogic ,  newLove.firstname, newLove.secondname, newLove.perc FROM         newLove LEFT OUTER JOIN                chatNickNames ON newLove.MSISDN = chatNickNames.MSISDN order by  newLove.originalid";


String filtershortcode = "ALL";


















    

      rs = con.createStatement().executeQuery(query1);            
      if(rs.next())
      {
     	 reccount = rs.getInt(1);
      }
        rs.close(); rs = null;
   
  
    count =  reccount;
  
       
       rs = con.createStatement().executeQuery(query2);            
       while(rs.next())
       {
     	 String tmp = rs.getString(1);
     	 visiblecount = visiblecount + 1 ;
       }
        rs.close(); rs = null;
        
   
   rs = null;
   rs = con.createStatement().executeQuery(query3);

   
     id = new String[visiblecount];
     country = new String[visiblecount];
     sentdate =  new String[visiblecount];
     shortcode = new String[visiblecount];
     tel = new String[visiblecount];
     nickname = new String[visiblecount];
     msg = new String[visiblecount];
     messagelogic= new String[visiblecount];
     nameone= new String[visiblecount];
     nametwo= new String[visiblecount];
     perc= new String[visiblecount];
   
   rs.next();
   //int theCounter = 0;
   //while(rs.next())
for (int theCounter=0;theCounter<visiblecount;theCounter++)
    {
     id[theCounter] = rs.getString(1).trim();
     country[theCounter] = rs.getString(2).trim();
     sentdate[theCounter] =  rs.getString(3).trim();
     tel[theCounter] = rs.getString(4).trim();
     nickname[theCounter] = rs.getString(5).trim();
     shortcode[theCounter] = rs.getString(6).trim();
     msg[theCounter] = rs.getString(7).trim(); 
     messagelogic[theCounter] = rs.getString(8).trim(); 
     nameone[theCounter] = rs.getString(9).trim();  
     nametwo[theCounter] = rs.getString(10).trim(); 
     perc[theCounter] = rs.getString(11).trim(); 
     
     rs.next();
    // theCounter = theCounter + 1 ;
   }
   rs.close(); 
   rs = null;
   
   
   
   

   
   




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



















   if(count != 0 ) 
   {
     if(count%pagesize ==0)
      {
        pages = (count/pagesize);
      }
      else
      {  
        pages = (count/pagesize) + 1  ;
     }
   }
 
if(count != 0 )
{
if(pages == 1)
{
lowerbound = 0;
upperbound = count;
}
else
{

if( ( (offset) * pagesize) <= count)
{
 lowerbound = (offset * pagesize) ;

 if(   ((offset+1) * pagesize) > count )
  {
   upperbound = count;
  }
  else
  {
   upperbound = ( (offset+1) * pagesize);
  }
}
else
{
lowerbound = 0;
upperbound = 0;

}  
}  
  
 
}






   
   
    


   

   

             
%>



































<html dir='rtl'>
<HEAD>


<script LANGUAGE="JavaScript" type="text/javascript">


function selectall(k)
{

	for( i=0; i< k; i++ )
	{ 
	 if( document.getElementById('ischeck' + i) != null )  
     { 
	   document.getElementById('ischeck' + i).checked = true; 
	 }
	}
	
}


    

function correctinvoke(target)
{
if(target == 0) {document.mainform.action="BATCHApprovelove.jsp";document.mainform.submit();}
if(target == 1) {document.mainform.action="BATCHRejectlove.jsp";document.mainform.submit();}
if(target == 2) {document.mainform.action="BATCHWaiting.jsp";document.mainform.submit();}
if(target == 3) {document.mainform.action="BATCHApproveBoxANDBAR.jsp";document.mainform.submit();}




}
 


 function correctinvokelove(target)
{
  if(target == 0) {document.thisfrm.action="addlove.jsp";document.thisfrm.submit();}
}




</script>





























<STYLE type=text/css>BODY {MARGIN: 0px; FONT: 14pt arial, geneva, lucida, "lucida grande", arial, helvetica, sans-serif; COLOR: #000000;background-color: #<%=bgcolor%>; }</style>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
<title>„ «»⁄… «·„Ì“«‰ ... <%=medianame%></title>


</head>


<BODY>





<table border='1' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%' height='80'>
  <tr>
    <td width='21%' align='center'><b><i><font color='#A36103' size='6'>„ «»⁄… «·„Ì“«‰</font></i></b></td>
    

                
                
    
    <td width='30%' align='center'>
    <table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%'>
      <tr><td width='100%' align='center'><font color='#000000' face='Arial' size='4'><b> Êﬁ‹‹  «·œŒÊ·  <%= intime %> </b></font></td></tr>
      <tr><td width='100%' align='center'><font color='#000000' face='Arial' size='4'><b> &nbsp;</b></font></td></tr>
      <tr><td width='100%' align='center'><font color='#000000' face='Arial' size='4'><b>  «—Ì‹‹Œ «·œŒÊ·  <%= indate %> </b></font></td></tr>
    </table>
    </td>
    <td width='24%' align='center'>
    	<table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#A36103' width='100%'>
 		<form action='MainPage.jsp' method='post'>                
     		 <tr><td align='center'><input type='submit' name='subMain' value='«·ﬁ«∆„… «·—∆Ì”Ì…' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
                </form>
 		<form name='theform' action='filterationlove.jsp' method='post'>
     		<tr><td align='center'><input type='submit' name='subRefresh' value='«⁄«œ…  Õ„Ì·' STYLE='font-weight:bold;font-family:arial;font-size:18;color:#00f;width:12em;height:2.5em'></td></tr>
               </form>
    	</table>
    </td>
<td bgcolor='#ffffff' width='15%' align='center'><IMG src='logo.png'></td>
  </tr>
</table>




<br>







  





 
      <table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
 <form name=thisfrm  action="" method='get'>
 
        <tr>
          <td width='100%' height='369' valign='top'>
      	    <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#ffffff' width='80%'>
      	    

       	    
      	      <tr height='25' bgcolor=#DCDCDC>
 

      	      

      	        <td width='15%' align='center'><b>«·«Ê·</b></td>
      	        <td width='15%' align='center'><b>«·À«‰Ì</b></td>
      	        <td width='15%' align='center'><b>‰”»Â</b></td>

      	              	        
      	      </tr>
      	      <tr>

      	        <td width='15%' align='center'><input type='text' style='font-size:12pt;color:#000000;font-weight:bold;width:8em;height:1.7em' dir='ltr' name='country' ></td>
      	        <td width='15%' align='center'><input type='text' style='font-size:12pt;color:#000000;font-weight:bold;width:8em;height:1.7em' dir='ltr' name='operator' ></td>
      	        <td width='15%' align='center'><input type='text' style='font-size:12pt;color:#000000;font-weight:bold;width:8em;height:1.7em' dir='ltr' name='provider' ></td>
      	        


      	        <td width='20%' align='right'><input type='button' name='subAdd' value='«—”«·' style='font-weight:bold ; width:9em ; height:2.5em' onClick="correctinvokelove(0)"></td>
      	              	        
      	      </tr>
</form>
      	    </table>


<br>




               


            <br>







            <table border='1' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='96%'>
                  <tr height='30'>
                    <td align='center' width='4%'>
<%
if(pages>0)
{
  for(int i=0;i<pages;i++)
  {
   if(i==offset)
    {
%>
                     <b><%= (offset +1)%></b>
<%
    }
    else
   {
%>
                  <b><a href=filterationlove.jsp?offset=<%= i %>&filtertheshortcode=<%= URLEncoder.encode(filtershortcode)%> ><%= Integer.toString(i+1) %> </a>&nbsp;</b>
<%
   }
   
  }
}
%>
                    </td>
                  </tr>
            </table>

  









            <table border='1' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='98%'>
                  <tr>
                        <td>
                              <table border='0' align='center' bgcolor=#DCDCDC cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                    <tr>
                                          <td width='5%' align='center'>
                                                <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                                      <input type='hidden' name='uid' value='41'>
                                                      <input type='hidden' name='cur_page' value='1'>
                                                      <input type='hidden' name='selc' value=''>
                                                      <tr><td align='center'><input type='button' name='subSelectAll' value='«·ﬂ·' style='font-weight:bold ; width:8em ; height:2em' onClick='selectall(<%=reccount%>)'></td></tr>
                                                </table>
                                          </td>
                                          <td width='5%' align='center'>&nbsp;</td>
                                          <td width='10%' align='center'><input type='button' name='subApproveSMSSel' value='„Ê«›ﬁ…' style='font-weight:bold ; color:#0000FF; width:8em ; height:2em' onClick="correctinvoke(0)"></td>

                                          <td width='10%' align='center'><input type='button' name='subDeclineSMSSel' value='—›÷' style='font-weight:bold ; width:8em ; color:#FF0000; height:2em' onClick="correctinvoke(1)"></td>

                                          <td width='25%' align='center'>
                                                <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                                      <tr align="center" >
                                                       <td align='center' >


 <INPUT type='hidden' NAME=filtertheshortcode SIZE=17  READONLY value="ALL" >
 
                                                       </td>
                                                      </tr>
                                                </table>
                                          </td>
                                          <td width='15%' align='center'>
                                                <table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                                      <tr>
                                                            <td align='center'><b>⁄œœ</b></td>
                                                            <td align='left'><font color=#000099><b><%= reccount %></b></font></td>
                                                      </tr>
                                                </table>
                                          </td>
                                          <td width='10%' align='center'>
                                          	<table border='0' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#111111' width='100%'>
                                                      <tr>
                                                            <td align='center'><b>’›Õ…</b></td>
                                                            <td align='left'><font color=#000099><b><%= (offset +1)%>&nbsp/&nbsp;<%= pages %></b></font></td>
                                                      </tr>
                                          	</table>
                                          </td>
                                    </tr>
                              </table>
                        </td>
                  </tr>
            </table>

   



































     <table border='1' align='center' cellpadding='0' cellspacing='0' style='border-collapse: collapse' bordercolor='#cccccc' width='98%'>
             <tr bgcolor=#DCDCDC>
                  <td width='5%' align='center'><b>«Œ Ì«—</b></td>

                  </td><td width='8%' align='center'><b>„”·”·</b></td>
                  <td width='10%' align='center'><b>«·«Ê·</b></td>
                  <td width='10%' align='center'><b>«·À«‰Ì</b></td>
                  <td width='5%' align='center'><b>‰”»Â</b></td>
                  <td width='25%' align='center'><b>«’· «·—”«·Â</b></td>                  
                  <td width='12%' align='center'><b> «—ÌŒ «·«—”«·</b></td>
                  <td width='15%' align='center'><b> ·Ì›Ê‰</b></td>
                  <td width='15%'  align='center'><b>„’œ— «·Œœ„…</b></td>
                  <td width='15%' align='center'><b>«·«”„ «·„” ⁄«—</b></td>
              
            </tr>
     


<form name=mainform method=post action="" >

<INPUT style="display: none;" NAME=theoffset SIZE=10  value="<%= lowerbound %>" > 
<INPUT style="display: none;" NAME=countrysc SIZE=10  value="<%= filtershortcode %>" > 
<INPUT style="display: none;" NAME=thebase SIZE=10  value="<%= offset %>" > 

<INPUT style="display: none;" NAME=count SIZE=10  value="<%= reccount %>" > 

<% for (int l =lowerbound ; l < upperbound ; l ++)
{
%>

<tr bgcolor=#FFFFFF>


 
           <INPUT style="display: none;" NAME=messagelogic<%= l %>  value="<%= messagelogic[l] %>" >     

           <INPUT style="display: none;" NAME=country<%= l %>  value="<%= country[l] %>" >                
           
           <INPUT style="display: none;" NAME=id<%= l %> SIZE=6  READONLY value="<%= id[l] %>" >  
           
           <INPUT style="display: none;" NAME=msg<%= l %> SIZE=6  READONLY value="<%= msg[l] %>" > 



  
            <td align='center'>  <INPUT id="ischeck<%= l %>" NAME=ischeck<%= l %> TYPE=CHECKBOX >  </td>
    	    <td align='center'>  <b><font color=#000000 size=3>  <%= id[l] %></b> </td>
    	    <td align='center'> <INPUT dir='rtl' style='font-size:12pt;color:#0000AA;font-weight:bold;width:10em;height:1.7em' id="nameone<%= l %>" NAME=nameone<%= l %> value=<%= nameone[l]  %> ></td>
      	    <td align='center'> <INPUT dir='rtl' style='font-size:12pt;color:#0000AA;font-weight:bold;width:10em;height:1.7em' id="nametwo<%= l %>" NAME=nametwo<%= l %> value=<%= nametwo[l]  %> ></td>
            <td align='center'> <INPUT dir='ltr' style='font-size:12pt;color:#0000AA;font-weight:bold;width:3em;height:1.7em' id="perc<%= l %>" NAME=perc<%= l %> value=<%= perc[l]  %> ></td>    	    
            <td align='center'>   <b><font color=#000000 size=4>  <%=  msg[l]  %></b> </td>    	    
    	    <td align='center'> <b><font color=#000000 size=4>  <%= sentdate[l] %> </td></font></b></td>




    	    
 <INPUT type='hidden' NAME=tel<%= l %> SIZE=17  READONLY value="<%= tel[l] %>" >

<%    	    
if(phoneallowed == 1)
{
%>
    	    <td align='center'><b><font color=#000000 size=4><%= tel[l] %></font></b></td>
<%
}
else
{
             if(tel[l].length() >= 4)
             {
%>
    	       <td align='center'><b><font color=#000000 size=4><%= tel[l].substring(tel[l].length()-4,tel[l].length()) %></font></b></td>
<%
             }
             else
             {
%>
    	       <td align='center'><b><font color=#000000 size=4><%= tel[l] %></font></b></td>
<%             
             }
}
%>





    	    <td align='center'> <b><font color=#000000 size=2>  <%= shortcode[l] %> </font></b></td>    	       	    

    	    <td align='center'> <b><font color=#000000 size=4> <%=  nickname[l]  %> </font></b></td>    	        
    	    
    	    	    


   	        	    





           </tr>            
<%
}
%>
</form>

 </table>



















<br>


</BODY>
</HTML>
























<%
con.close();   
}
}
%>

