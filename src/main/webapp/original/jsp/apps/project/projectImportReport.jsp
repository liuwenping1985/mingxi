<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b w100b">
<head>
	<title></title>
</head>
<body class="h100b w100b" bgColor="#f6f6f6">
	<table border="0" align=left width="100%" class="font_size12" cellpadding="0" cellspacing="0">
		<tr>
			<td height="20" style="padding-left: 5px" width="90" align="left">${ctp:i18n('import.report')}:</td>
			<td colspan="2" width="300">${ctp:i18n('project.import.report.project')}</td>
		</tr>
		<tr>
			<td height="20" style="padding-left: 5px" width="90" align="left">${ctp:i18n('import.filename')}:</td>
			<td colspan="3" width="300">${impURL}</td>
		</tr>
		<tr class="border_t">
			<th style="padding-left: 5px" class="bg_color_gray" width="10px">${ctp:i18n('project.import.report.serialNumber')}</th>
			<th class="bg_color_gray" width="50px">${ctp:i18n('project.import.report.projectName')}</th>
			<th class="bg_color_gray" width="50px">${ctp:i18n('project.import.report.result')}</th>
			<th class="bg_color_gray" width="280px">${ctp:i18n('import.description')}</th>
		</tr>
		<c:forEach var="info" varStatus="status" items="${errorInfos }">
			<tr>
				<td style="padding-left: 5px; border: #d0d0d0 solid 1px;">${v3x:toHTML(info.serialId)}</td>
				<td style="padding-left: 5px; border: #d0d0d0 solid 1px;">${v3x:toHTML(info.projectName)}</td>
				<td style="padding-left: 5px; border: #d0d0d0 solid 1px;">${v3x:toHTML(info.importResult)}</td>
				<td style="padding-left: 5px; border: #d0d0d0 solid 1px;">
					<c:forEach var="errorinfo" varStatus="s" items="${info.errorList}">
				   		${s.index+1}.${v3x:toHTML(errorinfo)}<br />
					</c:forEach>
				</td>
			</tr>
		</c:forEach>
	</table>
	</div>
</body>
</html>