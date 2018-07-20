<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head>
</head>
<c:choose>
	<c:when test="${isSpaceManager != false}">
		<frameset rows="*" id="bulFrame" border="0" frameborder="no">
		<frameset rows="40%,*" id='sx' cols="*" framespacing="0" frameborder="no" border="0">
			<frame frameborder="0" src="${bulDataURL}?method=list&condition=${param['condition']}&textfield=${param['textfield']}&type=${bultypeid == null ? param.type : bultypeid}&spaceType=${param.spaceType}&custom=${param.custom}&showAudit=${param.showAudit}&spaceId=${param.spaceId}" name="listFrame" scrolling="no" id="listFrame" />
			<frame frameborder="0" src="${commonDetailURL}" name="detailFrame" id="detailFrame" scrolling="no" />
		</frameset>
		</frameset>
		<noframes>
			<body scroll='no'>
			</body>
		</noframes>
	</c:when>
	<c:otherwise>
	<script type="text/javascript">
		alert(v3x.getMessage("bulletin.bulletin_no_pers"));
		//TODO yangwulin 2012-11-28 getA8Top().contentFrame.topFrame.back();
		getA8Top().back();
	</script>
	</c:otherwise>
</c:choose>
</html>
