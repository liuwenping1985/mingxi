<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html:link renderURL='/meetingroom.do' var='mrUrl' />
<html>
<head>
<%@ include file="../../migrate/INC/noCache.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/addressbook/js/prototype.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/meeting/js/leave.js${v3x:resSuffix()}" />"></script>
<c:if test="${(listType eq 'waitRecord' || listType eq 'draft')}"><%--xiangfan 添加 只有在起草会议纪要时 离开会弹出是否保存到草稿箱的窗口，因为在我发布的会议纪要里 没有保存到草稿箱的功能 --%>
	<script>
		window.onload = function() {
			initLeave(0);
		}
		window.onbeforeunload = function() {
			onbeforeunload();
		}
		window.onunload = function() {
			myOnUnload();
		}
	</script>
</c:if>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body scroll='no' style="overflow-y:hidden;">
<script type="text/javascript">

	//if(getA8Top()!=null && typeof(getA8Top().showLocation)!="undefined") {
	//	getA8Top().showLocation(2104,"<fmt:message key='mtSummary.create.lable'  bundle="${v3xMeetingSummaryI18N}"/>");
	//}
	var myBar = new WebFXMenuBar("/seeyon");	
	var insert = new WebFXMenu;
	insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
	insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' />", "quoteDocument()"));
	
	//发送
	<c:if test="${bean.state == 0 || bean.state == 1 || bean.state == 7}">
		myBar.add(new WebFXMenuButton("send", "<fmt:message key='common.toolbar.send.label' bundle='${v3xCommonI18N}' />", "toSend('send');", [1,4], "", null));
	</c:if>

	//保存
	myBar.add(new WebFXMenuButton("save", "<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' />", "toSend('save');", [1,4], "", null));
	
	//插入
	myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, [1,6], "", insert));
	
	//正文类型
	myBar.add(${v3x:bodyTypeSelector("v3x")});
	
	//正文类型下拉选择
	if(bodyTypeSelector){
		bodyTypeSelector.disabled("menu_bodytype_${bean.dataFormat}");
	}
	
	//返回
	myBar.add(new WebFXMenuButton("cancel", "<fmt:message key='common.toolbar.back.label' bundle='${v3xCommonI18N}' />", "doBack();", [7,4], "",null ));

	// 调用send方法
   	function toSend(type){
   		document.getElementById('formOper').value = type;
   		if(document.getElementById("isAudit") !=null && document.getElementById("auditors") != null){
    		if( type == 'send' && document.getElementById("isAudit").checked && document.getElementById("auditors").value == ""){
    			alert("审核人员不能为空!");
    			return false;
    		}
   		}
		saveAttachment();
		cloneAllAttachments();
		isHasAtts();
		meetingSaveOffice();
		//TODO
   		//getA8Top().startProc('');
 		disableButtons();
 		document.getElementById('dataForm').target="";
 		document.getElementById('dataForm').submit();
 		/*** 是否离开当前页面处理 start ***/
   		reductClick(false);
        topLinkClick(false); 
        /*** 是否离开当前页面处理 end ***/
   	}
	
	//xiangfan 添加 2012-04-17
	function doBack(){
		//编辑'我发布的会议纪要'中的纪要，'返回'时要跳转到'我发布的会议纪要'页面
		/*if("${listType}" != "waitRecord"){
			//getA8Top().contentFrame.mainFrame.location.href  = "${mtSummaryURL}?method=listHome&from=${from}&listType=${listType}";
		}else {
			//xiangfan　添加　修复GOV-2052　"返回"时，没有弹出警示框 2012-04-23
			if(confirm("确定要离开该页面吗?\n\n\n\n 按“确定”继续，或按“取消”留在当前页面。")){
			//	parent.treeFrame.location.href = "mtSummary.do?method=listLeft&from=${from}&listType=${listType}";
				self.history.back();
			}
		}*/
		if(confirm("确定要离开该页面吗?\n\n\n\n 按“确定”继续，或按“取消”留在当前页面。")){
			self.history.back();
		}
	}
   	
	function isHasAtts(){
		if(fileUploadAttachments.size()>0){
			document.getElementById("isHasAtt").value = "true";
		} else {
		    document.getElementById("isHasAtt").value = "false";
		}
	}
	
	function chanageBodyTypeExt(type){
		if(chanageBodyType(type)) {
			document.getElementById('dataFormat').value=type;
		}
	}
	
	//xiangfan 添加	
	function saveAsDraft(checkFlag){
		//if(!myCheckForm(document.getElementById('dataForm'))) {
		//	return;
		//}
		//alert("ASD");
		toSend("save");
	}
    	
   	function disableButtons() {
	    disableButton("send");
	    disableButton("save");
	    disableButton("saveAs");
	    disableButton("insert");
	    disableButton("cancel");
	    disableButton("bodyTypeSelectorspan");
	    disableButton("bodyTypeSelector");
	    
	    isFormSumit = true;
	    var title = document.getElementById('title').value;
	    document.getElementById('title').value = title.trim();
	}
		
	function checkSelectConferees(element){
		if(!isDefaultValue(element)){
			selectMtPeople('conferees','conferees');
			return false;
		}
		return true;
	}

	function selectAuditors(elements){
		var elementsIds = getIdsString(elements,true);
		var memberNames = getNamesString(elements);	
		document.getElementById("auditors").value=elementsIds;
		document.getElementById("auditorNames").value=memberNames;	
	}

	function openLeader(){
		var winWidth = 500;
		var winHeight = 370;
		var feacture = "dialogWidth:" + winWidth + "px; dialogHeight:" + winHeight + "px;";
		feacture = feacture + "directories:no; localtion:no; menubar:no; status:no;";
		feacture = feacture + "toolbar:no; scroll:no; resizeable:no; help:no";
		var approves = document.getElementById("auditors").value;
		var url = "mtAppMeetingController.do?method=openLeader&approves="+approves+"&fromType=3&ndate="+new Date().getTime();
		var retObj = window.showModalDialog(url,window ,feacture);
	}
	
</script>

	<div class="newDiv" style="border:solid 1px #A4A4A4">
		<form id="dataForm" name="dataForm" action="${mtSummaryURL}" method="post">
			<input type="hidden" id="type" value="2" />
			<input type="hidden" id="mtRoomName" name="mtRoomName" value="${meetingRoomName}" />
			<input type="hidden" id="mtTypeName" name="mtTypeName" value="${meetingTypeName}" />
			<input type="hidden" id="meetingId" name="meetingId" value="${meetingBean.id}" />
			<input type="hidden" name="fromMethod" value="${fromMethod != null?fromMethod:param.method }"/>
			<input type="hidden" id="method" name="method" value="saveSummary" />
			<input type="hidden" id="formOper" name="formOper" value="save" />
			<%--xiangfan 添加   --%>
			<input type="hidden" id="listType" name="listType" value="${listType}" />
			<input type="hidden" name="id" value="${bean.id}" />
			<input type="hidden" id="isHasAtt" name="isHasAtt" value="" />
			<input type="hidden" name="dataFormat" id="dataFormat" value="${bean.dataFormat}" />
			<input type="hidden" id="emceeId" name="emceeId" value="${meetingBean.emceeId}"/>
			<input type="hidden" id="recorderId" name="recorderId" value="${meetingBean.recorderId}"/>
			<c:set value="${v3x:parseElements(meetingEmceeList, 'id', 'entityType')}" var="emceesList"/>
			<c:set value="${v3x:parseElements(meetingRecorderList, 'id', 'entityType')}" var="recordersList"/>
			<c:set value="${v3x:parseElements(meetingConfereeList, 'id', 'entityType')}" var="confereesList"/>
			<c:set value="${v3x:parseElements(scopeList, 'id', 'entityType')}" var="scopesList"/>
			<c:set value="${v3x:parseElements(auditorList, 'id', 'entityType')}" var="auditorsList"/>

			<v3x:selectPeople id="emcee" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${emceesList}" panels="Department,Team,Outworker" maxSize="1" selectType="Member" jsFunction="setMtPeopleFields(elements,'emceeId','emceeName')" />
			<v3x:selectPeople id="conferees" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${confereesList}" panels="Department,Team,Post,Outworker" selectType="Member,Department,Team,Post" jsFunction="setMtPeopleFields(elements,'conferees','confereesNames')" />
			<v3x:selectPeople id="scopes" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${scopesList}" panels="Department,Team,Outworker" selectType="Member,Department,Team" jsFunction="setMtPeopleFields(elements,'scopes','scopesNames')" />
			<v3x:selectPeople id="recorder" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${recordersList}" panels="Department,Team,Outworker" maxSize="1" minSize="0" selectType="Member" jsFunction="setMtPeopleFields(elements,'recorderId','recorderName')" />
			<v3x:selectPeople id="auditors" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" originalElements="${auditorsList}" panels="Department,Team" selectType="Member" jsFunction="selectAuditors(elements)" />
			<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable" style="border:0;">
				<tr>
					<td height="22" class="webfx-menu-bar">
						<script type="text/javascript">
							document.write(myBar);
							var elements_emceeArr = elements_emcee;
							var elements_confereesArr = elements_conferees;
							var elements_scopesArr = elements_scopes;
							var elements_recorderArr = elements_recorder;
							var hiddenPostOfDepartment_conferees = true;
						</script>
					</td>
				</tr>
		
				<tr>
					<td height="10">
						<table border="0" height="10" cellpadding="0" cellspacing="0" width="100%" align="center">
							<tr class="bg-summary lest-shadow">
								<!-- 会议名称 -->
								<td width="10%" class="bg-gray">
									<fmt:message key="mt.list.column.mt_name" /><fmt:message key="label.colon" />
								</td>
								<td width="42%" colspan="3">
									<input type="text" class="input-100per" id="title" name="title" value="${meetingBean.title}" disabled="disabled" />
								</td>
								<!-- 开始时间-->
								<td width="8%" class="bg-gray">
									<fmt:message key="mt.mtMeeting.beginDate" /><fmt:message key="label.colon" />
								</td>
								<td width="17%">
									<input type="text"  class="input-100per" name="beginDate" id="beginDate" disabled="disabled"  value="<fmt:formatDate pattern="${datetimePattern}" value="${meetingBean.beginDate}" />"/>
								</td>
								<!-- 结束时间-->
								<td width="8%" class="bg-gray">
									<fmt:message key="common.date.endtime.label" bundle="${v3xCommonI18N}" />:
								</td>
								<td width="17%">
									<input type="text"  class="input-100per" name="endDate" id="endDate" disabled="disabled"  value="<fmt:formatDate pattern="${datetimePattern}" value="${meetingBean.endDate}" />" />
								</td>
							</tr>
							<tr class="bg-summary">
								<!-- 主持人-->
								<td width="8%" class="bg-gray">
									<fmt:message key="mt.mtMeeting.emceeId" /><fmt:message key="label.colon" />
								</td>
								<td width="17%">
									<input type="text" class="input-100per" id="emceeName" name="emceeName" disabled="disabled" value="${v3x:showMemberNameOnly(meetingBean.emceeId)}" title="${v3x:showMemberNameOnly(meetingBean.emceeId)}"/>
								</td>
								
								<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) { %>								
									<!-- 参会人员-->
									<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.join" /><fmt:message key="label.colon" /></td>
									<td width="17%">
										<fmt:message key="mt.mtMeeting.conferees" var="_myLabel"/>
										<fmt:message key="label.please.select" var="_myLabelDefault">
											<fmt:param value="${_myLabel}" />
										</fmt:message>
										<input type="hidden" id="conferees" name="conferees" value="${meetingBean.conferees}"/>
										<input type="text" class="input-100per cursor-hand" id="confereesNames" name="confereesNames" disabled="disabled" readonly="true" 
											value="<c:out value="${v3x:showOrgEntities(meetingConfereeList, 'id', 'entityType', pageContext)}" default="${_myLabelDefault}" escapeXml="true" />"
											title="${v3x:showOrgEntities(meetingConfereeList, 'id', 'entityType', pageContext)}"
											deaultValue="${_myLabelDefault}"
											onfocus="checkDefSubject(this, true)"
											onblur="checkDefSubject(this, false)"
											inputName="${_myLabel}" 
											validate="notNull,checkSelectConferees"
											onclick="selectMtPeople('conferees','conferees');"
											/>
									</td>
								<% } else { %>
									<td width="8%" class="bg-gray">
										<fmt:message key="mt.mtMeeting.createUser" /><fmt:message key="label.colon" />
									</td>
									<td width="17%">
										<input type="text" class="input-100per" id="createUser" name="createUser" disabled="disabled" value="${v3x:showMemberNameOnly(meetingBean.createUser)}" title="${v3x:showMemberNameOnly(meetingBean.createUser)}"/>
									</td>
								<% } %>
								
								<!-- 会议类型-->
								<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) { %>
									<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.meetingType" /><fmt:message key="label.colon" /></td>
									<td width="17%" colspan="3">
										<input type="text"  class="input-100per" name="meetingFormat" id="meetingFormat"  disabled="disabled" value="${meetingTypeName}"/>
									</td>
								<% } else { %>
									<!-- 参会人员-->
									<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.join" /><fmt:message key="label.colon" /></td>
									<td width="17%" colspan="3">
										<fmt:message key="mt.mtMeeting.conferees" var="_myLabel"/>
										<fmt:message key="label.please.select" var="_myLabelDefault">
											<fmt:param value="${_myLabel}" />
										</fmt:message>
										<input type="hidden" id="conferees" name="conferees" value="${meetingBean.conferees}"/>
										<input type="text" class="input-100per cursor-hand" id="confereesNames" name="confereesNames" disabled="disabled" readonly="true" 
											value="<c:out value="${v3x:showOrgEntities(meetingConfereeList, 'id', 'entityType', pageContext)}" default="${_myLabelDefault}" escapeXml="true" />"
											title="${v3x:showOrgEntities(meetingConfereeList, 'id', 'entityType', pageContext)}"
											deaultValue="${_myLabelDefault}"
											onfocus="checkDefSubject(this, true)"
											onblur="checkDefSubject(this, false)"
											inputName="${_myLabel}" 
											validate="notNull,checkSelectConferees"
											onclick="selectMtPeople('conferees','conferees');"
											/>
									</td>
								<% } %>
								
							</tr>
										
							<tr class="bg-summary">
								<!-- 实际参会人员-->
								<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.join.actual" /><fmt:message key="label.colon" /></td>
								<td width="17%" colspan="3">
								
									<fmt:message key="mt.mtMeeting.conferees" var="_myLabel"/>
									<fmt:message key="label.please.select" var="_myLabelDefault">
										<fmt:param value="${_myLabel}" />
									</fmt:message>
									<input type="hidden" id="scopes" name="scopes" value="${bean.conferees}"/>
									<input type="text" class="input-100per cursor-hand" id="scopesNames" name="scopesNames" readonly="true" 
										value="<c:out value="${v3x:showOrgEntities(scopeList, 'id', 'entityType', pageContext)}" default="${_myLabelDefault}" escapeXml="true" />"
										title="${v3x:showOrgEntities(scopeList, 'id', 'entityType', pageContext)}"
										deaultValue="${_myLabelDefault}"
										onfocus="checkDefSubject(this, true)"
										onblur="checkDefSubject(this, false)"
										inputName="${_myLabel}" 
										validate="checkSelectConferees"
										onclick="selectMtPeople('scopes', 'scopes');"
										/>
								</td>
								<!-- 是否需要审核-->
								<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_SUMMARY_PERM) { %>
									<td width="8%" class="bg-gray"><fmt:message key="mt.summary.audit.ornot" /><fmt:message key="label.colon" /></td>
									<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETINGROOM_APP) { %>
										<td>
									<% } else { %>
										<td width="42%" colspan="3">
									<% } %>
										<table width="100%">
											<tr>
												<td width="20">
													<input type="checkbox" id="isAudit" name="isAudit" <c:if test="${bean.state == 2 || bean.state == 3 || bean.state == 5 || bean.state == 6}" > disabled="disabled" </c:if>  <c:if test="${bean.isAudit}"> checked="checked" </c:if> onclick="this.checked ? document.getElementById('auditorNames').disabled = false : document.getElementById('auditorNames').disabled = true;" />
													<fmt:message key="mt.mtMeeting.auditor" var="_myLabel"/>
													<fmt:message key="label.please.select" var="_myLabelDefault">
														<fmt:param value="${_myLabel}" />
													</fmt:message>
												</td>
												<td>
													<input type="hidden" id="auditors" name="auditors" value="${bean.auditors}"/>
													<input type="text" readonly="readonly" class="input-100per cursor-hand" size="72" id="auditorNames" name="auditorNames" <c:if test="${bean.state == 2 || bean.state == 3 || bean.state == 5 || !bean.isAudit}"> disabled="disabled" </c:if>
														value="<c:out value="${v3x:showOrgEntities(auditorList, 'id', 'entityType', pageContext)}" default="${_myLabelDefault}" escapeXml="true" />"
														title="${v3x:showOrgEntities(auditorList, 'id', 'entityType', pageContext)}"
														deaultValue="${_myLabelDefault}"
														onfocus="checkDefSubject(this, true)"
														onblur="checkDefSubject(this, false)"
														inputName="${_myLabel}" 
														validate="notNull,checkSelectConferees"
														onclick="openLeader();"
														/>
												</td>
											</tr>
										</table>	
									</td>
								<% } else { %>
									<input type="hidden" value="${bean.isAudit }" name="isAudit" />
									<% if(!com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETINGROOM_APP) { %>
										<td colspan="4"></td>
									<% } %>
								<% } %>
								
								<!-- 会议室-->
								<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETINGROOM_APP) { %>
									<td width="8%" class="bg-gray"><fmt:message key="mt.mtMeeting.place" /><fmt:message key="label.colon" /></td>
									<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_SUMMARY_PERM) { %>
										<td>
									<% } else { %>
										<td width="17%" colspan="3">
									<% } %>
										<input type="text"  class="input-100per" name="meetingRoomName" id="meetingRoomName"  disabled="disabled" value="${meetingRoomName}"/>
									</td>
								<% } else { %>
									<% if(!com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_SUMMARY_PERM) { %>
										<td colspan="4"></td>
									<% } %>
								<% } %>
							</tr>
		
							 <tr id="attachment2TR" class="bg-summary" style="display:none;">
							      <td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:</td>
							      <td colspan="7" valign="top"><div class="div-float">(<span id="attachment2NumberDiv"></span>)</div>
							      <div></div><div id="attachment2Area" style="overflow: auto;"></div></td>
							 </tr>					
							
							<tr id="attachmentTR" style="display:none;" class="bg-summary">
								<td class="bg-gray"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /> <fmt:message key="label.colon" /> </td>
								<td class="value" colspan="7">
									<div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
									<v3x:fileUpload originalAttsNeedClone="${originalBodyNeedClone}" attachments="${attachments}" canDeleteOriginalAtts="true" />
								</td>
							</tr>
							
							<tr>
					  			<td colspan="9" height="6" class="bg-b"></td>
					 		</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<v3x:editor content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" originalNeedClone="${originalBodyNeedClone}" htmlId="content" category = "<%=ApplicationCategoryEnum.meeting.getKey()%>" />
					</td>
				</tr>
			</table>
		</form>
	</div>

	<iframe name="hiddenIframe" width="0" height="0"></iframe>
	<jsp:include page="../include/deal_exception.jsp" />
	
<script>
	previewFrame('Down');
</script>	
	</body>
</html> 