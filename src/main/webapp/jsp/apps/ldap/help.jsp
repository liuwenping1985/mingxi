<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@include file="header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><fmt:message key="common.toolbar.help.label" bundle="${v3xCommonI18N}"/></title>
</head>
<body scroll="no">
<table width="100%" height="100%" cellpadding="0" cellspacing="0" class="popupTitleRight">
	<tr><td colspan="3" class="PopupTitle"><fmt:message key="common.toolbar.help.label" bundle="${v3xCommonI18N}"/></td></tr>	
	<tr>
		<td width="10">&nbsp;</td>
		<td height="100%">
			<div class="border-top border-left border-right border-bottom scrollList">
				<ul class="help-content">
					<li>
						<ul>
							<li><span><fmt:message key="ldap.index.help.1.label" bundle="${ldaplocale}"/></span></li>
						</ul>
					</li>
					<li>
						<ul>
							<li><span><fmt:message key="ldap.index.help.2.label" bundle="${ldaplocale}"/></span></li>
						</ul>
					</li>
					<li>
						<ul>
							<li><span><fmt:message key="ldap.index.help.3.label" bundle="${ldaplocale}"/></span></li>
						</ul>
					</li>
				</ul>
			</div>
		</td>
		<td width="10">&nbsp;</td>
	</tr>
	<tr><td colspan="3" class="bg-advance-middel" align="right">
		 <input name="ok" type="button" onClick="window.close()" class="button-default-2" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />"  />
	</td>
	</tr>	
</table>
</body>
</html>