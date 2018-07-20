<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.seeyon.v3x.meeting.manager.MtMeetingManagerImpl"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<%@ taglib uri="http://www.seeyon.com/ctp" prefix="ctp" %>


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
window.onload = function(){
}

try {
	getA8Top().endProc('');
	parent.treeFrame.changeHandler("${param.listType}");
} catch(e) {
}

//当前位置
/*
if(getA8Top()!=null && typeof(getA8Top().showLocation)!="undefined") {
<c:choose>
<c:when test="${param.menuId=='2101'}">//会议通知
	<c:choose>
		<c:when test="${param.listType=='listNoticeMeeting'}">
			getA8Top().showLocation(2101, "<fmt:message key='mt.mtMeeting.notice.label'/>", "<fmt:message key='mt.meeting.my.notice'/>");
		</c:when>
		<c:when test="${param.listType=='listDraftNoticeMeeting'}">
			getA8Top().showLocation(2101, "<fmt:message key='mt.mtMeeting.notice.label'/>", "<fmt:message key='admin.label.drafts'/>");
		</c:when>
	</c:choose>
</c:when>
<c:when test="${param.menuId=='2102'}">//我的会议
<c:choose>
	<c:when test="${param.listType=='listMyJoinMeeting' || param.listType=='listMyJoinToOpenMeeting' || param.listType=='listToOpenMeeting'}">//我参加的未召开会议
		getA8Top().showLocation(2102, "<fmt:message key='mt.mtMeeting.attend.label'/>", "<fmt:message key='mt.mtMeeting.state.10'/>");
	</c:when>
	<c:when test="${param.listType=='listMyJoinOpenedMeeting' || param.listType=='listOpenedMeeting'}">//我参加的已召开会议
		getA8Top().showLocation(2102, "<fmt:message key='mt.mtMeeting.attend.label'/>", "<fmt:message key='mt.mtMeeting.state.convoked'/>");
	</c:when>
	<c:when test="${param.listType=='listMyPublishToOpenMeeting' || param.listType=='listMyPublishMeeting'}">//我发布的未召开会议
		getA8Top().showLocation(2102, "<fmt:message key='mt.mtMeeting.publish.label'/>", "<fmt:message key='mt.mtMeeting.state.10'/>");
	</c:when>
	<c:when test="${param.listType=='listMyPublishOpenedMeeting'}">//我发布的已召开会议
		getA8Top().showLocation(2102, "<fmt:message key='mt.mtMeeting.publish.label'/>", "<fmt:message key='mt.mtMeeting.state.convoked'/>");
	</c:when>
</c:choose>
</c:when>
</c:choose>
}*/

baseUrl='${mtMeetingURL}?method=';
var ht = new Hashtable();
var createUserIdTable = new Hashtable();
var userInternalID = "${sessionScope['com.seeyon.current_user'].id}";
var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
//发布
<c:if test="${listType=='listMyAppMeetingVarificated' || listType=='listMyAppMeeting'}">
	myBar.add(new WebFXMenuButton("convoked", "<fmt:message key='mt.list.toolbar.publish.label'/>",  "javascript:publishAppMeeting();", [4,3], "", null));
</c:if>
//lijl添加,在授权和取消授权的成功后给予的提示
<c:if test="${leaderCount==1||leaderCount==2}">
	alert("<fmt:message key='admin.alert.successfullyset'/>");
</c:if>

//编辑
<c:if test="${listType=='listMyPublishToOpenMeeting' || listType=='listMyPublishMeeting' || listType=='listDraftNoticeMeeting' || listType=='listNoticeMeeting'}">
	myBar.add(new WebFXMenuButton("convoked", "<fmt:message key='common.toolbar.edit.label' bundle='${v3xCommonI18N}'/>",  "javascript:editMtTemplate('ajaxMtMeetingManager', '${listType}');", [1,2], "", null));
</c:if>
	
//撤销
<c:if test="${listType=='listMyPublishToOpenMeeting' || listType=='listMyPublishMeeting' || listType=='listNoticeMeeting'}">
	myBar.add(new WebFXMenuButton("convoked", "<fmt:message key='common.toolbar.cancel.label' bundle='${v3xCommonI18N}'/>",  "javascript:deleteMtRecord('${mtMeetingURL}?method=delete&listMethod=listMyMeeting&listType=${listType}', 'cancel');", [3,8], "", null));
</c:if>	
	
//归档
<c:set value="false" var="pigeonholeBtnFlag" />
<% if(!com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEFT) { %>
	<c:set value="true" var="pigeonholeBtnFlag" />
<% } %>
<c:if test="${hasDocPlug && (listType=='listMyPublishOpenedMeeting' || ((listType=='listMyJoinOpenedMeeting' || listType=='listOpenedMeeting') && pigeonholeBtnFlag))}">
	if(v3x.getBrowserFlag('hideMenu')){
		myBar.add(new WebFXMenuButton("pigeonholeBtn", "<fmt:message key='common.toolbar.pigeonhole.label' bundle='${v3xCommonI18N}' />", "mtPigeonhole('<%=com.seeyon.v3x.common.constants.ApplicationCategoryEnum.meeting.key()%>', '${listType}', 'listMyMeeting','2102');", [1,9], "", null));
	}
</c:if>

//删除
<c:if test="${listType=='listMyPublishOpenedMeeting' || listType=='listMyJoinOpenedMeeting' || listType=='listOpenedMeeting' || listType=='listDraftNoticeMeeting' || listType=='listNoticeMeeting' || listType=='listLeaderOpenedMeeting'}">
	myBar.add(new WebFXMenuButton("convoked", "<fmt:message key='mt.list.toolbar.delete.label'/>",  "javascript:deleteMtRecord('${mtMeetingURL}?method=delete&listMethod=listMyMeeting&listType=${listType}', 'delete')", [1,3], "", null));
</c:if>
	
//阅读授权
<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEADER) { %>
	<c:if test="${listType=='listMyPublishToOpenMeeting' || listType=='listMyPublishOpenedMeeting' || listType=='listMyPublishMeeting' || listType=='listNoticeMeeting'}">
		myBar.add(new WebFXMenuButton("convoked", "<fmt:message key='mt.list.toolbar.readright'/>", "javascript:selectLookLeader();", [4,3], "", null));	
	</c:if>
<% } %>

function summaryMeeting(){
	var id=getSelectId();
	if(id==''){
		alert(v3x.getMessage("meetingLang.choose_item_from_list"));
		return;
	}else if(validateCheckbox("id")>1){
		alert(v3x.getMessage("meetingLang.please_choose_one_date"));
		return;
	}
	parent.location.href='${mtSummaryTemplateURL}?method='+'edit'+'&id='+id;
}
	

function showMeetingList() {
	location.href='mtMeeting.do?method=listMyMeeting&listType=${listType}';
}	
	
function editMeeting(id){
	if(userInternalID==createUserIdTable.items(id)){
		<%-- 已经开始的会议不允许修改，其他均允许修改 --%>
		if(!validateCanEdit(id, "ajaxMtMeetingManager")) {
			alert(v3x.getMessage("meetingLang.meeting_begin_cannot_edit"));
			if('${param.stateStr}' == '10' || '${param.stateStr}' == '')
				parent.getA8Top().reFlesh();
			return;
		}
		//parent.location.href=baseUrl+'edit'+'&id='+id+'&flag=editMeeting';
		location.href=baseUrl+'edit'+'&id='+id+'&flag=editMeeting&listType=${listType}';
	}else{
		alert(v3x.getMessage("meetingLang.you_not_creater"));
		return;
	}
}
	
function meetingToCol(){
	var id=getSelectId();
	if(id==''){
		alert(v3x.getMessage("meetingLang.choose_item_from_list"));
		return;
	}else if(validateCheckbox("id")>1){
		alert(v3x.getMessage("meetingLang.please_choose_one_date"));
		return;
	}
	parent.parent.location.href='${mtMeetingURL}?method='+'meetingToCol'+'&id='+id;
}
	
function summaryToCol(){
	var id=getSelectId();
	if(id==''){
		alert(v3x.getMessage("meetingLang.choose_item_from_list"));
		return;
	}else if(validateCheckbox("id")>1){
		alert(v3x.getMessage("meetingLang.please_choose_one_date"));
		return;
	}
	if(ht.items(id)==40){
		parent.parent.location.href='${mtMeetingURL}?method='+'summaryToCol'+'&id='+id;
	}else{
		alert(v3x.getMessage("meetingLang.meeting_no_summary"));
		return;
	}
}

//文章页面弹出窗口
function openWin(url){
	var rv = v3x.openWindow({
       url: url,
       dialogType: "open"
    });
}

function setSearchPeopleFields(elements, namesId, valueId) {
	document.getElementById(valueId).value = getIdsString(elements, false);
	document.getElementById(namesId).value = getNamesString(elements);
	document.getElementById(namesId).title = getNamesString(elements);
}
	
function showReplyLog(id) {
		var myUrl = baseUrl+"listMtLookRecordIframe&id="+id;//xiangfan 修改为listMtLookRecordIframe，先请求到框架层，修复GOV-2355，翻页时弹出新窗口的问题
		//mark by xuqiangwei Chrome37修改，这里应该被废弃了
		var rv = v3x.openWindow({
        url: myUrl,
        dialogType : "modal",
        width: 500,
        height: 400
    });
}
	
function selectLookLeader() {
	var ids = document.getElementsByName('id');
	var id = '';
	var mIds = [];
	var len = 0;
	var flag = false;
	var mName = "";
	var meetingId = "";
	for(var i=0;i<ids.length;i++){
		var idCheckBox=ids[i];
		if(idCheckBox.checked){
			//只有创建者可以删除会议
			mIds[len] = idCheckBox.value;
			len++;
			if(idCheckBox.roomState == 0) {
					mName += idCheckBox.mName+",";
			}else if(idCheckBox.roomState == 2){
				alert("《" + idCheckBox.mName + "》" + "审核未通过，无法阅权授予！");
				return ;
			}
			meetingId = idCheckBox.value;
		}
	}
	if(len==0){
		alert(v3x.getMessage("meetingLang.choose_item_from_list"));
		return;
	}
	if(mName!="") {
		alert(_("meetingLang.alert_no_mt_room_leadLookRole", mName.substring(0, mName.length-1)));
		return;	
	}
	
   	var returnValue = openLeader(meetingId,len);
    if(returnValue != null) {
    	var myForm = document.createElement("form");
    	document.appendChild(myForm);
    	myForm.action = "${controller}";
    	for(var i=0; i<mIds.length; i++) {
    		myForm.innerHTML += "<input type='hidden' name='meetingIds' value='"+mIds[i]+"'/>";
    	}	    	
    	myForm.innerHTML += "<input type='hidden' name='method' value='saveMeetingLeader'/><input type='hidden' name='userIds' value='"+returnValue[0]+"'/><input type='hidden' name='userNames' value='"+returnValue[1]+"'/><input type='hidden' name='listType' value='${param.listType}'/>";
     	myForm.submit();
    }
}

function openLeader(meetingId,len){
	var approves = document.getElementById("approves").value;
	var url = "mtAppMeetingController.do?method=openLeader&fromType=2&type=hytz&ndate="+new Date();
	if(len == 1){
		url += "&approves="+document.getElementById("approves_"+meetingId).value;
	}
	//mark by xuqiangwei Chrome37修改，这里应该被废弃了
	var retObj = v3x.openWindow({
        url: url,
        dialogType : v3x.getBrowserFlag('openWindow') == true ? "modal" : "1",
        width: "500",
        height: "370"
    });	    
	return retObj;
}

function search_result(){
	var beginDate = document.getElementById("fromDate").value;
	var endDate = document.getElementById("toDate").value;
	if(compareDate(beginDate,endDate)>0){
		alert("开始时间不能大于结束时间！");
		return ;
	}
	doSearch();
}

function ChangedEvent(obj){
	var beginDate = document.getElementById("fromDate");
	var endDate = document.getElementById("toDate");
	if(beginDate != null && endDate != null){
		beginDate.value = "";
		endDate.value = "";
	}
	showNextCondition(obj);
}

function summaryCreate(meetingId, recordId) {
	location.href = "mtSummary.do?method=createSummary&meetingId="+meetingId+"&id="+recordId;
}

//-->
</script>
</head>
<body onload="" class="page_color">
<div class="main_div_row2">
<div class="right_div_row2">
<div class="top_div_row2">
<input type="hidden" id="type" value="2"/>
<input type="hidden" id="approves"/>
<input type="hidden" id="approvesNames"/>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td class="webfx-menu-bar">
		<script type="text/javascript">
			document.write(myBar);	
		</script>
	</td>
	<td class="webfx-menu-bar">
		<form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
			<input type="hidden" value="<c:out value='${param.method}' />" name="method">
			<input type="hidden" value="${listType}" name="listType" />
			<input type="hidden" value="${videoConfStatus}" name="videoConfStatus" id="videoConfStatus"/>
			<div class="div-float-right condition-search-div">
				<div class="div-float" style="height:30px;">
					<select  style="vertical-align:middle;" name="condition" id="condition" onChange="ChangedEvent(this);" class="condition">
						<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
						
						<option value="title"><fmt:message key="mt.list.column.mt_name" /></option>
						
						<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) { %>
							<option value="meetingTypeId"><fmt:message key="mt.list.column.mt_type" /></option>
						<% } %>
						
						<c:if test="${listType=='listMyPublishOpenedMeeting'}">
							<option value="state"><fmt:message key="mt.mtMeeting.state" /></option>
						</c:if>
						
						<c:if test="${(listType=='listMyJoinMeeting' || listType=='listMyJoinToOpenMeeting' || listType=='listMyJoinOpenedMeeting') || (listType=='listToOpenMeeting' || listType=='listOpenedMeeting') || (listType=='listLeaderMeeting' || listType=='listLeaderToOpenMeeting' || listType=='listLeaderOpenedMeeting') }">
							<option value="createUser"><fmt:message key='mt.mtMeeting.createUser' /></option>
							<option value="sendDept"><fmt:message key='mt.senddept' /></option>
						</c:if>
						
						<option value="createDate"><fmt:message key="mt.searchdate" /></option>
						
						<c:if test="${listType=='listNoticeMeeting'}">
							<option value="room"><fmt:message key="mt.mtMeeting.place" /></option>
						</c:if>
						
						<!-- 视频会议 -->
						<%if(com.seeyon.ctp.common.SystemEnvironment.hasPlugin("videoconference")){ %>
							<option value="meetingNature"><fmt:message key="mt.mtMeeting.meetingNature" /></option>
						<%}%>
						
						<!-- 会议纪要 -->
						<c:if test="${listType=='listOpenedMeeting' }">
							<option value="meetingSummary"><fmt:message key="meeting.summary.record.publish"  bundle="${v3xMeetingSummaryI18N}"/></option>
						</c:if>
						
					</select>
				</div>

				<div id="titleDiv" class="div-float hidden">
					<input type="text" name="textfield" class="textfield">
				</div>
				
				<c:if test="${(listType=='listMyJoinMeeting' || listType=='listMyJoinToOpenMeeting' || listType=='listMyJoinOpenedMeeting') || (listType=='listToOpenMeeting' || listType=='listOpenedMeeting') || (listType=='listLeaderMeeting' || listType=='listLeaderToOpenMeeting' || listType=='listLeaderOpenedMeeting') }">
					<v3x:selectPeople id="createUser" panels="Department,Team" selectType="Member" departmentId="${currentUser.departmentId}" jsFunction="setSearchPeopleFields(elements, 'createUserName', 'createUserId')" minSize="0" maxSize="1" />
					<v3x:selectPeople id="sendDept" panels="Department" selectType="Department" jsFunction="setSearchPeopleFields(elements, 'sendDeptName', 'sendDeptId')" minSize="0" maxSize="1"/>
					<div id="createUserDiv" class="div-float hidden">
						<input type="text" name="textfield" id="createUserName" class="textfield" readonly="true" onclick="selectPeopleFun_createUser('textfield', 'textfield1')" />
						<input type="hidden" name="textfield1" id="createUserId" />
					</div>
					<div id="sendDeptDiv" class="div-float hidden">
						<input type="text" name="textfield" id="sendDeptName" class="textfield" readonly="true" onclick="selectPeopleFun_sendDept('textfield', 'textfield1')" />
						<input type="hidden" name="textfield1" id="sendDeptId" />
					</div>
				</c:if>
			
				<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) { %>
					<div id="meetingTypeIdDiv" class="div-float hidden">
						<select name="textfield" id="textfield" class="textfield">
							<c:forEach var="meetingType" items="${typeList}"> 
								 <option value="${meetingType.id}">${meetingType.name}</option>
							</c:forEach>
						</select>
					</div>
				<% } %>
			
				<c:if test="${listType=='listMyPublishOpenedMeeting'}">
					<div id="stateDiv" class="div-float hidden">
						<select name="textfield" id="textfield" class="textfield">
							<option value="20"><fmt:message key="mt.mtMeeting.state.20" /></option>
							<option value="30"><fmt:message key="mt.mtMeeting.state.30" /></option>
						</select>
					</div>
				</c:if> 

				<div id="createDateDiv" class="div-float hidden">
					<input type="text" name="textfield" id="fromDate" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly> 
						- 
					<input type="text" name="textfield1" id="toDate" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
				</div>
				
				<c:if test="${listType=='listNoticeMeeting'}">
					<div id="roomDiv" class="div-float hidden"><%--xiangfan修改，需求确认：改为输入的方式 GOV-3717--%>
						<input type="text" name="textfield" id="textfield" class="textfield" />
					</div>
				</c:if>
				
				<c:if test="${listType=='listOpenedMeeting' }">
					<div id="meetingSummaryDiv" class="div-float hidden">
					    <select name="textfield" id="textfield" class="textfield">
							  <option value="1">新建纪要</option>
					          <option value="2">查看纪要</option>
						</select>
					</div>
				</c:if>
				
				<!-- 视频会议  -->
				<%if(com.seeyon.ctp.common.SystemEnvironment.hasPlugin("videoconference")){ %>
					<div id="meetingNatureDiv" class="div-float hidden">
					    <select name="textfield" id="textfield" class="textfield">
							  <option value="1"><fmt:message key="mt.mtMeeting.label.ordinary" /></option>
					          <option value="2"><fmt:message key="mt.mtMeeting.label.video" /></option>
						</select>
					</div>
				<%}%>
				
				<div onclick="search_result();" class="condition-search-button div-float"></div>
			</div>
		</form>
	</td>
</tr>
</table>
</div>

<div class="center_div_row2" id="scrollListDiv">

<form id="listForm">

<v3x:table htmlId="listTable" data="list" var="bean" leastSize="0">

	<c:choose>
		<c:when test="${bean.proxy}">
			<c:set value="1" var="proxy" />
			<c:set value="${bean.proxyId}" var="proxyId" />
		</c:when>
		<c:otherwise>
			<c:set value="0" var="proxy" />
			<c:set value="-1" var="proxyId" />
		</c:otherwise>
	</c:choose>

	<c:choose>
		<c:when test="${(v3x:currentUser().id!=bean.createUser || bean.proxy) && (listType=='listMyJoinToOpenMeeting'||listType=='listToOpenMeeting'||listType=='listLeaderToOpenMeeting'||listType=='listLeaderMeeting')}">
			<c:set value="disabled" var="disabled" />
		</c:when>
		<c:otherwise>
			<c:set value="" var="disabled" />
		</c:otherwise>
	</c:choose>

	<c:choose>
		<c:when test="${bean.accountId!=v3x:currentUser().accountId}">
			<c:set value="(${v3x:showOrgEntitiesOfIds(bean.accountId,'Account',pageContext)})" var="createAccountName" />
		</c:when>
		<c:otherwise>
			<c:set value="" var="createAccountName" />
		</c:otherwise>
	</c:choose>

	<c:set value="displayMyDetail('${bean.id}','${proxy}','${proxyId}', 0);" var="click" />
	<c:choose>
		<c:when test="${(bean.state==0||bean.state==10||bean.state==20) && CurrentUser.id==bean.createUser && (listType=='listDraftNoticeMeeting'||listType=='listNoticeMeeting')}">
			<c:set value="editMeeting('${bean.id}');" var="dbClick" />
		</c:when>
		<c:otherwise>
			<c:set value="displayMyDetail('${bean.id}','${proxy}','${proxyId}', 1);" var="dbClick" />
		</c:otherwise>
	</c:choose>

	<c:set value="proxy-${bean.proxy}" var="proxyClass"></c:set>

	<c:choose>
	
	<%---------------- 会议管理-会议通知/草稿箱 -------------------%>
	<c:when test="${listType=='listNoticeMeeting' || listType=='listDraftNoticeMeeting'}">
		<%------------- 复选框 -----------------%>
		<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
			<input type='checkbox' name='id' attFlag="${bean.hasAttachments}" mName="${bean.title}" state="${bean.state}" roomState="${bean.roomState}" recordState="${bean.recordState }" value="<c:out value="${bean.id}"/>" ${disabled} />
			<!-- 保存阅权授予的人员的id,当只将一个会议进行授予时，可以回显已经授予的人员  -->
			<input type="hidden" name="approves" id="approves_${bean.id }" value="${bean.lookLeaders }"/>
		</v3x:column>
		<%------------- 标题 -----------------%>
		<v3x:column width="${listType=='listNoticeMeeting'?48:63 }%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.list.column.mt_name" className="cursor-hand sort" bodyType="${bean.dataFormat}" hasAttachments="${bean.hasAttachments}" alt="${createAccountName}${bean.title}" maxLength="45" symbol="...">
		<c:choose>
		<c:when test="${bean.roomState==2}"><%--会议室审核不通过名称标红 --%>
			<font color="red">${createAccountName}${v3x:toHTML(bean.title)}</font>
		</c:when>
		<c:otherwise>
			${createAccountName}${v3x:toHTML(bean.title)}
		</c:otherwise>
		</c:choose>
				<c:if test="${bean.meetingType eq  '2' }">
	                   <span class="bodyType_videoConf inline-block"></span>
	        	</c:if>
			<script type="text/javascript">
				ht.add('${bean.id}','${bean.state}');
				createUserIdTable.add('${bean.id}','${bean.createUser}');
			</script>
		</v3x:column>
		<%------------- 会议类型 -----------------%>
		<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) { %>
			<v3x:column width="${listType=='listNoticeMeeting'?8:12 }%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.list.column.mt_type" className="cursor-hand sort" value="${bean.mtType==null?'':bean.mtType.name}">
			</v3x:column>
		<% } %>
		<%------------- 会议开始时间 -----------------%>
		<v3x:column width="12%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.beginDate" className="cursor-hand sort">
			<fmt:formatDate pattern="${datePattern}" value="${bean.beginDate}" />
		</v3x:column>
		<%------------- 会议结束时间 -----------------%>
		<v3x:column width="12%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="common.date.endtime.label" className="cursor-hand sort">
			<fmt:formatDate pattern="${datePattern}" value="${bean.endDate}" />
		</v3x:column>
		
		
		<%------------- 会议室 -----------------%>
		<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETINGROOM_APP) { %>
			<v3x:column width="8%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.place" className="cursor-hand sort" >
				<c:if test="${empty bean.roomName}">
					<fmt:message key="mr.label.no"/>
				</c:if>
				<c:if test="${not empty bean.roomName}">
					${bean.roomName}
				</c:if>
			</v3x:column>
		<%} %>
			
		<c:if test="${listType=='listNoticeMeeting' }">
			<%------------- 发布情况 -----------------%>
			<v3x:column width="10%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.notice.desc" className="cursor-hand sort">
				<c:choose>
					<c:when test="${bean.roomState==2}">
						<font color="red"><fmt:message key="mt.room.state.nopass"/></font>
					</c:when>
					<c:when test="${bean.roomState==1 || bean.roomState==-2}"><%--通过和审核通过 都改成'已发布' --%>
						<fmt:message key="mt.meeting.publish"/>
					</c:when>
					<c:otherwise>
						<fmt:message key="mt.notice.state.auditing${bean.roomState}"/>
					</c:otherwise>
				</c:choose>
			</v3x:column>
			<%------------- 会议状态 -----------------%>
			<v3x:column width="5%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.list.column.mt_state" className="cursor-hand sort">
				<c:choose>
					<c:when test="${bean.state==10}">
						<fmt:message key="admin.label.mtNotStarted"/>
					</c:when>
					<c:when test="${bean.state==20}">
						<fmt:message key="mt.mtMeeting.state.20"/>
					</c:when>
					<c:when test="${bean.state==30 || bean.state==-10}">
						<fmt:message key="mt.mtMeeting.state.30"/>
					</c:when>
					<c:when test="${bean.state==40}">
						<fmt:message key="admin.label.mtzj"/>
					</c:when>
					<c:otherwise>
						<fmt:message key="mt.mtMeeting.state.${bean.state}"/>
					</c:otherwise>
				</c:choose>
			</v3x:column>
			<%------------- 领导查阅-----------------%>
			<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEADER ) { %>
				<v3x:column width="8%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="nt.notice.showLeaders" className="cursor-hand sort" value="${bean.lookLeaderNames}" maxLength="12" symbol="...">
				</v3x:column>
			<% } %>
		</c:if>
		
	</c:when>
	
	
	<%---------------- 我的会议-我发布的会议-------------------%>
	<c:when test="${listType=='listMyPublishToOpenMeeting' || listType=='listMyPublishOpenedMeeting' || listType=='listMyPublishMeeting'}">
		<%------------- 复选框 -----------------%>
		<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
			<input type='checkbox' name='id' attFlag="${bean.hasAttachments}" mName="${bean.title}" state="${bean.state}" roomState="${bean.roomState}" recordState="${bean.recordState }" value="<c:out value="${bean.id}"/>" ${disabled} />
			<!-- 保存阅权授予的人员的id,当只将一个会议进行授予时，可以回显已经授予的人员  -->
			<input type="hidden" name="approves" id="approves_${bean.id }" value="${bean.lookLeaders }"/>
		</v3x:column>
		<%------------- 标题 -----------------%>
		<v3x:column width="${listType=='listMyPublishOpenedMeeting'?26:30 }%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.list.column.mt_name" className="cursor-hand sort" bodyType="${bean.dataFormat}" hasAttachments="${bean.hasAttachments}" alt="${createAccountName}${bean.title}" maxLength="45" symbol="...">
			<c:choose>
				<c:when test="${bean.proxy}">
					<div class="link-blue">
					${createAccountName}${v3x:toHTML(bean.title)}
					<c:if test="${proxyId ne null }">
					  (<fmt:message key="mt.agent" />${v3x:showMemberName(bean.proxyId)})
					</c:if>
					</div>
				</c:when>
				<c:otherwise>
					${createAccountName}${v3x:toHTML(bean.title)}
				</c:otherwise>
			</c:choose>
				<c:if test="${bean.meetingType eq  '2' }">
	                   <span class="bodyType_videoConf inline-block"></span>
	        	</c:if>
			<script type="text/javascript">
				ht.add('${bean.id}','${bean.state}');
				createUserIdTable.add('${bean.id}','${bean.createUser}');
			</script>
		</v3x:column>
		<%------------- 会议类型 -----------------%>
		<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) { %>
			<v3x:column width="8%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.list.column.mt_type" className="cursor-hand sort" value="${bean.mtType==null?'':bean.mtType.name}">
			</v3x:column>
		<% } %>
		<%------------- 会议纪要 -----------------%>
		<c:if test="${listType=='listMyPublishOpenedMeeting' }">
			<v3x:column width="7%" type="String" label="mt.meetingrecord" className="cursor-hand sort">
				<c:choose>
					<c:when test="${bean.recordName==null || bean.recordName=='' }">
						<c:if test="${(CurrentUser.id==bean.recorderId) || (bean.recorderId==-1&&CurrentUser.id==bean.emceeId) }">
							<fmt:message key="mt.summary.create.lable"></fmt:message>
						</c:if>
					</c:when>
					<c:when test="${bean.mtSummaryState==4 || bean.mtSummaryState==6}">
						<a onclick="javascript:showMtSummary('${bean.recordId}', '${bean.id}', 1,'isYes', '${listType}')"><fmt:message key="mt.summary.view.lable"></fmt:message></a>
					</c:when>
					<c:otherwise>
						<fmt:message key="mr.label.no"></fmt:message>
					</c:otherwise>
				</c:choose>
			</v3x:column>		
		</c:if>
		<%------------- 会议开始时间 -----------------%>
		<v3x:column width="10%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.beginDate" className="cursor-hand sort">
			<fmt:formatDate pattern="${datePattern}" value="${bean.beginDate}" />
		</v3x:column>
		<%------------- 会议结束时间 -----------------%>
		<v3x:column width="10%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="common.date.endtime.label" className="cursor-hand sort">
			<fmt:formatDate pattern="${datePattern}" value="${bean.endDate}" />
		</v3x:column>
		<%------------- 会议室 -----------------%>
		<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETINGROOM_APP) { %>
			<v3x:column width="${listType=='listMyPublishOpenedMeeting'?6:8 }%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.place" className="cursor-hand sort" >
				<c:if test="${empty bean.roomName}">
					<fmt:message key="mr.label.no"/>
				</c:if>
				<c:if test="${not empty bean.roomName}">
					${bean.roomName}
				</c:if>
			</v3x:column>
		<%} %>
		<c:if test="${listType=='listMyPublishMeeting' || listType=='listMyPublishToOpenMeeting' }">
			<%------------- 会议状态 -----------------%>
			<v3x:column width="8%" type="String"  onClick="${click}" onDblClick="${dbClick }"  label="mt.mtMeeting.state" className="cursor-hand sort">
				<c:choose>
					<c:when test="${bean.state==10}">
						<fmt:message key="admin.label.mtNotStarted"/>
					</c:when>
					<c:when test="${bean.state==20}">
						<fmt:message key="mt.mtMeeting.state.20"/>
					</c:when>
					<c:when test="${bean.state==30 || bean.state==-10}">
						<fmt:message key="mt.mtMeeting.state.30"/>
					</c:when>
					<c:when test="${bean.state==40}">
						<fmt:message key="admin.label.mtzj"/>
					</c:when>
					<c:otherwise>
						<fmt:message key="mt.mtMeeting.state.${bean.state}"/>
					</c:otherwise>
				</c:choose>
			</v3x:column>
		</c:if>
		<%------------- 回执信息 -----------------%>
		<v3x:column width="${listType=='listMyPublishOpenedMeeting'?8:8 }%" type="String" label="mt.replyinfo" className="cursor-hand sort">
			<a onclick="javascript:showReplyLog('${bean.id}')"><fmt:message key="mt.showlog"/></a>
		</v3x:column>
		<%------------- 领导查阅-----------------%>
		<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_LEADER) { %>
			<v3x:column width="${listType=='listMyPublishOpenedMeeting'?8:12 }%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="nt.notice.showLeaders" className="cursor-hand sort" value="${bean.lookLeaderNames}" maxLength="12" symbol="...">
			</v3x:column>
		<% } %>
		<c:if test="${listType=='listMyPublishOpenedMeeting' }">
			<%------------- 会议状态 -----------------%>
			<v3x:column width="6%" type="String"  onClick="${click}" label="mt.mtMeeting.state" className="cursor-hand sort">
				<c:choose>
					<c:when test="${bean.state==10}">
						<fmt:message key="admin.label.mtNotStarted"/>
					</c:when>
					<c:when test="${bean.state==20}">
						<fmt:message key="mt.mtMeeting.state.20"/>
					</c:when>
					<c:when test="${bean.state==30 || bean.state==-10}">
						<fmt:message key="mt.mtMeeting.state.30"/>
					</c:when>
					<c:when test="${bean.state==40}">
						<fmt:message key="admin.label.mtzj"/>
					</c:when>
					<c:otherwise>
						<fmt:message key="mt.mtMeeting.state.${bean.state}"/>
					</c:otherwise>
				</c:choose>
			</v3x:column>
			<%------------- 归档-----------------%>
			<v3x:column width="6%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.notice.state.pigeonhole" className="cursor-hand sort">
				<fmt:message key="${bean.state==-10?'mt.mtMeeting.state.-10':'mt.notice.state.pigeonhole.not'}"/>
			</v3x:column>
		</c:if>
	</c:when>
	
	
	<%---------------- 我的会议-我参加的会议 /会议查看 -------------------%>
	<c:when test="${(listType=='listMyJoinMeeting' || listType=='listMyJoinToOpenMeeting' || listType=='listMyJoinOpenedMeeting')||(listType=='listToOpenMeeting' || listType=='listOpenedMeeting')}">
		<c:if test="${listType=='listMyJoinOpenedMeeting' || listType=='listOpenedMeeting' }">
			<%------------- 复选框 -----------------%>
			<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' attFlag="${bean.hasAttachments}" mName="${bean.title}" state="${bean.state}" roomState="${bean.roomState}" recordState="${bean.recordState }" value="<c:out value="${bean.id}"/>" ${disabled} />
				<!-- 保存阅权授予的人员的id,当只将一个会议进行授予时，可以回显已经授予的人员  -->
				<input type="hidden" name="approves" id="approves_${bean.id }" value="${bean.lookLeaders }"/>
			</v3x:column>
		</c:if>
		<%------------- 标题 -----------------%>
		<v3x:column width="${listType=='listToOpenMeeting'?53:31 }%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.list.column.mt_name" className="cursor-hand sort ${bean.state==10?(proxyClass):''}" bodyType="${bean.dataFormat}" hasAttachments="${bean.hasAttachments}" alt="${createAccountName}${bean.title}" maxLength="45" symbol="...">
			<c:choose>
				<c:when test="${bean.proxy}">
					${createAccountName}${v3x:toHTML(bean.title)}
					<c:if test="${proxyId ne null }">
					  (<fmt:message key="mt.agent" />${v3x:showMemberName(bean.proxyId)})
					</c:if>
				</c:when>
				<c:otherwise>
					${createAccountName}${v3x:toHTML(bean.title)}
				</c:otherwise>
			</c:choose>
				<c:if test="${bean.meetingType eq  '2' }">
	                   <span class="bodyType_videoConf inline-block"></span>
	        	</c:if>
			<script type="text/javascript">
				ht.add('${bean.id}','${bean.state}');
				createUserIdTable.add('${bean.id}','${bean.createUser}');
			</script>
		</v3x:column>
		<%------------- 发起人 -----------------%>
		<v3x:column width="8%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.createUser" className="cursor-hand sort">
			${v3x:showMemberName(bean.createUser)}
		</v3x:column>
		<c:set var="m" value="${v3x:getMember(bean.createUser)}" />
		<%------------- 发起部门 -----------------%>
		<v3x:column width="9%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.senddept" className="cursor-hand sort" value="${v3x:getDepartment(v3x:getMember(bean.createUser).orgDepartmentId).name}">
		</v3x:column>
		<%------------- 会议类型 -----------------%>
		<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) { %>
			<v3x:column width="8%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.list.column.mt_type" className="cursor-hand sort" value="${bean.mtType==null?'':bean.mtType.name}">
			</v3x:column>
		<% } %>
		<%------------- 会议纪要 -----------------%>
		<c:if test="${listType=='listMyJoinOpenedMeeting' || listType=='listOpenedMeeting'}">
			<v3x:column width="6%" type="String" label="mt.meetingrecord" className="cursor-hand sort">
				<c:choose>
					<c:when test="${bean.recordName==null || bean.recordName=='' }">
						<c:if test="${(CurrentUser.id==bean.recorderId) || (bean.recorderId==-1&&CurrentUser.id==bean.emceeId) }">
							<a href="javascript:summaryCreate('${bean.id }', '${bean.recordId }')"><fmt:message key="mt.summary.create.lable"></fmt:message></a>
						</c:if>
					</c:when>
					<c:when test="${bean.mtSummaryState==4 || bean.mtSummaryState==6}"><%-- xiangfan 添加 修复GOV-2376，只有审核通过或直接发布才能查看会议纪要 --%>
						<a onclick="javascript:showMtSummary('${bean.recordId}', '${bean.id}', 1,'isYes', '${listType}')"><fmt:message key="mt.summary.view.lable"></fmt:message></a>
					</c:when>
					<c:otherwise></c:otherwise>
				</c:choose>
			</v3x:column>	
		</c:if>
		<%------------- 会议开始时间 -----------------%>
		<v3x:column width="11%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.beginDate" className="cursor-hand sort">
			<fmt:formatDate pattern="${datePattern}" value="${bean.beginDate}" />
		</v3x:column>
		<%------------- 会议结束时间 -----------------%>
		<v3x:column width="11%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="common.date.endtime.label" className="cursor-hand sort">
			<fmt:formatDate pattern="${datePattern}" value="${bean.endDate}" />
		</v3x:column>
		<%------------- 会议室 -----------------%>
		<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETINGROOM_APP) { %>
			<v3x:column width="8%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.place" className="cursor-hand sort" >
				<c:if test="${empty bean.roomName}"></c:if>
				<c:if test="${not empty bean.roomName}">
					${bean.roomName}
				</c:if>
			</v3x:column>
		<%} %>
		<c:if test="${listType=='listMyJoinOpenedMeeting' || listType=='listOpenedMeeting'}">
			<%------------- 会议状态 -----------------%>
			<v3x:column width="6%" type="String"  onClick="${click}"onDblClick="${dbClick }"  label="mt.mtMeeting.state" className="cursor-hand sort">
				<c:choose>
					<c:when test="${bean.state==10}">
						<fmt:message key="admin.label.mtNotStarted"/>
					</c:when>
					<c:when test="${bean.state==20}">
						<fmt:message key="mt.mtMeeting.state.20"/>
					</c:when>
					<c:when test="${bean.state==30 || bean.state==-10}">
						<fmt:message key="mt.mtMeeting.state.30"/>
					</c:when>
					<c:when test="${bean.state==40}">
						<fmt:message key="admin.label.mtzj"/>
					</c:when>
					<c:otherwise>
						<fmt:message key="mt.mtMeeting.state.${bean.state}"/>
					</c:otherwise>
				</c:choose>
			</v3x:column>
		</c:if>
		<% if(!com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_APP) { %>
			<c:if test="${listType=='listMyJoinOpenedMeeting' || listType=='listOpenedMeeting'}">
				<%------------- 归档-----------------%>
				<v3x:column width="6%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.notice.state.pigeonhole" className="cursor-hand sort">
					<fmt:message key="${bean.state==-10?'mt.mtMeeting.state.-10':'mt.notice.state.pigeonhole.not'}"/>
				</v3x:column>
			</c:if>
		<% }%>
	</c:when>
	
	
	<%---------------- 领导查看会议 -------------------%>
	<c:when test="${listType=='listLeaderToOpenMeeting' || listType=='listLeaderOpenedMeeting'}">
		<c:if test="${listType=='listLeaderOpenedMeeting' }">
			<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' attFlag="${bean.hasAttachments}" mName="${bean.title}" state="${bean.state}" roomState="${bean.roomState}" recordState="${bean.recordState }" value="<c:out value="${bean.id}"/>" ${disabled} />
				<!-- 保存阅权授予的人员的id,当只将一个会议进行授予时，可以回显已经授予的人员  -->
				<input type="hidden" name="approves" id="approves_${bean.id }" value="${bean.lookLeaders }"/>
			</v3x:column>
		</c:if>
		<%------------- 标题 -----------------%>
		<v3x:column width="${listType=='listLeaderOpenedMeeting'?25:46 }%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.list.column.mt_name" className="cursor-hand sort ${bean.state==10?(proxyClass):''}" bodyType="${bean.dataFormat}" hasAttachments="${bean.hasAttachments}" alt="${createAccountName}${bean.title}" maxLength="45" symbol="...">
			<c:choose>
				<c:when test="${bean.proxy}">
					${createAccountName}${v3x:toHTML(bean.title)}
					<c:if test="${proxyId ne null }">
					  (<fmt:message key="mt.agent" />${v3x:showMemberName(bean.proxyId)})
					</c:if>
				</c:when>
				<c:otherwise>
					${createAccountName}${v3x:toHTML(bean.title)}
				</c:otherwise>
			</c:choose>
				<c:if test="${bean.meetingType eq  '2' }">
	                   <span class="bodyType_videoConf inline-block"></span>
	        	</c:if>
			<script type="text/javascript">
				ht.add('${bean.id}','${bean.state}');
				createUserIdTable.add('${bean.id}','${bean.createUser}');
			</script>
		</v3x:column>
		<%------------- 发起人 -----------------%>
		<v3x:column width="8%" type="String"  onClick="${click}" label="mt.mtMeeting.createUser" className="cursor-hand sort">
			${v3x:showMemberName(bean.createUser)}
		</v3x:column>
		<c:set var="m" value="${v3x:getMember(bean.createUser)}" />
		<%------------- 发起部门 -----------------%>
		<v3x:column width="10%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.senddept" className="cursor-hand sort" value="${v3x:getDepartment(v3x:getMember(bean.createUser).orgDepartmentId).name}">
		</v3x:column>
		<%------------- 会议类型 -----------------%>
		<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) { %>
		<v3x:column width="8%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.list.column.mt_type" className="cursor-hand sort" value="${bean.mtType==null?'':bean.mtType.name}">
		</v3x:column>
		<% } %>
		<%------------- 会议纪要 -----------------%>
		<c:if test="${listType=='listLeaderOpenedMeeting' }">
			<v3x:column width="7%" type="String" label="mt.meetingrecord" className="cursor-hand sort">
				<c:choose>
					<c:when test="${bean.recordName==null || bean.recordName=='' }">
						<c:if test="${CurrentUser.id==bean.recorderId }">
							<fmt:message key="mt.summary.create.lable"></fmt:message>
						</c:if>
					</c:when>
					<c:otherwise>
						<a onclick="javascript:showMtSummary('${bean.recordId}', '${bean.id}', 1,'isYes', '${listType}')"><fmt:message key="mt.meeting.summary.show"></fmt:message></a>
					</c:otherwise>
				</c:choose>
			</v3x:column>	
		</c:if>
		<%------------- 会议开始时间 -----------------%>
		<v3x:column width="11%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.beginDate" className="cursor-hand sort">
			<fmt:formatDate pattern="${datePattern}" value="${bean.beginDate}" />
		</v3x:column>
		<%------------- 会议结束时间 -----------------%>
		<v3x:column width="11%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="common.date.endtime.label" className="cursor-hand sort">
			<fmt:formatDate pattern="${datePattern}" value="${bean.endDate}" />
		</v3x:column>
		<%------------- 会议室 -----------------%>
		<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETINGROOM_APP) { %>
			<v3x:column width="8%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.place" className="cursor-hand sort" >
				<c:if test="${empty bean.roomName}"></c:if>
				<c:if test="${not empty bean.roomName}">
					${bean.roomName}
				</c:if>
			</v3x:column>
		<% } %>
		<c:if test="${listType=='listLeaderOpenedMeeting' }">
			<%------------- 会议状态 -----------------%>
			<v3x:column width="6%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.state" className="cursor-hand sort">
				<c:choose>
					<c:when test="${bean.state==10}">
						<fmt:message key="admin.label.mtNotStarted"/>
					</c:when>
					<c:when test="${bean.state==20}">
						<fmt:message key="mt.mtMeeting.state.20"/>
					</c:when>
					<c:when test="${bean.state==30 || bean.state==-10}">
						<fmt:message key="mt.mtMeeting.state.30"/>
					</c:when>
					<c:when test="${bean.state==40}">
						<fmt:message key="admin.label.mtzj"/>
					</c:when>
					<c:otherwise>
						<fmt:message key="mt.mtMeeting.state.${bean.state}"/>
					</c:otherwise>
				</c:choose>
			</v3x:column>
		</c:if>		
	</c:when>
	
</c:choose>
	
</v3x:table>
</form>
</div>
</div>
</div>

<%--
<%@ include file="../../doc/pigeonholeHeader.jsp"%>
//TODO
 --%>
<jsp:include page="../include/deal_exception.jsp" />

<script type="text/javascript">
<!--	
	previewFrame('Down');
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='mt.mtMeeting' /><fmt:message key='mt.list' />", [1,5], pageQueryMap.get('count'), _("meetingLang.detail_info_603_1"));	
	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	initIpadScroll("scrollListDiv",550,870);
//-->
</script>

</body>
</html>