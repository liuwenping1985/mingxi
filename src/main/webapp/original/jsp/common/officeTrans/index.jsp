<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources"/>
<html>
<head>
<%@ include file="../INC/noCache.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>A8-m</title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
	function showAnchor() {
		// 仅在IE情况下需要显示最大化、默认大小控制按钮
		if(navigator.appName == "Microsoft Internet Explorer"||navigator.userAgent.indexOf('Trident')!=-1) {
			document.getElementById('sizeTD').style.display = 'block';
		}
	}
	function changeSize() {
		if(document.getElementById('sizeAnchor').innerText == "[<fmt:message key='message.header.max.alt' />]") {
			fullScreen();
			document.getElementById('sizeAnchor').innerText = "[<fmt:message key='message.header.restore.alt' />]";
		}
		else {
			restoreScreen();
			document.getElementById('sizeAnchor').innerText = "[<fmt:message key='message.header.max.alt' />]";
		}
	}
	function fullScreen() {
		//window.dialogWidth = document.body.clientWidth;
		//window.dialogHeight = document.body.clientHeight;
		window.dialogWidth = window.screen.width + "px";
		window.dialogHeight = (window.screen.height - 100) + "px";
	}
	function restoreScreen() {
		window.dialogWidth = '900px';
		window.dialogHeight = '700px';
		try{
			window.dialogLeft = (window.screen.width - 900) / 2 + 'px';
			window.dialogTop = (window.screen.height - 700) / 2 + 'px';
		}catch(e){
			
		}
	}
	function reloadFrameCache(){
			var htmlFrame = document.getElementById('htmlFrame');
			htmlFrame.onreadystatechange = function(){
				if (htmlFrame.contentWindow.document.readyState == "complete"){
					var sheets = htmlFrame.contentWindow.document.getElementsByName('frSheet');
					if(sheets && sheets.length>0){
						sheets[0].src = sheets[0].src +'?rnd='+ Math.random()*10000;
					}
				}
			}
	}
	function reloadExcelSheet(){
		var htmlFrame = document.getElementById('htmlFrame');
		
			var state = htmlFrame.contentWindow.document.readyState;
			if (state == "complete" || state=='interactive'){
				// 所有外链都在新窗口打开
				var hrefs = htmlFrame.contentWindow.document.getElementsByTagName("a");
				if(hrefs && hrefs.length >0){
					for(var i=0;i<hrefs.length;i++){
						var a = hrefs[i];
						if(a.href && a.target ==""){
							a.target = "_blank";
						}
					}
				}

				var sheets = htmlFrame.contentWindow.document.getElementsByName('frSheet');
				if(sheets && sheets.length>0){
					sheets[0].src = sheets[0].src +'?rnd='+ Math.random()*10000;
				}
			}
	}
//-->
</script>
</head>
<body scroll="no" style="overflow: hidden;">
<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%" bgcolor="#FFFFFF">
    <c:if test="${param.needDownload eq 'true'}">
	<tr>
		<td width='80%' align="center" height="40px" style="background-color: #eeeeee; border-bottom: 1px solid #999999; font-size: 16px">&nbsp;&nbsp;&nbsp;&nbsp;${v3x:toHTML(param.filename)}&nbsp;<a target="downloadFileFrame" href="fileDownload.do?method=download&fileId=${param.fileId}&v=${param.v}&viewMode=download&createDate=${param.fileCreateDate1}&filename=${v3x:encodeURI(param.filename)}">[<fmt:message key="officeTrans.download2local.label" />]</td>
		<td id='sizeTD' width='20%' align="right" style="display:none;background-color: #eeeeee; border-bottom: 1px solid #999999; font-size: 16px"><a id='sizeAnchor' onClick="changeSize()" class="cursor-hand">[<fmt:message key='message.header.max.alt' />]</a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	</tr>
	</c:if>
	<tr>
		<td colspan="2"><iframe id="htmlFrame" ${param.scrolling eq 'hidden' ? 'scrolling="no"' : ''} src="/seeyon/office/cache/${param.fileCreateDate}/${param.fileId}/${param.fileId}.html?rnd=<%=(Math.random() * 100000)%>" frameborder="0" marginheight="0" marginwidth="0" width="100%" height="100%" onreadystatechange="reloadExcelSheet();"></iframe></td>
	</tr>
</table>
<iframe name="downloadFileFrame" id="downloadFileFrame" frameborder="0" width="0" height="0"></iframe>
<script type="text/javascript">
	<c:if test="${param.needDownload eq 'true'}">
		showAnchor();
	</c:if>
</script>
</body>
</html>