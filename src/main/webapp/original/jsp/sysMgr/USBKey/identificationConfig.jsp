<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>登录验证配置</title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/plugin/USBKey/js/IPInput.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
showCtpLocation("F13_identificationConfig");
//TODO　getA8Top().hiddenNavigationFrameset();
</script>
<style type="text/css">
.ip{
    border:1px solid #666;
    width:124px;
    font-size:12px;
}
.fld{
    float:left;
    width:25px;
}
.fld input{
    border:none;
    width:25px;
}
.fldDot{
    float:left;
    width:5px;
}
</style>
</head>
<body scroll="auto">
<form name="configIdentificationForm" action="${identificationURL}" method="post" onsubmit="return configIdentificationOK()">
<input type="hidden" name="method" value="saveIdentificationConfig">
<input type="hidden" name="noCheckIp" value="${noCheckIp}">
<table border="0" width="100%" height="100%" align="center" cellpadding="0" cellspacing="0" class="page-list-border">
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line">
		        <td width="45" class="page2-header-img"><div class="identificationConfig"></div></td>
		        <td class="page2-header-bg"><fmt:message key='menu.USBKey.config' /></td>
		        <td class="page2-header-line">&nbsp;</td>
			</tr>
		</table>
		</td>
	</tr>	
	<tr>
	   <td width="100%" height="100%" class="categorySet-head" style="padding-top: 60px;">
			<table width="500" align="center" height="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="100%" height="28">
					<label for="isMustUseDogLogin">
						<input id="isMustUseDogLogin" name="isMustUseDogLogin" onclick="displayIPTR()" type="checkbox" ${isMustUseDogLogin? 'checked':''}>
						<fmt:message key="USBKey.attribute.isMustUseDog"/>
					</label>
					</td>
				</tr>
				<tr id="setNoCheckIpTR" style="display: ${isMustUseDogLogin? '':'none'}">
					<td height="300">
						<fieldset style="padding:12px;">
							<legend><b><fmt:message key="identificationConfig.IPSetting.label"/>:</b></legend>
							<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td width="50" height="100%">&nbsp;
									</td>
									<td width="140" style="padding-top:12px;">
										<SELECT name="IPSelect" size="8" id="select" style="width:124px;" ondblclick="removeIPOption()">
									      <c:forTokens items="${noCheckIp}" delims=";" var="ip">
									        <OPTION value="${ip}">${ip}</OPTION>
									      </c:forTokens>
									    </SELECT>
									</td>
									<td width="100%" align="left" valign="middle">
									    &nbsp;&nbsp;<input type="button" value="<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />" class="button-default-2" onclick="removeIPOption()">
									</td>
								</tr>
								<tr>
								<td height="50" nowrap="nowrap">
									<fmt:message key="identificationConfig.IPAddress.label"/>:
								</td>
								<td>
									<div class="ip" id="ipAddress"></div>
									<script type="text/javascript">
										var ipAddress = new CIP("ipAddress", "ipAddress");
											ipAddress.create();
									</script>
								</td>
								<td>
									&nbsp;&nbsp;<input type="button" value="<fmt:message key='common.button.add.label' bundle='${v3xCommonI18N}' />" class="button-default-2" onclick="addIPOption(ipAddress.getIPValue())">
								</td>
								</tr>
								<tr>
									<td colspan="3" class="description-lable">
										<fmt:message key="identificationConfig.IPSetting.description"/>
									</td>
								</tr>
								<tr>
									<td colspan="3"><br/>
										<font color="red">
										<fmt:message key="identificationConfig.mustUseDogLogin.tip"/>
										</font>
									</td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
				<tr>
					<td height="100%">&nbsp;</td>
				</tr>
			</table>
	    </td>
	</tr>
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
	      	<input type="submit" name="submitBtn" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>" class="button-default_emphasize"/>&nbsp;&nbsp;
	      	<input type="button" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" class="button-default-2" onclick="getA8Top().document.getElementById('homeIcon').click();"/>
	   </td>
	</tr>
</table>
</form>
</body>
</html>