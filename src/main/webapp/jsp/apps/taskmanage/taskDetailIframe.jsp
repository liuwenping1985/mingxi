<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='task.detail' /></title>
</head>
<body onload="setDefaultTab(${param.msgLocation eq 'Feedback' ? '1' : '0'});" onunload="checkDecomposeAdd();" onkeydown="listenerKeyESC()" scroll='no'>
<table width="100%"  height="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
			<div class="tab-separator"></div>
			<div id="menuTabDiv" class="div-float">
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);" url="${taskManageUrl}?method=taskInfoIframe&id=${param.id}&flag=View&msgFlag=${param.msgFlag}&msgLocation=${param.msgLocation}&manageMode=${param.manageMode}&fromTree=${param.fromTree}" ><fmt:message key='task.detail' /></div>
				<div class="tab-tag-right"></div>
				<div class="tab-separator"></div>
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);" url="${taskManageUrl}?method=listTaskFeedbacksFrame&taskId=${param.id}&msgFlag=${param.msgFlag}&msgLocation=${param.msgLocation}&manageMode=${param.manageMode}" ><fmt:message key='task.feedback' /></div>
				<div class="tab-tag-right"></div>
				<div class="tab-separator"></div>	
			</div>
		</td>
	</tr>
	
	<tr>
		<td class="tab-body-bg" style="margin: 0px;padding:0px;">
			<iframe noresize="noresize" frameborder="no" id="detailIframe" name="detailIframe" style="width:100%;height: 100%;" border="0px"></iframe>			
		</td>
	</tr>
</table>
</body>
</html>