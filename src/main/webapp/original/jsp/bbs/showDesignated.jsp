<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
</head>
<body scroll="no" class="padding355">
<div class="border-tree scrollList">
	<table align="center" border="0" cellpadding="0" cellspacing="0" width="70%">
		<tr>
			<td height="40" colspan="2">
				<div class="div-float-right">
					<form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false">
						<input type="hidden" value="${param.method}" name="method">
						<input type="hidden" value="${param.group}" name="group" id="group" >
					  	<div id="subjectDiv" class="div-float"><input type="text" id="textfield" name="textfield" inputName="<fmt:message key='common.name.label' bundle='${v3xCommonI18N}' />" class="textfield" value="${param.textfield}" onkeydown="javascript:doSearchEnter()" maxlength="100"></div>
						<div onclick="javascript:doSearch()" class="condition-search-button"></div>
					</form>
				</div>
			</td>
		</tr>
		<tr>
			<td width="10%" align="center" class="sort" style="border-left: solid 1px #ddd; border-top: solid 1px #ddd;">
				<label for="all">
					<input type="checkbox" onclick="selectAll(this, 'designated')">
				</label>
			</td>
			<td class="sort" style="border-top: solid 1px #ddd;border-right: solid 1px #ddd; ">
				<fmt:message key="common.resource.body.name.label" bundle="${v3xMainI18N}"/>
			</td>
		</tr>
		<c:forEach items="${typeList}" var="type" varStatus="ordinal">
			<tr>
				<td align="center" class="sort" style="border-left: solid 1px #ddd;">
					<label for="responsible">
						<input id="type${ordinal.index}" name="designated" type="checkbox" value="${type.id}">
					</label>
				</td>
				<td class="sort" style="border-right: solid 1px #ddd; ">
					${v3x:toHTML(type.name)}
				</td>
			</tr>
		</c:forEach>
	</table>
</div>
</body>
<script type="text/javascript">
function OK(){
	var ids = [];
	var names = [];
	var designated = document.getElementsByName("designated");
	if(designated){
		for(var i = 0; i < designated.length; i++){
			if(designated[i] && designated[i].checked){
				ids[ids.length] = designated[i].value;
			}
		}
	}
	return [ids, names];
}

function doSearch() {
    // 特殊字符验证
  	if(!notSpecChar(document.getElementById('textfield'))) {
    	return;
    }
    var theForm = document.getElementsByName("searchForm")[0];
    if (theForm) {
	    theForm.target = theForm.target || "_self";
        theForm.submit();
    }
}

function doSearchEnter(){
	var evt = v3x.getEvent();
    if(evt.keyCode == 13){
    	doSearch();
    }
}

window.onload = function (){
	var values = window.dialogArguments;
	var designated = document.getElementsByName("designated");
	if(designated && values){
		for(var i = 0; i < designated.length; i ++){
			var valuestr = values.split(",");
			for(var j = 0; j < valuestr.length; j ++){
				if(valuestr[j] == designated[i].value){
					designated[i].checked = true;
				}
			}
		}
	}
}
</script>
</html>