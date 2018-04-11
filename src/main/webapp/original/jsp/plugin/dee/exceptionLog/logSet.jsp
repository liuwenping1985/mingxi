<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/plugin/dee/common/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:setBundle
	basename="com.seeyon.apps.dee.resources.i18n.DeeResources" />
<fmt:setBundle
	basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources"
	var="v3xCommonI18N" />

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='dee.clearlogset.title' /></title>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=deeSynchronLogManager"></script>
<script type="text/javascript">
function OK() {
	var radios = document.getElementById("listForm").day;
	for(var i = 0; i < radios.length; i++){
		if(radios[i].checked){
			var day = radios[i].value;
		}
	}
	return day;
}
</script>
</head>
<body>
	<form name="listForm" id="listForm" method="post" onsubmit="return false;">
		<fieldset style="width: 400px; border: 1; height: 120px; margin-left: 21px; margin-top: 8px;">
			<legend><fmt:message key='dee.clearlogset.tip1' /></legend>
			<table width="100%" style="text-align: center; margin-top: 25px;">
				<row>
					<td style="text-align: center;">
						<input type="radio" id="day" name="day" value="7" <c:if test="${day == 7}">checked</c:if> /><fmt:message key='dee.clearlogset.tip2' />&nbsp&nbsp&nbsp&nbsp
						<input type="radio" id="day" name="day" value="30" <c:if test="${day == 30}">checked</c:if> /><fmt:message key='dee.clearlogset.tip3' />&nbsp&nbsp&nbsp&nbsp
						<input type="radio" id="day" name="day" value="90" <c:if test="${day == 90}">checked</c:if> /><fmt:message key='dee.clearlogset.tip4' />&nbsp&nbsp&nbsp&nbsp
						<input type="radio" id="day" name="day" value="180" <c:if test="${day == 180}">checked</c:if> /><fmt:message key='dee.clearlogset.tip5' />&nbsp&nbsp&nbsp&nbsp
						<input type="radio" id="day" name="day" value="365" <c:if test="${day == 365}">checked</c:if> /><fmt:message key='dee.clearlogset.tip6' />&nbsp&nbsp&nbsp&nbsp
						<input type="radio" id="day" name="day" value="-1" <c:if test="${day == -1}">checked</c:if> /><fmt:message key='dee.clearlogset.tip7' />&nbsp&nbsp&nbsp&nbsp
					</td>
				</row>
			</table>
			<div style="margin-top: 30px; width: 100%; text-align: right;">
				<span style="margin-bottom: 5px; width: 100%; text-align: right; font-style: italic;"><fmt:message key='dee.clearlogset.tip8' />&nbsp&nbsp&nbsp&nbsp</span>
			</div>
		</fieldset>
	</form>
</body>
</html>