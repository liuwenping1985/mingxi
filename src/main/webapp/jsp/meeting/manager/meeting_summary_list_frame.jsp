<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../include/meeting_taglib.jsp" %>
<%@ include file="../include/meeting_header.jsp" %>
<%@ include file="meeting_summary_list_js.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script type="text/javascript">
var myBar = new WebFXMenuBar("${path}");

//编辑
myBar.add(new WebFXMenuButton("editBtn", "${editLabel}", "editMeetingSummary();", [1,2], "", null));
//撤销
myBar.add(new WebFXMenuButton("cancelBtn", "${cancelLabel}", "cancelMeetingSummary();", [3,8], "", null));
//转发
var transmit = new WebFXMenu;
var transmitFlag = false;
<c:if test="${hasColPlugin && hasNewCollMenu}">
	transmit.add(new WebFXMenuItem("transCol", "${summaryToColLabel}", "summaryTransmit(1)", ""));
</c:if>
<c:if test="${hasEdocPlugin && isEdocCreateRole}">
	transmit.add(new WebFXMenuItem("transEdoc", "${summaryToEdocLabel}", "summaryTransmit(2)", ""));
</c:if>
if(transmit.hasChild() && v3x.getBrowserFlag('hideMenu')){
	myBar.add(new WebFXMenuButton("transmit", "<fmt:message key='mt.list.trans.lable' />", null, [1,7], "", transmit));
}

/** 按钮页签 **/
//已召开
myBar.add(new WebFXMenuButton("donePanel", "${donePanelLabel}", "javascript:setPanelURL('listDoneMeeting');", [4,9], "", null));
//会议纪要
myBar.add(new WebFXMenuButton("summaryPanel", "${summaryPanelLabel}", "javascript:setPanelURL('listMeetingSummary');", [4,3], "", null));

</script>

</head>
<body class="page_color">

<div class="main_div_row2">

<div class="right_div_row2">

<!-- 按钮及小查询 start -->
<div class="top_div_row2">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="webfx-menu-bar border-left border-top">
			<script type="text/javascript">document.write(myBar);</script>
		</td>
		<td class="webfx-menu-bar border-right border-top">
			<form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
				<input type="hidden" value="<c:out value='${param.method}' />" name="method" /> 
				<input type="hidden" value="${param.stateStr}" name="stateStr" />
				<input type="hidden" value="${from}" name="searchForm" id="searchForm"/>
				<input type="hidden" value="${listType}" name="searchListType" id="searchListType"/>
				<input type="hidden" value="${listType}" name="listType" id="listType"/>
				
				<div class="div-float-right condition-search-div">
					<div class="div-float">
						<select name="condition" id="condition" onChange="ChangedEvent(this)" class="condition">
							<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							<option value="mtName"><fmt:message key="mt.list.column.mt_name" /></option>
							<option value="periodicityInfoId"><fmt:message key="mt.list.column.mt_type" /></option>
							<c:if test="${hasVideoConferencePlugin }">
								<option value="meetingNature"><fmt:message key="mt.mtMeeting.meetingNature" /></option>
							</c:if>
							<option value="createUser"><fmt:message key='mt.mtMeeting.publishUser' /></option>
							<option value="mtBeginDate"><fmt:message key="mt.searchdate" /></option>
							<option value="summaryCreateDate"><fmt:message key="mt.summary.createDate" /></option>
							<c:if test="${hasMeetingType }">
	                            <option value="mtTypeName"><fmt:message key="mt.mtMeeting.meetingCategory" /></option>
	                        </c:if>
						</select>
					</div>
					
					<div id="mtNameDiv" class="div-float hidden">
						<input type="text" name="textfield" class="textfield" />
					</div>
					
                    <div id="periodicityInfoIdDiv" class="div-float hidden">
                        <select name="textfield" id="textfield" class="textfield">
                            <option value="one"><fmt:message key="mt.mtMeeting.type.one.meeting"/></option>
                            <option value="periodic"><fmt:message key="mt.mtMeeting.type.periodic.meeting"/></option>
                        </select>
                    </div>
					
				    <c:if test="${hasMeetingType }">
					    <div id="mtTypeNameDiv" class="div-float hidden">
	                      	<%-- 这里注释保留，预防需求变回，会议分类 使用下拉选择
	                      	<select name="textfield" id="textfield" class="textfield">
		                    	<c:forEach var="meetingType" items="${typeList}"> 
			                  		<option value="${meetingType.name}">${meetingType.name}</option>
		                    	</c:forEach>
	                      	</select> --%>
	                      	<input type="text" name="textfield" id="textfield" class="textfield" />
	                    </div>
	                 </c:if>
					
					<div id="createUserDiv" class="div-float hidden">
						<input type="text" name="textfield" id="textfield" class="textfield" />
					</div>
					
					<div id="mtBeginDateDiv" class="div-float hidden">
						<input type="text" name="textfield" id="fromDate" class="input-date cursor-hand" onclick="selectDateTime(this);" readonly /> 
						- 
						<input type="text" name="textfield1" id="toDate" class="input-date cursor-hand" onclick="selectDateTime(this);" readonly />
					</div>
					
					<div id="summaryCreateDateDiv" class="div-float hidden">
						<input type="text" name="textfield" id="summaryFromDate" class="input-date cursor-hand" onclick="selectDateTime(this);" readonly /> 
						- 
						<input type="text" name="textfield1" id="summaryToDate" class="input-date cursor-hand" onclick="selectDateTime(this);" readonly />
					</div>
					
					<!-- 视频会议  -->
					<c:if test="${hasVideoConferencePlugin }">
						<div id="meetingNatureDiv" class="div-float hidden">
						    <select name="textfield" id="textfield" class="textfield">
								  <option value="1"><fmt:message key="mt.mtMeeting.label.ordinary" /></option>
						          <option value="2"><fmt:message key="mt.mtMeeting.label.video" /></option>
							</select>
						</div>
					</c:if>
					<div onclick="search_result()" class="condition-search-button div-float"></div>
				</div>
			</form>
		</td>
	</tr>
</table>
</div><!-- top_div_row2 -->
<!-- 按钮及小查询 end -->

<!-- 列表 start -->
<div class="center_div_row2" id="scrollListDiv">
<form name="listForm" id="listForm">
<input id="content" name='content' type='hidden' value="" />
<v3x:table htmlId="listTable" data="list" var="bean" leastSize="0" bundle="${v3xMeetingSummaryI18N}">
							
	<c:set value="displayMeetingSummaryDetail('${bean.id }','${bean.meetingId}')" var="click" />
	<c:choose>
		<c:when test="${false}">
			<c:set value="editMeetingSummary()" var="dbClick" />
		</c:when>
		<c:otherwise>
			<c:set value="openMeetingSummaryDetail('${bean.id}', '${bean.meetingId }');" var="dbClick" />
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
    <c:choose>
        <c:when test="${(v3x:currentUser().id!=bean.createUser)}">
            <c:set value="disabled" var="disabled" />
        </c:when>
        <c:otherwise>
            <c:set value="" var="disabled" />
        </c:otherwise>
    </c:choose>
	<!-- 选择框  -->
	<v3x:column width="5%" align="center" label="${selectAllInput }">
		<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" createUser ="${bean.createUser}" state="${bean.state}" ${disabled} />
	</v3x:column>
	
	<!-- 会议名称  -->
	<v3x:column width="47%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.list.column.mt_name" className="cursor-hand sort mxtgrid_black" bodyType="${bean.dataFormat}" hasAttachments="${bean.hasAttachments}" alt="${createAccountName}${bean.mtName}">
		${createAccountName}${bean.mtName}
			<c:if test="${bean.meetingType eq  '2' }">
				<span class="bodyType_videoConf inline-block"></span>
        	</c:if>
	</v3x:column>
	
	<!-- 发起人  -->
	<v3x:column width="8%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.createUser" className="cursor-hand sort">
		${v3x:showMemberName(bean.createUser)}
	</v3x:column>
	<!-- 发起部门 -->
	<v3x:column width="10%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.senddept" className="cursor-hand sort">
		${v3x:getDepartment(v3x:getMember(bean.createUser).orgDepartmentId).name}
	</v3x:column>
	<!-- 记录人 -->
	<v3x:column width="8%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.recorderId" className="cursor-hand sort">
		${v3x:showMemberName(bean.recorderId)}
	</v3x:column>
	
	<!-- 会议类型  -->
	<v3x:column width="8%" type="String"  onClick="${click}" label="mt.mtMeeting.meetingType" className="cursor-hand sort">
        <c:choose>
            <c:when test="${ empty bean.periodicityInfoId }">
                <fmt:message key="mt.mtMeeting.type.one.meeting"/>
            </c:when>
            <c:otherwise>
                <fmt:message key="mt.mtMeeting.type.periodic.meeting"/>
            </c:otherwise>
        </c:choose>
    </v3x:column>
    
    <!-- 会议分类 -->
    <c:if test="${hasMeetingType }">
        <v3x:column width="8%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.meetingCategory" className="cursor-hand sort">
            ${bean.mtTypeName}
        </v3x:column>
    </c:if>
	
	<!-- 纪要发起时间  xiangfan 添加 修复GOV-2057 没有'纪要发起时间'列头错误 -->
	<v3x:column width="11%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.summary.createDate" className="cursor-hand sort">
		<fmt:formatDate pattern="${datePattern}" value="${bean.createDate}" />
	</v3x:column>
							
	<!-- 会议时间  -->
	<v3x:column width="11%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.searchdate" className="cursor-hand sort">
		<fmt:formatDate pattern="${datePattern}" value="${bean.mtBeginDate}" />
	</v3x:column>
	
	<!-- 会议地址  -->
	<%-- <c:if test="${hasMeetingRoomApp }">
		<v3x:column width="10%" type="String"  onClick="${click}" onDblClick="${dbClick }" label="mt.mtMeeting.place" className="cursor-hand sort">
			${bean.mtRoomName}
		</v3x:column>
	</c:if> --%>
	
</v3x:table>
</form>
</div><!-- center_div_row2 -->
<!-- 列表 end -->

</body>
</html>
