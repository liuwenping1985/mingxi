<%--
 $Author: zhout $
 $Rev: 2187 $
 $Date:: 2012-08-21 13:23:50#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>A8</title>
<base target="_blank">
<script type="text/javascript">
var key = '<%=request.getParameter("key")%>';
var html = null;
if(parent.htmlTempleteContent){
	html = parent.htmlTempleteContent[key];
}

function show(){
	var iframeKey = parent.document.getElementById('htmlTempleteOfIframe' + key);
	if(iframeKey){
		iframeKey.innerHTML = document.body.innerHTML;
	}
}
</script>
</head>
<body style="overflow:hidden;" oncontextmenu="self.event.returnValue=false" class="bg_color_none">
<script type="text/javascript">
if(html){
	document.write(html);
}
</script>
</body>
</html>