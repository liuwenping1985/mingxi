<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b w100b">
<head>
<title></title>
</head>
<body class="h100b w100b" bgColor="#f6f6f6">
	<table  border="0" align=left width="100%" class="font_size12">
		<tr>
			<td height="20" style="padding-left: 5px" width="90" align="left">${ctp:i18n('import.filename')}:</td>
			<td colspan="2" width="300">${impURL}</td>
		</tr>
		<c:if test="${fromStock != 'fromStock'}" >
			<tr>
				<td height="20" style="padding-left: 5px" width="90" align="left">${ctp:i18n('import.option')}:</td>
				<td colspan="2" width="300">
					<c:choose>
						<c:when test="${repeat=='0'}">${ctp:i18n('import.repeatitem.overcast')}</c:when>
						<c:otherwise>${ctp:i18n('import.repeatitem.overleap')}</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</c:if>
		<tr class="border_t">
			<td  style="padding-left: 5px" class="bg_color_gray" width="90">${ctp:i18n('import.data')}</td>
			<td  class="bg_color_gray" width="70">${ctp:i18n('office.stock.result.report.js')}</td>
			<td  class="bg_color_gray" width="230">${ctp:i18n('import.description')}</td>
		</tr>
		<c:forEach var="info" items="${errorInfos }">
		<tr class="border_t">
			<td style="padding-left: 5px" >${info.filedName}</td>
			<td style="padding-left: 5px" >${info.importResult}</td>
			<td style="padding-left: 5px" >${info.errorInfo}</td>
		</tr>
		</c:forEach>
	</table>
</div>
</body>
</html>