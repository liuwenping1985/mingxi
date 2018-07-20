<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>配置期刊内容</title>
</head>
<body scroll="no">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="bg-advance-middel" style="padding:0;">
			<iframe src="${path }/info/magazine.do?method=contentIframe&type=${param.type}&magazineId=${param.magazineId}" name="myiframe" id="myiframe" frameborder="0" height="100%" width="100%" scrolling="no"></iframe>
		</td>
	</td>
	</tr>
</table>	
</body>
</html>
