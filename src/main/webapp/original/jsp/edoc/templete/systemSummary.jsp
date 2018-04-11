<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="../edocHeader.jsp"%>
</head>
<body scroll="no">

<v3x:attachmentDefine attachments="${attachments}" />

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">
	<tr>
		<td height="10" class="detail-summary">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
				<tr>
					<td width="90" height="28" nowrap class="bg-gray"><fmt:message key="edocTable.temlateTitle" /> : </td>
					<td>${v3x:toHTMLWithoutSpace(templete.subject)}</td>
					<td width="60px" class="bg-gray"><fmt:message key="process.cycle.label"/>:</td>
					<td width="60px">${deallineLabel}&nbsp;</td>
					<td width="100px"><span title="${fullArchiveName}" style="width: 200px; overflow: hidden; white-space: nowrap; word-break: keep-all; text-overflow: ellipsis; display: inline-block;"><fmt:message key="prep-pigeonhole.label" /> : &nbsp;${archiveName}</span></td>
					
				</tr>
				<tr>
					<td height="18" nowrap class="bg-gray"><fmt:message key="common.creater.label" bundle="${v3xCommonI18N}" /> : </td>
					<td>${member.name} (<fmt:formatDate value="${templete.createDate}" pattern="${datePattern}"/>)</td>
					<td width="100px" class="bg-gray"><fmt:message key="common.remind.time.label" bundle='${v3xCommonI18N}' />:</td>
					<td>${remindLabel}&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr id="attachmentTr" style="display: none">
					<td height="18" nowrap class="bg-gray" valign="top"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /> : </td>
					<td colspan='4'>
						<div class="div-float" onmouseover="exportAttachment(this)">
							<div class="div-float">(<span id="attachmentNumberDiv" class="font-12px"></span><fmt:message key="edoc.unit" bundle="${v3xCommonI18N}" />)</div>
							<script type="text/javascript">
							<!--
							showAttachment('${templete.id}', 0, 'attachmentTr', 'attachmentNumberDiv');
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
			<iframe src="${edocTempleteURL}?method=systemTopic&templeteId=${param.templeteId}" width="100%" height="100%" name="contentIframe" frameborder="0" scrolling="yes" marginheight="0" marginwidth="0"></iframe>
		</td>
	</tr>	
</table>
</body>
</html>