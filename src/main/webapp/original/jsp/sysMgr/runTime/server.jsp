<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
getA8Top().showCtpLocation("F13_sysRuntimeServer");
</script>

</head>
<body scroll="no" style="overflow: no">
<form action="<html:link renderURL='/serverState.do?method=doChanageState' />" method="post" onsubmit="return checkForm(this)">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="border_b">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line">
		        <td width="45" class="page2-header-img"><div class="serverStateIndex"></div></td>
		        <td class="page2-header-bg"><fmt:message key="menu.system.runtimeServer" /></td>
		        <td>&nbsp;</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="top" class="padding5">
			<table align="center" width="500" cellpadding="0" cellspacing="0">	
				<tr>
					<td height="50">&nbsp;</td>
					<td height="50">&nbsp;</td>
			    </tr>
			    <tr>
			    <td width="100" align="right"><fmt:message key="ServerState.forecastTime.label" var="forecastTimeLabel" />${forecastTimeLabel}:&nbsp;&nbsp;	</td>
			    <td height="26"> <input value="${(empty minute || minute < 1) ? '5' : minute}" name="minute" inputName="${forecastTimeLabel}" validate="notNull,isInteger" max="30" mix="1" style="width: 50px"> <fmt:message key="ServerState.minute.label" /> </td>
			    </tr>
			    <tr>
			    <td align="right"><fmt:message key="ServerState.comment.label" var="commentLabel" />${commentLabel}:&nbsp;&nbsp;</td>
			    <td height="80"> <textarea cols="60" rows="4" name="comment" inputName="${commentLabel}" validate="notNull" maxSize="50">${comment}</textarea></td>
			    </tr>
				<tr>
				<td></td>
					<td style="padding: 5px 0px 5px 0px">
						<label for="autoExit">
							<input type="checkbox" name="autoExit" id="autoExit" ${isShutdown == true ? (autoExit ? 'checked' : '') : 'checked'}> <fmt:message key="ServerState.description.autoExit.label" />
						</label>
					</td>
			    </tr>
				<tr>
					<td colspan="2"><p class="description-lable"><b><fmt:message key="common.instructions.label" bundle="${v3xCommonI18N}" /></b><br/>
						<fmt:message key="ServerState.description.label" /></p>
					</td>
			    </tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="submit" ${isShutdown?'disabled':''} value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">
		</td>
	</tr>
</table>
</form>
</body>
</html>