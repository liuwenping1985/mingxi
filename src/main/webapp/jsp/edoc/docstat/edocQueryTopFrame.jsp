<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../edocHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>

</head>
<body scroll="no">	
<table width="100%" height="100%" cellpadding="0" cellspacing="0">

	<tr>
		<td colspan="2">
			<iframe id="main" name="main" src="${edocStat}?method=listQueryResult&flag=0" width="100%" height="100%" frameborder="0"/>
		</td>
	</tr>

</table>
<div class="hidden">
<iframe name="temp_iframe" id="temp_iframe">&nbsp;</iframe>
</div>
</body>