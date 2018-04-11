<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../workFlowAnalysis/header.jsp" %>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/isearch/css/isearch.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/templete.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
	function getAppType(){
		alert(${v3x:hasPlugin('form')});
		alert(${v3x:getSysFlagByName('sys_isGovVer')});
		var hh="<tr><td width='12%' align='right'><fmt:message key='common.application.type.label' /> : </td>"+
			"<td width='15%'><select name='appType' id='appType' style='width: 100%;'>"+
			"<c:if test="${v3x:hasPlugin('form') && v3x:getSysFlagByName('sys_isGovVer')==true} || v3x:getSysFlagByName('sys_isGovVer') != true">"+
			"<option value='2'><fmt:message key='application.2.label' bundle='${v3xCommonI18N}' /></option>"+
			"</c:if><option value='1'><fmt:message key='node.policy.collaboration' bundle='${v3xCommonI18N}' /></option>"+
			"<option value='4'><fmt:message key='application.4.label' bundle='${v3xCommonI18N}' /></option>"+
			"</select></td>'</tr>";
			return hh;
		
	}
</script>