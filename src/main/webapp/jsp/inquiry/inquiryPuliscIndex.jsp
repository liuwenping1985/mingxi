<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>

</head>
<body scroll='no' class="padding5">
<table class="page-list-border" height="100%" width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<iframe name="pulisIframe" id="pulisIframe" src="${basicURL}?method=puliscListMain&surveytypeid=${param.surveytypeid}&group=${param.group}&custom=${param.custom}&spaceType=${param.spaceType}&spaceId=${v3x:toHTML(param.spaceId)}" frameborder="0" style="width:100%;height: 100%;"></iframe>
		</td>
	</tr>
</table>

</body>
</html>