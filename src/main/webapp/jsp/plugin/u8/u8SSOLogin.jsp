<%@page import="java.net.URLEncoder"%>
<%@page import="com.seeyon.apps.u8.po.U8UserMapperBean"%>
<%@page import="com.seeyon.ctp.util.DateUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@include file="header.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js" />"></script>
<%
response.setDateHeader("Expires",-1);
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragrma","no-cache");

%>
 <script type="text/javascript">
 resetCtpLocation();
//适配U8 11.0版本的WEB登录
function init(){
	if(!"${bean}"){
		alert('<fmt:message key="u8.space.error"/>');
		return;
	}
	var logindate = '<%=DateUtil.getDate("yyyy-MM-dd")%>';
	var sessionInfo = "<info><zt>${bean.accountNo}</zt><year>${bean.accountYear}</year><date>"+logindate+"</date><serial></serial><uid>${bean.perator}</uid><pwd>${bean.password}</pwd><server>${bean.serverAddress}</server><lang>zh-CN</lang></info>";
	sessionInfo = encodeURIComponent(sessionInfo);
	document.getElementById("u8webform").action="http://" +"${webAddress}"+"/U8SL/Login.aspx";
	document.getElementById("logininfo").value=sessionInfo; 
	u8webform.submit(); 
}

 </script>
 <body onload="init();">
 <form id="u8webform" name="u8webform" method="post" target="_self" action="">
      	<input id="logininfo" name="logininfo" type="hidden" value="2178"/>
      </form>
 </body>
 </html> 