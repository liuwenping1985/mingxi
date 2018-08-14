<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../include/meeting_taglib.jsp" %>
<%@ include file="../include/meeting_header.jsp" %>
<%@ include file="meeting_list_js.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<script type="text/javascript">
var myBar = new WebFXMenuBar("${path}");

//新建
myBar.add(new WebFXMenuButton("createBtn", "${createLabel}",  "javascript:createMeeting();", [4,5], "", null));
//撤销
myBar.add(new WebFXMenuButton("cancelBtn", "${cancelLabel}",  "javascript:cancelMeeting();", [3,8], "", null));
//编辑
myBar.add(new WebFXMenuButton("editBtn", "${editLabel}",  "javascript:editMeeting();", [1,2], "", null));
//提前结束
myBar.add(new WebFXMenuButton("finishAdvance", "${finishLabel}", "javascript:finishMeeting()", [4,3]));
//删除
myBar.add(new WebFXMenuButton("delBtn", "${deleteLabel}",  "javascript:deleteMeeting()", [1,3], "", null));

/** 按钮页签 **/
//待发
myBar.add(new WebFXMenuButton("waitSendPanel", "${waitSendPanelLabel}", "javascript:setPanelURL('listWaitSendMeeting');", [4,6], "", null));
//已发
myBar.add(new WebFXMenuButton("sendPanel", "${sendPanelLabel}", "javascript:setPanelURL('listSendMeeting');", [4,3], "", null));

</script>
</head>
<body class="page_color">

<div class="main_div_row2">

<div class="right_div_row2">

<!-- 按钮及小查询 start -->
<div class="top_div_row2">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td class="webfx-menu-bar">
		<script type="text/javascript">
			document.write(myBar);
		</script>
	</td>

	<td class="webfx-menu-bar">
		<form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false;" style="margin: 0px">
			<input type="hidden" value="<c:out value='${param.method}' />" name="method">
			<input type="hidden" value="${listType}" name="listType" />
			<input type="hidden" value="${videoConfStatus}" name="videoConfStatus" id="videoConfStatus"/>
			<div class="div-float-right condition-search-div">
				<div class="div-float" style="height:30px;">
					<select  style="vertical-align:middle;" name="condition" id="condition" onChange="ChangedEvent(this);" class="condition">
						<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
						<option value="title"><fmt:message key="mt.list.column.mt_name" /></option>						
						<option value="beginDate"><fmt:message key="mt.searchdate" /></option>
						<option value="room"><fmt:message key="mt.mtMeeting.place" /></option>
						<!-- 会议方式(普通/视频) -->
						<c:if test="${hasVideoConferencePlugin }">
							<option value="meetingNature"><fmt:message key="mt.mtMeeting.meetingNature" /></option>
						</c:if>
						<!-- 会议类型 (单次 /周期)-->
						<option value="category"><fmt:message key="mt.list.column.mt_type" /></option>
						<!-- 会议分类(普通/重要) -->
						<option value="meetingTypeId"><fmt:message key="mt.mtMeeting.meetingCategory" /></option>
					</select>
				</div>

				<div id="titleDiv" class="div-float hidden">
					<input type="text" name="textfield" class="textfield">
				</div>

				<div id="beginDateDiv" class="div-float hidden">
					<input type="text" name="textfield" id="fromDate" class="input-date cursor-hand" onclick="whenstart('${path}',this,575,140);" readonly>
						-
					<input type="text" name="textfield1" id="toDate" class="input-date cursor-hand" onclick="whenstart('${path}',this,575,140);" readonly>
				</div>

				<!-- 会议地点 -->
				<div id="roomDiv" class="div-float hidden">
					<input type="text" name="textfield" id="textfield" class="textfield" />
				</div>
				
				<!-- 会议方式(普通/视频) -->
				<c:if test="${hasVideoConferencePlugin }">
					<div id="meetingNatureDiv" class="div-float hidden">
					    <select name="textfield" id="textfield" class="textfield">
							  <option value="1"><fmt:message key="mt.mtMeeting.label.ordinary" /></option>
					          <option value="2"><fmt:message key="mt.mtMeeting.label.video" /></option>
						</select>
					</div>
				</c:if>

				<!-- 会议类型 (单次 /周期)-->
				<div id="categoryDiv" class="div-float hidden">
					<select name="textfield" id="textfield" class="textfield">
						<option value="0"><fmt:message key="mt.mtMeeting.type.one.meeting"/></option>
						<option value="1"><fmt:message key="mt.mtMeeting.type.periodic.meeting"/></option>
					</select>
				</div>
				
				<!-- 会议分类(普通/重要) -->
				<div id="meetingTypeIdDiv" class="div-float hidden">
					<input type="text" name="textfield" id="textfield" class="textfield" />
				</div>
				
				<div onclick="search_result();" class="condition-search-button div-float"></div>
			</div>
		</form>
	</td>
</tr>
</table>
</div><!-- top_div_row2 -->
<!-- 按钮及小查询 end -->

<!-- 列表 start -->
<div class="center_div_row2" id="scrollListDiv">

<form id="listForm" name="listForm">

<input type="hidden" id="editType"/>
<input type="hidden" id='canSendSMS' name="canSendSMS" value="false"/>

<v3x:table htmlId="listTable" data="list" var="bean" leastSize="0">
<c:set value="${bean.proxyId}" var="proxyId" />
<c:set value="${bean.proxyId==-1 ? 0 : 1 }" var="proxy" />
<c:set value="proxy-${proxy}" var="proxyClass"></c:set>

<c:set value="" var="createAccountName" />

<c:set value="displayMeetingDetail('${bean.id}','${proxy}','${proxyId}');" var="click" />

	<%------------- 复选框 -----------------%>
	<v3x:column width="5%" align="center" label="${selectAllInput }">
		<input type='checkbox' name='id' attFlag="${bean.hasAttachments}" mName="${bean.title}" state="${bean.state}"
		roomState="${bean.roomState}" room="${bean.room }" recordState="${bean.recordState }" category="${bean.category }" periodicityId="${bean.periodicityId }"
		value="<c:out value="${bean.id}"/>" ${disabled} />
	</v3x:column>

	<%------------- 标题 -----------------%>
	<v3x:column width="38%" type="String" onClick="${click}" onDblClick="${dbClick }" label="mt.list.column.mt_name" className="cursor-hand sort" bodyType="${bean.bodyType}" hasAttachments="${bean.hasAttachments}" alt="${createAccountName}${bean.title}" maxLength="45" symbol="...">
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
			ht.add("${bean.id}","${bean.state}");
			createUserIdTable.add("${bean.id}","${bean.createUser}");
		</script>
	</v3x:column>

	<%------------- 会议开始时间 -----------------%>
	<v3x:column width="10%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.beginDate" className="cursor-hand sort">
		<fmt:formatDate pattern="${datePattern}" value="${bean.beginDate}" />
	</v3x:column>

	<%------------- 会议结束时间 -----------------%>
	<v3x:column width="10%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="common.date.endtime.label" className="cursor-hand sort">
		<fmt:formatDate pattern="${datePattern}" value="${bean.endDate}" />
	</v3x:column>

	<%------------- 会议地址 -----------------%>
	<v3x:column width="10%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.place" className="cursor-hand sort" >
		<c:choose>
			<c:when test="${not empty bean.meetPlace}">
				${v3x:toHTML(bean.meetPlace)}
			</c:when>
			<c:when test="${not empty bean.roomName}">
				${v3x:toHTML(bean.roomName)}
			</c:when>
		</c:choose>
	</v3x:column>

	<%------------- 发布情况 -----------------%>
	<v3x:column width="9%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.notice.desc" className="cursor-hand sort">
		<c:choose>
			<c:when test="${bean.roomState==2}">
				<font color="red"><fmt:message key="mt.room.state.nopass"/></font>
			</c:when>
			<c:when test="${bean.roomState==1 || bean.roomState==-2}"><%--通过和审核通过 都改成'已发布' --%>
				<fmt:message key="mt.meeting.publish"/>
			</c:when>
			<c:when test="${bean.roomState==3}"><%-- 发出周期性会议中已经结束的会议 还申请了会议室的，发布状态为空  --%>
				<%-- 这里就什么都不显示 --%>
			</c:when>
			<c:otherwise>
				<fmt:message key="mt.notice.state.auditing${bean.roomState}"/>
			</c:otherwise>
		</c:choose>
	</v3x:column>

	<%------------- 会议状态 -----------------%>
	<v3x:column width="6%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.list.column.mt_state" className="cursor-hand sort">
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
			<c:when test="${bean.state==31}">
				<fmt:message key="meeting.room.used.status.3"/>
			</c:when>
			<c:when test="${bean.state==40}">
				<fmt:message key="mt.mtMeeting.state.30"/>
			</c:when>
			<c:otherwise>
				<fmt:message key="mt.mtMeeting.state.${bean.state}"/>
			</c:otherwise>
		</c:choose>
	</v3x:column>
	
	<%------------- 会议类型 (单次 /周期) -----------------%>
	<v3x:column width="6%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.meetingType" className="cursor-hand sort">
		<c:choose>
			<c:when test="${bean.category == 0}">
				<fmt:message key="mt.mtMeeting.type.one.meeting"/>
			</c:when>
			<c:otherwise>
				<fmt:message key="mt.mtMeeting.type.periodic.meeting"/>
			</c:otherwise>
		</c:choose>
	</v3x:column>

	<%------------- 会议分类(普通/重要) -----------------%>
	<v3x:column width="6%" type="String" onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.meetingCategory" className="cursor-hand sort" value="${bean.meetingTypeName}">
	</v3x:column>

</v3x:table>
</form>
</div><!-- center_div_row2 -->
<!-- 列表 end -->

</div><!-- right_div_row2 -->
</div><!-- main_div_row2 -->

</body>
</html>