<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.seeyon.v3x.bulletin.util.*" %>
<%@ include file="../../migrate/INC/noCache.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ include file="../include/taglib.jsp" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>

<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/addressbook/js/prototype.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
//-->
</script>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="mt.resource"/></title>
<script type="text/javascript">
<!--
function ok(){
	// dosomething()
	window.close();
}

function selectP(){
	var elements=new Array();
	var total=0;

	$$('input[type="checkbox"][name="select"]').select(function(i){return i.checked}).each(function(i){
		var element=new Element();
		element.id=i.value;
		element.name=replace039(i.getAttribute("resourceName"));
		elements[total]=element;
		total=total+1;
	});   
	
	// 取resource.name的标准写法
	//var finputs = document.getElementsByName("select");
	//for(var i = 0; i < finputs.length; i++){
	//	if(finputs[i].checked = true){
	//		alert(finputs[i].value);
	//		alert(finputs[i].getAttribute("resourceName"));
	//	}
	//}
	
	window.returnValue=elements;
	
	window.close();
}

function replace039(str){
	return str.replace(/"/g,"'");
}

function init(){
	var oldResourceIds = '${oldResourceIds}';
	if(oldResourceIds==null || oldResourceIds==""){
		return;
	}
	var ids = oldResourceIds.split(',');
	var selects = document.getElementsByName("select");
	for(var i=0;i<selects.length;i++){
		for(var j=0;j<ids.length;j++){
			if(selects[i].value==ids[j]){
				selects[i].checked="checked";
				break;
			}	
		}
	}
	
}

//-->
</script>
</head>
<body scroll="no" style="overflow: hidden" onkeydown="listenerKeyESC()" onload="init();">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key="mt.resource"/></td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
			<div class="scrollList">
			<c:forEach items="${resourceMap}" var="resource">
				<label for="in${resource.id}">
				<input name="select" id="in${resource.id}" type="checkbox" value='${resource.id}' resourceName="${resource.name}">${resource.name}</input></label><br>
			</c:forEach>
			</div>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<input type="button" onclick="selectP()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default_emphasize">&nbsp;
			<input type="button" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
		</td>
	</tr>
</table>
</body>
</html>
