<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css"
	href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<title><fmt:message key='common.advance.label'
	bundle='${v3xCommonI18N}' /></title>
<%@ include file="../../common/INC/noCache.jsp"%>
<script type="text/javascript">
<!--
var parentWindow = v3x.getParentWindow();
function init(){
	document.getElementById("brief").value = parentWindow.document.getElementById("brief").value;
	document.getElementById("keywords").value = parentWindow.document.getElementById("keywords").value;
	var ops = document.getElementById("templateId").options;
	var tempIndex = parentWindow.document.getElementById("tempIndex").value;
	if(tempIndex == null || tempIndex == '')
		ops[0].selected = true;
	else
		ops[tempIndex].selected = true;
}

function OK(){
	var templateId =  parentWindow.document.getElementById("templateId").value;
	var newTemplateId = document.getElementById("templateId").value;
	parentWindow.document.getElementById("brief").value = document.getElementById("brief").value;
	parentWindow.document.getElementById("keywords").value = document.getElementById("keywords").value;
	if(templateId != newTemplateId){
	if(confirm('<fmt:message key="info.load.template" />')){
		parentWindow.document.getElementById("templateId").value = newTemplateId;
		parentWindow.document.getElementById("form_oper").value="loadTemplate";
		parentWindow.document.getElementById("method").value="create";
		parentWindow.isFormSumit = true;
					
		var ops = document.getElementById("templateId").options;
		for(var i = 0; i < ops.length; i++){
			if(ops[i].selected){
				parentWindow.document.getElementById('tempIndex').value = i;
				break;	
			}		
		}
		parentWindow.saveAttachment();
		parentWindow.document.getElementById("dataForm").submit();
	}
	}
	window.close();
}

	
//-->
</script>
</head>
<body style="overflow: no;" onload="init();">
<div class="main_div_center">
<div class="right_div_center">
<div class="center_div_center">
<form action="" name="form" id="form" method="post">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%"
	align="center" style="table-layout: fixed" class="popupTitleRight">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message
			key='common.advance.label' bundle='${v3xCommonI18N}' /></td>
	</tr>
	<tr class="bg-advance-middel">
		<td>
		<table border="0" cellpadding="0" cellspacing="0" width="100%"
			align="center">
			<tr valign="middle">
				<td class="label bg-gray lest-shadow" rowspan="1" valign="center"><fmt:message
					key="news.data.brief" /><fmt:message key="label.colon" /></td>
				<td class="value lest-shadow" rowspan="1" valign="top"><fmt:message
					key='news.data.brief' var="_myLabel" /> <fmt:message
					key="label.please.input" var="_myLabelDefault">
					<fmt:param value="${_myLabel}" />
				</fmt:message> <c:set var="_value" value="${v3x:toHTML(bean.brief)}" /> <input
					type="text" class="input-300px" name="brief" id="brief" value=""
					title="" inputName="${_myLabel}" validate="maxLength" maxSize="120" /></td>
			</tr>
			<tr>
				<td class="label bg-gray"><fmt:message key="news.data.keywords" /><fmt:message
					key="label.colon" /></td>
				<td class="value"><fmt:message key="news.data.keywords"
					var="_myLabel" /> <fmt:message key="label.please.input"
					var="_myLabelDefault">
					<fmt:param value="${_myLabel}" />
				</fmt:message> <input type="text" class="input-300px" name="keywords"
					id="keywords" value="${_value}" title="${_value}"
					inputName="${_myLabel}" validate="maxLength" maxSize="60" /></td>
			</tr>

			<tr>
				<td class="label bg-gray "><fmt:message key="news.template" /><fmt:message
					key="label.colon" /></td>
				<td class="value"><select name="templateId" id="templateId">
					<option value="">&lt;<fmt:message key="oper.please.select" /><fmt:message
						key="news.template" />&gt;</option>
					<c:forEach items="${templateList}" var="template">
						<option value="${template.id}">${template.templateName}</option>
					</c:forEach>
			</td>
			</tr>
		</table>
		</td>
	</tr>
	<c:if test="${v3x:getBrowserFlagByUser('OpenDivWindow', v3x:currentUser())==true}">
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
		    <input type="button" class="button-default-2"  onclick="OK();"
		       value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>"/>&nbsp;&nbsp;&nbsp;&nbsp;
		    <input type="button" class="button-default-2" 
		       value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" onclick="window.close()"/>
		</td>
	</tr>
	</c:if>
</table>
</form>
</div>
</div>
</div>
</body>
</html>