<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doc.jsp.createf.title' /></title>
<script type="text/javascript">
	function OK(){
	    var oTitle=document.getElementById("title");
	    oTitle.value = oTitle.value.trim();
	    
		if(checkForm(mainForm)){
			var parentId = parent.window.docResId;
			var docLibId = parent.window.docLibId;
			var docLibType = parent.window.docLibType;
			mainForm.action = "${detailURL}?method=createFolder&parentId=" + parentId + "&docLibId=" + docLibId + "&docLibType=" + docLibType ;
			mainForm.submit();
			return true;
		}
		return false;
	}

	function onEnterPress(){
		if(v3x.getEvent().keyCode == 13){
			OK();
		}
	}
	window.onload = function() {
		document.getElementById('title').focus();
	};
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()" style="background:#fafafa;">
<form name="mainForm" id="mainForm" action="" method="post" onsubmit="return false" target="folderIframe" onkeydown="onEnterPress()">
<input type='hidden' name='parentVersionEnabled' id='parentVersionEnabled' value="${v3x:toHTML(param.parentVersionEnabled)}" />
<input type='hidden' name='parentCommentEnabled' id='parentCommentEnabled' value="${v3x:toHTML(param.parentCommentEnabled)}" />
<input type='hidden' name='parentRecommendEnable' id='parentRecommendEnable' value="${v3x:toHTML(param.parentRecommendEnable)}" />
<table width="93%" height="100%" border="0" cellspacing="0" cellpadding="0" >
	<tr>
		<td align="right" width="20%" nowrap="nowrap" style="height:25px;line-height:25px;"><font color="red">*</font><fmt:message key="doc.jsp.createf.name" />：</td>
		<td align="left" width="53%"><input type="text" name="title" id="title" value="" style="width:100%;height:25px;line-height:25px;" validate="notNull,isWord,notSpecChar" maxSize="80" inputName="<fmt:message key="doc.jsp.createf.name" />" />
        </td>
	</tr>
</table>
</form>
<iframe name="folderIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0" />
</body>
</html>
