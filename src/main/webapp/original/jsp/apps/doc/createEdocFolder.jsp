<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doc.jsp.createEdoc.title' /></title>
<script type="text/javascript">
function OK(){
	if(document.getElementById("title").value!="") {
		if(checkForm(mainForm)){ 
	 		var obj = parent; 
			var parentId = obj.window.docResId;
			var docLibId = obj.window.docLibId;
	//		var docLibType = obj.window.docLibType;
			mainForm.action = "${detailURL}?method=doCreateEdocFolder&parentId=" + parentId + "&docLibId=" + docLibId;
			mainForm.submit();
			return true;
		}
		return false;
	}
	else{
		alert(v3x.getMessage("DocLang.doc_jsp_createf_null_failure_alert"));
		document.getElementById("title").focus();
		return false;
	}
}
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()" style="overflow:hidden;background-color: white;">
<form name="mainForm" id="mainForm" action="" method="post"
	onsubmit="return (checkForm(this)&& newCreateEdoc('${detailURL}'))" target="folderIframe">
<input type='hidden' name='parentCommentEnabled' id='parentCommentEnabled' value='${param.parentCommentEnabled}' />
<input type='hidden' name='parentRecommendEnable' id='parentRecommendEnable' value='${param.parentRecommendEnable}' />
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="2">
    <tr>
        <td colspan="2" height="25">
        <div>
            <table align="center" width="95%" border="0" class="ellipsis" cellspacing="0" cellpadding="2"  style="word-break:break-all;word-wrap:break-word">
                <td align="right" nowrap="nowrap" width="23%"><font color="red">*</font>
                <fmt:message key="doc.jsp.createEdoc.name" />:</td>
                <td><input type="text" id="title" name="title" value="" size="52" validate="notNull,isWord" maxSize="80" inputName="<fmt:message key="doc.jsp.createEdoc.name" />" /></td>
            </table>
        </div>
    </tr>
    <tr>
        <td colspan="2" valign="top"><div id="propDiv"></div>
        </td>
    </tr>
            <%-- 
	<c:if test="${v3x:getBrowserFlagByRequest('HideButtons', pageContext.request)}">
	<tr>
		<td height="42" align="right" class="bg-advance-bottom"><input
			type="submit" name="b1"
			value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />"
			class="button-default-2">&nbsp; <input type="button"
			name="b2" onclick="window.close();"
			value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />"
			class="button-default-2"></td>
	</tr>
	</c:if>
	--%>
</table>
<table cellspacing=0 cellpadding=0 align=center>
	<tbody>
		<tr>
			<td height="100"></td>
		</tr>
	</tbody>
</table>
</form>
<script type="text/javascript">
		document.getElementById("propDiv").innerHTML = '${propHtml}';
</script>
<iframe name="folderIframe" frameborder="0"
	height="0" width="0" scrolling="no" marginheight="0" marginwidth="0" />
</body>
</html>
