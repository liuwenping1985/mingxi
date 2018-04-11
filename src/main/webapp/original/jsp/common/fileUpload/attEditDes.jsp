<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="header.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<title><fmt:message key="fileUpdate.page.about" /></title>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
<table width="100%" height="100%" cellpadding="0" cellspacing="0" class="popupTitleRight">
	<tr><td colspan="3" class="PopupTitle"><fmt:message key="fileUpdate.page.about" /></td></tr>	
	<tr>
		<td width="10">&nbsp;</td>
		<td height="100%">
			<div class="border-top border-left border-right border-bottom scrollList">
				<ul class="help-content">
					<li>
						<ul>
							<li><span><fmt:message key="fileUpdate.page.about.1"/></span></li>
						</ul>
					</li>
					<li>
						<ul>
							<li><span><fmt:message key="fileUpdate.page.about.2"/></span></li>
						</ul>
					</li>
				</ul>
			</div>
		</td>
		<td width="10">&nbsp;</td>
	</tr>
	<tr><td colspan="3" class="bg-advance-middel" align="right">
		 <input name="ok" type="button" onClick="window.close()" class="button-default-2" value="<fmt:message key='common.button.close.label' bundle='${v3xCommonI18N}' />"  />
	</td>
	</tr>	
</table>
</body>
</html>