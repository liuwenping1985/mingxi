<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../edocHeader.jsp" %>
<html>
<head>
<script type="text/javascript">
    var menuKey = "1508";
    //是否是单位公文管理员
     var isAccountAdmin = ${v3x:isRole("AccountEdocAdmin", v3x:currentUser())};
    if(isAccountAdmin){
        menuKey = "208"
    }
    showCtpLocation("F07_edocSystem1");
</script>
</head>
<frameset  rows="*" framespacing="1" border="0" frameborder="no">
<frameset rows="30%,*" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
	<frame frameborder="no" src="${edocObjTeamUrl}?method=list" name="listFrame" scrolling="no" id="listFrame" />
	<frame src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" frameborder="no" scrolling="no"/>
</frameset>
</frameset>
<noframes><body scroll="no"></body>
</noframes>
</html>