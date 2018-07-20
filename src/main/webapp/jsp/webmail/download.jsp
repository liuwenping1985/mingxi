<%@page language="java" contentType="application/x-msdownload" pageEncoding="UTF-8"%>
<%@page import="java.io.*" %>
<%@page import="java.net.URLEncoder" %><%
	 String path = (String)request.getAttribute("path");
	 String fileName = (String)request.getAttribute("filename");
     response.reset();
     response.setContentType("application/x-download");
     String filedisplay = URLEncoder.encode(fileName,"UTF-8");
     response.addHeader("Content-Disposition","attachment;filename=" + filedisplay);
     OutputStream outp = null;
     FileInputStream in = null;
     try
     {
         outp = response.getOutputStream();
         in = new FileInputStream(path + fileName);
         byte[] b = new byte[1024];
         int i = 0;
         while((i = in.read(b)) > 0)
         {
             outp.write(b, 0, i);
         }
         outp.flush();
     }
     catch(Exception e)
     {
         e.printStackTrace();
     }
     finally
     {
         if(in != null)
         {
             in.close();
             in = null;
         }
         if(outp != null)
         {
             outp.close();
             outp = null;
         }
         File f = new File(path+fileName);
         f.delete();
     }
%>