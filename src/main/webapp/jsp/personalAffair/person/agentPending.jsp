<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    int exchangeType = com.seeyon.v3x.edoc.EdocEnum.edocType.recEdoc.ordinal();
    
    request.setAttribute("exchangeType",exchangeType);
    request.setAttribute("href", com.seeyon.v3x.main.section.templete.BaseSectionTemplete.OPEN_TYPE.href);
    request.setAttribute("open", com.seeyon.v3x.main.section.templete.BaseSectionTemplete.OPEN_TYPE.openWorkSpace);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../header.jsp" %>
<%@ taglib uri="http://v3x.seeyon.com/taglib/collaboration" prefix="col"%>
<html:link renderURL="/main.do" var="mainURL" />
<html:link renderURL="/collaboration.do" var="collURL" />
<html:link renderURL="/mtMeeting.do" var="meetingURL" />
<html:link renderURL="/edocController.do" var="edocURL" />
<html:link renderURL="/exchangeEdoc.do" var="exchangeURL" />
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/collaboration/css/collaboration.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/collaboration.js${v3x:resSuffix()}" />"></script>
<%--引用结束 --%>
<script type="text/javascript">
<!--
function openPendingDetail(_url, openType) {
	if(openType == 'href'){
		location.href = _url;
	}
	else{
		//TODO 这里校验代理是否有效,如果无效，刷新后页面
	    var rv = v3x.openWindow({
	        url: _url,
	        workSpace: 'yes'
	    });
	    //if (rv == "true" || rv == true) {
	        getA8Top().reFlesh();
	    //}
    }
}
//-->
</script>
<title>代理-待办事项-更多</title>
</head>
<body scroll="no" style="overflow: hidden">
<c:set value="${param.type=='all'? '-sel':''}" var="isSel0"/>
<c:set var="openType" value="${open}" />
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr>
		<td width="100%" height="60" valign="top">
			 <table width="100%"  border="0" cellpadding="0" cellspacing="0">
		     <tr class="page2-header-line" height="60">
		        <td width="80" height="60"><img src="<c:url value="/apps_res/peoplerelate/images/pic1.gif" />" width="80" height="60" /></td>
		        <td class="page2-header-bg">
		        <c:if test="${ isAudit eq false}">
		      	 <fmt:message key="common.my.agent.label"/>
		        </c:if>
		        <c:if test="${ isAudit eq true}">
		        <fmt:message key="common.my.auditpending.label"/>
		        </c:if>
		        </td>
		        <td class="page2-header-line page2-header-link">&nbsp;</td>
			</tr>
			</table>
		</td>
	</tr>
<tr>
<td valign="top" class="padding5">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	       <td valign="bottom" height="26" class="tab-tag">
				<div class="div-float">
					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel cursor-hand" onclick="javascript:location.href='${mainURL}?method=agentPending&type=all&isAudit=${isAudit}'">
						<fmt:message key='common.agent.pending.label' bundle='${v3xCommonI18N}'/>
						<fmt:message key="common.items.count.label" bundle='${v3xCommonI18N}'>
					      <fmt:param value="${allCount}" />
					    </fmt:message>
					</div>
					<div class="tab-tag-right-sel"></div>
				</div>
				
				<div class="div-float-right">
				<form action="" name="searchForm" id="searchForm" method="get" onkeypress="doSearchEnter()" onsubmit="return false" style="margin: 0px">
						<input type="hidden" name="method" value="${param.method }">
						<div class="div-float">
							<select name="condition" id="condition"  onChange="showNextSpecialCondition(this)" class="condition">
						    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							    <option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" /></option>
							    <option value="importLevel"><fmt:message key="common.importance.label" bundle='${v3xCommonI18N}' /></option>
							    <option value="sender"><fmt:message key="common.sender.label" bundle="${v3xCommonI18N}" /></option>
							    <option value="createDate"><fmt:message key="common.date.sendtime.label" bundle="${v3xCommonI18N}" /></option>
						  		<option value="subState"><fmt:message key="common.state.label" bundle="${v3xCommonI18N}" /></option>
						  		<option value="applicationEnum"><fmt:message key="common.app.type" bundle="${v3xCommonI18N}" /></option>
						  	</select>
					  	</div>
					  	<div id="subjectDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
					  	<div id="senderDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
					  	<div id="importLevelDiv" class="div-float hidden">
					  		<select name="textfield" class="textfield">
					  			<v3x:metadataItem metadata="${comImportanceMetadata}" showType="option" name="importantLevel" />
					  		</select>
					  	</div>
					  	<div id="subStateDiv" class="div-float hidden">
					  		<select name="textfield" class="textfield">
					  			<option value=""></option>
					  			<option value="13"><fmt:message key="processLog.action.18" bundle="${v3xCommonI18N}"/></option>
					  			<option value="12"><fmt:message key="common.read.label" bundle="${v3xCommonI18N}" /></option>
					  			<option value="11"><fmt:message key="common.not.read.label" bundle="${v3xCommonI18N}" /></option>
					  		</select>
					  	</div>
					  	<div id="applicationEnumDiv" class="div-float hidden">
					  		<select name="textfield" class="textfield">
					  			<option value=""></option>
					  			<option value="1"><fmt:message key="application.1.label" bundle="${v3xCommonI18N}" /></option>
					  			<option value="4,16,19,20,21,22,23,24"><fmt:message key="application.4.label" bundle="${v3xCommonI18N}" /></option>
					  			<c:if test="${ isAudit eq false}">
					  			<option value="6"><fmt:message key="application.6.label" bundle="${v3xCommonI18N}" /></option>
					  			</c:if>
					  			<option value="7,8,10"><fmt:message key="application.public.label" bundle="${v3xCommonI18N}" /></option>
					  		</select>
					  	</div>
					  	<div id="createDateDiv" class="div-float hidden">
					  		<input type="text" name="textfield" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
					  		-
					  		<input type="text" name="textfield1" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
					  	</div>
					  	<div onclick="javascript:doSearch()" class="div-float condition-search-button"></div>
					</form>
				
					<a href="javascript:getA8Top().contentFrame.topFrame.back()"><fmt:message key='common.toolbar.back.label' bundle="${v3xCommonI18N}"/></a>
				</div>
			 </td>
			 <td valign="bottom" width="3" rowspan="2"><div class="tab-tag-1">&nbsp;</div></td>
		</tr>
	  <tr>
	    <td valign="top" colspan="2" class="tab-body-bg-0">
	    <div class="scrollList">
	  <form action="" name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
	  		<c:url value='/common/images/overTime.gif' var="overTime" />
			<c:url value='/common/images/timeout.gif' var="timeOut" />
			<v3x:table width="100%" htmlId="pending" data="pendingList" var="pending" dragable="false">
			      <c:set value="${v3x:toString(v3x:getApplicationCategoryEnum(pending.app))}" var="appCategory"/>
			       <v3x:column width="15" align="right">
			      	<img src="<c:url value="/common/images/icon.gif"/>" width="10" height="10"/>
				  </v3x:column>
				  <c:choose>
				    <c:when test="${appCategory == 'collaboration'}">
    				  <c:set var="url" value="${collURL}?method=detail&from=Pending&affairId=${pending.id}&from=Pending"/>
    				  <c:set var="typeURL" value="${collURL}?method=collaborationFrame&from=Pending"/>
				    </c:when>
				    <c:when test="${appCategory == 'meeting'}">
				      <c:set var="url" value="${meetingURL}?method=mydetail&id=${pending.objectId}&fagent=1&proxy=1&proxyId=${pending.memberId}"/>
				      <c:set var="typeURL" value="${meetingURL}?method=listMain"/>     
				    </c:when>
				    <c:when test="${appCategory == 'edoc' || appCategory == 'edocSend'}">
				      <c:set var="url" value="${edocURL}?method=detail&from=Pending&affairId=${pending.id}"/>	
				      <c:set var="typeURL" value="${edocURL}?method=entryManager&entry=sendManager"/>
				    </c:when>
				      <c:when test="${appCategory == 'edocRec'}">
				      <c:set var="url" value="${edocURL}?method=detail&from=Pending&affairId=${pending.id}"/>	
				      <c:set var="typeURL" value="${edocURL}?method=entryManager&entry=recManager"/>
				    </c:when>
				    <c:when test="${appCategory == 'edocSign'}">
				     <c:set var="url" value="${edocURL}?method=detail&from=Pending&affairId=${pending.id}"/>	
				      <c:set var="typeURL" value="${edocURL}?method=entryManager&entry=signReport"/>
				    </c:when>
				    <c:when test="${appCategory == 'edocRegister'}">
				      <c:set var="openType" value="${href}" />
				      <c:set var="url" value="${edocURL}?method=entryManager&entry=newEdoc&comm=register&edocType=${exchangeType}&exchangeId=${pending.subObjectId}&edocId=${pending.objectId}" />	
				      <c:set var="typeURL" value="${edocURL}?method=entryManager&entry=edocFrame&from=listRegisterPending" />
				    </c:when>
				     <c:when test="${appCategory == 'exSend'}">
				     	<c:set var="url" value="${exchangeURL}?method=sendDetail&modelType=toSend&id=${pending.subObjectId}"/>
				     </c:when>
				     <c:when test="${appCategory == 'exSign'}">
				     	<c:set var="url" value="${exchangeURL}?method=receiveDetail&modelType=toReceive&id=${pending.subObjectId}"/>
				     </c:when>
				  </c:choose>
                  <c:set var="click" value="openPendingDetail('${url}', '${openType}')"/>
                  <c:set var="colSubject" value="${col:showSubject(pending, -1)}"></c:set>
                  <c:set var="colSubject" value="${v3x:toHTMLWithoutSpace(colSubject)}"></c:set>
				  <c:choose>
					<c:when test="${pending.deadlineDate ne null && pending.deadlineDate ne '' && pending.deadlineDate ne '0'}">
						<v3x:column type="String" width="40%" className="cursor-hand sort proxy-false"
						   label="common.subject.label" maxLength="50" symbol="..." alt="${colSubject }" 
						   bodyType="${pending.bodyType}" hasAttachments="${pending.hasAttachments}" value="${colSubject }"
						   importantLevel="${pending.importantLevel}" onClick="${click}"
						   onmouseover="this.className='sort mouseoverColor cursor-hand'" onmouseout="this.className='cursor-hand sort proxy-false'" 
						   extIcons="${pending.isOvertopTime eq true ? timeOut : overTime}" />
					</c:when>
					<c:otherwise>
						<v3x:column type="String" width="40%" className="cursor-hand sort proxy-false" 
						   label="common.subject.label" maxLength="50" symbol="..." value="${colSubject }"
						   bodyType="${pending.bodyType}" hasAttachments="${pending.hasAttachments}" 
						   importantLevel="${pending.importantLevel}" onClick="${click}"  alt="${colSubject }"
						   onmouseover="this.className='sort mouseoverColor cursor-hand'" onmouseout="this.className='cursor-hand sort proxy-false'" />
					</c:otherwise>
				  </c:choose>
					   
				  <v3x:column width="12%" type="String" align="left" label="common.sender.label" maxLength="18"
					   value="${v3x:showMemberName(pending.senderId)}" />
				
				  <v3x:column width="18%" type="Date" align="left" label="common.date.sendtime.label">
					   <fmt:formatDate value="${pending.createDate}" pattern="${datetimePattern}"/>
				  </v3x:column>
				
				  <c:choose>
				  <c:when test="${pending.deadlineDate eq null}">
					  <v3x:column width="10%" type="String" align="center" label="pending.deadlineDate.label" onClick="${click}" >
					  	<fmt:message key='common.default' bundle='${v3xCommonI18N}'/>
					  </v3x:column>
				  </c:when>
				  <c:otherwise>
				  	  <fmt:message var="isOvertop" key='pending.overtop.${pending.isOvertopTime}.label' />
					  <v3x:column width="10%" type="String" align="center" label="pending.deadlineDate.label" className="cursor-hand sort deadline-false" 
					  onClick="${click}" alt="${v3x:_(pageContext, isOvertop)}" >
						  <v3x:metadataItemLabel metadata="${colMetadata.collaboration_deadline}" value="${pending.deadlineDate}"/>
					  </v3x:column>
				  </c:otherwise>
				  </c:choose>
				  <c:if test="${ isAudit eq false}">
				  <v3x:column width="12%" type="String" align="left" label="${agentFlag ? 'agent.is.surrogate.name' : 'agent.surrogate.name' }" maxLength="18"
					   value="${v3x:showAgentMemberName(pending.memberId, pending.app)}" />
				 </c:if>
				  <v3x:column width="12%" type="String" align="left" label="application.type.label">
				  	<c:choose>
					  	<c:when test="${pending.bodyType eq 'FORM' }" >
							<fmt:message key='application.2.label' bundle='${v3xCommonI18N}'/> 
						</c:when>
						<c:otherwise>
							<fmt:message key='application.${pending.app}.label' bundle='${v3xCommonI18N}'/>
						</c:otherwise>
					</c:choose>
				  </v3x:column>
			</v3x:table>
			</form>
		</div>
	    </td>
    </tr>
</table>
</td>
</tr>
</table>
<script type="text/javascript">
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
</script>
</body>
</html>