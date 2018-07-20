<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.meeting.manager.MtMeetingManagerImpl"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/meetingsummary/js/meetingsummary.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
	try {
		//getA8Top().endProc('');
	} catch(e) {
	}
	var listType = '${param.listType == null ? listType : param.listType}';
	
	var userInternalID = "${sessionScope['com.seeyon.current_user'].id}";
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	if('all' == listType){//全部
		//getA8Top().showLocation(2104,"<fmt:message key='mtSummary.publish.lable'  bundle="${v3xMeetingSummaryI18N}"/>", "<fmt:message key='mtSummary.tree.all.lable' bundle='${v3xMeetingSummaryI18N}'/>");
		myBar.add( new WebFXMenuButton("newBtn1", "<fmt:message key='common.toolbar.edit.label'  bundle='${v3xCommonI18N}' />", "edit();", [1,2], "", null));
		myBar.add( new WebFXMenuButton("newBtn1", "<fmt:message key='common.toolbar.cancel.label'  bundle='${v3xCommonI18N}' />", "cancelMyPublish('all');", [3,8], "", null));
		/*puyc 修改 2012-2-9*/
		myBar.add( new WebFXMenuButton("delBtn", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "deleteMyMtSummary('all');", [1,3], "", null));
		//myBar.add( new WebFXMenuButton("newBtn1", "<fmt:message key='common.toolbar.transmit.label'  bundle='${v3xCommonI18N}' />", "parent.location.href='${mtMeetingURL}?method=create&formOper=new';", [1,1], "", null));
		/*
		var transmit = new WebFXMenu;
		transmit.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.transmit.col.label' bundle='${v3xCommonI18N}' />", "summaryTransmit(1)", ""));
        <c:if test="${isEdocCreateRole}">
		transmit.add(new WebFXMenuItem("", "<fmt:message key='mtSummary.toolbar.transmit.edoc.label' bundle='${v3xMeetingSummaryI18N}'/>", "summaryTransmit(2)", ""));
        </c:if>
		if(transmit.hasChild()&&v3x.getBrowserFlag('hideMenu')){
			myBar.add(new WebFXMenuButton("transmit", "<fmt:message key='common.toolbar.transmit.label' bundle='${v3xCommonI18N}' />", null, [1,7], "", transmit));
		}
		myBar.add( new WebFXMenuButton("delBtn", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "deleteMyMtSummary('all');", [1,3], "", null));
         */
    }else if('waitAudit' == listType){//待审核
    	//getA8Top().showLocation(2104,"<fmt:message key='mtSummary.publish.lable'  bundle="${v3xMeetingSummaryI18N}"/>", "<fmt:message key='mtSummary.tree.waitAudit.lable' bundle='${v3xMeetingSummaryI18N}'/>");
		myBar.add( new WebFXMenuButton("newBtn1", "<fmt:message key='common.toolbar.edit.label'  bundle='${v3xCommonI18N}' />", "edit();", [1,2], "", null));
		myBar.add( new WebFXMenuButton("newBtn1", "<fmt:message key='common.toolbar.cancel.label'  bundle='${v3xCommonI18N}' />", "cancelMyPublish('waitAudit');", [3,8], "", null));
	}else if('listMeetingSummaryPublishPassed' == listType){//审核通过
		//getA8Top().showLocation(2104,"<fmt:message key='mtSummary.publish.lable'  bundle="${v3xMeetingSummaryI18N}"/>", "<fmt:message key='mtSummary.tree.passed.lable' bundle='${v3xMeetingSummaryI18N}'/>");
		//myBar.add( new WebFXMenuButton("newBtn1", "<fmt:message key='common.toolbar.transmit.label'  bundle='${v3xCommonI18N}' />", "parent.location.href='${mtMeetingURL}?method=create&formOper=new';", [1,1], "", null));
		myBar.add(new WebFXMenuButton("newBtn1", "<fmt:message key='common.toolbar.edit.label'  bundle='${v3xCommonI18N}' />", "edit();", [1,2], "", null));
		myBar.add( new WebFXMenuButton("newBtn1", "<fmt:message key='common.toolbar.cancel.label'  bundle='${v3xCommonI18N}' />", "cancelMyPublish('passed');", [3,8], "", null));
		var transmit = new WebFXMenu;
		<c:if test="${hasColPlug}">
		transmit.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.transmit.col.label' bundle='${v3xCommonI18N}' />", "summaryTransmit(1)", ""));
		</c:if>
		<c:if test="${isEdocCreateRole && hasEdocPlug}">
		transmit.add(new WebFXMenuItem("", "<fmt:message key='mtSummary.toolbar.transmit.edoc.label' bundle='${v3xMeetingSummaryI18N}'/>", "summaryTransmit(2)", ""));
		</c:if>
		if(transmit.hasChild()&&v3x.getBrowserFlag('hideMenu')){
			myBar.add(new WebFXMenuButton("transmit", "<fmt:message key='common.toolbar.transmit.label' bundle='${v3xCommonI18N}' />", null, [1,7], "", transmit));
		}
	}else if('notPassed' == listType){//审核未通过
		//getA8Top().showLocation(2104,"<fmt:message key='mtSummary.publish.lable'  bundle="${v3xMeetingSummaryI18N}"/>", "<fmt:message key='mtSummary.tree.notpassed.lable' bundle='${v3xMeetingSummaryI18N}'/>");
		myBar.add( new WebFXMenuButton("newBtn1", "<fmt:message key='common.toolbar.edit.label'  bundle='${v3xCommonI18N}' />", "edit();", [1,2], "", null));
		myBar.add( new WebFXMenuButton("delBtn", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "deleteMyMtSummary('notPassed');", [1,3], "", null));
	}else{//草稿箱
		//getA8Top().showLocation(2104,"<fmt:message key='mtSummary.create.lable'  bundle="${v3xMeetingSummaryI18N}"/>", "<fmt:message key='mtSummary.tree.draftbox.lable' bundle='${v3xMeetingSummaryI18N}'/>");
		myBar.add( new WebFXMenuButton("newBtn1", "<fmt:message key='common.toolbar.edit.label'  bundle='${v3xCommonI18N}' />", "edit();", [1,2], "", null));
		myBar.add( new WebFXMenuButton("delBtn", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "deleteMtSummaryDraftBox();", [1,3], "", null));
	}
	baseUrl='${mtMeetingURL}?method=';

	var userInternalID = "${CurrentUser.id}";
	
	function edit(){
		var summaryId = "";
		var len = 0;
		var alertMessage = "";
		var checkBoxList = parent.listFrame.document.getElementsByName('id');
		var createUser = "";
		for(var i = 0; i < checkBoxList.length; i++){
			if(checkBoxList[i].checked){
				len++;
				if(checkBoxList[i].getAttribute('state')==4) {
				 	alertMessage = v3x.getMessage("meetingLang.summary_list_toolbar_edit_pass_alert");
				}else if(checkBoxList[i].getAttribute('state')==3){//xiangfan GOV-4160审核中的纪要不允许编辑
					alertMessage = v3x.getMessage("meetingLang.summary_auditing_notallow_edit");
				}
				if(len>1) {
					break;					
				}
				summaryId = checkBoxList[i].getAttribute("value");
				createUser = checkBoxList[i].getAttribute("createUser");
			}
		}
		if(len>0){
			if(alertMessage!="") {
				alert(alertMessage);
				return false;
			}
			if(len==1){
				if(userInternalID==createUser) {
					location.href = "mtSummary.do?method=createSummary&id="+summaryId;
				} else {
					alert(v3x.getMessage("meetingLang.you_not_creater"));
					return;
				}
			}else{
				alert(v3x.getMessage("meetingLang.summary_list_toolbar_only_choose_one_toEdit"));
				return false;				
			}
		}else{
			alert(v3x.getMessage("meetingLang.summary_list_toolbar_select_edit_item"));
			return false;
		}
		
	}
	function selectDateTime(whoClick){
	    var date = whenstart('${pageContext.request.contextPath}', whoClick, 575,140);
	    var newDate = new Date();
	    var strDate = newDate.getYear()+"-"+(newDate.getMonth()+1)+"-"+newDate.getDate();
	    strDate = formatDate(strDate);
	    if(whoClick.id=='fromDate'){
	      if(document.getElementById('toDate').value!="" && 
	        date>document.getElementById('toDate').value){
	        alert(v3x.getMessage("meetingLang.checkdate_startdoesnotlateend"));
	      }
	      else if(null!=date){
	         whoClick.value = date;
	      }
	    }
	    if(whoClick.id=='toDate'){
	      if(document.getElementById('fromDate').value!="" && 
	        date<document.getElementById('fromDate').value){
	        alert(v3x.getMessage("meetingLang.checkdate_enddoeslatestart"));
	      }
	      else if(null!=date&&date!=""){
	         whoClick.value = date;
	      }
	    }   
    }
	
	function setSearchPeopleFields(elements, namesId, valueId) {
		document.getElementById(valueId).value = getIdsString(elements, false);
		document.getElementById(namesId).value = getNamesString(elements);
		document.getElementById(namesId).title = getNamesString(elements);
	}


	/**
	 * 会议纪要－转发 1、协同   2、公文
	 */
	function summaryTransmit(type) {
	    var theForm = document.getElementsByName("listForm")[0];
	    if (!theForm) {
	        return true;
	    }

	    var id_checkbox = document.getElementsByName("id");
	    if (!id_checkbox) {
	        return true;
	    }

	    var selectedCount = 0;
	    var summaryId = null;
	    var summaryState=null;
	    
	    var len = id_checkbox.length;
	    for (var i = 0; i < len; i++) {
	        if (id_checkbox[i].checked) {
	            summaryId = id_checkbox[i].getAttribute("value");
	            summaryState= id_checkbox[i].getAttribute("state");
	            selectedCount++;
	        }
	    }

	    if (selectedCount == 0) {
	        alert("请选择一条记录进行转发。");
	        return true;
	    }

	    if (selectedCount > 1) {
	        alert("只能选择一条记录进行转发。");
	        return true;
	    }

	    if(summaryState!=4 && summaryState!=6){
	        alert("只能选择审核通过或正常发布的会议纪要进行转发。");
	        return true;
	    }
	    if(type==1){ //转发协同
		    parent.parent.parent.location.href='${mtSummaryURL}?method=summaryToCol&id='+summaryId;
	    }else if(type==2){ //转发公文
	    	//parent.parent.location.href='edocController.do?method=listIndex&from=newEdoc&edocType=0';
	    	//parent.parent.location.href="<html:link renderURL='edocController.do?method=listIndex&from=newEdoc&edocType=0' />";
	    	parent.parent.parent.location.href='edocController.do?method=entryManager&entry=sendManager&toFrom=newEdoc&meetingSummaryId='+summaryId;
	    }
	    return true;
	}
	
	function search_result(){
		var beginDate = document.getElementById("fromDate").value;
		var endDate = document.getElementById("toDate").value;
		if(compareDate(beginDate,endDate)>0){
			alert("结束日期应大于开始日期！");
			return ;
		}
		doSearch();
	}
    //-->
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<c:choose>
<c:when test="${listType=='all'}">
<c:set var="mtState" value="mt.mtMeeting.state"></c:set>
</c:when>
<c:when test="${listType=='waitAudit'}">
<c:set var="mtState" value="mt.list.column.mt_desc"></c:set>
</c:when>
<c:when test="${listType=='passed'}">
<%--puyc 修改 2012-2-9 --%>
<c:set var="mtState" value="mt.list.column.mt_publish_desc_way"></c:set>
</c:when>
<c:otherwise>
<c:set var="mtState" value="mt.mtMeeting.state"></c:set>
</c:otherwise>
</c:choose>


</head>
<body>
<div class="main_div_row2">
<div class="right_div_row2">
<div class="top_div_row2">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td class="webfx-menu-bar">
		<script type="text/javascript">document.write(myBar);</script>
</td>
		<td class="webfx-menu-bar">
			<form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
			<input type="hidden" value="<c:out value='${param.method}' />" name="method" /> 
			<input type="hidden" value="${param.stateStr}" name="stateStr" />
			<!-- lijl添加,searchForm、searchListType隐藏表单域,用来存储上一次所进入的入口 -->
			<input type="hidden" value="${from}" name="searchForm" id="searchForm"/>
			<input type="hidden" value="${listType}" name="searchListType" id="searchListType"/>
			<div class="div-float-right condition-search-div">
				<div class="div-float">
					<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
						<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
						<option value="mtName"><fmt:message key="mt.list.column.mt_name" /></option>
						<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) { %>
							<option value="mtTypeName"><fmt:message key="mt.mtMeeting.meetingType" /></option>
						<% } %>
						<%if(com.seeyon.ctp.common.SystemEnvironment.hasPlugin("videoconference")){ %>
							<option value="meetingNature"><fmt:message key="mt.mtMeeting.meetingNature" /></option>
						<%}%>
						<option value="createUser"><fmt:message key='mt.mtMeeting.publishUser' /></option>
						<option value="mtBeginDate"><fmt:message key="mt.searchdate" /></option>
						<c:if test="${param.listType!='draft' }">
							<option value="summaryCreateDate"><fmt:message key="mt.summary.createDate" /></option><%--xiangfan 添加 ，修复 GOV-2161 小查询 缺少'纪要发起时间'查询条件 --%>
						</c:if>
						
						<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_SUMMARY_PERM) { %>
							<c:if test="${listType=='all' || listType=='waitAudit' || listType=='passed'}">
								<option value="state"><fmt:message key="${mtState}" /></option>
							</c:if>
						<% } %>
					</select>
				</div>
				<div id="mtNameDiv" class="div-float hidden">
					<input type="text" name="textfield" class="textfield" />
				</div>
				<!--
			 	<div id="mtTypeNameDiv" class="div-float hidden">
					<input type="text" name="textfield" class="textfield" />
				</div>
			    --> 
			    <% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) { %>
				    <div id="mtTypeNameDiv" class="div-float hidden">
                      <select name="textfield" id="textfield" class="textfield">
	                    <c:forEach var="meetingType" items="${typeList}"> 
		                  <option value="${meetingType.name}">${meetingType.name}</option>
	                    </c:forEach>
                      </select>
                       </div>
                      <% } %>
				
				<div id="createUserDiv" class="div-float hidden">
					<v3x:selectPeople id="createUser" panels="Department,Team" selectType="Member"
						departmentId="${currentUser.departmentId}"
						jsFunction="setSearchPeopleFields(elements, 'createUserName', 'createUserId')" minSize="0" maxSize="1" />
					<input type="text" name="textfield" id="createUserName" class="textfield" readonly="true" onclick="selectPeopleFun_createUser('textfield', 'textfield1')" />
					<input type="hidden" name="textfield1" id="createUserId" />
				</div>
				<div id="mtBeginDateDiv" class="div-float hidden">
					<input type="text" name="textfield" id="fromDate" class="input-date cursor-hand" onclick="selectDateTime(this);" readonly /> 
					- 
					<input type="text" name="textfield1" id="toDate" class="input-date cursor-hand" onclick="selectDateTime(this);" readonly />
				</div>
				<c:if test="${param.listType!='draft' }">
					<div id="summaryCreateDateDiv" class="div-float hidden">
						<input type="text" name="textfield" id="fromDate" class="input-date cursor-hand" onclick="selectDateTime(this);" readonly /> 
						- 
						<input type="text" name="textfield1" id="toDate" class="input-date cursor-hand" onclick="selectDateTime(this);" readonly />
					</div>
				</c:if>
				<!-- 会议发布状态 -->
				<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_SUMMARY_PERM) { %>
					<div id="stateDiv" class="div-float hidden">
						<select name="textfield" class="textfield">
							<c:if test="${listType=='all'}">
								<option value="2,3"><fmt:message key='mtSummary.tree.waitAudit.lable' bundle='${v3xMeetingSummaryI18N}'/></option>
								<option value="4,6"><fmt:message key='mtSummary.tree.passed.lable' bundle='${v3xMeetingSummaryI18N}'/></option>
								<option value="5"><fmt:message key='mtSummary.tree.notpassed.lable' bundle='${v3xMeetingSummaryI18N}'/></option>
							</c:if>
							<c:if test="${listType=='waitAudit'}">
								<option value="2"><fmt:message key='mtSummary.publish.lable.notReviewed' bundle='${v3xMeetingSummaryI18N}'/></option>
								<option value="3"><fmt:message key='mt.list.column.type.50'/></option>
							</c:if>
							<c:if test="${listType=='passed'}">
								<option value="6"><fmt:message key='mtSummary.publish.lable.normalPublish' bundle='${v3xMeetingSummaryI18N}'/></option>
								<option value="4"><fmt:message key='mtSummary.publish.lable.passAndPublish' bundle='${v3xMeetingSummaryI18N}'/></option>
							</c:if>
						</select>
					</div>
				<% } %>
				<!-- 视频会议  -->
				<%if(com.seeyon.ctp.common.SystemEnvironment.hasPlugin("videoconference")){ %>
					<div id="meetingNatureDiv" class="div-float hidden">
					    <select name="textfield" id="textfield" class="textfield">
							  <option value="1"><fmt:message key="mt.mtMeeting.label.ordinary" /></option>
					          <option value="2"><fmt:message key="mt.mtMeeting.label.video" /></option>
						</select>
					</div>
				<%}%>
				<div onclick="search_result()" class="condition-search-button div-float"></div>
			</div>
		</form>
	</td>
</tr>
</table>
</div>

<div class="center_div_row2" id="scrollListDiv">
<form  name="listForm" id="listForm">
<input id="content" name='content' type='hidden' value="" />
<v3x:table htmlId="listTable" data="list" var="bean" leastSize="0" bundle="${v3xMeetingSummaryI18N}">
							
	<c:set value="showSummary('${bean.id }','${bean.meetingId}', 0)" var="click" />
	<c:choose>
		<c:when test="${CurrentUser.id==bean.createUser}">
			<c:set value="edit()" var="dbClick" />
		</c:when>
		<c:otherwise>
			<c:set value="showSummary('${bean.id}', '${bean.meetingId }', 1);" var="dbClick" />
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

	<!-- 选择框  -->
	<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
		<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" createUser ="${bean.createUser}" state="${bean.state}" ${disabled} />
	</v3x:column>
	
	<!-- 会议名称  -->
	<v3x:column width="48%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.list.column.mt_name" className="cursor-hand sort" bodyType="${bean.dataFormat}" hasAttachments="${bean.hasAttachments}" alt="${createAccountName}${bean.mtName}">
		${createAccountName}${bean.mtName}
			<c:if test="${bean.meetingType eq  '2' }">
				<span class="bodyType_videoConf inline-block"></span>
        	</c:if>
	</v3x:column>
	
	<!-- 发布人  -->
	<v3x:column width="8%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.publishUser" className="cursor-hand sort">
		${v3x:showMemberName(bean.createUser)}
	</v3x:column>
	
	<!-- 会议类型  -->
	<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) { %>
		<v3x:column width="${listType=='notPassed'?15:10}%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.meetingType" className="cursor-hand sort">
			${bean.mtTypeName}
		</v3x:column>
	<% } %>
	
	<c:if test="${param.listType!='listMeetingSummaryDraft' }">
		<!-- 纪要发起时间  xiangfan 添加 修复GOV-2057 没有'纪要发起时间'列头错误 -->
		<v3x:column width="12%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.summary.createDate" className="cursor-hand sort">
			<fmt:formatDate pattern="${datePattern}" value="${bean.createDate}" />
		</v3x:column>
	</c:if>
							
	<!-- 会议时间  -->
	<v3x:column width="12%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.searchdate" className="cursor-hand sort">
		<fmt:formatDate pattern="${datePattern}" value="${bean.mtBeginDate}" />
	</v3x:column>
	
	<!-- 会议室  -->
	<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETINGROOM_APP) { %>
		<v3x:column width="15%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.place" className="cursor-hand sort">
			${bean.mtRoomName}
		</v3x:column>
	<%} %>
							
	<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_SUMMARY_PERM) { %>
		<!-- 状态1:草稿 2:待审核 3:审核通过 4:审核不通过 5:正常发布 6:撤销 -->
		<c:if test="${listType != 'notPassed'}"><!-- 在点击"我发布的会议记要"时的状态列 -->
			<v3x:column width="7%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="${mtState }" className="cursor-hand sort">
				<c:choose>
					<c:when test="${bean.state==1}">
						<!--草稿-->
						<fmt:message key='mt.list.column.type.0'/>
					</c:when>
					<c:when test="${bean.state==2}">
						<!--未审核-->
						<fmt:message key='mtSummary.publish.lable.notReviewed' bundle='${v3xMeetingSummaryI18N}'/>
					</c:when>
					<c:when test="${bean.state==3}">
						<!--审核中-->
						<fmt:message key='mt.list.column.type.50'/>
					</c:when>
					<c:when test="${bean.state==4}">
						<!--审核通过-->
						<fmt:message key='mtSummary.publish.lable.passAndPublish' bundle='${v3xMeetingSummaryI18N}'/>
					</c:when>
					<c:when test="${bean.state==5}">
						<!--审核不通过-->
						<fmt:message key='mtSummary.tree.notpassed.lable' bundle='${v3xMeetingSummaryI18N}'/>
					</c:when>
					<c:when test="${bean.state==6}">
						<!--正常发布-->
						<fmt:message key='mtSummary.publish.lable.normalPublish' bundle='${v3xMeetingSummaryI18N}'/>
					</c:when>
					<c:when test="${bean.state==7}">
						<!--撤销-->
						<fmt:message key='mt.list.column.type.40'/>
					</c:when>
				</c:choose>
			</v3x:column>
		</c:if>
	<% } %>
</v3x:table>
</form>
</div>
</div>
</div>
<script type="text/javascript">
	previewFrame('Down');
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='mt.mtMeeting' /><fmt:message key='mt.list' />", [1,2], pageQueryMap.get('count'), _("meetingLang.detail_info_603_1"));	
	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	initIpadScroll("scrollListDiv",550,870);
</script>
</body>
</html>
