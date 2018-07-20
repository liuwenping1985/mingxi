<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/meeting_taglib.jsp" %>
<%@ include file="../include/meeting_header.jsp" %>
<%@ include file="meeting_create_js.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml" class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<c:set value="${param.portalRoomAppId!=null && param.portalRoomAppId!=''}" var="isPortalRoomAppId" ></c:set>
<c:set value="true" var="hasNoSaveBtn"></c:set>
<title>${titleLabel }</title>
<script type="text/javascript">
///////////////////////按钮
var myBar = new WebFXMenuBar("${path}");
//产品版本信息ID 
var projectId = "${productId}";
//保存
<c:if test="${bean.state==0}">
	myBar.add(new WebFXMenuButton("save", "${saveBtn}",  "toSave('listWaitSendMeeting');", [1,5], "", null));
	<c:set value="false" var="hasNoSaveBtn"></c:set>	
</c:if>

//调用模板
<%--<c:if test="${param.flag!='editMeeting'}">--%>
	myBar.add(new WebFXMenuButton("loadTemplate", "${openTemplateBtn}", "showTemplate()", [3,7], "", null));    	
	<%--</c:if>--%>

//保存模板
<c:if test="${bean.state==10||bean.state==0}">
	//另存为
	myBar.add(new WebFXMenuButton("saveAs", "${saveAsBtn}", "saveAsTemplate();", [3,5], "", null));  
	
	//插入
	var insert = new WebFXMenu;
	insert.add(new WebFXMenuItem("", "${insertAttsBtn}", "insertAttachment(null, null, '_insertAttCallback', 'false')"));
	insert.add(new WebFXMenuItem("", "${insertDocBtn}", "quoteDocument()"));
	myBar.add(new WebFXMenuButton("insert", "${insertBtn}", null, [1,6], "", insert));
	myBar.add(${v3x:bodyTypeSelector("v3x")});
	if(bodyTypeSelector){
		bodyTypeSelector.disabled("menu_bodytype_${bean.dataFormat}");
	}
</c:if>

//主持人
isNeedCheckLevelScope_emcee = false;
//与会人
isNeedCheckLevelScope_confereesSelect = false;
//记录人
isNeedCheckLevelScope_recorder = false;
//领导
isNeedCheckLevelScope_leaderSelect = false;
//告知
isNeedCheckLevelScope_impartSelect = false;

${alert};
</script>
<style>
input,select {
	vertical-align: middle;
	height: 22px;
}
</style>
</head>

<body class="h100b over_hidden">
<form id="dataForm" name="dataForm" action="${meetingURL}" method="post" class="h100b w100b">
<div class="newDiv h100b w100b">

<input type="hidden" id="method" name="method" value="save" />
<input type="hidden" id="isOpenWindow" name="isOpenWindow" value=""/>
<fmt:formatDate value="${nowTime}" pattern="yyyy-MM-dd HH:mm" var="nowDate"/>
<input type="hidden" name="nowDate" id="nowDate" value="${nowDate}" />

<!-- 页面入口参数 -->
<input type="hidden" id="listType" name="listType" value="${v3x:toHTML(listType)}" />
<input type="hidden" id="formOper" name="formOper" value="save" />
<input type="hidden" name="fromMethod" value="${fromMethod != null?fromMethod:v3x:toHTML(param.method) }"/>
<%--向凡 添加，如果会议申请转会议通知时sendType=publishAppToMt,其他情况为空值,同样是为了不允许删除其他会议的会议室问题--%>
<input type="hidden" name="sendType" id="sendType" value="${v3x:toHTML(param.sendType)}" />
<%--xiangfan 添加， 会议室申请有两个入口【申请会议室】和【新建会议通知】RoomApp表示入口是【申请会议室】 MtMeeting表示入口是【新建会议通知】--%>
<input type="hidden" name="appType" id="appType" value="MtMeeting" />

<!-- 会议申请ID -->
<input type="hidden"  name="mtAppId" value="${v3x:toHTML(mtAppId)}" />
<!-- 会议资源ID -->
<!--
<input type="hidden" id="resourcesId" name="resourcesId" value="${bean.resourcesId}" />
-->
<input type="hidden" id="userId" name="userId" value="${v3x:currentUser().id}" />
<input type="hidden" id="meetingId" name="meetingId" value="${v3x:toHTML(meetingId)}" />
<input type="hidden" name="affairId" id="affairId" value="${affairId}"/>
<input type="hidden" name="tempId" value="${v3x:toHTML(param.templateId)}" />
<input type="hidden" name="project" value="${v3x:toHTML(project)}" />
<input type="hidden" id="isHasAtt" name="isHasAtt" value="" />
<input type="hidden" name="dataFormat" id="dataFormat" value="${bean.dataFormat}" />

<!-- 当从 会议申请审核通过列表中 转到会议通知页面的时候，不保存id,因为这时候的id不是会议通知的id而是会议申请的id -->
<c:if test="${meetAppToMeet != 'true' }">
	<input type="hidden" id="mtId" name="id" value="${bean.id}" />
</c:if>
<input type="hidden" name="meetAppToMeet" value="true" />

<!-- ******************************** 视频会议 start ********************************** -->
<input type="hidden" name="videoConfPoints" id="videoConfPoints" value="${videoConfPoints}"/>
<input type="hidden" name="videoConfStatus" id="videoConfStatus" value="${videoConfStatus}"/>
<!-- ******************************** 视频会议 end ********************************** -->

<!-- ******************************** 图形化会议室 start ********************************** -->

<input type="hidden" id="portalRoomAppId" name="portalRoomAppId" value="${v3x:toHTML(param.portalRoomAppId)}"/>
<!-- 手工输入地址 -->
<input type="hidden" name="meetingPlace" id="meetingPlace" value="${bean.meetPlace}"/>
<!-- 选择会议室 -->
<input type="hidden" id="isFromPortal" name="isFromPortal" value=""/>
<input type="hidden" id="hasMeetingRoom" name="hasMeetingRoom" value="${hasMeetingRoom}"/>
<input type="hidden" name="oldRoomAppId" id="oldRoomAppId" value="${oldRoomAppId}"/>
<input type="hidden" id="roomAppId" name="roomAppId" value="${roomAppId}" />
<input type="hidden" id="selectedRoomName" name="selectedRoomName" value="${selectedRoomName}" />
<input type="hidden" name="meetingroomId" id="meetingroomId" value="${meetingroomId}" />
<input type="hidden" name="meetingroomName" id="meetingroomName" value="${meetingroomName}" />
<input type="hidden" name="needApp" id="needApp" value="${needApp}"/>
<fmt:formatDate value="${roomAppBeginDate}" pattern="yyyy-MM-dd HH:mm" var="roomAppBeginDateJsp"/>
<fmt:formatDate value="${roomAppEndDate}" pattern="yyyy-MM-dd HH:mm" var="roomAppEndDateJsp"/>
<input type="hidden" id="roomAppBeginDate" name="roomAppBeginDate" value="${roomAppBeginDateJsp }" />
<input type="hidden" id="roomAppEndDate" name="roomAppEndDate" value="${roomAppEndDateJsp }" />
<c:forEach items="${meetingRoomApp }" var="app">
	<input type="hidden" name="beginTime${app.meetingRoom.id }" id="beginTime${app.meetingRoom.id }" value="${app.startDatetime}" />
	<input type="hidden" name="endTime${app.meetingRoom.id }" id="endTime${app.meetingRoom.id }" value="${app.endDatetime}" />
</c:forEach>
<!-- ******************************** 图形化会议室 end ********************************** -->

<!-- ******************************** 周期性会议设置 ********************************** -->
<c:set var="periodicityInfoIdReal" value="${(bean.periodicityInfoId==null||bean.periodicityInfoId=='') ? bean.periodicityInfoId2 : bean.periodicityInfoId}" />
<c:set var="periodicityInfoId" value="${(param.periodicityInfoId==null||param.periodicityInfoId=='') ? periodicityInfoIdReal : v3x:toHTML(param.periodicityInfoId)}" />
<input type="hidden" id="periodicityType" name="periodicityType" value="${pinfo.periodicityType }"/>
<input type="hidden" id="scope" name="scope" value="${pinfo.scope }"/>
<input type="hidden" id="periodicityStartDate" name="periodicityStartDate" value="${pinfo.startDate }"/>
<input type="hidden" id="periodicityEndDate" name="periodicityEndDate" value="${pinfo.endDate }"/>
<input type="hidden" id="periodicityInfoId" name="periodicityInfoId" value="${periodicityInfoId}"/>
<input type="hidden" id="createUserName" name="createUserName" 
				value="<c:out value="${v3x:showOrgEntities(createUserSelect, 'id', 'entityType', pageContext)}" default="" escapeXml="true" />"
				title="${v3x:showOrgEntities(createUserSelect, 'id', 'entityType', pageContext)}"
				onclick="selectMtPeople('createUserSelect','createUser');"
				/>				
				
<%--这个是设置周期性后，通过ajax计算出所有会议日期，用于图形化会议中 --%>
<input type="hidden" id="periodicityDates" />


<!-- 会议表单元素 -->
<%-- toolbar内容 --%>
<div id="toolbar-div" class="w100b">
    <div class="webfx-menu-bar">
        <script type="text/javascript">
        <!--
                document.write(myBar);
        //-->
        </script>
    </div>
    <hr style="margin: 0px"/>
</div>

<%-- 会议字段内容 --%>
<div id="meeting-fields-div" class="w100b">
    <table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" id="contentTable">

<tr class="bg-summary" >
	<td rowspan="3" style="width: 85px;" nowrap="nowrap" class="border-left">
		<a onclick="toSend('${meetingId}', 'listSendMeeting')" id='send' class="margin_lr_10 align_center display_inline-block new_btn">${sendBtn }</a>
	</td>
        
    <!-- 会议名称 -->
    <td nowrap="nowrap"  align="right" style="width:60px;line-height: 30px;">
    	<div class="padding_r_5">${subjectLabel }${colonLabel }</div>
    </td>
	<td colspan="3" style="padding-right: 24px;">
		<div class="common_txtbox_wrap">
			<c:set value="${subjectLabel }" var="_myLabel"></c:set>
			<fmt:message key="label.please.input" var="_myLabelDefault">
                <fmt:param value="${subjectLabel }" />
            </fmt:message>
           <input type="text" class="w100b validate" id="title" name="title" maxlength="60"
					value="<c:out value="${bean.title==null?bean.title:v3x:toHTML(bean.title)}" default="${_myLabelDefault}" escapeXml="false"></c:out>" 
					title="${v3x:toHTML(bean.title)}"
					defaultValue="${_myLabelDefault}"
					onfocus="checkDefSubject(this, true)"
					onblur="checkDefSubject(this, false)"
					inputName="${subjectLabel }"
					validate="notNull,isDefaultValue"
					${param.clearValue}
				/>
		</div>
	</td>
	
	<!-- 开始时间 -->
	<td nowrap="nowrap"  align="right" style="width:60px;">
		<div  class="padding_r_5">${beginDateLabel }${colonLabel }</div>
	</td>
	<td  style="padding-right:24px;width: 20%;">
		<div class="common_txtbox_wrap" >
			<input type="text" name="beginDate" id="beginDate" class="w100b cursor-hand" readonly onclick="selectMeetingTime(this);" inputName="${beginDateLabel }" validate="notNull" value="${beginDateValue }" />
		</div>
	</td>

	<!-- 结束时间 -->
	<td nowrap="nowrap" align="right" style="width: 150px;" >
		<div  class="padding_r_5">${endDateLabel }${colonLabel }</div>
	</td>
    <td style="width: 30%;">
   		<div class="common_txtbox_wrap">
   			<input type="text" name="endDate" id="endDate" class="w100b cursor-hand" readonly onclick="selectMeetingTime(this);" inputName="${endDateLabel }" validate="notNull" value="${endDateValue }" />
   		</div>
   	</td>
    <td valign="middle" nowrap="nowrap" align="right" class="border-right"></td>
</tr>

<tr class="bg-summary">
	<!-- 主持人 -->
    <td nowrap="nowrap" align="right" style="line-height: 30px;">
    	<div class="padding_r_5">${emceeIdLabel }${colonLabel }</div>
    </td>
	
    <td style="padding-right: 24px;width: 15%;" >
    	<div class="common_txtbox_wrap">
    		<c:set value="${emceeIdLabel }" var="_myLabel"></c:set>
			<fmt:message key="label.please.select" var="_myLabelDefault">
				<fmt:param value="${_myLabel}" />
			</fmt:message>
			<input type="hidden" id="emceeId" name="emceeId" value="${bean.emceeId}"/>
			<input type="text" class="w100b cursor-hand" id="emceeName" name="emceeName" readonly="true" 
				value="<c:out value="${v3x:showOrgEntities(emceeList, 'id' , 'entityType' , pageContext)}" default="${_myLabelDefault}" escapeXml="true" />"
				title="${v3x:showOrgEntities(emceeList, 'id' , 'entityType' , pageContext)}"
				defaultValue="${_myLabelDefault}"
				onfocus="checkDefSubject(this, true)"
				onblur="checkDefSubject(this, false)"
				inputName="${_myLabel}" 
				validate="notNull,isDefaultValue"
				onclick="selectMtPeople('emcee','emceeId');"
				/>	
		</div>
    </td>
        
    <!-- 记录人 -->
    <td nowrap="nowrap" align="right" style="width: 60px;">
    	<div class="padding_l_10 padding_r_5">${recorderIdLabel }${colonLabel }</div>
    </td>
	<td style="padding-right:24px;width: 15%">
		<div class="common_txtbox_wrap">
			<c:set value="${recorderIdLabel }" var="_myLabel"></c:set>
			<fmt:message key="label.please.select" var="_myLabelDefault">
				<fmt:param value="${_myLabel}" />
			</fmt:message>
			
			<input type="hidden" id="recorderId" name="recorderId" value="${bean.recorderId}"/>
			<input type="text" class="w100b cursor-hand" id="recorderName" name="recorderName" readonly="true" 
				value="<c:out value="${v3x:showOrgEntities(recorderList, 'id' , 'entityType' , pageContext)}" default="${_myLabelDefault}" escapeXml="true" />"
				title="${v3x:showOrgEntities(recorderList, 'id' , 'entityType' , pageContext)}"
				defaultValue="${_myLabelDefault}"
				onfocus="checkDefSubject(this, true)"
				onblur="checkDefSubject(this, false)"
				inputName="${_myLabel}" 
				onclick="selectMtPeople('recorder','recorderId');"
				/>
		</div>
	</td>
    
    <!-- 会议地点 -->
	<td nowrap="nowrap"  align="right">
		<c:set value="${(bean.room == null && bean.meetPlace != null && bean.meetPlace != '')}" var="isMeetPlace" ></c:set>
		<div  class="padding_r_5">${placeLabel }${colonLabel }</div>
	</td>
	
	<%--当新建或批量修改的时候 才显示周期性设置 --%>
	<c:set value="${param.method == 'create' || !empty param.periodicityInfoId || (param.listType == 'listWaitSendMeeting' && !empty bean.periodicityInfoId) || periodicityDisplay == 'true'}" var="display"/>

		<c:choose>
		<c:when test="${v3x:getSysFlagByName('meeting_showRelatedProject') == false}"><%--A6s版本 = 7--%>
		<td style="padding-right:24px;">
			<fmt:message key="mt.meMeeting.input" var="_handWriteLabal" />
			<c:set value="&lt;${_handWriteLabal}&gt;" var="_handWriteLabal"></c:set>
			<input type="text" class="input-100per" name="a6s_hand_write" id="a6s_hand_write"
			                value="<c:out value="${bean.meetPlace}" default="${_handWriteLabal}" escapeXml="false" />" 
			                maxlength="60"
			                title="${bean.meetPlace}"
			                defaultValue="${_handWriteLabal}"
			                onfocus="checkDefSubject(this, true)"
			                onblur="checkDefSubject(this, false)"
			                inputName="${addressLabel }"
			            />
			<input type="hidden" id="selectRoomType" name="selectRoomType" value="mtPlace"/>
		</td>
		<td>
			<%-- 提前提醒--%>
	        <input type="checkbox" class="radio_com" id="remindFlag" name="remindFlag" value="${bean.remindFlag}" style='DISPLAY:none' checked="checked"/>
			<div  class="padding_r_5">${beforeTimeLabel }${mtMtMeetingRemind }${colonLabel }</div>
		</td>
	    <td>
	   			<select id="beforeTime" name="beforeTime" onchange="changeRemindFlag(this)" value="${bean.beforeTime}" style="width:100%;" align="right">
					<v3x:metadataItem metadata="${remindTimeMetaData}" showType="option" name="beforeTime" selected="${bean.beforeTime}" />
				</select>
	   	</td>
		</c:when>
		<c:otherwise>
		<td style="padding-right:24px;">
		<div class="common_selectbox_wrap">
	   	<select id="selectRoomType" name="selectRoomType" class="input-100per" onchange="changeRoomType(this,false);">
	   		<option value="mtRoom" meetingroomId="${meetingroomId}" isNeedApp="${needApp}" startDatetime="<fmt:formatDate pattern='${datetimePattern}' value='${bean.beginDate}' />" selectedRoomName="${selectedRoomName}" endDatetime="<fmt:formatDate pattern='${datetimePattern}' value='${bean.endDate}' />" <c:if test="${bean.room != null && !isPortalRoomAppId}">selected</c:if>>
	       		<c:choose>
		            <c:when test="${bean.room != null}">${bean.roomName}(${roomAppBeginDateJsp }--${roomAppEndDateJsp })</c:when>
		            <c:otherwise>&lt;${roomDecription }&gt;</c:otherwise>
	            </c:choose>
	        </option>
			<option value="mtPlace" <c:if test="${isMeetPlace && !isPortalRoomAppId}">selected</c:if>>
	        	<c:choose>
	            	<c:when test="${isMeetPlace}">${bean.meetPlace}</c:when>
	            	<c:otherwise>&lt;${roomInput }&gt;</c:otherwise>
	        	</c:choose>
	        </option>
			<c:forEach items="${meetingRoomApp }" var="app">
				<c:if test="${app.meetingRoom.id!=meetingroomId }">
					<option value="mtRoom" roomType="backstage" roomAppId="${app.id}" isFromPortal="${param.portalRoomAppId==app.id}" <c:if test="${param.portalRoomAppId==app.id}">selected</c:if> meetingroomId="${app.meetingRoom.id }" selectedRoomName="${app.meetingRoom.name}" isNeedApp="0" startDatetime="<fmt:formatDate pattern='${datetimePattern}' value='${app.startDatetime}' />" endDatetime="<fmt:formatDate pattern='${datetimePattern}' value='${app.endDatetime}' />" rType="apped">
						${app.meetingRoom.name }
						(<fmt:formatDate pattern="${datetimePattern}" value="${app.startDatetime}" />
						--
						<fmt:formatDate pattern="${datetimePattern}" value="${app.endDatetime}" />)
					</option>
				</c:if>
			</c:forEach>
		</select>
		</div></td>
		<td colspan="2">
		<table class="w100b" style="border: 0px;" cellpadding="0px;" cellspacing="0px;">
		  <tr>
			  <c:if test="${F09_meetingRoomApp }">
			  <td style="width: 78px; padding-left: 7px;">
	            <div class="w100b" style="width: 100px;">
	                <a class="common_button common_button_icon comp" style="width:auto;" href="javascript:void(0)" id="chooseMeetingRoom" onclick="showMTRoom()">
	                    <em class="ico16 process_16"> </em>${roomAppLabel }
	                </a>
	            </div>
	            </td>
	        </c:if>
	        <td nowrap="nowrap"  align="right" style="width: 90px;padding-left:15px;">
	            <div  class="padding_r_5">
	                ${beforeTimeLabel }${mtMtMeetingRemind }${colonLabel }
	            </div>
	        </td>
	        <td style="width: 100%">
	        <%--提前提醒 --%>
        <input type="checkbox" class="radio_com" id="remindFlag" name="remindFlag" value="${bean.remindFlag}" style='DISPLAY:none' checked="checked"/>
            <select id="beforeTime" class="w100b" name="beforeTime" onchange="changeRemindFlag(this)" value="${bean.beforeTime}" align="right">
                <v3x:metadataItem metadata="${remindTimeMetaData}" showType="option" name="beforeTime" selected="${bean.beforeTime}" />
            </select>
	        </td>
		  </tr>
		</table>
		</td>
		</c:otherwise>
		</c:choose>
    <td valign="middle" nowrap="nowrap" align="right" class="border-right"></td>	          	
</tr>
	
<tr class="bg-summary">
	<!-- 参会人员 -->
    <td colspan="1" nowrap="nowrap"  align="right" style="line-height: 30px;">
    	<div class="padding_r_5">${joinLabel }${colonLabel }</div>
    </td>
	<td colspan="3" style="padding-right:24px;">
		<div class="common_txtbox_wrap">
			<c:set value="${joinLabel }" var="_myLabel"></c:set>
			<fmt:message key="label.please.select" var="_myLabelDefault">
				<fmt:param value="${_myLabel}" />
			</fmt:message>
			<input type="hidden" id="conferees" name="conferees" value="${bean.conferees}"/>
			<%-- 通过会议模板新建会议、或者在关联项目主页新建项目会议时，会初始化与会人员值，作为新旧对比的旧值，应置为空 --%>
			<input type="hidden" id="oldConferees" name="oldConferees" value="${param.formOper eq 'createByTemplate' || project eq 'project' ? '' : bean.conferees}"/>
			<input type="text" class="w100b cursor-hand" id="confereesNames" name="confereesNames" readonly="true"
				value="<c:out value="${v3x:showOrgEntities(confereeList, 'id', 'entityType', pageContext)}" default="${_myLabelDefault}" escapeXml="true" />"
				title="${v3x:showOrgEntities(confereeList, 'id', 'entityType', pageContext)}"
				defaultValue="${_myLabelDefault}"
				onfocus="checkDefSubject(this, true)"
				onblur="checkDefSubject(this, false)"
				inputName="${_myLabel}" 
				validate="notNull,checkSelectConferees"
				onclick="selectMtPeople('confereesSelect','conferees');"
				/>
		</div>
	</td>
	
	<%--告知 --%>
	<td nowrap="nowrap" align="right">
		<div  class="padding_r_5">${impartLabel }${colonLabel } </div>
	</td>
	<c:if test="${v3x:getSysFlagByName('meeting_showRelatedProject') == false}">
    <td colspan="3">
    <div class="" style="width:92%;float:left">
    </c:if>
    <c:if test="${v3x:getSysFlagByName('meeting_showRelatedProject') == true}">
    <td  style="padding-right:24px;">
    <div class="common_txtbox_wrap">
    </c:if>
      		<c:set value="${impartLabel }" var="_impartLabel"></c:set>
			<fmt:message key="label.please.select" var="_myImpartLabelDefault">
				<fmt:param value="${_impartLabel}" />
			</fmt:message>
			<input type="hidden" id="impart" name="impart" value="${bean.impart}"/>
			<input type="text" class="w100b cursor-hand" id="impartNames" name="impartNames" readonly="true"
				value="<c:out value="${v3x:showOrgEntities(impartList, 'id', 'entityType', pageContext)}" default="${_myImpartLabelDefault}" escapeXml="true" />"
				title="${v3x:showOrgEntities(impartList, 'id', 'entityType', pageContext)}"
				defaultValue="${_myImpartLabelDefault}"
				onfocus="checkDefSubject(this, true)"
				onblur="checkDefSubject(this, false)"
				inputName="${_impartLabel}" 
				onclick="selectMtPeople('impartSelect','impart');"
				/>
		</div>
		<c:if test="${v3x:getSysFlagByName('meeting_showRelatedProject') == false}">
			<div>
			<a href="javascript:void(0);" id="show_more" style="font:12" class="margin_r_5 margin_l_10" onclick="showMore();return false;">${moreLabel }</a>
			</div>
		</c:if>
	</td>
    
    
	<!--所属项目 -->
	<c:if test="${v3x:getSysFlagByName('meeting_showRelatedProject') == true}">
	<td nowrap="nowrap" align="right">
		<div  class="padding_r_5">${projectIdLabel }${colonLabel }</div>
	</td>
    <td >
      	<div class="common_selectbox_wrap">
      		<select id="projectId" name="projectId" class="input-100per" value="${bean.projectId}">
		    	<option value="-1">&lt;${selectLabel }${projectIdLabel }&gt;</option>
				<c:forEach items="${projectMap}" var="project">
					<option value='${project.id}'>${v3x:toHTML(project.projectName)}</option>
				</c:forEach>
		 	</select>
		 	<c:set value="${bean.projectId==null ? '-1' : bean.projectId}" var="projectId" />
		 	<script type="text/javascript">
				setSelectValue("projectId","${projectId}");
			</script>
		</div>
	</td>      	
	</c:if>
	<!-- 更多 -->
	<c:if test="${v3x:getSysFlagByName('meeting_showRelatedProject') == true}">
	<td valign="middle" nowrap="nowrap" align="right" class="border-right" style="width: 40px">
		<a href="javascript:void(0);" id="show_more" style="font:12" class="margin_r_5 margin_l_10" onclick="showMore();return false;">${moreLabel }</a>
	</td>
	</c:if>
</tr>

<tr id="passwordArea" class="bg-summary hidden">
    <td>&nbsp;</td>
	<!-- 参会密码 -->
	<td colspan="1" nowrap="nowrap"  align="right" style="padding:6px">
		<div class="padding_r_5">${passwordLabel }${colonLabel }</div>
	</td>
	<td style="padding-right: 24px;">
		<div class="common_txtbox_wrap">
			<input type="text" class="w100b" id="meetingPassword" name="meetingPassword" onblur="changeTextValue('meetingPassword')" onclick="clearPassword('meetingPassword')" value="${v3x:toHTML(bean.meetingPassword) }"/>
		</div>
		<!-- (${letterLabel }) -->
	</td>
	
	<!-- 确认密码 -->
	<td nowrap="nowrap"  align="right">
		<div class="padding_l_10 padding_r_5">${passwordConfirmLabel }${colonLabel }</div>
	</td>
	<td style="padding-right:24px;">
		<div class="common_txtbox_wrap">
			<input type="text" class="w100b" id="meetingPasswordConfirm" name="meetingPasswordConfirm"  onblur="changeTextValue('meetingPasswordConfirm')" onclick="clearPassword('meetingPasswordConfirm')"  value="${v3x:toHTML(bean.meetingPasswordConfirm )}" />
		</div>
	</td>
	
	<!-- 是否显示到会议视频列表 -->
	<td nowrap="nowrap">&nbsp;</td>
	<td  colspan="3">
		<input type="checkbox" id="meetingCharacter" name="meetingCharacter" value="${bean.meetingCharacter}" 
			<c:if test="${bean.meetingCharacter == '' || bean.meetingCharacter == 'true'}">checked="true"</c:if>/> ${characterLabel }
	</td>
	
	<td valign="middle" nowrap="nowrap" align="right" class="border-right"></td>
</tr>

<!--更多-->
<tr class="bg-summary newinfo_more hidden" >

<td>&nbsp;</td>

<!-- 会议格式 -->
<td nowrap="nowrap"  align="right" style="line-height: 30px;">
<div class="padding_r_5">${templateIdLabel }${colonLabel }</div>
</td>

<td style="padding-right: 24px;">
<div class="common_selectbox_wrap">
			<select id="selectFormat" name="contentTemplateId" class="w100b" value="${bean.templateId}" onchange="loadContentTemplate();">
				<option value="">&lt;${selectLabel }${templateIdLabel }&gt;</option>
				<c:forEach items="${contentTemplateList}" var="contentTemplate">
					<option value='${contentTemplate.id}'>${contentTemplate.templateName}</option>
				</c:forEach>
			</select>
			<script type="text/javascript">
		    	var selectFormatlength = document.getElementById('selectFormat').options.length;
				for(var i=selectFormatlength-1;i>=0;i--){
					if("${bean.templateId}"==document.getElementById('selectFormat').options[i].value){
						document.getElementById('selectFormat').options[i].selected="selected";
					}
		        }
		        var selectFormat_oldValue = document.getElementById("selectFormat").value;
			</script>
			<input type="hidden" id="loadTemplate" value="${loadLabel }" onclick="loadContentTemplate();" />
		</div>
</td>
<%--会议用品 --%>
<td nowrap="nowrap"  align="right" style="line-height: 30px;">
<div class="padding_r_5">${resourceLabel }${colonLabel }</div>
</td>

<td style="padding-right:24px;">
<div class="common_txtbox_wrap">
			<c:set value="${resourceLabel }" var="_myLabel"></c:set>
			<fmt:message key="label.please.select" var="_myLabelDefault">
                <fmt:param value="${resourceLabel }" />
            </fmt:message>
            
			<input type="hidden" id="resourcesId" name="resourcesId" value="${bean.resourcesId}" />
            <input type="text" id="resourcesName"  name="resourcesName" readonly="readonly" class="w100b cursor-hand"
            	value="<c:out value="${bean.resourcesName}" default="${_myLabelDefault}" escapeXml="true" />"  
            	title="${bean.resourcesName }"
            	defaultValue="${_myLabelDefault}"
            	onfocus="checkDefSubject(this, true)"
                onblur="checkDefSubject(this, false)"
                inputName="${_myLabel }"
            	onclick="selectResources();" />
</div>

</td>
<%--会议方式 --%>
<td nowrap="nowrap"  align="right">
<div  class="padding_r_5">${meetingNatureLabel }${colonLabel }</div>
</td>

<td style="padding-right: 24px;">
<table border="0" cellpadding="0" cellspacing="0"  style="width: 100%">
	<tr>
		<td style="width: 100%">
			 <div class="common_selectbox_wrap clearfix ">
			 <c:if test="${v3x:getSysFlagByName('meeting_showRelatedProject') == false}">
			 <label id="meetingNature" name="meetingNature" onchange="validatePasswordArea()" "${videoConfStatus eq 'enable' ? '' : 'disabled'}">
				<option value="1">${ordinaryLabel }</label>
			 <c:if test="${not empty videoConfUrl}">
					<option value="2" ${bean.meetingType eq '2' ? 'selected' : ''}>${videoLabel}</option>
			 </c:if>
			</c:if>
			<c:if test="${v3x:getSysFlagByName('meeting_showRelatedProject') == true}">
			 <select
				id="meetingNature" name="meetingNature"
				onchange="validatePasswordArea()" "${videoConfStatus eq 'enable' ? '' : 'disabled'}">
				<option value="1">${ordinaryLabel }</option>
				<c:if test="${not empty videoConfUrl}">
					<option value="2" ${bean.meetingType eq '2' ? 'selected' : ''}>${videoLabel}</option>
				</c:if>
			</select>
			</c:if>
			</div>
		</td>
		<%--周期性 --%>
		<%--IE6-8 不支持opacity设置透明度，只能用disabled来设置，IE10及以上不支持span等标签设置disabled，用opacity设置透明度,IE9使用两者都行 --%>
		<%--A6s版本 != 7 --%>
		<td style="width: 76px;padding-left:15px;">
			<span <c:if test="${display == 'false' }">disabled="disabled" style="opacity:0.4;"</c:if> <c:if test="${display != 'false' }">onclick="showRepeatCycle('${v3x:toHTML(periodicityInfoId) }');"</c:if>>
				<a class="common_button common_button_icon comp" style="width: auto;"> 
					<em class="ico16 cycleMeeting_16"></em><fmt:message key='mt.periodic' />
				</a>
			</span>
		</td>
	</tr>
</table>
</td>

<td nowrap="nowrap"  align="right">
<div class="padding_l_10 padding_r_5">${meetingCategory}${colonLabel }</div>
</td>
<td >
    <table class="w100b" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td style="padding-right: 5px;<c:if test="${isCanSendSMS}">width:50%;</c:if>">
              <div class="common_selectbox_wrap clearfix w100b">
                <select class="w100b" id="meetingTypeId" name="meetingTypeId"  onchange="changeMtType(this,'2');">
                    <option value="-1"><fmt:message key="mt.meetingType.input" /></option>
                    <c:forEach items="${mtTypeList}" var="mt">
                    <option value='${mt.id}' <c:if test="${mt.id == bean.meetingTypeId}">selected</c:if>>${v3x:toHTML(mt.name)}</option>
                    </c:forEach>
                </select>
             </div>
            </td>
            <!-- 发送短信 -->
            <c:if test="${isCanSendSMS}">
                <td nowrap="nowrap"  align="right" style="width: 60px;">
                   <div class="padding_r_5">
                    ${mtMtMeetingMessages}${colonLabel }
                   </div>
                </td>
                <td nowrap="nowrap" align="right" style="width:50%;">
                   <div class="w100b" class="common_selectbox_wrap clearfix ">
                    <select class="w100b" id="SendTextMessages" class="input-100per"  name="SendTextMessages"
                        value="" style="width: 100%;" align="right">
                        <option value=1><fmt:message key="mt.mtMeeting.yes" /></option>
                        <option value=0 selected="selected"><fmt:message
                            key="mt.mtMeeting.no" /></option>
                    </select>
                    </div>
                </td>
            </c:if>
        </tr>
    </table>
</td>
<td valign="middle" nowrap="nowrap" align="right" class="border-right"></td>
</tr>


<tr id="attachment2TR" class="bg-summary" style="display:none;">
    <td>&nbsp;</td>
	<td nowrap="nowrap" height="18" class="bg-gray" ><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:</td>
	<td colspan="7" ><div class="div-float" style="margin-top: 4px;">(<span id="attachment2NumberDiv"></span>)</div>
	<div></div><div id="attachment2Area" style="overflow: auto;"></div></td>
	<td>&nbsp;</td>
</tr>					

<tr id="attachmentTR" style="display:none;" class="bg-summary">
	<td>&nbsp;</td>
	<td class="bg-gray"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /> <fmt:message key="label.colon" /> </td>
	<td class="value" colspan="7">
		<div class="div-float" style="margin-top: 4px;">(<span id="attachmentNumberDiv"></span>)</div>
		<v3x:fileUpload originalAttsNeedClone="${originalBodyNeedClone}" attachments="${attachments}" canDeleteOriginalAtts="true" />
	</td>
	<td>&nbsp;</td>
</tr>

<tr>
	<td colspan="10" height="6" class="bg-b">&nbsp;</td>
</tr>

</table>
</div>

<%-- 正文内容 --%>
<div id="content-div" class="w100b">
    <div style="width: 100%;" id="scrollListMeetingDiv">
            <v3x:editor htmlId="${(bean.state!=0 && bean.state!=10 && bean.state!=null)?'meeting-contentText':'content'}" 
                content="${bean.content}" type="${bean.dataFormat}" originalNeedClone="${originalBodyNeedClone}"
                createDate="${bean.createDate}" category="<%=ApplicationCategoryEnum.meeting.getKey()%>" />
    </div>
</div>

</div>
</form>

<!-- radishlee add 2012-4-16                见cvs版本1.2 无注释 如果调用模板。不许修改    此处删除 ext5字段无用 -->
<c:if test="${bean.isEdit!=null && bean.isEdit!='' && !bean.isEdit && bean.state!=10 }">
<script type="text/javascript">
	$('dataForm').disable();
</script>
</c:if>

<div style="display:none">
	<input type="hidden" id="mtTitle2" name="mtTitle2" value="" />
	<input type="hidden" id="attender2" name="attender2" value="" />
	<input type="hidden" id="tel2" name="tel2" value="" />
	<input type="hidden" id="noticeView2" name="noticeView2" value="" />
	<input type="hidden" id="planView2" name="planView2" value="" />
	<input type="hidden" id="leader2" name="leader2" value="" />
	<input type="hidden" id="leaderNames2" name="leaderNames2" value="" />
</div>

<iframe name="hiddenIframe" width="0" height="0" style="display:none"></iframe>
<script type="text/javascript">
OfficeObjExt.setIframeId("officeFrameDiv");
//xl 7-18按钮图标居中对齐
$(function(){
	$("img.toolbar-button-icon").css({
		"margin-top":"3px",
		"margin-bottom":"3px"
	});
})
</script>
</body>
</html>
