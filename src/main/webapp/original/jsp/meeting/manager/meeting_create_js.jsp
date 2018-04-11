<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- 当前位置：国际化定义 -->
<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' var="titleLabel" />
<c:if test="${bean.id!=null}">
	<fmt:message key='common.toolbar.edit.label' bundle='${v3xCommonI18N}' var="titleLabel" />
</c:if>
<fmt:message key="mt.mtMeeting" var="meetingTitle" />
<c:set value="${titleLabel }${meetingTitle }" var="titleLabel"></c:set>

<c:choose>
	<c:when test="${bean.id==null || bean.id==-1}">
		<c:set value="" var="meetingId" />
	</c:when>
	<c:otherwise>
		<c:set value="${bean.id}" var="meetingId" />
	</c:otherwise>
</c:choose>

<span style="display:none">
	<fmt:message key='common.toolbar.send.label' bundle='${v3xCommonI18N}' var='sendBtn' />
	<fmt:message key='collaboration.newcoll.save' var='saveBtn'/>
	<fmt:message key='common.toolbar.templete.label' bundle='${v3xCommonI18N}' var='openTemplateBtn' />
	<fmt:message key='mt.mtMeeting.state.convoked' var='donePanelLabel' />
	<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' var='insertBtn' />
	<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' var='insertAttsBtn' />
	<fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' var='insertDocBtn' />
	<fmt:message key='mt.templet.saveAs' var='saveAsBtn' />
	<fmt:message key="mt.list.column.mt_name" var="subjectLabel" />
	<fmt:message key="mt.mtMeeting.beginDate" var="beginDateLabel" />
	<fmt:message key="common.date.endtime.label" bundle="${v3xCommonI18N}" var="endDateLabel" />
	<fmt:message key="mt.mtMeeting.emceeId" var="emceeIdLabel" />
	<fmt:message key="mt.mtMeeting.recorderId" var="recorderIdLabel" />
	<fmt:message key="mt.mtMeeting.place" var="placeLabel" />
	<fmt:message key="mr.button.appMeetingRoom" var="roomAppLabel" />
	<fmt:message key="mt.mtMeeting.join" var="joinLabel" />
	<fmt:message key="mt.meeting.impart" var="impartLabel" />
	<fmt:message key="mt.mtMeeting.projectId" var="projectIdLabel" />
	<fmt:message key="meeting.mtMeeting.meetingNature" var="meetingNatureLabel" />
	<fmt:message key="mt.mtMeeting.password" var="passwordLabel" />
	<fmt:message key="mt.mtMeeting.letter.or.num" var="letterLabel" />
	<fmt:message key="mt.mtMeeting.password.confirm" var="passwordConfirmLabel" />
	<fmt:message key="mt.mtMeeting.character" var="characterLabel" />
	<fmt:message key="meeting.mtMeeting.label.video" var="videoLabel" />
	<fmt:message key="meeting.mtMeeting.label.ordinary" var="ordinaryLabel" />
	<fmt:message key="mt.resource" var="resourceLabel" />
	<fmt:message key="mt.mtMeeting.remindFlag" var="remindFlagLabel" />
	<fmt:message key="mt.mtMeeting.templateId" var="templateIdLabel" />
	<fmt:message key="mt.mtMeeting.beforeTime" var="beforeTimeLabel" />
	<fmt:message key="mt.mtMeeting.Remind" var="mtMtMeetingRemind" />
	<fmt:message key="mt.mtMeeting.messages" var="mtMtMeetingMessages" />
	<fmt:message key="meeting.create.more" var="moreLabel" />
	<fmt:message key="oper.please.select" var="selectLabel" />
	<fmt:message key="mt.meMeeting.decription" var="roomDecription" />
	<fmt:message key="mt.meetingAddress.input.plea" var="roomInput" />
	<fmt:message key="oper.load" var="loadLabel" />
	<fmt:message key="label.colon" var="colonLabel" />
	
	<fmt:message key="mt.repeat.cycle.setting" var="cycleTitle" />

	<fmt:message key="label.please.input" var="subjectDefaultLabel">
		<fmt:param value="${subjectLabel }" />
    </fmt:message>

	<fmt:message key="label.please.select" var="emceeDefaultLabel">
		<fmt:param value="${emceeIdLabel}" />
	</fmt:message>
	
	<fmt:message key="label.please.select" var="recorderDefaultLabel">
		<fmt:param value="${recorderIdLabel}" />
	</fmt:message>

	<fmt:message key="label.please.select" var="confereesDefaultLabel">
		<fmt:param value="${joinLabel}" />
	</fmt:message>

	<fmt:message key="label.please.select" var="impartDefaultLabel">
		<fmt:param value="${impartLabel}" />
	</fmt:message>

	<fmt:message key="label.please.select" var="resourceDefaultLabel">
		<fmt:param value="${resourceLabel}" />
	</fmt:message>
	
	<fmt:message key="mt.mtMeeting.title" var="mtTitleLabel" />
	<fmt:message key="label.please.input" var="mtTitleDefaultLabel">
		<fmt:param value="${mtTitleLabel }" />
    </fmt:message>

	<fmt:message key="mt.mtMeeting.leader" var="leaderLabel" />
	<fmt:message key="label.please.input" var="leaderDefaultLabel">
		<fmt:param value="${leaderLabel }" />
    </fmt:message>

	<fmt:message key="mt.mtMeeting.attender" var="attenderLabel" />
	<fmt:message key="label.please.input" var="attenderDefaultLabel">
		<fmt:param value="${attenderLabel }" />
    </fmt:message>
    
    <fmt:message key="mt.mtMeeting.tel" var="telLabel" />
	<fmt:message key="label.please.input" var="telDefaultLabel">
		<fmt:param value="${telLabel }" />
    </fmt:message>

	<fmt:message key="mt.mtMeeting.note" var="noteLabel" />
	<fmt:message key="label.please.input" var="noteDefaultLabel">
		<fmt:param value="${noteLabel }" />
    </fmt:message>
    
    <fmt:message key="meeting.mtMeeting.plan" var="planLabel" />
	<fmt:message key="label.please.input" var="planDefaultLabel">
		<fmt:param value="${planLabel }" />
    </fmt:message>

	<fmt:message key="mt.mtMeeting.meetingCategory" var="categoryLabel" />
	 <fmt:message key="meeting.collide.remind" var="collideTitleLabel" />
	<fmt:formatDate pattern="${datetimePattern}" value="${newVo.meeting.beginDate}" var="beginDateValue" />
	<fmt:formatDate pattern="${datetimePattern}" value="${newVo.meeting.endDate}" var="endDateValue" />
	<fmt:formatDate pattern="yyyy-MM-dd" value="${newVo.periodicity.startDate}" var="periodicityStartDateValue" />
	<fmt:formatDate pattern="yyyy-MM-dd" value="${newVo.periodicity.endDate}" var="periodicityEndDateValue" />
	<fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd HH:mm" var="nowDate"/>
</span>


<c:set value="${v3x:showOrgEntities(newVo.emceeList, 'id' , 'entityType' , pageContext)}" var="emceeNameList"/>
<c:set value="${v3x:showOrgEntities(newVo.recorderList, 'id' , 'entityType' , pageContext)}" var="recorderNameList"/>
<c:set value="${v3x:showOrgEntities(newVo.confereeList, 'id' , 'entityType' , pageContext)}" var="confereeNameList"/>
<c:set value="${v3x:showOrgEntities(newVo.impartList, 'id' , 'entityType' , pageContext)}" var="impartNameList"/>
<c:set value="${v3x:showOrgEntities(newVo.leaderList, 'id' , 'entityType' , pageContext)}" var="leaderNameList"/>

<c:set value="${v3x:parseElements(newVo.emceeList, 'id', 'entityType')}" var="emceeList"/>
<c:set value="${v3x:parseElements(newVo.recorderList, 'id', 'entityType')}" var="recorderList"/>
<c:set value="${v3x:parseElements(newVo.confereeList, 'id', 'entityType')}" var="confereesList"/>
<c:set value="${v3x:parseElements(newVo.leaderList, 'id', 'entityType')}" var="leaderList"/>
<c:set value="${v3x:parseElements(newVo.impartList, 'id', 'entityType')}" var="impartList"/>
<c:set value="${v3x:parseElements(newVo.createUserList, 'id', 'entityType')}" var="createUser"/>

<v3x:selectPeople id="emceeSelect" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${emceeList}" panels="Department,Team,Outworker" maxSize="1" selectType="Member" jsFunction="peopleCallback_emcee(elements,'emceeId','emceeName')" />
<v3x:selectPeople id="recorderSelect" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${recorderList}" panels="Department,Team,Outworker" maxSize="1" minSize="0" selectType="Member" jsFunction="peopleCallback_recorder(elements,'recorderId','recorderName')" />
<v3x:selectPeople id="confereesSelect" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${confereesList}" panels="Department,Team,Post,Outworker,Level" selectType="Account,Member,Department,Team,Post,Level" jsFunction="peopleCallback_conferees(elements,'conferees','confereesNames')" />
<v3x:selectPeople id="impartSelect"    departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${impartList}"    panels="Department,Team,Post,Outworker,Level" minSize="0" selectType="Account,Member,Department,Team,Post,Level" jsFunction="peopleCallback_impart(elements,'impart','impartNames')" />
<v3x:selectPeople id="leaderSelect" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${leaderList}" panels="Department,Team,Post,Outworker" minSize="0" selectType="Member" jsFunction="peopleCallback_leader(elements,'leader','leaderNames')" />
<v3x:selectPeople id="createUserSelect" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${createUser}" panels="Department,Team,Post,Outworker" selectType="Member" jsFunction="peopleCallback_createUser(elements,'createUser','createUserName')" />

<script>

var _path = "${path}";

var pageX = {};
pageX.meeting = {};
pageX.periodicity = {};
pageX.meetingRoomApp = {};

pageX.html = {};
pageX.i18n = {};

pageX.action = "${newVo.action}";

pageX.meeting.id = "${newVo.meeting.id}";
pageX.meeting.state = "${newVo.meeting.state}";
pageX.meeting.title = "${v3x:escapeJavascript(newVo.meeting.title)}";
pageX.meeting.createUser = "${newVo.meeting.createUser}";
pageX.meeting.dataFormat = "${newVo.meeting.dataFormat}";
pageX.meeting.beginDate = "${beginDateValue}";
pageX.meeting.endDate = "${endDateValue}";
pageX.meeting.beforeTime = "${newVo.meeting.beforeTime}";
pageX.meeting.projectId = "${newVo.meeting.projectId}";
pageX.meeting.contentTemplateId = "${newVo.contentTemplateId}";
pageX.meeting.meetingTypeId = "${newVo.meeting.meetingTypeId}";
pageX.meeting.meetingType = "${newVo.meeting.meetingType}";
pageX.meeting.resourcesName = "${newVo.resourcesName}";
pageX.meeting.room = "${newVo.meeting.room}";
pageX.meeting.roomAppId = "${newVo.myMeetingroomAppedName.option2Id}";
pageX.meeting.password = "${newVo.meeting.meetingPassword}";
pageX.meeting.emceeId = "${newVo.meeting.emceeId}";
pageX.meeting.recorderId = "${newVo.meeting.recorderId}";
pageX.meeting.emceeName = "${v3x:escapeJavascript(emceeNameList)}";
pageX.meeting.recorderName = "${v3x:escapeJavascript(recorderNameList)}";
pageX.meeting.confereesNames = "${v3x:escapeJavascript(confereeNameList)}";
pageX.meeting.impartNames = "${v3x:escapeJavascript(impartNameList)}";
pageX.meeting.isSendTextMessages = "${newVo.meeting.isSendTextMessages}";

pageX.meetingRoomApp.id = "${newVo.roomAppId}";

pageX.periodicity.id = "${newVo.periodicity.id}";
pageX.periodicity.periodicityType = "${newVo.periodicity.periodicityType}";
pageX.periodicity.scope = "${newVo.periodicity.scope}";
pageX.periodicity.startDate = "${periodicityStartDateValue}";
pageX.periodicity.endDate = "${periodicityEndDateValue}";

pageX.html.showPasswordArea = "${v3x:hasPlugin('videoconference') && newVo.isVideoEnable && newVo.isShowPassword}";
pageX.html.title = "${v3x:toHTMLWithoutSpace(bean.title)}";
pageX.html.listType = "listSendMeeting";
pageX.html.systemNowDatetime = "${nowDate}";
pageX.html.isBatch = "${newVo.isBatch}";
pageX.html.portalRoomAppId = "${portalRoomAppId}";

pageX.i18n.saveBtnLabel = "${saveBtn}";
pageX.i18n.openTemplateBtnLabel = "${openTemplateBtn}";
pageX.i18n.saveAsBtnLabel = "${saveAsBtn}";
pageX.i18n.subjectLabel = "${subjectLabel}";
pageX.i18n.subjectDefaultLabel = "${subjectDefaultLabel}";
pageX.i18n.beginDateLabel = "${beginDateLabel}";
pageX.i18n.endDateLabel = "${endDateLabel}";
pageX.i18n.emceeDefaultLabel = "${emceeDefaultLabel}";
pageX.i18n.recorderDefaultLabel = "${recorderDefaultLabel}";
pageX.i18n.confereesDefaultLabel = "${confereesDefaultLabel}";
pageX.i18n.impartDefaultLabel = "${impartDefaultLabel}";
pageX.i18n.resourceDefaultLabel = "${resourceDefaultLabel}";
pageX.i18n.emceeLabel = "${emceeIdLabel}";
pageX.i18n.recorderLabel = "${recorderIdLabel}";
pageX.i18n.confereesLabel = "${joinLabel}";
pageX.i18n.impartLabel = "${impartLabel}";
pageX.i18n.resourceLabel = "${resourceLabel}";
pageX.i18n.cycleTitle = "${cycleTitle}";
pageX.i18n.colonLabel = "${colonLabel}";
pageX.i18n.collideTitleLabel = "${collideTitleLabel}";
</script>

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" href="${path}/common/all-min.css" />
<link rel="stylesheet" href="${path}/skin/default/skin.css" />

<jsp:include page="../include/deal_exception.jsp" />

<input type="hidden" id="meetingTypeContent_1" keyName="mtTitle" value="${v3x:toHTML(newVo.meeting.mtTitle) }" selectPerson="true" readOnly="false" maxLength="85" defaultLabel="${mtTitleDefaultLabel }" label="${mtTitleLabel }" />
<input type="hidden" id="meetingTypeContent_2" keyName="leaderNames" keyId="leader" value="${v3x:toHTML(leaderNameList )}" idValue="${newVo.meeting.leader }" readOnly="true" cursor="cursor-hand" maxLength="85" defaultLabel="${leaderDefaultLabel }" label="${leaderLabel }" />
<input type="hidden" id="meetingTypeContent_3" keyName="attender" value="${v3x:toHTML(newVo.meeting.attender) }" readOnly="false" maxLength="85" defaultLabel="${attenderDefaultLabel }" label="${attenderLabel }" />
<input type="hidden" id="meetingTypeContent_4" keyName="tel" value="${v3x:toHTML(newVo.meeting.tel) }" readOnly="false" maxLength="50" defaultLabel="${telDefaultLabel }" label="${telLabel }" />
<input type="hidden" id="meetingTypeContent_5" keyName="notice" value="${newVo.meeting.notice }" readOnly="true" maxLength="200" cursor="cursor-hand" defaultLabel="${noteDefaultLabel }" label="${noteLabel }" />
<input type="hidden" id="meetingTypeContent_6" keyName="plan" value="${newVo.meeting.plan }" readOnly="true" maxLength="200" cursor="cursor-hand" defaultLabel="${planDefaultLabel }" label="${planLabel }" />
