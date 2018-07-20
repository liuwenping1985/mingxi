<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.meeting.manager.MtMeetingManagerImpl"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../meeting/include/taglib.jsp" %>
<%@ include file="../meeting/include/header.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/meetingsummary/js/meetingsummary.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
	try {
		getA8Top().endProc('');
	} catch(e) {
	}
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	var fromVar='${listType}';
	if(getA8Top()!=null && typeof(getA8Top().showLocation)!="undefined") {
		if('all'==fromVar){
			getA8Top().showLocation(2104,"<fmt:message key='mtSummary.audit.lable'  bundle="${v3xMeetingSummaryI18N}"/>", "<fmt:message key='mtSummary.tree.all.lable' bundle='${v3xMeetingSummaryI18N}'/>");
		}else if('waitAudit'==fromVar){
			getA8Top().showLocation(2104,"<fmt:message key='mtSummary.audit.lable'  bundle="${v3xMeetingSummaryI18N}"/>", "<fmt:message key='mtSummary.tree.waitAudit.lable' bundle='${v3xMeetingSummaryI18N}'/>");
		}else if('audited'==fromVar){
			getA8Top().showLocation(2104,"<fmt:message key='mtSummary.audit.lable'  bundle="${v3xMeetingSummaryI18N}"/>", "<fmt:message key='mtSummary.tree.audited.lable' bundle='${v3xMeetingSummaryI18N}'/>");
		}
	 }
	 if('audited'==fromVar){
		 myBar.add( new WebFXMenuButton("delBtn", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "deleteMyAuditMtSummary('audited');", [1,3], "", null));
	 }
	
	baseUrl='${mtMeetingURL}?method=';

	var userInternalID = "${sessionScope['com.seeyon.current_user'].id}";
	function editMeeting(id){
		if(userInternalID==createUserIdTable.items(id)){
			<%-- 已经开始的会议不允许修改，其他均允许修改 --%>
			if(!validateCanEdit(id)) {
				alert(v3x.getMessage("meetingLang.meeting_begin_cannot_edit"));
				if('${param.stateStr}' == '10' || '${param.stateStr}' == '')
					parent.getA8Top().reFlesh();
				return;
			}
			parent.location.href=baseUrl+'edit'+'&id='+id+'&flag=editMeeting';
		}else{
			alert(v3x.getMessage("meetingLang.you_not_creater"));
			return;
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
    //-->
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
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
												<option value="createUser"><fmt:message key='mt.mtMeeting.recorderId' /></option>
												<option value="mtCreateUser"><fmt:message key='mt.mtMeeting.createUser' /></option>
												<option value="createDate"><fmt:message key="mtSummary.publish.lable.startTime" bundle='${v3xMeetingSummaryI18N}' /></option>
											</select>
										</div>
										<!-- 会议名称 -->
										<div id="mtNameDiv" class="div-float hidden">
											<input type="text" name="textfield" class="textfield" />
										</div>
										<!-- 会议类型 -->
										<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) { %>
											<div id="mtTypeNameDiv" class="div-float hidden">
												<select name="textfield" id="textfield" class="textfield">
							                    <c:forEach var="meetingType" items="${typeList}"> 
								                  <option value="${meetingType.name}">${meetingType.name}</option>
							                    </c:forEach>
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
										<!-- 发起人 -->
										<div id="createUserDiv" class="div-float hidden">
											<v3x:selectPeople id="createUser" panels="Department,Team" selectType="Member"
												departmentId="${currentUser.departmentId}"
												jsFunction="setSearchPeopleFields(elements, 'createUserName', 'createUserId')" minSize="0" maxSize="1" />
											<input type="text" name="textfield" id="createUserName" class="textfield" readonly="true" onclick="selectPeopleFun_createUser('textfield', 'textfield1')" />
											<input type="hidden" name="textfield1" id="createUserId" />
										</div>
										<!-- 记录人 -->
										<div id="mtCreateUserDiv" class="div-float hidden">
											<v3x:selectPeople id="mtCreateUser" panels="Department,Team" selectType="Member"
												departmentId="${currentUser.departmentId}"
												jsFunction="setSearchPeopleFields(elements, 'mtCreateUserName', 'mtCreateUserId')" minSize="0" maxSize="1" />
											<input type="text" name="textfield" id="mtCreateUserName" class="textfield" readonly="true" onclick="selectPeopleFun_mtCreateUser('textfield', 'textfield1')" />
											<input type="hidden" name="textfield1" id="mtCreateUserId" />
										</div>
										<!-- 纪要发起时间 -->
										<div id="createDateDiv" class="div-float hidden">
											<input type="text" name="textfield" id="fromDate" class="input-date cursor-hand" onclick="selectDateTime(this);" readonly /> 
											- 
											<input type="text" name="textfield1" id="toDate" class="input-date cursor-hand" onclick="selectDateTime(this);" readonly />
										</div>
										<div onclick="javascript:doSearch()" class="condition-search-button div-float"></div>
									</div>
								</form>
							</td>
						</tr>
					</table>
				</div>
				<div class="center_div_row2" id="scrollListDiv">
					<form name="listForm" id="listForm">
						<v3x:table htmlId="listTable" data="list" var="bean" leastSize="0" bundle="${v3xMeetingSummaryI18N}">
						
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
						
							<c:set var="click" value="showSummary('${bean.id }','${bean.meetingId}','${listType}', '${proxy }', '${proxyId }')"/><%--xiangfan 添加${listType}，修复GOV-2185 2012-04-24 --%>
							<!-- 选择框  -->
							<v3x:column width="3%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
								<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" state="${bean.auditState}" ${disabled} />
							</v3x:column>
							<!-- 会议名称  -->
							<c:choose>
								<c:when test="${listType != 'waitAudit'}">
								<v3x:column width="30%" type="String"  onClick="${click}" label="mt.list.column.mt_name" className="cursor-hand sort" bodyType="${bean.dataFormat}">
									${v3x:toHTML(bean.mtName)}
								</v3x:column>
								</c:when>
								<c:otherwise>
									<v3x:column width="30%" type="String"  onClick="${click}" label="mt.list.column.mt_name" className="cursor-hand sort proxy-${bean.proxy }" bodyType="${bean.dataFormat}">
										<%--xiangfan 添加 修復GOV-452 第二次发起审核时没有显示 '(重新发起审核)' --%>
										<c:if test="${bean.auditNum > 1}">
											<fmt:message key='mt.summary.moreAudit'/>
										</c:if>
										
										<c:choose>
											<c:when test="${bean.proxy}">
												${createAccountName}${v3x:toHTML(bean.mtName)}
												<c:choose>
													<c:when test="${proxyId ne null }">
														 <c:choose>
														  	<c:when test="${listType == 'waitAudit'}">
														  		(<fmt:message key="mt.agent" />${v3x:showMemberName(bean.proxyId)})
														  	</c:when>
														  	<c:otherwise>
														  		${createAccountName}${v3x:toHTML(bean.mtName)}
														  	</c:otherwise>
													  	</c:choose>
													</c:when>
													<c:otherwise>
														${bean.proxyLabel }  
													</c:otherwise>
												</c:choose>
											</c:when>
											<c:otherwise>
												${createAccountName}${v3x:toHTML(bean.mtName)}
											</c:otherwise>
										</c:choose>
									</v3x:column>
								</c:otherwise>
							</c:choose>
							<!-- 发布人  -->
							<v3x:column width="10%" type="String"  onClick="${click}" label="mt.mtMeeting.createUser" className="cursor-hand sort">
								${v3x:showMemberName(bean.createUser)}
							</v3x:column>
							<!-- 记录人  -->
							<v3x:column width="10%" type="String"  onClick="${click}" label="mt.mtMeeting.recorderId" className="cursor-hand sort">
								${v3x:showMemberName(bean.createUser)}
							</v3x:column>
							<!-- 会议类型  -->
								<% if(com.seeyon.v3x.meeting.contants.MeetingConfig.HAS_MEETING_TYPE) { %>
								<v3x:column width="12%" type="String"  onClick="${click}" label="mt.mtMeeting.meetingType" className="cursor-hand sort">
									${bean.mtTypeName}
								</v3x:column>
							<% } %>
							<!-- 视频会议 -->
							<%if(com.seeyon.ctp.common.SystemEnvironment.hasPlugin("videoconference")){ %>
								<v3x:column width="8%" type="String"  onClick="${click}" label="mt.mtMeeting.meetingNature" className="cursor-hand sort" value="${bean.meetingType=='2'?'视频会议':'普通会议'}">
								</v3x:column>
							<%} %>
							<!-- 会议时间  -->
							<v3x:column width="13%" type="String"  onClick="${click}" label="mt.searchdate" className="cursor-hand sort">
								<fmt:formatDate pattern="${datePattern}" value="${bean.mtBeginDate}" />
							</v3x:column>
							<!-- 纪要发起时间  -->
							<v3x:column width="13%" type="String"  onClick="${click}" label="mtSummary.publish.lable.startTime" className="cursor-hand sort">
								<fmt:formatDate pattern="${datePattern}" value="${bean.createDate}" />
							</v3x:column>
							<!-- 会议室  -->
							<v3x:column width="9%" type="String"  onClick="${click}" label="mt.mtMeeting.place" className="cursor-hand sort">
								${bean.mtRoomName}
							</v3x:column>
							<!-- 状态1:待审核 2:审核通过 3:审核不通过 -->
							<%--puyc 修改 2012-2-10 --%>
							<c:if test="${listType != 'waitAudit' && listType != 'audited'}">
								<v3x:column width="10%" type="String"  onClick="${click}" label="mt.mtMeeting.state" className="cursor-hand sort">
									<c:choose>
										<c:when test="${bean.auditState==2}">
											<!--待审核-->
											<fmt:message key='mt.list.column.type.10'/>
										</c:when>
										<c:when test="${bean.auditState==3}">
											<!-- 审核中 -->
											<fmt:message key="mt.list.column.type.50"/>
										</c:when>
										<c:when test="${bean.auditState==4}">
											<!--审核通过-->
											<fmt:message key='mt.list.column.type.20'/>
										</c:when>
										<c:when test="${bean.auditState==5}">
											<!--审核不通过-->
											<fmt:message key='mtSummary.tree.notpassed.lable' bundle='${v3xMeetingSummaryI18N}'/>
										</c:when>
									</c:choose>
								</v3x:column>
							</c:if>
						</v3x:table>
					</form>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			//showDetailPageBaseInfo("detailFrame", "<fmt:message key='mt.mtMeeting' /><fmt:message key='mt.list' />", [1,2], pageQueryMap.get('count'), _("meetingLang.detail_info_603_1"));	
			showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
			initIpadScroll("scrollListDiv",550,870);
		</script>
	</body>
</html>