<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.apps.m1.authorization.resouces.i18n.MobileManageResources" var="mobileManageBundle"/>

<script type="text/javascript">
function init() {
	
	var success = "<c:out value='${success}'/>";
	var error = "<c:out value='${errMsg}'/>";
	if (success == "true") {
		alert("<fmt:message key='label.mm.orgbindnum.success' bundle='${mobileManageBundle}'/>");
	} else if (success == "false") {
		alert(error);
	}
}
function confirm() {
	  var numInput = document.getElementById("orgbindNum").value;
	
	if(isNaN(numInput) || numInput.indexOf(".") != -1){
		alert("<fmt:message key='label.mm.orgbindnum.inputerr' bundle='${mobileManageBundle}'/>");
		numInput = "${bindNum}";
		return;
	}
	var bindNumStr = numInput.replace(/(^\s*)|(\s*$)/g, "");
	var bindNum = Number(bindNumStr);
	if (bindNumStr.length == 0 || isNaN(bindNum) || bindNum <= 0 || bindNum > 10) {
		alert("<fmt:message key='label.mm.orgbindnum.inputerr' bundle='${mobileManageBundle}'/>");
		numInput = "${bindNum}";
		
		return ;
	}
	document.getElementById("form1").submit();
}

function cancel() {
	window.location = "<c:url value='/m1/mClientBindController.do'/>?method=toSetBindNum";
}
</script>
