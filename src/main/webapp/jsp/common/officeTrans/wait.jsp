<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>A8-m</title>
<%@ include file="../INC/noCache.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
</head>
<body>
<div style="text-align: center;">
<br><br>
<img src="common/skin/default/images/space/loading.gif" border="0" align="absmiddle">&nbsp;&nbsp;<span id="msg"><fmt:message key="officeTrans.wait.label" /></span>
</div>
<script type="text/javascript">
<!--
var fileId = '${param.fileId}';

var counter = 0;

function lunxun(){
}

lunxun.prototype.go = function(result) {
	var ajax = new XMLHttpRequestCaller(this, "officeTransManager", "isExist");
	ajax.addParameter(1, "long", fileId);
	ajax.addParameter(2, "String", "${param.fileCreateDate}");
	ajax.serviceRequest();
}

lunxun.prototype.invoke = function(result) {
	if(result == true || result == "true"){
		window.location.href = "/seeyon/office/cache/${param.fileCreateDate}/${param.fileId}/${param.fileId}.html";
		parent.reloadFrameCache();
	}
	else{
		if(counter++ <= 10){
			window.setTimeout("l.go()", 2000);
		}
		else{
			document.getElementById("msg").innerText = "<fmt:message key='officeTrans.service.wuxiao.label' />";
		}
	}
}

var l = new lunxun();

window.setTimeout("l.go()", 2000);
//-->
</script>
</body>
</html>