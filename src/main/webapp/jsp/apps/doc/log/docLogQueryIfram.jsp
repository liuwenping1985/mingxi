<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../docHeader.jsp" %>
<%@include file="../../../common/INC/noCache.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>
<c:choose>
<c:when test="${param.isLib == 'true'}">
<fmt:message key='doc.jsp.log.title.lib'/>
</c:when>
<c:when test="${param.isFolder == 'true'}">
<fmt:message key='doc.jsp.log.title.folder'/>
</c:when>
<c:otherwise>
<fmt:message key='doc.jsp.log.title'/>
</c:otherwise>
</c:choose>
:${docLibName}
</title>
</head>
<body scroll="no">

		<iframe name="docIframe" id="docIframe" frameborder="0" height="100%" width="100%" scrolling="no"></iframe>
	

<script>
	var folder = "${param.isFolder == 'true'}";
	//alert(folder)
	if(folder == 'true'){
		docIframe.window.location.href = "${detailURL}?method=folderLogView&docResId=${param.docResId }&docLibId=${param.docLibId }&isGroupLib=${param.isGroupLib}&isFolder=true&name=" + encodeURI('${v3x:escapeJavascript(param.name)}');
	}
	else{
		docIframe.window.location.href = "${detailURL}?method=docLogView&docResId=${param.docResId}&isGroupLib=${isGroupLib}&docLibId=${param.docLibId }&isFolder=false&name=" + encodeURI('${v3x:escapeJavascript(param.name)}');
	}
</script>

</body>
</html>