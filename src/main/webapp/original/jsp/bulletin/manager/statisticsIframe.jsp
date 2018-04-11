<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<html>
<head>
<title>
	<fmt:message key='common.toolbar.statistics.label' bundle='${v3xCommonI18N}' />
</title>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
</head>
<body scroll="no">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<iframe src="${bulDataURL}?method=statistics&type=byRead&bulTypeId=${param.bulTypeId}&spaceId=${param.spaceId}" name="myiframe" id="myiframe" frameborder="0" height="100%" width="100%" scrolling="no"></iframe>
		</td>
	</tr>
</table>	
</body>
</html>
