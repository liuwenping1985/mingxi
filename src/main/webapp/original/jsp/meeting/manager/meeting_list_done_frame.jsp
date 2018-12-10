<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../include/meeting_taglib.jsp" %>
<%@ include file="../include/meeting_header.jsp" %>
<%@ include file="meeting_list_js.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script type="text/javascript">
var myBar = new WebFXMenuBar("${path}");

//归档
<c:if test="${hasDocPlugin }">
	myBar.add(new WebFXMenuButton("pigeonholeBtn", "${pigeonholeLabel}", "meetingPigeonhole();", [1,9], "", null));
</c:if>
//删除
myBar.add(new WebFXMenuButton("delBtn", "${deleteLabel}",  "javascript:deleteMeeting()", [1,3], "", null));

/** 按钮页签 **/
//已召开
myBar.add(new WebFXMenuButton("donePanel", "${donePanelLabel}", "javascript:setPanelURL('listDoneMeeting');", [4,9], "", null));
//会议纪要
myBar.add(new WebFXMenuButton("summaryPanel", "${summaryPanelLabel}", "javascript:setPanelURL('listMeetingSummary');", [4,3], "", null));

//新建任务
<c:if test="${canNewTask}">
myBar.add(new WebFXMenuButton("summaryPanel", "${newTaskButton}", "javascript:newTaskInfoBtn();", [14,1], "", null));
</c:if>
//-->
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
						<option value="createUser"><fmt:message key='mt.mtMeeting.createUser' /></option>
						<option value="sendDept"><fmt:message key='mt.senddept' /></option>
						<option value="beginDate"><fmt:message key="mt.searchdate" /></option>
						<option value="meetingSummary"><fmt:message key="meeting.summary.record.publish" /></option>
						<!-- 会议方式(普通/视频) -->
						
							<option value="meetingNature"><fmt:message key="mt.mtMeeting.meetingNature" /></option>
						
						<!-- 会议类型 (单次 /周期)-->
						<option value="category"><fmt:message key="mt.list.column.mt_type" /></option>
						<!-- 会议分类(普通/重要) -->
						<option value="meetingTypeId"><fmt:message key="mt.mtMeeting.meetingCategory" /></option>
					</select>
				</div>

				<div id="titleDiv" class="div-float hidden">
					<input type="text" name="textfield" class="textfield">
				</div>

				<div id="createUserDiv" class="div-float hidden">
					<input type="text" name="textfield" id="textfield" class="textfield" />
				</div>

				<div id="sendDeptDiv" class="div-float hidden">
					<input type="text" name="textfield" id="textfield" class="textfield" />
				</div>

				<div id="beginDateDiv" class="div-float hidden">
					<input type="text" name="textfield" id="fromDate" class="input-date cursor-hand" onclick="whenstart('${path}',this,575,140);" readonly>
						-
					<input type="text" name="textfield1" id="toDate" class="input-date cursor-hand" onclick="whenstart('${path}',this,575,140);" readonly>
				</div>

				<!-- 会议纪要 -->
				<div id="meetingSummaryDiv" class="div-float hidden">
				    <select name="textfield" id="textfield" class="textfield">
						  <option value="1">新建纪要</option>
				          <option value="2">查看纪要</option>
					</select>
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

<form id="listForm">

<v3x:table htmlId="listTable" data="list" var="bean" leastSize="0">
	<c:set value="${(CurrentUser.id==bean.recorderId) || (bean.recorderId==-1&&CurrentUser.id==bean.emceeId) }" var="canRecord"></c:set>
	<c:set value="${bean.proxyId}" var="proxyId" />
	<c:set value="proxy-${bean.proxyId==-1 ? 0 : 1}" var="proxyClass" />

	<c:set value="displayMeetingDetail('${bean.id}', '${proxyId}');" var="click" />

	<%------------- 复选框 -----------------%>
	<v3x:column width="4%" align="center" label="${selectAllInput }">
		<input type='checkbox' name='id' canRecord="${canRecord}" attFlag="${bean.hasAttachments}" mName="${bean.title}" state="${bean.state}" roomState="${bean.roomState}" recordState="${bean.recordState }" value="<c:out value="${bean.id}"/>" ${disabled} />
	</v3x:column>

	<%------------- 标题 -----------------%>
	<v3x:column width="22%" type="String"  onClick="${click}" label="mt.list.column.mt_name" className="cursor-hand sort mxtgrid_black ${bean.state==10 ? (proxyClass) : ''}" bodyType="${bean.bodyType}" hasAttachments="${bean.hasAttachments}" alt="${bean.title}" maxLength="45" symbol="...">
		<c:choose>
			<c:when test="${bean.proxyId != -1}">
				${v3x:toHTML(bean.title)}
				<c:if test="${bean.proxyId ne null and bean.proxyId ne -1 }">
				  (<fmt:message key="mt.agent" />${v3x:showMemberName(bean.proxyId)})
				</c:if>
			</c:when>
			<c:otherwise>
				${v3x:toHTML(bean.title)}
			</c:otherwise>
		</c:choose>
		
		<c:if test="${bean.meetingType eq  '2' }">
                  <span class="bodyType_videoConf inline-block"></span>
       	</c:if>
       	
		<script type="text/javascript">
			ht.add("${bean.id}","${bean.state}");
			createUserIdTable.add("${bean.id}","${bean.createUser}");
			recorderUserIdTable.add("${bean.id}","${bean.recorderId}");
			emceeUserIdTable.add("${bean.id}","${bean.emceeId}");
		</script>
	</v3x:column>

	<%------------- 发起人 -----------------%>
	<v3x:column width="8%" type="String"  onClick="${click}" label="mt.mtMeeting.createUser" className="cursor-hand sort">
		${ctp:toHTML(v3x:showMemberName(bean.createUser))}
	</v3x:column>

	<%------------- 发起部门 -----------------%>
	<v3x:column width="8%" type="String"  onClick="${click}" label="mt.senddept" className="cursor-hand sort">
		${v3x:getDepartment(v3x:getMember(bean.createUser).orgDepartmentId).name}
	</v3x:column>

	<%------------- 会议纪要 -----------------%>
	<v3x:column width="6%" type="String" label="mt.meetingrecord" className="cursor-hand sort">
		<c:choose>
			<c:when test="${empty bean.recordName }">
                <c:choose>
				<c:when test="${canRecord eq true}">
					<a href="javascript:meetingSummaryCreate('${bean.id }', '${bean.recordId }')"><fmt:message key="mt.summary.create.lable"></fmt:message></a>
				</c:when>
                <c:otherwise>
                    <fmt:message key="mr.label.no"></fmt:message>
                </c:otherwise>
                </c:choose>
			</c:when>
			
			<%--当前为告知的列不显示查看会议纪要--%> 
			<c:when test="${bean.isImpart }">
				<fmt:message key="mr.label.no"></fmt:message>
			</c:when>
			<c:otherwise>
				<a onclick="javascript:openMeetingSummaryDetail('${bean.recordId}', '${bean.id}','isYes', '${listType}')">
					<fmt:message key="mt.summary.view.lable"></fmt:message>
				</a>
			</c:otherwise>
			
		</c:choose>
	</v3x:column>
	
	
	<%-- 会议任务 --%>
	<c:if test="${hasPluginTask}">
	<v3x:column width="6%" type="String" label="mt.com.seeyon.apps.task.label" className="cursor-hand sort">
		<c:choose>
			<c:when test="${bean.taskTotal == 0}">
                <c:choose>
				<c:when test="${canRecord eq true && canNewTask eq true}">
					<a href="javascript:newTaskInfo('${bean.id}')">
						<fmt:message key="mt.task.create.label"></fmt:message>
					</a>
				</c:when>
                <c:otherwise>
                    <fmt:message key="mr.label.no"></fmt:message>
                </c:otherwise>
                </c:choose>
			</c:when>
			
			<%--当前为告知的列不显示查看会议纪要--%> 
			<c:when test="${bean.isImpart }">
				<fmt:message key="mr.label.no"></fmt:message>
			</c:when>
			<c:otherwise>
				<a onclick="javascript:openMeetingTaskDetail('${bean.id}', '${canRecord}')">
					${bean.taskTotal}
				</a>
			</c:otherwise>
		</c:choose>
	</v3x:column>
	</c:if>

	<%------------- 会议开始时间 -----------------%>
	<v3x:column width="10%" type="String"  onClick="${click}" label="mt.mtMeeting.beginDate" className="cursor-hand sort">
		<fmt:formatDate pattern="${datePattern}" value="${bean.beginDate}" />
	</v3x:column>

	<%------------- 会议结束时间 -----------------%>
	<v3x:column width="10%" type="String"  onClick="${click}" label="common.date.endtime.label" className="cursor-hand sort">
		<fmt:formatDate pattern="${datePattern}" value="${bean.endDate}" />
	</v3x:column>

	<%------------- 会议地址 -----------------%>
	<v3x:column width="9%" type="String"  onClick="${click}" label="mt.mtMeeting.place" className="cursor-hand sort" >
		<c:choose>
			<c:when test="${not empty bean.meetPlace}">
				${v3x:toHTML(bean.meetPlace)}
			</c:when>
			<c:when test="${not empty bean.roomName}">
				${v3x:toHTML(bean.roomName)}
			</c:when>
		</c:choose>
	</v3x:column>

	<%------------- 归档-----------------%>
	<c:if test="${hasDocPlugin }">
	<v3x:column width="5%" type="String"  onClick="${click}" label="mt.notice.state.pigeonhole" className="cursor-hand sort">
		<fmt:message key="${bean.state==-10 ? 'mt.mtMeeting.state.-10' : 'mt.notice.state.pigeonhole.not'}"/>
	</v3x:column>
	</c:if>
	
	<%------------- 会议类型 (单次 /周期) -----------------%>
	<v3x:column width="6%" type="String"  onClick="${click}" label="mt.mtMeeting.meetingType" className="cursor-hand sort">
		<c:choose>
			<c:when test="${bean.category == 0 }">
				<fmt:message key="mt.mtMeeting.type.one.meeting"/>
			</c:when>
			<c:otherwise>
				<fmt:message key="mt.mtMeeting.type.periodic.meeting"/>
			</c:otherwise>
		</c:choose>
	</v3x:column>

	<%------------- 会议分类 -----------------%>
	<v3x:column width="6%" type="String" onClick="${click}" label="mt.mtMeeting.meetingCategory" className="cursor-hand sort" value="${bean.meetingTypeName}">
	</v3x:column>

</v3x:table>
</form>
</div><!-- center_div_row2 -->
<!-- 列表 end -->

</div><!-- right_div_row2 -->
</div><!-- main_div_row2 -->

</body>
</html>
