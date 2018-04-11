<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n('message.header.person.label')}</title>    
<%@ include file="header.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/showHistoryMessage.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}"/>"></script>
<link type="text/css" rel="stylesheet" href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />">
  
<html:link renderURL="/message.do" var="mainURL" />
<script type="text/javascript">
<!--
var showType=${param.showType};

function exportExcel(){
	var showType = ${param.showType};
	if(showType == 1){
		if(root.getSelected()){
			var exportType = "";
			var exportId = "";
			var selectId = root.getSelected().businessId;
			if(selectId == "member"){
				if(confirm(_("MainLang.message_export_1"))){
					exportType = "1";
				}else{
					return;
				}
			}else if(selectId == "team"){
				if(confirm(_("MainLang.message_export_2"))){
					exportType = "2";
				}else{
					return;
				}
			}else if(selectId.startsWith("mm")){
				if(confirm(_("MainLang.message_export_3"))){
					exportType = "3";
					exportId = selectId.substring(2, selectId.length);
				}else{
					return;
				}
			}else if(selectId.startsWith("tt")){
				if(confirm(_("MainLang.message_export_4"))){
					exportType = "4";
					exportId = selectId.substring(2, selectId.length);
				}else{
					return;
				}
			}
		}else{
			alert(_("MainLang.message_export_5"));
			return;
		}
		saveAsExcelFrame.location.href = "<c:url value='/message.do'/>?method=saveAsExcel&showType=1&exportType=" + exportType + "&exportId=" + exportId;
		return;
	}else{
		saveAsExcelFrame.location.href = "<c:url value='/message.do'/>?method=saveAsExcel&showType=${param.showType}&pageSize=${param.pageSize}&page=${param.page}";
	}
}

var tagName = ${param.showType==0}? "<fmt:message key='message.tag.systemMessage.label' />" : "<fmt:message key='message.tag.personMessage.label' />";

function cleanMessage(){
	if(${empty messageList}){
		return;
	}
	if(confirm(_("MainLang.message_alert_sureToClean", tagName))){
		location.href = "${mainURL}?method=removeMessages&showType=${param.showType}";
	}
}

try{
	var tohtml = "<span class='nowLocation_content'>" + "${ctp:i18n('message.header.person.label')}" + "</span>";
	showCtpLocation("", {html:tohtml});
}catch(e){}

function setBulPeopleFields_Mem(elements){
	if(elements.length>1){
		alert(v3x.getMessage("MainLang.system_phrase"));
		return false;
	}else{
		var element = elements[0];
		document.getElementById("memberId").value=element.id;
		document.getElementById("memberName").value=element.name;	
	}
}

/**
 * 删除聊天记录
 */
function deleteMessage(){
	var deleteType = "";
	var deleteIds = "";
	var checkboxs = showHistoryMessage.document.getElementsByName("id");
	var checked = 0;
	var checkboxsValue = "";
	for(var i = 0; i < checkboxs.length; i ++){
		if(checkboxs[i].checked){
			checkboxsValue += checkboxs[i].value + ",";
			checked ++;
		}
	}
	if(checked > 0){
		if(confirm(_("MainLang.message_delete_1"))){
			deleteType = "1";
			deleteIds = checkboxsValue.substring(0, checkboxsValue.length - 1);
		}else{
			return;
		}
	}else{
		if(root.getSelected()){
			var messageType = root.getSelected().businessId;
			if(messageType == "member"){
				if(confirm(_("MainLang.message_delete_2"))){
					deleteType = "2";
				}else{
					return;
				}
			}else if(messageType == "team"){
				if(confirm(_("MainLang.message_delete_3"))){
					deleteType = "3";
				}else{
					return;
				}
			}else if(messageType.startsWith("mm")){
				if(confirm(_("MainLang.message_delete_4"))){
					deleteType = "4";
					deleteIds = messageType.substring(2, messageType.length);
				}else{
					return;
				}
			}else if(messageType.startsWith("tt")){
				if(confirm(_("MainLang.message_delete_5"))){
					deleteType = "5";
					deleteIds = messageType.substring(2, messageType.length);
				}else{
					return;
				}
			}else{
				alert(_("MainLang.message_delete_6"));
				return;
			}
		}else{
			alert(_("MainLang.message_delete_6"));
			return;
		}
	}
	var id = document.getElementById("id").value;
	location.href = "/seeyon/message.do?method=deleteMessage&deleteType=" + deleteType + "&deleteIds=" + deleteIds + "&id=" + id;
}

function deleteMessageOk(){
	location.href = "${mainURL}?method=showMessages&showType=1";
}

/**
 * 选择人员或讨论组查看聊天记录
 */
function showAllHistoryMessage(type, id){
	document.getElementById("id").value = "";
	if(type == "-1"){
		document.getElementById("sort").value = "true";
		document.getElementById("area").value = "0";
		showHistoryMessage.location.href = "/seeyon/message.do?method=showAllHistoryMessage&init=true";
	}else if(type == "-2"){
		document.getElementById("sort").value = "false";
		document.getElementById("area").value = "1";
	}else if(type == "-3"){
		document.getElementById("sort").value = "true";
		document.getElementById("area").value = "2";
	}else{
		document.getElementById("sort").value = "false";
		document.getElementById("id").value = id;
		if(type == "1"){
			document.getElementById("area").value = "3";
		}else{
			document.getElementById("area").value = "4";
		}
		showHistoryMessage.location.href = "/seeyon/message.do?method=showAllHistoryMessage&type=" + type + "&id=" + id;
	}
}

/**
 * 查询 聊天记录
 */
function searchAllHistoryMessage(){
	var area = document.getElementById("area").value;
	var id = document.getElementById("id").value;
	if(area == "3" && id == ""){
		alert(_("MainLang.message_select_1"));
		return;
	}
	if(area == "4" && id == ""){
		alert(_("MainLang.message_select_2"));
		return;
	}
	var theForm = document.getElementById("searchForm1");
	theForm.submit();
}

function changeArea(){
	var area = document.getElementById("area").value;
	document.getElementById("id").value = "";
	if(area == "0" || area == "2"){
		document.getElementById("sort").value = "true";
	}else{
		document.getElementById("sort").value = "false";
	}
}

window.onload = function() {
	setMenuState('${param.showType}', '${param.readType}');
	
	<%--
	TODO fenghao
	if(typeof aa${fn:replace(param.id,'-','_')} != "undefined"){
		aa${fn:replace(param.id,'-','_')}.expandAll();
		aa${fn:replace(param.id,'-','_')}.select();
		showAllHistoryMessage('${param.type}', '${param.id}');
	}
	--%>
}
function setMenuState(showType, menu_id){
	if(showType == "0"){
		if(menu_id == null || menu_id == ""){
			menu_id = "allType";
		}
		var menuDiv = document.getElementById(menu_id);
		if(menuDiv != null){
		    menuDiv.className = "webfx-menu--button-sel";
		    menuDiv.firstChild.className="webfx-menu--button-content-sel";
		    menuDiv.onmouseover = "";
		    menuDiv.onmouseout = "";
		    document.getElementById("readType").value = menu_id;
		}else{
			return;
		}
	}
}
//-->
</script>
<style type="text/css">
img{
	border: 0px;
}
.webfx-menu-bar-gray .webfx-menu-bar-gray{
	border:none;
	}

/***layout*row1+row2***/
.main_div_row2 {
 width: 100%;
 height: 100%;
 _padding-left:0px;
}
.right_div_row2 {
 width: 100%;
 height: 100%;
 _padding:30px 0px 0px 0px;
}
.main_div_row2>.right_div_row2 {
 width:auto;
 position:absolute;
 left:0px;
 right:0px;
}
.center_div_row2 {
 width: 100%;
 height: 100%;
 /*background-color:#00CCFF;*/
 overflow:auto;
}
.right_div_row2>.center_div_row2 {
 height:auto;
 position:absolute;
 top:40px;
 bottom:0px;
}
.top_div_row2 {
 height:30px;
 width:100%;
 /*background-color:#9933FF;*/
 position:absolute;
 top:0px;
}
.div-float a{
 color:#000;
}
/***layout*row1+row2****end**/	
</style>
</head>
<body scroll="no" style="overflow: hidden">
<c:set value="${param.showType==0? '-sel':''}" var="isSel1"/>
<c:set value="${param.showType==1? '-sel':''}" var="isSel2"/>
<v3x:selectPeople id="selectMember" panels="Department,Outworker,RelatePeople" selectType="Member" jsFunction="setBulPeopleFields_Mem(elements);"/>

<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2 border-right">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		    <td height="26" width="100%" class="webfx-menu-bar-gray webfx-menu-bar-gray-xx gov_nobordertop" valign="middle">
		    <fmt:message key="${param.showType ==0 ? 'message.button.clean' : 'phrase.title.delete.label'}" var="deleteBar" />
	    	<div style="float:left;width:40%;">
		    	<script type="text/javascript">
		    	<!--
			    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
			    	if(v3x.getBrowserFlag('hideMenu')){
			    		myBar.add(new WebFXMenuButton("exportExcel", "<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />", "javascript:exportExcel()", [2,6]));
			    	}
			    	myBar.add(new WebFXMenuButton("cleanMessage", "${deleteBar}", "${param.showType==0 ? 'javascript:cleanMessage()' : 'javascript:deleteMessage()'}", [1,3]));
			    	if(${param.showType==0}){
			    		myBar.add(new WebFXMenuButton("updateState","<fmt:message key='common.all.label' bundle='${v3xCommonI18N}'/><fmt:message key='message.ignore.title' bundle='${v3xCommonI18N}'/>","updateMessageState(null, '${param.readType}');",[10,3]));
			    		myBar.add(new WebFXMenuButton("allType","&nbsp;&nbsp;&nbsp;<fmt:message key='common.all.label' bundle='${v3xCommonI18N}'/>&nbsp;","showAllType();",""));
			    		myBar.add(new WebFXMenuButton("notRead","&nbsp;&nbsp;&nbsp;<fmt:message key='common.not.read.label' bundle='${v3xCommonI18N}'/>&nbsp;","showNotRead();",""));
			    	}
			    	document.write(myBar);
			    	document.close();
			    //-->
		    	</script>
	    	</div>
	    	<c:if test="${param.showType==0}">
		    	<form action="" name="searchForm" id="searchForm" method="get" style="margin: 0px" onKeyPress="doSearchEnter()" onSubmit="return false">
			 	<input type="hidden" value="<c:out value='${param.method}' />" name="method">
			 	<input type="hidden" name="showType" value="${param.showType}">
			 	<input type="hidden" id="readType" name="readType" value="">
				<div class="div-float-right" style="padding-top: 5px">
					<div class="div-float">
						<select name="condition" id="condition"  onChange="showNextCondition(this)" class="condition">
					    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}"/></option>
						    <option value="messageContent"><fmt:message key="message.tableHeader.title" /></option>
						    <option value="senderName">
					    		<fmt:message key="message.tableHeader.sender" />
						    </option>
						    <option value="creationDate"><fmt:message key="common.date.sendtime.label" bundle="${v3xCommonI18N}" /></option>
							<c:if test="${CurrentUser.externalType == 0}">
                                <option value="messageCategory"><fmt:message key="common.type.label" bundle="${v3xCommonI18N}" /></option>
                            </c:if>
						</select>
					</div>
					<div class="div-float hidden" id="messageContentDiv"><input type="text" name="textfield" class="textfield" ></div>
					<div class="div-float hidden" id="senderNameDiv">
						<input type="text" name="textfield" class="textfield" >
					</div>
					<div class="div-float hidden" id="creationDateDiv">
						<input type="text" id="startDate" name="textfield" class="input-date div-float"  onClick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
						<span class="div-float" style="line-height: 21px; vertical-align: middle;">-</span>
						<input type="text" id="endDate" name="textfield1" class="input-date div-float" onClick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
					</div>
					<div class="div-float hidden" id="messageCategoryDiv" >
						<select name="textfield1" class="textfield">
							<c:if test ="${v3x:hasPlugin('collaboration')}">
							<option value="1"><fmt:message key="application.1.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>
							<option value="2"><fmt:message key="application.2.label" bundle="${v3xCommonI18N}" /></option>
							<c:if test ="${v3x:hasPlugin('edoc')}">
								<option value="4,16,19,20,21,22,23,24"><fmt:message key="application.4.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>
							<c:if test ="${v3x:hasPlugin('calendar')}">
								<option value="11"><fmt:message key="application.11.label" bundle="${v3xCommonI18N}" /></option>
                            </c:if>
                            <c:if test ="${v3x:hasPlugin('doc')}">
                            <c:choose>
                            <c:when test="${v3x:getSysFlagByName('sys_isA6Ver')}">
                                <option value="3"><fmt:message key="sys.app.3.label.A6" bundle="${v3xSysI18N}" /></option>
                            </c:when>
                            <c:otherwise>
                                <option value="3"><fmt:message key="application.3.label${v3x:suffix()}" bundle="${v3xCommonI18N}" /></option>
                            </c:otherwise>
                            </c:choose>
                            </c:if>
                            <c:if test ="${v3x:hasPlugin('webmail')}">
								<option value="12"><fmt:message key="application.12.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>
							<option value="13"><fmt:message key="application.13.label" bundle="${v3xCommonI18N}" /></option>
							<c:if test ="${v3x:hasPlugin('project')}">
								<option value="14"><fmt:message key="application.14.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>
							<option value="15"><fmt:message key="application.15.label" bundle="${v3xCommonI18N}" /></option>
							<c:if test ="${v3x:hasPlugin('hr')}">
							<option value="17"><fmt:message key="application.17.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>
							<c:if test ="${v3x:hasPlugin('bulletin')}">
							<option value="7"><fmt:message key="application.7.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>
							<c:if test ="${v3x:hasPlugin('news')}">
							<option value="8"><fmt:message key="application.8.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>
							<c:if test ="${v3x:hasPlugin('bbs')}">
							<option value="9"><fmt:message key="application.9.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>
							<c:if test ="${v3x:hasPlugin('inquiry')}">
							<option value="10"><fmt:message key="application.10.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>
							<c:if test ="${v3x:hasPlugin('meeting')}">
							<option value="6"><fmt:message key="application.6.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>
							<c:if test ="${v3x:hasPlugin('plan')}">
								<option value="5"><fmt:message key="application.5.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>
							<c:if test ="${v3x:hasPlugin('office')}">
							<option value="26"><fmt:message key="application.26.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>
							<option value="27"><fmt:message key="application.27.label" bundle="${v3xCommonI18N}" /></option>
							<c:if test ="${v3x:hasPlugin('taskmanage')}">
								<option value="30"><fmt:message key="application.30.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>
							<option value="31"><fmt:message key="application.31.label" bundle="${v3xCommonI18N}" /></option>
							<c:if test ="${ctp:hasPlugin('infosend')==true}">
							<option value="32"><fmt:message key="application.32.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>						
							<option value="35"><fmt:message key="application.35.label" bundle="${v3xCommonI18N}" /></option>
							<c:if test ="${ctp:hasPlugin('attendance')==true}">
							<option value="36"><fmt:message key="application.36.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>
							<c:if test ="${ctp:hasPlugin('sap')==true}">
							<option value="38"><fmt:message key="application.38.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>
							<c:if test ="${ctp:hasPlugin('cip')}">
							<option value="39"><fmt:message key="application.39.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>
							<c:if test ="${ctp:hasPlugin('show')==true}">
							<option value="40"><fmt:message key="application.40.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>				
							<c:if test ="${ctp:hasPlugin('wfanalysis')==true}">
							<option value="41"><fmt:message key="application.41.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>				
							<c:if test ="${ctp:hasPlugin('behavioranalysis')==true}">
							<option value="42"><fmt:message key="application.42.label" bundle="${v3xCommonI18N}" /></option>
							</c:if>				
							<c:forEach items="${otherapp }" var="other">
							<option value="${other.applicationCategory }">${v3x:messageFromResource(other.i18NResource, other.displayName)}</option>
							</c:forEach>
						</select>
					</div>
					<div onClick="javascript:doSearchMessage()" class="div-float condition-search-button"></div>
				</div>			
				</form>
			</c:if>
			<c:if test="${param.showType==1}">
				<form action="/seeyon/message.do" target="showHistoryMessage" name="searchForm1" id="searchForm1" method="get" onSubmit="return false">
				<input type="hidden" id="method" name="method" value="showAllHistoryMessage">
				<input type="hidden" id="id" name="id" value="">
				<input type="hidden" id="search" name="search" value="true">
				<input type="hidden" id="sort" name="sort" value="true">
				<div class="div-float-right" style="padding-top: 5px">
					<div class="div-float" style="padding-top: 2px"><fmt:message key='message.find.range'/>:&nbsp;</div>
					<div class="div-float">
						<select id="area" name="area" onChange="changeArea()">
					    	<option value="0"><fmt:message key='message.find.range.0'/></option>
					    	<option value="1"><fmt:message key='message.find.range.1'/></option>
					    	<option value="2"><fmt:message key='message.find.range.2'/></option>
					    	<option value="3"><fmt:message key='message.find.range.3'/></option>
					    	<option value="4"><fmt:message key='message.find.range.4'/></option>
						</select>&nbsp;&nbsp;
					</div>
					<div class="div-float">
						<select id="time" name="time" onChange="" class="">
					    	<option value="0"><fmt:message key='message.find.time.0'/></option>
					    	<option value="1"><fmt:message key='message.find.time.1'/></option>
					    	<option value="2"><fmt:message key='message.find.time.2'/></option>
					    	<option value="3"><fmt:message key='message.find.time.3'/></option>
						</select>&nbsp;&nbsp;
					</div>
					<div class="div-float" style="padding-top: 2px"><fmt:message key='message.find.content'/>:&nbsp;</div>
					<div class="div-float">
						<input type="text" id="content" name="content" class="textfield">&nbsp;&nbsp;
					</div>
					<div onClick="javascript:searchAllHistoryMessage()" class="div-float condition-search-button"></div>
				</div>
				</form>
			</c:if>
    	    </td>
	    </tr>
	    <fmt:message key="message.sender.anonymous" var="anonymous"/>
	   </table> 
    </div>
    <div class='center_div_row2' id="scrollListDiv" style="overflow: hidden;">
		<c:if test="${param.showType==0}">
			  <form name="listForm" id="listForm" method="get" onSubmit="return false" style="margin: 0px" action="">
					<v3x:table htmlId="messageList" data="messageList" var="msg" className="sort" dragable="true">
						<c:choose>
							<c:when test="${ msg.link eq 'null' || msg.link eq ''}">
								<c:if test="${msg.isRead}">
									<c:set value="javascript:void(null)" var="openLink"/>
									<c:set value='' var="hand"/>
								</c:if>
								<c:if test="${!msg.isRead}">
									<c:set value="javascript:void(null)" var="openLink"/>
									<c:set value='cursor-hand' var="hand"/>
								</c:if>
							</c:when>
							<c:otherwise>
								<c:set value="getA8Top().openDocument('${msg.link }','${msg.openType }')" var="openLink"/>
								<c:set value='cursor-hand' var="hand"/>
							</c:otherwise>
						</c:choose>
						<v3x:column width="8%"  type="String" className="sort ${hand}" label="message.tableHeader.category">
                            <c:choose>
                            <c:when test="${msg.messageCategory == '3' && CurrentUser.externalType != 0}">知识分享</c:when>
                            <c:when test="${msg.messageCategory == '3' && v3x:getSysFlagByName('sys_isA6Ver')}">
                                <fmt:message key="sys.app.3.label.A6" bundle="${v3xSysI18N}" />
                            </c:when>
                            <c:when test="${msg.messageCategory == '3' && !v3x:getSysFlagByName('sys_isA6Ver')}">
                                <fmt:message key="application.3.label${v3x:suffix()}" bundle="${v3xCommonI18N}" />
                            </c:when>
                            <c:when test="${msg.messageCategory>2000}">
                                <fmt:message key="application.39.label" />
                            </c:when>
                            <c:otherwise>
                                ${v3x:getApplicationCategoryName(msg.messageCategory, pageContext)}
                            </c:otherwise>
                            </c:choose>
                        </v3x:column> 
						<v3x:column width="12%" type="String" className="sort ${hand}" label="message.tableHeader.sender">
							<c:choose>
								<c:when test="${msg.senderId!=-1}">
									<c:choose>
										<c:when test="${msg.senderId != v3x:currentUser().id && msg.senderId != 8 &&  msg.senderId != 2 && msg.senderId != 1 && msg.senderId != 0 && !v3x:getOrgEntity('Member', msg.senderId).isAdmin}">
											<span class="like-a" onClick="showV3XMemberCard('${msg.senderId}')">${v3x:showMemberName(msg.senderId)}</span>
										</c:when>
										<c:otherwise>
											${v3x:showMemberName(msg.senderId)}
										</c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
										${v3x:showMessageAnonymous(msg)}
								</c:otherwise>
							</c:choose>
						</v3x:column>
						
						<v3x:column width="12%" type="Date"  className="sort ${hand}"  label="common.date.sendtime.label">
							<fmt:formatDate value="${msg.creationDate}" pattern="${datetimePattern}" />
						</v3x:column>
						<v3x:column type="String" width="60%" onClick="javascript:updateMessageState('${msg.id}', '${param.readType}','show');${openLink}" className="sort ${hand}" label="message.tableHeader.title" escapeHtml="true">
							<c:choose>
								<c:when test="${hand=='cursor-hand'}">
									<span class="div-float" style="white-space: normal;">
										<c:if test="${msg.importantLevel == '2' || msg.importantLevel == '3'}">
											<span class='inline-block importance_${msg.importantLevel}'></span>
										</c:if>
                                        <c:set var="readClass" value="${msg.isRead?'':'color_black font_bold'}"/>
										<c:if test="${msg.messageCategory == '31'}">
											<a class="title-more ${readClass}" >
												${msg.messageContent}
											</a>
										</c:if>
										<c:if test="${msg.messageCategory != '31'}">
											<a class="title-more ${readClass}" title="${v3x:toHTMLAlt(msg.messageContent)}">
												${v3x:toHTMLAlt(v3x:getSafeLimitLengthString(msg.messageContent, 100,'..'))}
											</a>
										</c:if>
										<c:if test="${!msg.isRead}">
											<span id="${msg.id}Span" name="unReadMsg" class="icon_com news_com" style="display: inline-block;"></span>
										</c:if>
									</span>
								</c:when>
								<c:otherwise>
									<span class="div-float">
										<c:if test="${msg.importantLevel == '2' || msg.importantLevel == '3'}">
											<span class='inline-block importance_${msg.importantLevel}'></span>
										</c:if>
										<span title="${v3x:toHTMLAlt(msg.messageContent)}">${v3x:toHTMLAlt(v3x:getSafeLimitLengthString(msg.messageContent, 100,'..'))} </span>
									</span>
								</c:otherwise>
							</c:choose>
						</v3x:column>	
                        <v3x:column width="8%" type="String" align="center" className="sort ${hand}"  label="message.ignore.title">
                            <c:if test="${!msg.isRead}">
                                <span class="div-float-right" id="${msg.id}Div" name="unReadMsg" style="border: 0">
                                    <a href="javascript:updateMessageState('${msg.id}', '${param.readType}')">[<fmt:message key='message.ignore.title' bundle='${v3xCommonI18N}'/>]&nbsp;&nbsp;&nbsp;&nbsp;</a>
                                </span>
                            </c:if>
                        </v3x:column>			
					</v3x:table>
			  </form>
		</c:if>
		<c:if test="${param.showType==1}">
			<table width="100%" height="200" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td width="200" style="border-right: solid #ececec 4px;height:100%" valign="top">
						<div class="scrollList"  id="scrollListTree" style="width: 200px;overflow: auto;padding: 5px;">
							<script type="text/javascript">
								var root = new WebFXTree("root", "<fmt:message key='message.group'/>", "javascript:showAllHistoryMessage('-1', '')");
								root.setBehavior('classic');
								root.icon = "<c:url value='/common/images/templete.gif'/>";
								root.openIcon = "<c:url value='/common/images/templete.gif'/>";
								
								var icon1 = "/seeyon/apps_res/v3xmain/images/message/16/user.gif";
								var icon2 = "/seeyon/apps_res/v3xmain/images/message/16/users.gif";
								<%--
						        TODO fenghao
								var aa${fn:replace('member','-','_')} = new WebFXTreeItem("member","<fmt:message key='message.contact'/>(${memberSize})","javascript:showAllHistoryMessage('-2', '')");
								var aa${fn:replace('team','-','_')} = new WebFXTreeItem("team","<fmt:message key='message.team'/>(${teamSize})","javascript:showAllHistoryMessage('-3', '')");
								
								root.add(aa${fn:replace('member','-','_')});
								root.add(aa${fn:replace('team','-','_')});
					           
								<c:forEach items="${memberList}" var="m">
									var aa${fn:replace(m,'-','_')} = new WebFXTreeItem("mm${m}","${v3x:toHTML(v3x:getOrgEntity('Member', m).name)}","javascript:showAllHistoryMessage('1', '${m}')");
									aa${fn:replace(m,'-','_')}.icon= icon1;
									aa${fn:replace(m,'-','_')}.openIcon= icon1;
									aa${fn:replace('member','-','_')}.add(aa${fn:replace(m,'-','_')});
								</c:forEach>
						
								<c:forEach items="${deptList}" var="d">
									var aa${fn:replace(d,'-','_')} = new WebFXTreeItem("tt${d}","${v3x:getDepartment(d).name}","javascript:showAllHistoryMessage('2', '${d}')");
									aa${fn:replace(d,'-','_')}.icon= icon2;
									aa${fn:replace(d,'-','_')}.openIcon= icon2;
									aa${fn:replace('team','-','_')}.add(aa${fn:replace(d,'-','_')});
								</c:forEach>
						       --%>
								<c:forEach items="${teamList}" var="t">
									<c:set value="${v3x:getTeam(t)}" var="currentTeam" />
									<c:if test="${currentTeam.type == '2'}">
		    							<c:set value="3" var="currentType" />
			    					</c:if>
			    					<c:if test="${currentTeam.type == '3'}">
		    							<c:set value="4" var="currentType" />
			    					</c:if>
			    					<c:if test="${currentTeam.type == '4'}">
		    							<c:set value="5" var="currentType" />
			    					</c:if>
			    					<%--
                                    TODO fenghao
									var aa${fn:replace(t,'-','_')} = new WebFXTreeItem("tt${t}","${v3x:toHTML(currentTeam.name)}","javascript:showAllHistoryMessage('${currentType}', '${t}')");
									aa${fn:replace(t,'-','_')}.icon= icon2;
									aa${fn:replace(t,'-','_')}.openIcon= icon2;
									aa${fn:replace('team','-','_')}.add(aa${fn:replace(t,'-','_')});
									--%>
								</c:forEach>

								document.write(root);
								document.close();
								<%--
								/*if(aa${fn:replace('member','-','_')}.getFirst()){
									aa${fn:replace('member','-','_')}.expand();
								}
								if(aa${fn:replace('team','-','_')}.getFirst()){
									aa${fn:replace('team','-','_')}.expand();
								}*/
								--%>
							</script>
							<br/><br/>
						</div>
					</td>
					<td valign="top">
						<iframe src="/seeyon/message.do?method=showAllHistoryMessage&init=true" id="showHistoryMessage" name="showHistoryMessage" frameborder="0" width="100%" height="100%" scrolling="no"></iframe>
					</td>
				</tr>
			</table>
		</c:if>
    </div>
  </div>
</div>
<iframe name="saveAsExcelFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
<script type="text/javascript">
<!--
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
var oHeight = parseInt(document.body.clientHeight)-65;

<c:if test="${param.showType==1}">
document.getElementById('showHistoryMessage').style.height = (oHeight+30)+"px";
</c:if>

var scrollListTree = document.getElementById('scrollListTree');
if(scrollListTree){
	scrollListTree.style.height = parseInt(document.body.clientHeight)-80+"px";
}
//-->
</script>
</body>
</html>