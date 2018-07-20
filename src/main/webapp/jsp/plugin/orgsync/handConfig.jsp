<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="header.jsp"%>
<title>组织机构同步</title>
<script type="text/javascript">
	  showCtpLocation("F21_OrgSync_Setup"); 
</script>
</head>
<c:choose>
<c:when test="${sys_isGroupVer}">
<frameset rows="27,*" id='main' cols="*" frameborder="0">
<frame src="${urlNCSynchron}?method=showMenu" frameborder="0" border="0" noresize="noresize" name="menuFrame" id="menuFrame" scrolling="no" />
	<frameset id="treeandlist" rows="*" cols="20%,*" frameborder="1" border="5" bordercolor="#ececec">
	<frame src="${urlNCSynchron}?method=showAccountsCofigTree" name="treeFrame" id="treeFrame" frameborder="no"/>
	<frame src="${urlNCSynchron}?method=handSychron" name="listAndDetailFrame" id="listAndDetailFrame" scrolling="no" frameborder="no"/>
    </frameset>
</frameset>
</c:when>
<c:otherwise>
<frameset rows="30,*" id='main' cols="*" framespacing="0" frameborder="no" border="0">
<frame src="${urlNCSynchron}?method=showMenu" frameborder="no" noresize="noresize" name="menuFrame" id="menuFrame" scrolling="no" />
	<frame src="${urlNCSynchron}?method=handSychron" name="listAndDetailFrame" id="listAndDetailFrame" scrolling="no" frameborder="no"/>
</frameset>
</c:otherwise>
</c:choose>

<noframes><body scroll="no"></body>
</noframes>
</html>