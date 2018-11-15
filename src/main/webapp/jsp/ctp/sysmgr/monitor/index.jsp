<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	session.setAttribute("GoodLuckA8", Boolean.TRUE);
	
	String serverInfo = application.getServerInfo();
	
	if (serverInfo != null  && (serverInfo.contains("WebSphere") || serverInfo.contains("WebLogic") || serverInfo.contains("TongWeb"))) {
		response.sendRedirect("/seeyon/ctp/sysmgr/monitor/status4WAS.do");
	}
	else{
		response.sendRedirect("status.do");
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>A8 Management Monitor</title>
<link rel="stylesheet" type="text/css" href="../common/css/default.css">
</head>
<body>
<img border="0" src="../common/images/A8-logo.gif">
<hr size="1" noshade="noshade">
<div align="center" style="height: 400px; padding: 200px">
<form action="index.jsp" method="post" >
Password:
<input name="password" type="password" value="" style="width: 100px">
<input type="submit" value="Sign In">
</form>
</div>
<hr size="1" noshade="noshade"><center><font size="-1" color="#525D76"><em>Copyright &copy; 2009, www.seeyon.com</em></font></center>
</body>
</html>