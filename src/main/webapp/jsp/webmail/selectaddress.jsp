<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.webmail.resources.i18n.WebMailResources"/>
<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>

<html:link renderURL='/webmail.do' var='webmailURL' />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/webmail/css/webmail.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;

//-->
</script>

<script type="text/javascript">

function bookInit(){
	var memberDataBody = document.getElementById("memberDataBody");
	var teamList = document.getElementById("teamList");
	<c:forEach items="${list}" var="book">
	if(v3x.isMSIE){
		memberDataBody.add(createOption("${book.email}","${book.name}<c:if test="${book.email!=null&&book.email!=''}">(${book.email})</c:if>"));
	}else{
		memberDataBody.appendChild(createOption("${book.email}","${book.name}<c:if test="${book.email!=null&&book.email!=''}">(${book.email})</c:if>"));
	}
		
	</c:forEach>
	<c:forEach items="${teamList}" var="team">
	if(v3x.isMSIE){
		teamList.add(createOption("${team.id}","${team.name}"));
	}else{
		teamList.appendChild(createOption("${team.id}","${team.name}"));
	}
		
	</c:forEach>
	var items = teamList.options;
	if(items != null && items.length > 0){
		for(var i = 0; i < items.length; i++){
			var item = items[i];
			if(item.value == "${teamId}"){
				item.selected = true;
				break;
			}
		}
	}
	if(v3x.getBrowserFlag('selectPeopleShowType')){
		touchScroll('memberDataBody');
		touchScroll('ListSelect');
	}
}

function doSelectBook(){
	var memberDataBody = document.getElementById("memberDataBody");
	var listSelect = document.getElementById("ListSelect");
	if(v3x.getBrowserFlag('selectPeopleShowType')){
		var items = memberDataBody.options;
		if(items != null && items.length > 0){
			for(var i = 0; i < items.length; i++){
				var item = items[i];
				if(item.selected && !checkSelectedBook(item.value,item.text)){
					if(v3x.isMSIE){
						listSelect.add(createOption(item.value, item.text));
					}else{
						listSelect.appendChild(createOption(item.value, item.text));
					}
					
				}
			}
		}
	}else{
		var items = memberDataBody.childNodes;
		if(items != null && items.length > 0){
			for(var i = 0; i < items.length; i++){
				var item = items[i];
				if(item.getAttribute('seleted')=='true' && !checkSelectedBook(item.getAttribute('value'),item.innerHTML)){
					if(v3x.isMSIE){
						listSelect.add(createOption(item.value, item.text));
					}else{
						listSelect.appendChild(createOption(item.getAttribute('value'),item.innerHTML));
					}
					
				}
			}
		}

	}
}

function removeBook(){
	var listSelect = document.getElementById("ListSelect");
	if(v3x.getBrowserFlag('selectPeopleShowType')){
		var items = listSelect.options;
		if(items != null && items.length > 0){
			var selectedIndex = -1;
			for(var i = 0; i < items.length; i++){
				var item = items[i];
				if(item.selected){
					selectedIndex = item.index;
					break;
				}
			}
			if(selectedIndex != -1){
				listSelect.remove(selectedIndex);
				removeBook();
			}
		}
	}else{
		var items = listSelect.childNodes;
		if(items != null && items.length > 0){
			var selectedIndex = -1;
			for(var i = 0; i < items.length; i++){
				var item = items[i];
				if(item.getAttribute('seleted')=='true'){
					listSelect.removeChild(item);
					i--;
				}
			}
		}
	}
}

function checkSelectedBook(value,text){
	if(value == null || value.length == 0){
		alert(text+"没有Email信息");
		return true;
	}
	var listSelect = document.getElementById("ListSelect");
	var items = listSelect.options;
	if(items != null && items.length > 0){
		for(var i = 0; i < items.length; i++){
			var item = items[i];
			if(item.value == value){
				alert(item.text + "已经选择");
				return true;
			}
		}
	}
	return false;
}

function createOption(value, text){
	var option = null;
	if(v3x.getBrowserFlag('selectPeopleShowType')){
		option = document.createElement("option");
		option.value = value;
		option.text = text;
	}else{
		var option = document.createElement('div');
		var text = document.createTextNode(text);
		option.appendChild(text);
		option.setAttribute('value',value);
		option.setAttribute('seleted','false');
		option.setAttribute('class','member-list-div');
		option.onclick = function(){selectMemberFn(this);}
	}
	return option
}
function selectMemberFn(obj,temp_Id){
	if(!obj){return;}
	var seleted = obj.getAttribute('seleted');
	if(seleted == 'false'){
		obj.setAttribute('seleted','true');
		obj.setAttribute('class','member-list-div-select');
	}else{
		obj.setAttribute('seleted','false');
		obj.setAttribute('class','member-list-div');
	}
}
function returnSelected(){
	var data = new Array();
	
	try{
		var listSelect = document.getElementById("ListSelect");
		var items = listSelect.options;
		if(items != null && items.length > 0){
			for(var i = 0; i < items.length; i++){
				var item = items[i];
				data[i] = item.value;
			}
		}
	}
	catch(e){
		if(e != 'continue'){
			alert(e.message);
		}
		return;
	}
	//正常返回数据，如果没有人，则data是一个length为0的数组，即data = []
	transParams.parentWin.selectAddressCollBack(data);
}

function chanageTeam(teamId){
	document.location.href = "${webmailURL}?method=getAddress&teamId="+teamId;
}
function OK(){
	var data = new Array();
	
	try{
		var listSelect = document.getElementById("ListSelect");
		var items = listSelect.childNodes;
		if(items != null && items.length > 0){
			for(var i = 0; i < items.length; i++){
				var item = items[i];
				data[i] = item.getAttribute('value');
			}
		}
	}
	catch(e){
		if(e != 'continue'){
			alert(e.message);
		}
		return;
	}
	return data;
}

</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/SelectPeople/css/css.css${v3x:resSuffix()}" />" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/SelectPeople/tree/xtree.css${v3x:resSuffix()}" />" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/SelectPeople/tablesort/tablesort.css${v3x:resSuffix()}" />" />
</head>
<body scroll="no" onload="bookInit()">

<table id="selectPeopleTable" width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="popupTitleRight">
	<tr>
		<td height="21" class="PopupTitle" colspan="2"><fmt:message key='label.mail.addbycontact'/></td>
	</tr>
	<tr valign="top"><td width="35" align="center">&nbsp;</td>
		<td align="center">
			<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
				<tr>
					<td height="40" align="right">&nbsp;
					<table border="0" cellspacing="0" cellpadding="0" style="display:none">
						<tr>
							<td>
								<select name="teamList" onchange="chanageTeam(this.value)" id="teamList" class="select-change-account">
								<option value="-1">全部</option>
								</select>
							</td>
							<td class="td-left-5">
								<table border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="cursor-hand" id="button1" onClick="showParentTree()" title="<fmt:message key='selectPeople.showparent.title' />"><img height=14 src="<c:url value="/common/SelectPeople/images/xs.gif"/>" width=15 align=absMiddle></td>
									</tr>
								</table>
							</td>
							<td class="td-left-5">
								<table border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td class="cursor-hand" id="button2" onClick="hiddenArea1()" title="<fmt:message key='selectPeople.hidden1.title' />"><img
											src="<c:url value="/common/SelectPeople/images/hb.gif"/>" width="16" height="16" align="absmiddle"></td>
									</tr>
								</table>
							</td>
							<td align="right" class="td-left-5"><span id="searchArea"><input
								id="q" type="text" value="" /><img
								src="<c:url value="/common/SelectPeople/images/search_button_rest.gif"/>"
								border="0" align="absmiddle" class="cursor-hand" onclick="searchItems()" /></span></td>
						</tr>
					</table>
					</td>
					<td>&nbsp;</td>
					
					<td width="35">&nbsp;</td><td>&nbsp;</td>
				</tr>
				<tr>
					<td width="240" height="285" valign="top">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr onselectstart="return false">
							<td height="135" id="Area2" class="iframe-">
							<c:choose>
								<c:when test="${v3x:getBrowserFlagByUser('selectPeopleShowType', v3x:currentUser())==false}">
									<div id="memberDataBody" class="select-people-list"></div>
								</c:when>
								<c:otherwise>
									<select id="memberDataBody"
										ondblclick="doSelectBook();" 
										multiple="multiple" style="width:240px;" size="26">
									</select>
								</c:otherwise>
							</c:choose>
							
							</td>
						</tr>
					</table>
					</td>
					<td width="35" align="center" valign="top">
						<br/><br/><br/><br/><br/><br/><br/><br/>
						<p><img src="<c:url value="/common/SelectPeople/images/arrow_a.gif"/>"
							alt="<fmt:message key='selectPeople.alt.select' bundle='${v3xMainI18N }'/>" width="24"
							height="24" class="cursor-hand" onclick="doSelectBook()"></p><br/>
						<p><img src="<c:url value="/common/SelectPeople/images/arrow_del.gif"/>"
							alt="<fmt:message key='selectPeople.alt.unselect' bundle='${v3xMainI18N }'/>" width="24"
							height=24 class="cursor-hand" onclick="removeBook()"></p>
					</td>
					<td width="240" valign="top" class="iframe1-">
						<c:choose>
							<c:when test="${v3x:getBrowserFlagByUser('selectPeopleShowType', v3x:currentUser())==false}">
								<div id="ListSelect" class="select-people-list"></div>
							</c:when>
							<c:otherwise>
								<select id="ListSelect" ondblclick="removeBook()" 
									multiple="multiple" style="width:240px" size="26">
								</select>
							</c:otherwise>
						</c:choose>
						
					</td>
					<td width="35" align="center">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3" height="20" class="bg-advance-bottom" align="right">
			<input name="Submit" type="button" onClick="returnSelected()" class="button-default-2"
				value='<fmt:message key="common.button.ok.label" bundle="${v3xCommonI18N}" />'>
			<input name="close" type="button" onclick="getA8Top().selectAddressWin.close();" class="button-default-2"
				value='<fmt:message key="common.button.cancel.label" bundle="${v3xCommonI18N}" />'>
		</td>
	</tr>
</table>
</body>
</html>