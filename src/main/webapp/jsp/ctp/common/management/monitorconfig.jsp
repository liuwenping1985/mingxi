<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.seeyon.ctp.monitor.domain.MonitorConfig"%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>A8</title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
v3x.loadLanguage("/apps_res/systemmanager/js/i18n");
getA8Top().hiddenNavigationFrameset(2407);
//-->
</script>

</head>
<body scroll="no" style="overflow: no">
<%
if(request.getParameter("intervalTime")!=null){
	MonitorConfig.setIntervalTimems(Long.parseLong(request.getParameter("intervalTime"))*1000);
	MonitorConfig.setSpareDBConThreshold(Long.parseLong(request.getParameter("spareDbCon")));
	MonitorConfig.setBusyThreadsCount4HttpThreshold(Long.parseLong(request.getParameter("httpThreshold")));
	MonitorConfig.setBusyThreadsCount4AjpThreshold(Long.parseLong(request.getParameter("ajpThrehold")));
	%>
	<script type="text/javascript">alert('配置成功！');</script>
	<%
}
%>
<form action="<html:link renderURL='monitorconfig.jsp' />" method="post" onsubmit="return checkForm(this)">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="border_lr">
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line">
		        <td width="45" class="page2-header-img"><div class="infoOpen"></div></td>
		        <td class="page2-header-bg">监控配置</td>
		        <td>&nbsp;</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="top" class="padding5">
			<table align="center" width="500" cellpadding="0" cellspacing="0">	
			<tr><td colspan="2"  height="50">&nbsp;</td></tr>
			    <tr>
			    	<td height="30" align="right">监控间隔(秒):&nbsp;</td>
			    	<td><input type="input" id="intervalTime" name="intervalTime" class="input-datetime cursor-hand" inputName="监控间隔" validate="notNull,isInteger" min="3" value="<%= MonitorConfig.getIntervalTimems()/1000%>"></td>
			    </tr>
			    <tr>
			    	<td height="30" align="right">空间数据库连接数:&nbsp;</td>
			    	<td><input type="input" id="spareDbCon" name="spareDbCon" class="input-datetime cursor-hand" inputName="空间数据库连接数" validate="notNull,isInteger" min="1" value="<%= MonitorConfig.getSpareDBConThreshold()%>"></td>
			    </tr>
			    <tr>
			    	<td height="30" align="right">HTTP繁忙线程数:&nbsp;</td>
			    	<td><input type="input" id="httpThreshold" name="httpThreshold" class="input-datetime cursor-hand" inputName="HTTP繁忙线程数" validate="notNull,isInteger" min="5" value="<%= MonitorConfig.getBusyThreadsCount4HttpThreshold()%>"></td>
			    </tr>
			    <tr>
			    	<td height="30" align="right">AJP繁忙线程数:&nbsp;</td>
			    	<td><input type="input" id="ajpThrehold" name="ajpThrehold" class="input-datetime cursor-hand" inputName="AJP繁忙线程数" validate="notNull,isInteger" min="5" value="<%= MonitorConfig.getBusyThreadsCount4AjpThreshold() %>"></td>
			    </tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="submit" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
</table>
</form>
<script type="text/javascript">
<!--
function enabledEndTime(){
	document.getElementById("endTime").disabled = !document.getElementById("enabled").checked
	document.getElementById("password").disabled = !document.getElementById("enabled").checked
}

enabledEndTime();
//-->
</script>
</body>
</html>