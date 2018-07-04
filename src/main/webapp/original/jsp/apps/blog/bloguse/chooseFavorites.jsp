<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum"%>
<%@ page import="com.seeyon.ctp.common.constants.Constants"%>

<%@ include file="../header.jsp"%>

<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">

<title><fmt:message key="blog.favorites.choose" /></title>
<script type="text/javascript">
function save(){
	var id = document.getElementById("familyList").value;
	var button1 = document.getElementById("button1") ;
	var button2 = document.getElementById("button2") ;
	button1.disabled = "disabled" ;
	button2.disabled = "disabled" ;
    document.favoritesForm.action = "${detailURL}?method=createFavoritesArticle&familyid="+id; 	
	document.favoritesForm.target = "blogIframe";
	document.favoritesForm.submit();
	//window.close();
}

function refFun (returnValue) {
	transParams.parentWin.openTheWindowCallBackFun(returnValue);
}

</script>

</head>

<body scroll="no"  onkeydown="listenerKeyESC()">

<form name="favoritesForm" method="post" action="" onsubmit="">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">


	<tr>
		<td height="20" class="PopupTitle"><fmt:message key="blog.favorites.choose" /></td>
	</tr>
	<tr>
		<td style="	background-color: #F6F6F6;" align="center">		
		<input type="hidden"  name="articleId" value="${articleId}"> 
		<input type="hidden"  name="resourceMethod" value="${resourceMethod}">
		<select style="width: 75%" id="familyList" name="familyList">
			<option value="${defaultFmId}">-- <fmt:message key="blog.favorites.choose" /> --</option>
			<c:forEach items="${FamilyModelList}" var="vo">
				<option value="${vo.id}">${v3x:toHTML(vo.nameFamily)}</option>
			</c:forEach>
		</select>
	</td>
	</tr>
<tr>
	<td height="42" align="right" class="bg-advance-bottom">
		<input type="button" id="button1" onclick="save()"  value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />"  class="button-default-2">&nbsp;
		<input type="button" id="button2" onclick="getA8Top().openTheWindows.close()" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
	</td>
</tr>
</table>
	</form>





<iframe name="blogIframe" frameBorder="0"
	height="0" width="0" scrolling="no" marginheight="0" marginwidth="0" />
</body>
</html>