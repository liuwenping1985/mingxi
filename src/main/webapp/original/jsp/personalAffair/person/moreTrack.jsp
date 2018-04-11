<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>	
<%@ include file="../header.jsp" %>
<%@ taglib uri="http://v3x.seeyon.com/taglib/collaboration" prefix="col"%>
<html:link renderURL="/collaboration.do" var="collURL" />
<html:link renderURL="/edocController.do" var="edocURL" />
<html:link renderURL="/main.do" var="mainURL" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>

<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/collaboration.js${v3x:resSuffix()}" />"></script>
<title></title>
<script type="text/javascript">
<!--
	getA8Top().showShortCut();
	
	function openTrackDetail(_url) {
	    var rv = v3x.openWindow({
	        url: _url,
	        workSpace: 'yes'
	    });
	    if (rv == "true") {
	        getA8Top().reFlesh();
	    }
	}
	
	function commitCancelTrackForm(){
		var flag = checkBeforeCancelTrackSubmit();
		
		if(flag){	
			document.getElementsByName("cancelTrackForm")[0].submit();
		}
	}
	
	/**
	 * 按发起人查询，选人界面返回值
	 */
	function setSearchPeopleFields(elements){
		document.getElementById("senderId").value = getIdsString(elements, false);
		document.getElementById("senderName").value = getNamesString(elements);
	}
	
	window.onload = function() {
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	}
//-->
</script>
</head>
<body class="with-header">
<div class="main_div_row2">
  <div class="right_div_row2">
  <div class="top_div_row2">
    <table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
        <tr class="page2-header-line">
            <td width="100%" height="38" valign="top" colspan="2">
                <form id="cancelTrackForm" name="cancelTrackForm" action="${mainURL}" method="get" style="margin: 0px">
                <input type="hidden" name="method" value="cancelTrack">
                <input type="hidden" name="fragmentId" value="${param.fragmentId }">
                <input type="hidden" name="ordinal" value="${param.ordinal }">
                 <table width="100%"  border="0" cellpadding="0" cellspacing="0">
                 <tr class="page2-header-line">
                    <td width="45" class="page2-header-img">
                        <div class="trace"></div>
                    </td>
                    <td class="page2-header-bg"><fmt:message key="common.my.track.title"/></td>
                    <td class="page2-header-line page2-header-link" align="right" valign="middle">
                    <a href="javascript:commitCancelTrackForm()"><fmt:message key='track.button.cancel.label'/></a>&nbsp;&nbsp;
                    <a href="javascript:getA8Top().contentFrame.topFrame.back()"><fmt:message key='common.toolbar.back.label' bundle="${v3xCommonI18N}"/></a>
                    </td>
                </tr>
                </table>
                </form>
            </td>
        </tr>
    
                <tr>
                   <td height="30" class="webfx-menu-bar" valign="top">&nbsp;
                       <fmt:message key="common.my.track.label">
                          <fmt:param value="${countTrack}"></fmt:param>
                       </fmt:message>
                   </td>
                   <td height="30" class="webfx-menu-bar" valign="top">
                        <form action="" name="searchForm" id="searchForm" method="get" style="margin: 0px; padding:0;" onsubmit="return false" onkeydown="doSearchEnter()">
                            <input type="hidden" value="moreTrack" name="method">
                            <input type="hidden" name="fragmentId" value="${param.fragmentId }">
                			<input type="hidden" name="ordinal" value="${param.ordinal }">
                            <div class="div-float-right condition-search-div">
                                <div class="div-float">
                                    <select id="condition" name="condition" onChange="showNextCondition(this)" class="condition">
                                        <option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
                                        <option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" /></option>
                                        <option value="importLevel"><fmt:message key="common.importance.label" bundle="${v3xCommonI18N}" /></option>
                                        <option value="sender"><fmt:message key="common.sender.label" bundle="${v3xCommonI18N}" /></option>
                                        <option value="createDate"><fmt:message key="common.send.time.label" bundle="${v3xCommonI18N}" /></option>
                                    </select>
                                </div>
                                
                                <div id="subjectDiv" class="div-float hidden"><input type="text" id="title" name="textfield" class="textfield" maxlength="100"></div>
                                
                                <div id="importLevelDiv" class="div-float hidden">
                                    <select id="importantLevel" name="textfield" class="textfield">
                                        <v3x:metadataItem metadata="${comImportanceMetadata}" showType="option" name="importantLevel" />
                                    </select>	
                                </div>
                                
                                <div id="senderDiv" class="div-float hidden">
                                    <v3x:selectPeople id="sender" panels="Department,Team,Post,Outworker" selectType="Member" departmentId="${currentUser.departmentId}" jsFunction="setSearchPeopleFields(elements)" minSize="0" maxSize="1" />
                                    <input type="hidden" name="textfield" id="senderId" />
                                    <input type="text" name="textfield1" id="senderName" class="textfield cursor-hand" readonly onclick="selectPeopleFun_sender()" />
                                </div>
                                
                                <div id="createDateDiv" class="div-float hidden">
                                    <input type="text" name="textfield" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
                                    -
                                    <input type="text" name="textfield1" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
                                </div>
                                
                                <div onclick="javascript:doSearch()" class="div-float condition-search-button"></div>
                            </div>
                        </form>
                   </td>
                </tr>
                </table>
            </div>
            <c:set value="${(v3x:getSysFlagByName('sys_isGovVer')=='true') && (v3x:hasPlugin('edoc'))}" var="isGovEdoc"></c:set>
			<div class="center_div_row2" id="scrollListDiv">
			   <form action="" name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
					<v3x:table width="100%" htmlId="trackTable" data="allTrackList" var="track" className="sort ellipsis">
					      <c:set value="${v3x:toString(v3x:getApplicationCategoryEnum(track.app))}" var="appCategory"/>
					      <v3x:column nowarp="nowarp" width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"affairIds\")'/>">
							<input type='checkbox' name='affairIds' value="${track.id}" extAttribute="${track.id}" />
						  </v3x:column>	
						  	
						  <c:choose>
						    <c:when test="${appCategory == 'collaboration'}">
						      <c:set var="from" value="${track.state == 2 ? 'Sent' : (track.state == 3 ? 'Pending' : 'Done')}" />
		    				  <c:set var="url" value="${collURL}?method=detail&from=${from}&affairId=${track.id}"/>
		    				  <c:set var="typeURL" value="${collURL}?method=collaborationFrame&from=${from}"/>		    
						    </c:when>
						    <c:when test="${appCategory == 'edoc' || appCategory == 'edocSend'}">
							 <c:set var="from" value="${track.state == 2 ? 'Sent' : (track.state == 3 ? 'Pending' : 'Done')}" />
						      <c:set var="toFrom" value="${track.state == 2 ? 'listSent' : (track.state == 3 ? 'listPending' : 'listDone')}"/>
						      <c:set var="url" value="${edocURL}?method=detail&from=${from}&affairId=${track.id}"/>
						      <%-- branches_a8_v350_r_gov GOV-2989  唐桂林修改个人空间-跟踪事项公文链接 start --%>
						      <c:choose>
						      	<c:when test="${isGovEdoc }">
						      		<c:set var="typeURL" value="${edocURL }?method=entryManager&entry=sendManager&edocType=0&track=1&toFrom=${toFrom }"/>
						      	</c:when>
						      	<c:otherwise>
						      		<c:set var="typeURL" value="${edocURL}?method=edocFrame&from=list${from}&edocType=0"/>
						      	</c:otherwise>
						      </c:choose>
						      <%-- branches_a8_v350_r_gov GOV-2989  唐桂林修改个人空间-跟踪事项公文链接 end --%>
						    </c:when>
						    <c:when test="${appCategory == 'edocRec'}">
							 <c:set var="from" value="${track.state == 2 ? 'Sent' : (track.state == 3 ? 'Pending' : 'Done')}" />
						      <c:set var="toFrom" value="${track.state == 2 ? 'listSent' : (track.state == 3 ? 'listPending' : 'listDone')}"/>
						      <c:set var="url" value="${edocURL}?method=detail&from=${from}&affairId=${track.id}"/>	
						      <%-- branches_a8_v350_r_gov GOV-2989  唐桂林修改个人空间-跟踪事项公文链接 start --%>
						      <c:choose>
						      	<c:when test="${isGovEdoc }">
						      		<c:set var="typeURL" value="${edocURL }?method=entryManager&entry=recManager&edocType=1&track=1&toFrom=${toFrom }"/>
						      	</c:when>
						      	<c:otherwise>
						      		<c:set var="typeURL" value="${edocURL}?method=edocFrame&from=list${from}&edocType=1"/>
						      	</c:otherwise>
						      </c:choose>
						      <%-- branches_a8_v350_r_gov GOV-2989  唐桂林修改个人空间-跟踪事项公文链接 end --%>
						    </c:when>
						    <c:when test="${appCategory == 'edocSign'}">
							 <c:set var="from" value="${track.state == 2 ? 'Sent' : (track.state == 3 ? 'Pending' : 'Done')}" />
							 <c:set var="toFrom" value="${track.state == 2 ? 'listSent' : (track.state == 3 ? 'listPending' : 'listDone')}"/>
						     <c:set var="url" value="${edocURL}?method=detail&from=${from}&affairId=${track.id}"/>	
						      <%-- branches_a8_v350_r_gov GOV-2989  唐桂林修改个人空间-跟踪事项公文链接 start --%>
						      <c:choose>
						      	<c:when test="${isGovEdoc }">
						      		<c:set var="typeURL" value="${edocURL }?method=entryManager&entry=signReport&edocType=3&track=1&toFrom=${toFrom }"/>
						      	</c:when>
						      	<c:otherwise>
						      		<c:set var="typeURL" value="${edocURL}?method=edocFrame&from=list${from}&edocType=2"/>
						      	</c:otherwise>
						      </c:choose>
						      <%-- branches_a8_v350_r_gov GOV-2989  唐桂林修改个人空间-跟踪事项公文链接 end --%>
						    </c:when>
						    <%--Meari GOV-3215首页点击跟踪事项更多，点开详细的链接后点开后面的链接都不对start--%>
						     <c:when test="${appCategory == 'info'}">
					     	<c:set var="url" value="infoDetailController.do?method=detail&summaryId=${track.objectId}&from=Pending&affairId=${track.id}"/>
					     	<c:set var="typeURL" value="infoNavigationController.do?method=indexManager&entry=${entry}"/>
					    </c:when>
					    <%--Meari GOV-3215首页点击跟踪事项更多，点开详细的链接后点开后面的链接都不对end --%>
						  </c:choose>
		                  <c:set var="openDetail" value="openTrackDetail('${url}')"/>
		                  <c:set var="trackSubjectTitle" value="${col:showSubject(track, -1)}"/>
		                  <c:set var="trackSubject" value="${col:showSubject(track, 80)}"/>
					      <v3x:column type="String" className="sort" align="left" width="50%"
							   label="common.subject.label"
							   bodyType="${track.bodyType}" hasAttachments="${track.hasAttachments}" importantLevel="${track.importantLevel}" alt="${v3x:escapeJavascript(trackSubjectTitle) }">
							   <a href="javascript:${openDetail}" class="title-more">${v3x:toHTML(trackSubject)}</a>
						  </v3x:column>
						  <v3x:column nowarp="nowarp" type="Date" width="15%" label="common.date.sendtime.label">
							   <fmt:formatDate value="${track.createDate}" pattern="${datetimePattern}"/>
						  </v3x:column>
						  <v3x:column nowarp="nowarp" type="String" width="10%" label="common.sender.label" value="${v3x:showMemberName(track.senderId)}">
						  </v3x:column>
						  
						  <fmt:message var="isOvertop" key='pending.overtop.${track.isOvertopTime}.label' />
							<v3x:column nowarp="nowarp" width="10%" type="String" label="pending.deadlineDate.label" className="sort deadline-${track.isOvertopTime}" 
							onClick="${click}" alt="${v3x:_(pageContext, isOvertop)}" >
							<v3x:metadataItemLabel metadata="${colMetadata.collaboration_deadline}" value="${track.deadlineDate==null? 0:track.deadlineDate}"/>
						  </v3x:column>
						  <c:if test="${track.app==1 || track.app==19 || track.app==20 || track.app==21 }">
								<fmt:message key="col.state.${track.state}.label"  bundle='${v3xCommonI18N}' var="state"/>
								<c:set value="(${state })" var="trackState"/>
						  </c:if>
						  <v3x:column nowarp="nowarp" type="String" label="application.type.label" width="10%">
						   	  <fmt:message key='application.${track.app}.label' bundle='${v3xCommonI18N}' var="appName" />
							  <a title="${appName}" href="${typeURL}" >${appName} ${trackState}</a>
						  </v3x:column>
					</v3x:table>
					</form>
				</div>	</div></div>
</body>
</html>