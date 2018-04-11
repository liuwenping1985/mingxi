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
<div style="text-align:center;margin-top: 60px">
<br><br>
<img src="common/skin/default/images/space/loading.gif" border="0" align="absmiddle">&nbsp;&nbsp;<span id="msg" style="font-size: 14px;"><fmt:message key="officeTrans.wait.label" /></span>
</div>
<div id="detailMsgDiv" style="text-align: left;margin-left: 300px"></div>
<iframe name="downloadFileFrame2" id="downloadFileFrame2" frameborder="0" width="0" height="0"></iframe>
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
		if(counter++ <= 15){
			window.setTimeout("l.go()", 2000);
		}
		else{
            var downloadHtml="<a target='downloadFileFrame2' href='fileDownload.do?method=download&fileId=${param.fileId}&v=${v3xFile.v}&viewMode=download&createDate=${param.fileCreateDate1}&filename=${v3x:encodeURI(v3xFile.filename)}'>${v3x:toHTML(v3xFile.filename)}</>"
		    var errorMsg1="<fmt:message key='officeTrans.error.msg1'/>:&nbsp;&nbsp;" + downloadHtml+"<br/><br/>";
		    var errorMsg2="<div><fmt:message key='officeTrans.error.reasonall'/>:<br/><fmt:message key='officeTrans.error.reason1'/><br/><fmt:message key='officeTrans.error.reason2'/><br/><fmt:message key='officeTrans.error.reason3'/><br/><fmt:message key='officeTrans.error.reason4'/><br/></div>"
			//document.getElementById("msg").innerText = "<fmt:message key='officeTrans.service.wuxiao.label' />";
            document.getElementById("msg").innerHTML = errorMsg1;
            document.getElementById("detailMsgDiv").innerHTML=errorMsg2;

		}
	}
}

var l = new lunxun();

window.setTimeout("l.go()", 2000);
//-->
</script>
</body>
</html>