<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<%@ include file="docHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doc.jsp.rename.title'/></title>
<script type="text/javascript">
function OK(){
	document.getElementById("mainForm").submit();
}

function fnSubmit(){
    //解决2次转移问题
    return readyToRename("${dr.parentFrId}", "${dr.frType}", "${v3x:toHTML(dr.frName)}");
}

function enterKeyEvent(){
	if (event.keyCode ==13) {
		if(getA8Top().frames.main && getA8Top().frames.main.document && getA8Top().frames.main.document.getElementById("myKnowledgeLib")){
			getA8Top().frames.main.fnReNameSubmit();
		}
	}
}
</script>
</head>
<body bgColor="#f6f6f6" scroll="no" style="overflow:hidden;height:220px;" onkeydown="listenerKeyESC()" onunload="unlockAfterAction('${param.rowid}');">
<form name="mainForm" id="mainForm" action="${detailURL}?method=rename&docResId=${param.rowid}&isFolder=${dr.isFolder}&from=${param.from}" 
	  method="post" target="renameIframe" onsubmit='return fnSubmit();' style="height: 220px;">
	<table class="popupTitleRight" id ="miantable" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="20" class="PopupTitle" colspan="2" nowrap="nowrap"><fmt:message key='doc.jsp.rename.title'/></td>
		</tr>
		<tr valign="top">
            <td align="right" nowrap="nowrap" width="20%"><fmt:message key='doc.jsp.rename.inputname'/>:</td>
			<td>
				<input id="oldName" type="hidden" name="oldName" value="${v3x:toHTML(dr.frName)}" >
				<input id="docSuffix" type="hidden" name="docSuffix" value="${docSuffix}" >
				<input type="text" id="newName" name="newName" onkeydown="enterKeyEvent();" value='<c:out value="${docPrefix}" escapeXml="true"/>' maxlength="80" style="width:250px" inputName="<fmt:message key='doc.jsp.rename.inputname'/>" validate="isDeaultValue,notNull,notSpecCharWithoutApos"/>
			</td>
		</tr>
		<c:if test="${v3x:getBrowserFlagByRequest('HideButtons', pageContext.request) and param.from ne 'knowledgeCenter'}">
    		<tr>
    			<td height="42" align="right" class="bg-advance-bottom" colspan="2">
    				<input name='b1' type="submit" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}"/>" class="button-default_emphasize">&nbsp;
    				<input name='b2' type="button" onclick="window.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
    			</td>
    		</tr>
		</c:if>
	</table>
</form>
<iframe name="renameIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
<script type="text/javascript">
setTimeout(function(){
  if (document.body.clientHeight > 0) {
   	document.body.style.height = document.body.clientHeight + "px";
  	document.getElementById("mainForm").style.height =  document.body.clientHeight + "px";
  	document.getElementById("miantable").style.height =  document.body.clientHeight + "px";
  }
},100)
</script>
</html>