<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<SCRIPT language=javascript> 
<!-- 
	var v3x = new V3X();
	v3x.init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.v3x.common.i18n.LocaleContext.getLanguage(request)%>");
	v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
	v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
getA8Top().hiddenNavigationFrameset(1003);
//--> 
</SCRIPT> 
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/weather.js${v3x:resSuffix()}" />"></script>
<title>天气预报</title>
</head>
<body scroll="no" style="overflow: hidden" onload="initWeather('${weatherConfig}')">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr>
		<td width="100%" height="80" valign="top">
			 <table width="100%" border="0" cellpadding="0" cellspacing="0" class="page2-header-line">
			        <tr>
						<td width="80"><img src="<c:url value="/apps_res/v3xmain/images/page_title/title_weather.gif" />" width="80" height="60" /></td>
						<td class="page2-header-bg">&nbsp;<fmt:message key="menu.tools.weather" /></td>
						<td class="page2-header-line">&nbsp;</td>
			      </tr>
			 </table>
		</td>
	</tr>
<tr>
<td valign="top">
<TABLE width="80%" align="center" border="0" cellpadding="0" cellspacing="0">
 <TR>
   <TD width="50%" align="center">
       <table width="400" height="360" cellpadding="2" cellspacing="1" style="border:2px solid #488ef7;">
         <tr>
             <td width="100%" height="28" bgcolor="#488ef7" style="padding-left:6px;"><b><font color="#ffffff"><fmt:message key="weather.city.label"/></font></b>
             </td>
       	 </tr>
         <tr>
             <td width="100%" height="332" align="center">
             <div id="cityWeatherDIV"></div>
             </td>
       	 </tr>
       </table>
   </TD>
   <TD width="50%" align="center">
   <table width="400" height="360" cellpadding="2" cellspacing="1" style="border:2px solid #488ef7;">
         <tr>
             <td width="100%" height="28" bgcolor="#488ef7" style="padding-left:6px;"><b><font color="#ffffff"><fmt:message key="weather.countrywide.label"/></font></b>
             </td>
       	 </tr>
         <tr>
             <td width="100%" height="332" align="center">
                <div id="countrywideWeatherDIV"></div>
             </td>
       	 </tr>
    </table> 
   </TD>
</TR>
</TABLE>
</body>
</html>