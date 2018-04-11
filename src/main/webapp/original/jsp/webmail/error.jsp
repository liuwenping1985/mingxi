<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.ctp.common.constants.Constants" %>	
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="webmailheader.jsp" %>
<title>ERROR</title>
<script type="text/javascript">
<!--
	var msgArr = new Array();
	msgArr[0] = "Error";
	msgArr[1] = "<fmt:message key='label.erromsg.1'/>";
	msgArr[2] = "<fmt:message key='label.erromsg.2'/>";
	msgArr[3] = "<fmt:message key='label.erromsg.3'/>";
	msgArr[4] = "<fmt:message key='label.erromsg.4'/>";
	msgArr[5] = "<fmt:message key='label.erromsg.5'/>";
	msgArr[6] = "<fmt:message key='label.erromsg.6'/>";
	msgArr[7] = "<fmt:message key='label.erromsg.7'/>";
	msgArr[8] = "<fmt:message key='label.erromsg.8'/>";
	msgArr[9] = "<fmt:message key='label.erromsg.9'/>";
	if(${errorMsg}!=null && ${errorMsg}!='' && ${errorMsg}!='null'){
		if(msgArr[${errorMsg}] == undefined || msgArr[${errorMsg}] == "undefined"){
			alert(${errorMsg});
		}else{
			alert(msgArr[${errorMsg}]);
		}
	}
	if("${errorUrls}".indexOf("method") != -1){
		if(${errorUrls == '?method=list&jsp=inbox'}){
			parent.location.href =  '${webmailURL}${errorUrls}';
		}else if(${errorUrls == '?method=set'}){
			parent.location.href = '${webmailURL}?method=list&jsp=set';
		}else{
			window.location.href = '${webmailURL}${errorUrls}';
		}
	}else{
		history.go(-1);
	}
//-->
</script>
</head>

<body style="overflow: hidden;" scroll="no">
</body>
</html>