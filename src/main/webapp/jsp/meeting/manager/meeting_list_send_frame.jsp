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
		<form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false;" style="margin: 0px">
			<input type="hidden" value="<c:out value='${param.method}' />" name="method">
			<input type="hidden" value="${listType}" name="listType" />
			<input type="hidden" value="${videoConfStatus}" name="videoConfStatus" id="videoConfStatus"/>
			<div class="div-float-right condition-search-div">
				<div class="div-float" style="height:30px;">
					<select  style="vertical-align:middle;" name="condition" id="condition" onChange="ChangedEvent(this);" class="condition">
						<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
						<option value="title"><fmt:message key="mt.list.column.mt_name" /></option>
						<c:if test="${hasMeetingType }">
							<option value="meetingTypeId"><fmt:message key="mt.list.column.mt_type" /></option>
						</c:if>
						<option value="beginDate"><fmt:message key="mt.searchdate" /></option>
						<c:if test="${hasMeetingRoomApp }">
							<option value="room"><fmt:message key="mt.mtMeeting.place" /></option>
						</c:if>
						<c:if test="${hasVideoConferencePlugin }">
							<option value="meetingNature"><fmt:message key="mt.mtMeeting.meetingNature" /></option>
						</c:if>
						<c:if test="${hasMeetingType }">
							<option value="meetingType"><fmt:message key="mt.mtMeeting.meetingCategory" /></option>
						</c:if>
					</select>
				</div>

				<div id="titleDiv" class="div-float hidden">
					<input type="text" name="textfield" class="textfield">
				</div>

				<c:if test="${hasMeetingType }">
					<div id="meetingTypeIdDiv" class="div-float hidden">
						<select name="textfield" id="textfield" class="textfield">
							<option value="one"><fmt:message key="mt.mtMeeting.type.one.meeting"/></option>
							<option value="periodic"><fmt:message key="mt.mtMeeting.type.periodic.meeting"/></option>
						</select>
					</div>
				</c:if>

				<div id="beginDateDiv" class="div-float hidden">
					<input type="text" name="textfield" id="fromDate" class="input-date cursor-hand" onclick="whenstart('${path}',this,575,140);" readonly>
						-
					<input type="text" name="textfield1" id="toDate" class="input-date cursor-hand" onclick="whenstart('${path}',this,575,140);" readonly>
				</div>

				<!-- 会议地点 -->
				<c:if test="${hasMeetingRoomApp }">
					<div id="roomDiv" class="div-float hidden"><%--xiangfan修改，需求确认：改为输入的方式 GOV-3717--%>
						<input type="text" name="textfield" id="textfield" class="textfield" />
					</div>
				</c:if>
				<!-- 会议分类 -->
				<c:if test="${hasMeetingType }">
					<div id="meetingTypeDiv" class="div-float hidden">
						<input type="text" name="textfield" id="textfield" class="textfield" />
					</div>
				</c:if>
				<!-- 视频会议  -->
				<c:if test="${hasVideoConferencePlugin }">
					<div id="meetingNatureDiv" class="div-float hidden">
					    <select name="textfield" id="textfield" class="textfield">
							  <option value="1"><fmt:message key="mt.mtMeeting.label.ordinary" /></option>
					          <option value="2"><fmt:message key="mt.mtMeeting.label.video" /></option>
						</select>
					</div>
				</c:if>

				<div onclick="search_result();" class="condition-search-button div-float"></div>
			</div>
		</form>
	</td>
</tr>
</table>
</div>
<!-- 按钮及小查询 end -->

<!-- 列表 start -->
<div class="center_div_row2" id="scrollListDiv">
<form id="listForm" name="listForm">
<input type="hidden" id="editType"/>
<input type="hidden" id='canSendSMS' name="canSendSMS" value="false"/>
<v3x:table htmlId="listTable" data="list" var="bean" leastSize="0">
	<c:choose>
		<c:when test="${bean.mtMeeting.proxy}">
			<c:set value="1" var="proxy" />
			<c:set value="${bean.mtMeeting.proxyId}" var="proxyId" />
		</c:when>
		<c:otherwise>
			<c:set value="0" var="proxy" />
			<c:set value="-1" var="proxyId" />
		</c:otherwise>
	</c:choose>
	<c:set value="" var="createAccountName" />

	<c:set value="displayMeetingDetail('${bean.mtMeeting.id}','${proxy}','${proxyId}');" var="click" />
	<!-- 会议已发列表，未召开时支持会议编辑 -->
	<c:choose>
		<c:when test="${false}">
			<c:set value="editMeeting('${bean.mtMeeting.id}');" var="dbClick" />
		</c:when>

	</c:choose>

	<c:set value="proxy-${bean.mtMeeting.proxy}" var="proxyClass"></c:set>

	<%------------- 复选框 -----------------%>
	<v3x:column width="5%" align="center" label="${selectAllInput }">
		<input type='checkbox' name='id' attFlag="${bean.mtMeeting.hasAttachments}" mName="${bean.mtMeeting.title}" state="${bean.mtMeeting.state}"
		roomState="${bean.mtMeeting.roomState}" recordState="${bean.mtMeeting.recordState }" periodicityInfoId="${bean.mtMeeting.periodicityInfoId }"
		value="<c:out value="${bean.mtMeeting.id}"/>" ${disabled} />
	</v3x:column>

	<%------------- 标题 -----------------%>
	<v3x:column width="38%" type="String" onClick="${click}" onDblClick="${dbClick }" label="mt.list.column.mt_name" className="cursor-hand sort" bodyType="${bean.mtMeeting.dataFormat}" hasAttachments="${bean.mtMeeting.hasAttachments}" alt="${createAccountName}${bean.mtMeeting.title}" maxLength="45" symbol="...">
		<c:choose>
			<c:when test="${bean.mtMeeting.roomState==2}"><%--会议室审核不通过名称标红 --%>
				<font color="red">${createAccountName}${v3x:toHTML(bean.mtMeeting.title)}</font>
			</c:when>
			<c:otherwise>
				${createAccountName}${v3x:toHTML(bean.mtMeeting.title)}
			</c:otherwise>
		</c:choose>
			<c:if test="${bean.mtMeeting.meetingType eq  '2' }">
                   <span class="bodyType_videoConf inline-block"></span>
        	</c:if>
		<script type="text/javascript">
			ht.add('${bean.mtMeeting.id}','${bean.mtMeeting.state}');
			createUserIdTable.add('${bean.mtMeeting.id}','${bean.mtMeeting.createUser}');
		</script>
	</v3x:column>

	<%------------- 会议开始时间 -----------------%>
	<v3x:column width="12%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.beginDate" className="cursor-hand sort">
		<fmt:formatDate pattern="${datePattern}" value="${bean.mtMeeting.beginDate}" />
	</v3x:column>

	<%------------- 会议结束时间 -----------------%>
	<v3x:column width="12%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="common.date.endtime.label" className="cursor-hand sort">
		<fmt:formatDate pattern="${datePattern}" value="${bean.mtMeeting.endDate}" />
	</v3x:column>

	<%------------- 会议地址 -----------------%>
	<c:if test="${hasMeetingRoomApp }">
		<v3x:column width="10%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.place" className="cursor-hand sort" >
			<c:if test="${not empty bean.mtMeeting.roomName}">
				${v3x:toHTML(bean.mtMeeting.roomName)}
			</c:if>
		</v3x:column>
	</c:if>

	<%------------- 发布情况 -----------------%>
	<v3x:column width="10%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.notice.desc" className="cursor-hand sort">
		<c:choose>
			<c:when test="${bean.mtMeeting.roomState==2}">
				<font color="red"><fmt:message key="mt.room.state.nopass"/></font>
			</c:when>
			<c:when test="${bean.mtMeeting.roomState==1 || bean.mtMeeting.roomState==-2}"><%--通过和审核通过 都改成'已发布' --%>
				<fmt:message key="mt.meeting.publish"/>
			</c:when>
			<c:when test="${bean.mtMeeting.roomState==3}"><%-- 发出周期性会议中已经结束的会议 还申请了会议室的，发布状态为空  --%>
				<%-- 这里就什么都不显示 --%>
			</c:when>
			<c:otherwise>
				<fmt:message key="mt.notice.state.auditing${bean.mtMeeting.roomState}"/>
			</c:otherwise>
		</c:choose>
	</v3x:column>

	<%------------- 会议状态 -----------------%>
	<v3x:column width="8%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.list.column.mt_state" className="cursor-hand sort">
		<c:choose>
			<c:when test="${bean.mtMeeting.state==10}">
				<fmt:message key="admin.label.mtNotStarted"/>
			</c:when>
			<c:when test="${bean.mtMeeting.state==20}">
				<fmt:message key="mt.mtMeeting.state.20"/>
			</c:when>
			<c:when test="${bean.mtMeeting.state==30 || bean.mtMeeting.state==-10}">
				<fmt:message key="mt.mtMeeting.state.30"/>
			</c:when>
			<c:when test="${bean.mtMeeting.state==40}">
				<fmt:message key="mt.mtMeeting.state.30"/>
			</c:when>
			<c:otherwise>
				<fmt:message key="mt.mtMeeting.state.${bean.mtMeeting.state}"/>
			</c:otherwise>
		</c:choose>
	</v3x:column>
	<%------------- 会议类型 -----------------%>
	<v3x:column width="8%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.meetingType" className="cursor-hand sort">
		<c:choose>
			<c:when test="${ empty bean.mtMeeting.periodicityInfoId }">
				<fmt:message key="mt.mtMeeting.type.one.meeting"/>
			</c:when>
			<c:otherwise>
				<fmt:message key="mt.mtMeeting.type.periodic.meeting"/>
			</c:otherwise>
		</c:choose>
	</v3x:column>

	<%------------- 会议分类 -----------------%>
	<c:if test="${hasMeetingType }">
		<v3x:column width="8%" type="String" onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.meetingCategory" className="cursor-hand sort" value="${bean.mtMeeting.mtType==null?'':bean.mtMeeting.mtType.name}">
		</v3x:column>
	</c:if>

</v3x:table>
</form>
</div><!-- center_div_row2 -->
<!-- 列表 end -->

</div><!-- right_div_row2 -->
</div><!-- main_div_row2 -->

</body>
</html>
