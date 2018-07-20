<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<body style="overflow: hidden" scroll="no" class="padding5">
	<div class="page-list-border">
		<iframe id="auditListIndex" name="auditListIndex" src="${basicURL}?method=checkerListFrameInner&group=${param.group}&hasCheckAuth=true&surveytypeid=${param.surveytypeid}&spaceType=${param.spaceType}&spaceId=${param.spaceId}&where=${param.where}" style="width:100%;height: 99%;" frameborder="0">
		</iframe>
	</div>
</body>
</html>