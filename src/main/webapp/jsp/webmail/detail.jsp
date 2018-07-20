<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.webmail.resources.i18n.WebMailResources"/>
<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>

<html:link renderURL='/webmail.do' var='webmailURL' />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" href="${pageContext.request.contextPath}/skin/default/skin.css">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;

//-->
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Mail</title>

</head>
<body scroll="no">

<v3x:attachmentDefine attachments="${attachments}" />

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">
	<tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
			getDetailPageBreak(); 
		</script>
		</td>
	</tr>
	<tr>
		<td height="10" class="detail-summary">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" class="ellipsis">
				<tr>
					<td height="22" nowrap class="bg-gray" width="60"><fmt:message key='label.head.from'/>: </td>
					<td title="<c:out value='${bean.from}' />"><c:out value='${bean.from}' /></td>
					<td height="22" width="60" nowrap style="text-align: left;padding-right: 5px;	font-size: 12px;height: 24px;"><fmt:message key='label.head.to'/>: </td>
					<td title="<c:out value='${bean.to}' />"><c:out value='${bean.to}' /></td>
				</tr>
				<tr>
					<td width="90" height="22" nowrap class="bg-gray"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />: </td>
					<td title="${v3x:toHTML(bean.subject)}">${v3x:toHTML(bean.subject)}</td>
					<td height="22" nowrap 	style="text-align: left;padding-right: 5px;	font-size: 12px;height: 24px;"><fmt:message key='label.head.cc'/>: </td>
					<td title="<c:out value='${bean.cc}' />"><c:out value='${bean.cc}' /></td>
				</tr>
				<c:if test="${folderType == 0 }">
					<tr>
						<td height="22" nowrap class="bg-gray"><fmt:message key='label.head.bc'/>: </td>
						<td colspan="3" title="<c:out value='${bean.bc}' />"><c:out value='${bean.bc}' /></td>
					</tr>
				</c:if>
				<tr id="attachmentTr" style="display:none">
					<td height="18" nowrap class="bg-gray" valign="top"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />: </td>
					<td colspan="3">
						<div class="attachment-single div-float" onmouseover="exportAttachment(this)">
							<div class="div-float">(<span id="attachmentNumberDiv"></span>个)</div>
							<script type="text/javascript">
							<!--
							showAttachment('${bean.mailLongId}', 0, 'attachmentTr', 'attachmentNumberDiv');
							//-->
							</script>
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
		<td height="5" class="detail-summary-separator"></td>
	</tr>
	<tr>
		<td valign="top">
			<%-- TODO 修改SRC --%>
			<iframe src="<html:link renderURL='/webmail.do?method=show&folderType=${folderType}&showType=1&mailNumber=${bean.mailNumber}'/>" width="100%" height="100%" name="contentIframe" frameborder="0" scrolling="yes" marginheight="0" marginwidth="0"></iframe>
		</td> 
	</tr>
</table>
</body>
</html>