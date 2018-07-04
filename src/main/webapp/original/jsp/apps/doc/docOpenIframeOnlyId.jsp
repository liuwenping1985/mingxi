<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
var jsURL = "${detailURL}";
var docURL = jsURL;
var baseurl = v3x.baseURL;
var srcURL = baseurl + "/doc.do?method=xmlJsp";
_ = v3x.getMessage;
v3x.loadLanguage("/apps_res/doc/i18n");
</script>

<title id="ititle">${title}</title>

</head>
<body class="h100b" >
<c:if test="${docExist}">
<IFRAME name="myframe" id="myframe" frameborder="1" width="100%" height="100%" src="<c:url value='${_url}'/>"></IFRAME>
</c:if>
<c:if test="${!docExist}">
<IFRAME name="myframe" id="myframe" frameborder="0" width="100%" height="100%" src=""></IFRAME>
</c:if>
<script type="text/javascript">
function closeDialog() {
	try{
		getA8Top().window.close();
	}catch(e){
		window.close();
	}
}
var exist = '${docExist}';
var isPermission = '${hasPermission}';
if(exist == 'false'){	
	alert(v3x.getMessage('DocLang.doc_source_doc_no_exist'));
	closeDialog();
} else {
	if(isPermission === 'false') {
		alert(v3x.getMessage('news.user.notAuthority'));
		closeDialog();
	}
}
</script>
</body>
</html>