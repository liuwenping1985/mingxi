<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="../docHeader.jsp"%> 
<html>
<head>
<title></title>
<script type="text/javascript" language="javascript">
	var docResourceId='${docResourceId}';
	//function findBy(){	
	//	folderLog.action="${detailURL}?method=findLogBy&name=${v3x:escapeJavascript(param.name)}&begin=" +folderLog.begin.value+ "&end=" +folderLog.end.value;
	//	folderLog.submit();
	//}
//var type = "${isGroupLib}";
// alert(type);
	
</script>
</head>
<body scroll="no">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="22">
	<form name="folderLog" id="folderLog" method="post" action="">	
	<input type="hidden" id="docName" name="docName" value="${v3x:toHTML(param.name)}" />
	<c:set value="${v3x:_(pageContext, param.name)}" var="theDocName"/>
	<script type="text/javascript">
		var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
		if(v3x.getBrowserFlag("hideMenu") == true){
    		myBar.add(new WebFXMenuButton("print", "<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />", "printFileLog();", [1,8]));
    		myBar.add(new WebFXMenuButton("exportExcel", "<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />", "exportExcelNew('folder',docResourceId, '${v3x:escapeJavascript(theDocName)}','${isGroupLib}');", [2,6]));
    		myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.back.label' bundle='${v3xCommonI18N}' />",  "parent.window.close();", [7,4]));
		}
		document.write(myBar);
	</script>
		</td>
	</tr>
	
	<tr>
		<td>
	<div id="scrollListDiv" class="scrollList">
    	<v3x:table data="${folderLogView }" var="log" isChangeTRColor="true" showHeader="true" showPager="true">	
    		<v3x:column width="10%" label="doc.jsp.log.user.label" type="String" value="${log.member.name}"></v3x:column>
    		 <c:if test="${isGroupLib == true}">
    		<v3x:column label="doc.jsp.log.account.label" width="20%" type="String" value="${log.account.shortName}" ></v3x:column>
    		<v3x:column width="20%" label="doc.jsp.log.action.label" type="String">
    			<fmt:message key="${log.operationLog.actionType}"/>
    		</v3x:column>
    		 </c:if>
    		 <c:if test="${isGroupLib != true}">
    		<v3x:column width="40%" label="doc.jsp.log.action.label" type="String">
    			<fmt:message key="${log.operationLog.actionType}"/>
    		</v3x:column>
    		 </c:if>
    		<v3x:column width="15%" label="doc.jsp.log.date.label" align="left" type="Date"><fmt:formatDate value="${log.operationLog.actionTime}" pattern="${datetimePattern}"/></v3x:column>
    		<v3x:column width="30%" label="doc.jsp.log.description.label" type="String" alt="${v3x:messageOfParameterXML(pageContext, log.operationLog.contentLabel, log.operationLog.contentParameters)}" value="${v3x:messageOfParameterXML(pageContext, log.operationLog.contentLabel, log.operationLog.contentParameters)}" maxLength="52" symbol="..."></v3x:column>
    		<v3x:column width="10%" label="doc.jsp.log.address.label" type="String" value="${log.operationLog.remoteIp}"></v3x:column>
    	</v3x:table>
	</div>
	</td></tr>
	</form>
</table>
	 <iframe id="theLogIframe" name="theLogIframe" frameborder="0" marginheight="0" marginwidth="0" ></iframe>
</body>
</html>
<script type="text/javascript">
  // bindOnresize('scrollListDiv2',0,30)
</script>