<%@ page language="java"  import="java.util.*,java.io.*,java.text.*,java.sql.*" %>
<%
  String filetosave= (new SimpleDateFormat("yyyyMMdd")).format(new java.util.Date((new java.util.Date()).getTime())).trim() + request.getContextPath() +".csv";
  BufferedOutputStream o = new BufferedOutputStream(response.getOutputStream());
  String thedata= request.getParameter("data");
  response.setContentType("text/csv");
  response.addHeader("Content-Disposition","attachment;filename="+ filetosave);
  o.write(thedata.getBytes());
  o.flush();
  o.close();
%>