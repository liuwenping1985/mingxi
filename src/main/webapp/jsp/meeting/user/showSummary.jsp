<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<html>
<head>
<%@ include file="../include/header.jsp" %>
<title><fmt:message key="application.6.label" bundle="${v3xCommonI18N}"/><fmt:message key="mt.summary" /></title>
<style>
.body-bg{
	background-color: #9099ae;
	text-align: center;
}
</style>
</head>
<body class="body-bg" scroll="yes">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr>
		<td height="10" class="detail-summary" width="100%">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
				<tr>
					<td width="10%" height="28" nowrap class="bg-gray detail-subject" align="right"><fmt:message key="mt.mtSummaryTemplate.templateName"/>:</td>
					<td class="detail-subject" width="40%">${summary.templateName}&nbsp;</td>
					<td width="10%" height="22" nowrap class="bg-gray detail-subject"><fmt:message key='common.creater.label' bundle='${v3xCommonI18N}' />:</td>
					<td class="detail-subject" width="40%">${summary.createUserName}&nbsp;</td>
				</tr>
				<tr>
					<td height="22" nowrap class="bg-gray detail-subject" width="10%"><fmt:message key='common.date.createtime.label' bundle='${v3xCommonI18N}' />:</td>
					<td class="detail-subject" width="40%">
            			<fmt:formatDate value="${summary.createDate}"  pattern="${datePattern}"/>&nbsp;
          			</td>
          			<td height="22" nowrap class="bg-gray detail-subject" width="10%"><fmt:message key='common.description.label' bundle='${v3xCommonI18N}' />:</td>
					<td class="detail-subject" width="40%">
            			${summary.description}&nbsp;
          			</td>
				</tr>
				<tr id="attachmentTr" style="display: none">
					<v3x:attachmentDefine attachments="${attachments}" />
					<td height="18" nowrap class="bg-gray detail-subject" valign="top" width="10%"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /><fmt:message key="label.colon" /></td>
					<td class="detail-subject" width="40%">
						<div class="attachment-single div-float" onmouseover="exportAttachment(this)">
							<div class="div-float font-12px">(<span id="attachmentNumberDiv"></span>)</div>
							<script type="text/javascript">
							<!--
							showAttachment('${summary.id}', 0, 'attachmentTr', 'attachmentNumberDiv');
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
	
	<tr id="summaryTR">
		<td valign="top">
			<c:if test="${summary!=null}">
   				<v3x:showContent content="${summary.content}" type="${summary.templateFormat}" createDate="${summary.createDate}" />
   			</c:if>&nbsp;
		</td>
	</tr>
</table>

</body>
</html>