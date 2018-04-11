<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html"
	prefix="html"%>

<fmt:setBundle
	basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources"
	var="v3xCommonI18N" />
<fmt:setBundle
	basename="com.seeyon.v3x.main.resources.i18n.MainResources" />

<fmt:setBundle basename="com.seeyon.apps.index.resource.i18n.IndexResources" var="indexResources"/>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
		<title><fmt:message key="menu.system.index.setting.title" />
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	</head>
	${v3x:skin()}
	<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
	<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/addressbook/js/prototype.js${v3x:resSuffix()}" />"></script>
	<script type="text/javascript">

	var v3x = new V3X();
	//getA8Top().showLocation(2307);
	//getA8Top().hiddenNavigationFrameset(2307);


	function init(){
		if("${modelName}"=="local"){
			SetA8Switch_off();
		}else{
			SetA8Switch_on();
		}
		<c:if test="${param.outMsg!=null}">
			alert('<fmt:message key="${param.outMsg}" bundle="${indexResources }"/>');
		</c:if>
	}

	function SetA8Switch_off(){
		tr1.style.display = "none";
		tr2.style.display = "none";
		$('showOff').checked="checked";
		//tr3.style.display = "none";
		//tr4.style.display = "none";
	}

	function SetA8Switch_on(){
		tr1.style.display = "";
		tr2.style.display = "";
		$('showOn').checked="checked";
		//tr3.style.display = "";
		//tr4.style.display = "";

	}
	function openHelp(){
		var returnValue = new V3X().openWindow({
			url: "<c:url value='/index/indexController.do?method=openHelp' />",
			width : 560,
			height : 420,
			dialogType: 'open',
			resizable: "no"
		});
	}
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
</script>
	<body scroll="no" onload="init()">
		<span id="nowLocation"></span>
		<form id="form1" method="post" name=""
			action="<c:url value='/index/indexController.do?method=updateIndexConfig' />" onSubmit="return checkForm(this)">
			<table border="0" cellpadding="0" cellspacing="0"  align="center" width="100%" height="100%" class="">
			<tr class="page2-header-line">
				<td width="100%" height="41" valign="top" class="border_b">
					 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
				     	<tr class="page2-header-line">
				        <td width="45" class="page2-header-img"><div class="iSearchIndex"></div></td>
			        <td class="page2-header-bg"><fmt:message key="menu.system.index.setting"/></td>
			        <td class="page2-header-line padding5" align="right"><a href="javascript:openHelp()" class="like-a"><fmt:message key="common.toolbar.help.label" bundle="${v3xCommonI18N}"/></a></td>
			        <td class="page2-header-line padding5" width="20">&nbsp;</td>
				</tr>
			     </table>
				</td>
				</tr>

				<tr>
					<td valign="top"><br/><br/><br/>
						<TABLE width="80%"  align="center" border="0"
							cellpadding="2" cellspacing="2">
							<tr>
								<td align="right">
									<strong>
										<fmt:message key="menu.system.index.setting.title" />:
									</strong>
								</td>
								<td></td>
							</tr>
							<TR>
								<TD align="right" width="40%">
									<font color="red">*</font><fmt:message
											key="menu.system.index.setting.model" />:
								</TD>
								<TD>

								   <label onclick="SetA8Switch_off()">
									  <input id="showOff" name="modelName" type="radio" value="local" ${modelName!='remote' ? 'checked' : ''}>
									  <fmt:message key="menu.system.index.setting.LocalModel" />

								   </label>

								   <label onclick="SetA8Switch_on()">
									  <input id="showOn" name="modelName" type="radio" value="remote" ${modelName=='remote' ? 'checked' : ''}>
									<fmt:message key="menu.system.index.setting.remoteModel" />
								   </label>

								</TD>
							</TR>
							<TR>
								<TD  align="right">
									<font color="red">*</font>
									<fmt:message key='menu.system.index.setting.ipAddress' />
									:
								</TD>
								<TD>
									<input type="text" name="indexIp"
										inputName="<fmt:message key='menu.system.index.setting.ipAddress' />"
										validate="notNull" value="${indexIp}">
								</TD>
							</TR>
							<TR>
								<TD  align="right">
									<font color="red">*</font>
									<fmt:message key="menu.system.index.setting.Port" />
									:
								</TD>
								<TD>
									<input type="text" name="indexPort"
										inputName="<fmt:message key='menu.system.index.setting.Port'/>"
										validate="notNull" value="${indexPort}" readonly="readonly" style="color: darkgray">
								</TD>
							</TR>
							<TR>
								<TD  align="right">
									<font color="red">*</font>
									<fmt:message key="menu.system.index.setting.serviceName" />
									:
								</TD>
								<TD>
									<input type="text" name="indexServiceName"
										inputName="<fmt:message key='menu.system.index.setting.serviceName' />"
										validate="notNull" value="${indexServiceName}" readonly style="color: darkgray">
								</TD>
							</TR>
							<tr>
								<td  align="right" class="description-lable">
									<font color="red">*</font>
									<fmt:message key="menu.system.index.setting.insertTime" />
									:
								</td>
								<td class="description-lable">
									<input type="text" name="indexParseTimeSlice"
										inputName="<fmt:message key='menu.system.index.setting.insertTime'/>"
										validate="notNull,isInteger" value="${indexParseTimeSlice}">
										<fmt:message key='menu.system.index.setting.ms'/>
								</td>
							</tr>
							<tr>
								<td  align="right" class="description-lable">
									<font color="red">*</font>
									<fmt:message key="menu.system.index.setting.updateTime" />
									:
								</td>
								<td class="description-lable">
									<input type="text" name="indexUpdateTimeSlice"
										inputName="<fmt:message key='menu.system.index.setting.updateTime'/>"
										validate="notNull,isInteger" value="${indexUpdateTimeSlice}">
										<fmt:message key='menu.system.index.setting.minutes'/>
								</td>
							</tr>


							<tr id = "tr1">
								<td colspan="2">
									<center>
										<c:choose>
										<c:when test ="${v3x:getSysFlagByName('sys_isGovVer')=='true'}">
											<fmt:message key="menu.system.index.setting.A8SideConfiguration${v3x:suffix()}" />
										</c:when>
										<c:when test="${v3x:getSysFlagByName('sys_isA6Ver')=='true'}">
											<fmt:message key="menu.system.index.setting.A6SideConfiguration" />
										</c:when>
										<c:otherwise>
											<fmt:message key="menu.system.index.setting.A8SideConfiguration${v3x:oemSuffix()}" />
										</c:otherwise>
										</c:choose>
									</center>
								</td>
							</tr>

							<tr id = "tr2">
								<td  align="right" class="description-lable">
									<font color="red">*</font>
									<fmt:message key="menu.system.index.setting.ipAddress" />
									:
								</td>
								<td class="description-lable">
									<input type="text" name="a8Ip"
										inputName="<fmt:message key='menu.system.index.setting.ipAddress'/>"
										validate="notNull" value="${a8Ip}">
								</td>
							</tr>
							<!--
							<tr id = "tr3" >
								<td height="40%" align="right" class="description-lable">
									<font color="red">*</font>
									<fmt:message key="menu.system.index.setting.Port" />
									:
								</td>
								<td class="description-lable">
									<input type="text" name="a8-Port"
										inputName="<fmt:message key='menu.system.index.setting.Port'/>"
										validate="notNull" value="${a8-Port}" readonly style="color: darkgray" >
								</td>
							</tr>
							<tr id = "tr4">
								<td height="40%" align="right" class="description-lable">
									<font color="red">*</font>
									<fmt:message key="menu.system.index.setting.serviceName" />
									:
								</td>
								<td class="description-lable">
									<input type="text" name="a8-ServiceName"
										inputName="<fmt:message key='menu.system.index.setting.serviceName'/>"
										validate="notNull" value="${a8-ServiceName}" readonly style="color: darkgray">
								</td>
							</tr>
						 -->
						</TABLE>
					</td>
				</tr>
				<tr>
					<td  height="42" align="center"
						class="bg-advance-bottom" >
						<input type="submit"
							value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">
						&nbsp;&nbsp;
						<input type="button"
							onclick="getA8Top().document.getElementById('homeIcon').click();"
							value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />"
							class="button-default-2">
					</td>
				</tr>
			</TABLE>
		</form>
	</body>
<script language="javascript">
showCtpLocation('F04_indexConfig');
</script>
</html>


