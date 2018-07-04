<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<style>
<!--
.bodyc{
	padding: 5px 0px 0px 10px;
}
//-->
</style>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/doc.js${v3x:resSuffix()}" />"></script>
</head>
<body
	onkeydown="self.event.returnValue=false"
	oncontextmenu="self.event.returnValue=false" onselect="return false"
	onselectstart="self.event.returnValue=false" ondrag="return false"
	scroll="no" style="overflow: hidden">
<div class="bodyc">
	<fmt:message key="seeyon.top.nowLocation.label" /> <span id="nowLocation"></span>
</div>
	<script type="text/javascript">
		showLocation(502, '${param.libName}');
		getA8Top().contentFrame.LeftRightFrameSet.cols = "0,*";
		parent.parent.layout.cols = "150,*";
	</script>
</body>
</html>