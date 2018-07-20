<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<%@ include file="../include/header.jsp" %>
<html>
<head>
<script type="text/javascript">
<!--
function OK(){
	var ids = [];
	var names =[];
	var types = document.getElementsByName("type");
	for(var i = 0; i < types.length; i++){
		if(types[i].checked){
			ids[ids.length] = types[i].value;
			names[names.length] = types[i].nextSibling.nodeValue;
		}
	}
	return [ids,names];
}
window.onload=function(){
	var ss = parent.singlePanelValue;
	var types = document.getElementsByName("type");
	if(ss){
		for(var i = 0; i < types.length; i++){
			var va = types[i].value;
			for(var j = 0 ; j < ss.length;j++){
				if(ss[j] == va){
					types[i].checked = "checked";
					break;
				}
			}
		}
	}
}
//-->
</script>
</head>
<body scroll="no" style="overflow: hidden" onkeydown="listenerKeyESC()" >
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="popupTitleRight">
	<tr>
		<td height="20" class="PopupTitle"></td>
	</tr>
	<tr class="bg-advance-middel">
	<td>
		<div class="scrollList">
		<table width="100%" height="200" border="0" cellspacing="0" cellpadding="0" align="center">
			<c:forEach items="${typeList}" var="newsType">
			<tr>
			<td width="20%"></td>
			<td width="60%">
				<label for="type${newsType.id}"><input type="checkbox" id="type${newsType.id}" name="type" value="${newsType.id}">${v3x:toHTML(newsType.typeName)}</label>
			</td>
			<td width="20%"></td>
			</tr>
			</c:forEach>
		</table>
		</div>
	</td>
	</tr>
</table>
</body>
</html>