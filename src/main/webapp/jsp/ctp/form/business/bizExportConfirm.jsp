<%--
 $Author: daiy $
 $Rev: 12370 $
 $Date:: 2012-12-15
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>导出业务确认</title>
</head>
<BODY>
<div>
	<table>
		<tr><td  colspan="5" align="left">${ctp:i18n("formsection.export.name") }<strong>${bizName}</strong></td></tr>
		<!--  <tr><td colspan="5" align="left">导出存储路径选择为:&nbsp;&nbsp;<input type="file" ></td></tr>-->
		<tr><td colspan="5" align="left">${ctp:i18n("formsection.export.config.info") }</td></tr>
			<tr height="200px" valign="top">
				<td>
					<fieldset style="height:120px;width:130px;">
						<legend>1.${ctp:i18n("formsection.export.config.enum") }</legend>
						<c:forEach items="${bizConfigBean.ctpEnumItemList}" var="enum" varStatus="status">
							<input type="checkbox" checked="checked" disabled="disabled"><strong>${enum.name}</strong><br>
						</c:forEach>
					</fieldset>
					</td>
					<td>
					<fieldset style="height:120px;width:130px;">
						<legend>2.${ctp:i18n("formsection.export.config.serial") }</legend>
						<c:forEach items="${bizConfigBean.formSerialNumberList}" var="serialNum" varStatus="status">
							<input type="checkbox" checked="checked" disabled="disabled"><strong>${serialNum.variableName}</strong><br>
						</c:forEach>
					</fieldset>
					</td>
					<td>
					<fieldset style="height:120px;width:130px;">
						<legend>3.${ctp:i18n("bizconfig.formflow.label") }</legend>
						<c:forEach items="${bizConfigBean.formDefinitionList}" var="formDefinition" varStatus="status">
						<c:if test="${formDefinition.formType == 1}">
							<input type="checkbox" checked="checked" disabled="disabled"><strong>${formDefinition.name}</strong><br>
						</c:if>
						</c:forEach>
					</fieldset>
					</td>
					<td>
					<fieldset style="height:120px;width:130px;">
						<legend>4.${ctp:i18n("menu.basedata.label") }</legend>
						<c:forEach items="${bizConfigBean.formDefinitionList}" var="formDefinition" varStatus="status">
						<c:if test="${formDefinition.formType == 3}">
							<input type="checkbox" checked="checked" disabled="disabled"><strong>${formDefinition.name}</strong><br>
						</c:if>
						</c:forEach>
					</fieldset>
					</td>
					<td>
					<fieldset style="height:120px;width:130px;">
						<legend>5.${ctp:i18n("menu.appform.label") }</legend>
						<c:forEach items="${bizConfigBean.formDefinitionList}" var="formDefinition" varStatus="status">
						<c:if test="${formDefinition.formType == 2}">
							<input type="checkbox" checked="checked" disabled="disabled"><strong>${formDefinition.name}</strong><br>
						</c:if>
						</c:forEach>
					</fieldset>
					</td>
				</td>
			</tr>
		</table>
</div>
<%@ include file="bizExportConfirm.js.jsp" %>
</BODY>
</HTML>