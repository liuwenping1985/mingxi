<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<title></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/SelectPeople/js/orgDataCenter.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" src="<c:url value="/main/common/js/frame-ajax.js${v3x:resSuffix()}" />"></script>
</head>
<body>
<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;
//-->
</SCRIPT>

<script type="text/javascript">
<!--
function init(){
	<c:if test='${not empty ExceptionKey}'>
		alert('<fmt:message key="${ExceptionKey}" />');
		window.open("/seeyon/closeIE7.htm", "_self");
		return;
	</c:if>

	var url="<html:link renderURL='${link}' />";
	
	if(url.indexOf("/seeyon/doc.do?method=docHomepageIndex")!=-1)
	{
		var nurl=url.substring(8);
		url="a8genius.do?method=window&url="+encodeURIComponent(nurl);
	}
	
	window.location.href=url;
	window.opener=null;
    window.open('','_self');
}

init();
function close()
{
	window.open("${isNeedLogout ? '/seeyon/main.do?method=logout&Offline=false&close=true' : '/seeyon/closeIE7.htm'}", "_self");
}
//-->
</script>
</body>
</html>