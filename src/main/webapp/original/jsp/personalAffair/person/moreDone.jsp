<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="../header.jsp" %>
<%@ taglib uri="http://v3x.seeyon.com/taglib/collaboration" prefix="col"%>
<html:link renderURL="/collaboration.do" var="collURL" />
<html:link renderURL="/edocController.do" var="edocURL" />
<html:link renderURL="/mtMeeting.do" var="meetingURL" />
<html:link renderURL="/mtAppMeetingController.do" var="meetingAppURL" />
<html:link renderURL="/mtSummary.do" var="mtSummaryURL" />
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
                 <table width="100%"  border="0" cellpadding="0" cellspacing="0">
                 <tr class="page2-header-line">
                    <td width="45"  class="page2-header-img">
                        <div class="trace"></div>
                    </td>
                    <td class="page2-header-bg"><fmt:message key="common.my.done.title"/></td>
                    <td class="page2-header-line page2-header-link" align="right" valign="middle">
                    <a href="javascript:getA8Top().contentFrame.topFrame.back()"><fmt:message key='common.toolbar.back.label' bundle="${v3xCommonI18N}"/></a>
                    </td>
                </tr>
                </table>
                </form>
            </td>
        </tr>

                <tr>
                   <td height="30" class="webfx-menu-bar" valign="top">&nbsp;
                       <fmt:message key="common.my.done.title"/>
                   </td>
                   <td height="30" class="webfx-menu-bar" valign="top">
                        <form action="" name="searchForm" id="searchForm" method="get" style="margin: 0px; padding:0;" onsubmit="return false" onkeydown="doSearchEnter()">
                            <input type="hidden" value="${param.method}" name="method">
                            <input type="hidden" name="fragmentId" value="${param.fragmentId }">
                			<input type="hidden" name="ordinal" value="${param.ordinal }">
                            <div class="div-float-right condition-search-div">
                                <div class="div-float">
                                    <select id="condition" name="condition" onChange="showNextCondition(this)" class="condition">
                                        <option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
                                        <option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" /></option>
                                        <option value="importLevel"><fmt:message key="common.importance.label" bundle="${v3xCommonI18N}" /></option>
                                        <option value="sender"><fmt:message key="common.sender.label" bundle="${v3xCommonI18N}" /></option>
                                        <option value="createDate"><fmt:message key="common.date.donedate.label" bundle="${v3xCommonI18N}" /></option>
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
            <c:set value="${(v3x:getSysFlagByName('sys_isGovVer')=='true')}" var="isGov"></c:set>
            <c:set value="${hasMtAppAuditGrant }" var="hasMtAppAuditGrant"></c:set>
			<div class="center_div_row2" id="scrollListDiv">
			   <form action="" name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
					<v3x:table width="100%" htmlId="trackTable" data="allDoneList" var="track" className="sort ellipsis">
					      <c:set value="${v3x:toString(v3x:getApplicationCategoryEnum(track.app))}" var="appCategory"/>
					      <c:set var="categoryLabel" value="application.${track.app}.label" />
					      <v3x:column nowarp="nowarp" width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"affairIds\")'/>">
							<input type='checkbox' name='affairIds' value="${track.id}" extAttribute="${track.id}" />
						  </v3x:column>

						  <c:choose>
						    <c:when test="${appCategory == 'collaboration'}">
						      <c:set var="from" value="${track.state == 2 ? 'Sent' : (track.state == 3 ? 'Pending' : 'Done')}" />
		    				  <c:set var="url" value="${collURL}?method=detail&from=${from}&affairId=${track.id}"/>
		    				  <c:set var="typeURL" value="${collURL}?method=collaborationFrame&from=${from}"/>
						    </c:when>
						    <c:when test="${appCategory == 'meeting'}">
						    	<%-- branches_a8_v350_r_gov GOV-3001  唐桂林修改个人空间-已办事项会议链接 start --%>
								<c:if test="${isGov }">
									<c:set var="categoryLabel" value="application.${track.app }.${track.subApp}${v3x:suffix() }.label" />
						      		<c:choose>
									<%-- 会议审核 --%>
						      		<c:when test="${track.subApp == 6 }">
						      			<c:set var="url" value="${meetingAppURL}?method=mydetail&id=${track.objectId }&affairId=${track.id}"/>
						      			<c:if test="${hasMtAppAuditGrant }">
						      			<c:set var="typeURL" value="${meetingURL }?method=entryManager&entry=meetingManager&listMethod=listAudit&listType=listAppAuditingMeetingAudited"/>
						      			</c:if>
						      		</c:when>
						      		<%--会议纪要审核 branches_a8_v350sp1_r_gov 向凡 添加 修复 GOV-4910--%>
						      		<c:when test="${track.subApp == 7}">
				        			   <c:set var="url" value="${mtSummaryURL}?method=mydetail&recordId=${track.objectId}&affairId=${track.id }"/>
				       				   <c:set var="typeURL" value="${mtSummaryURL}?method=listHome&from=audit&listType=waitAudit"/>
				      				</c:when>
						      		<c:otherwise></c:otherwise>
						      		</c:choose>
						      	</c:if>
						      <%--branches_a8_v350_r_gov GOV-3001  唐桂林修改个人空间-已办事项会议链接 end --%>
						    </c:when>
						    <c:when test="${appCategory == 'edoc' || appCategory == 'edocSend'}">
							 <c:set var="from" value="${track.state == 2 ? 'Sent' : (track.state == 3 ? 'Pending' : 'Done')}" />
						      <c:set var="url" value="${edocURL}?method=detail&from=${from}&affairId=${track.id}"/>
						      <%-- branches_a8_v350_r_gov GOV-2991  唐桂林修改个人空间-已办事项公文链接 start --%>
						      <c:choose>
						      	<c:when test="${isGov }">
						      		<c:set var="typeURL" value="${edocURL }?method=entryManager&entry=sendManager&edocType=0&toFrom=listDone"/>
						      	</c:when>
						      	<c:otherwise>
						      		<c:set var="typeURL" value="${edocURL}?method=edocFrame&from=list${from}&edocType=0"/>
						      	</c:otherwise>
						      </c:choose>
						      <%-- branches_a8_v350_r_gov GOV-2991  唐桂林修改个人空间-已办事项公文链接 end --%>
						    </c:when>
						    <c:when test="${appCategory == 'edocRec'}">
							 <c:set var="from" value="${track.state == 2 ? 'Sent' : (track.state == 3 ? 'Pending' : 'Done')}" />
						      <c:set var="url" value="${edocURL}?method=detail&from=${from}&affairId=${track.id}"/>
						      <%-- branches_a8_v350_r_gov GOV-2991  唐桂林修改个人空间-已办事项公文链接 start --%>
						      <c:choose>
						      	<c:when test="${isGov }">
						      		<c:set var="typeURL" value="${edocURL }?method=entryManager&entry=recManager&edocType=1&toFrom=listDone"/>
						      	</c:when>
						      	<c:otherwise>
						      		<c:set var="typeURL" value="${edocURL}?method=edocFrame&from=list${from}&edocType=1"/>
						      	</c:otherwise>
						    </c:choose>
						    <%-- branches_a8_v350_r_gov GOV-2991  唐桂林修改个人空间-已办事项公文链接 end --%>
						    </c:when>
						    <c:when test="${appCategory == 'edocSign'}">
							 <c:set var="from" value="${track.state == 2 ? 'Sent' : (track.state == 3 ? 'Pending' : 'Done')}" />
						     <c:set var="url" value="${edocURL}?method=detail&from=${from}&affairId=${track.id}"/>
						      <c:set var="typeURL" value="${edocURL}?method=edocFrame&from=list${from}&edocType=2"/>
						      <%-- branches_a8_v350_r_gov GOV-2991  唐桂林修改个人空间-已办事项公文链接 start --%>
						      <c:choose>
						      	<c:when test="${isGov }">
						      		<c:set var="typeURL" value="${edocURL }?method=entryManager&entry=signReport&edocType=2&toFrom=listDone"/>
						      	</c:when>
						      	<c:otherwise>
						      		<c:set var="typeURL" value="${edocURL}?method=edocFrame&from=list${from}&edocType=2"/>
						      	</c:otherwise>
						      </c:choose>
						      <%-- branches_a8_v350_r_gov GOV-2991  唐桂林修改个人空间-已办事项公文链接 end --%>
						    </c:when>
						    
						    
						    <c:when test="${appCategory == 'edocRecDistribute'}">
						     	<c:set var="url" value="${edocURL}?method=detail&from=Sent&affairId=${track.id}"/>
						      	<c:set var="typeURL" value="" />
						      	<%-- branches_a8_v350_r_gov GOV-2991  唐桂林修改个人空间-已办事项公文链接 start --%>
								<c:if test="${hasEdocDistributeGrant }">					      
						      		<c:set var="typeURL" value="${edocURL}?method=listIndex&toFrom=listDistribute&from=listSent&edocType=1"/>
								</c:if>
						      <%-- branches_a8_v350_r_gov GOV-2991  唐桂林修改个人空间-已办事项公文链接 end --%>
						    </c:when>
						    
						    
						    <%-- branches_a8_v350_r_gov GOV-2991  唐桂林修改个人空间-已办事项信息报送链接 start --%>
						    <c:when test="${appCategory == 'info'}">
						     	<c:set var="url" value="infoDetailController.do?method=detail&summaryId=${track.objectId }&from=${from }&affairId=${track.id }"/>
					      		<c:set var="typeURL" value="infoNavigationController.do?method=indexManager&entry=infoAuditing&toFrom=listInfoAuditDone&affairId=${track.id }"/>
						    </c:when>
						    <%-- branches_a8_v350_r_gov GOV-2991  唐桂林修改个人空间-已办事项信息报送链接 end --%>
						  </c:choose>
		                  <c:set var="openDetail" value="openTrackDetail('${url}')"/>
		                  <c:set var="trackSubjectTitle" value="${col:showSubject(track, -1)}"/>
		                  <c:set var="trackSubject" value="${col:showSubject(track, 80)}"/>
					      <v3x:column type="String" className="sort" align="left" width="60%"
							   label="common.subject.label"
							   bodyType="${track.bodyType}" hasAttachments="${track.hasAttachments}" importantLevel="${track.importantLevel}" alt="${v3x:escapeJavascript(trackSubjectTitle) }">
							 <a href="javascript:${openDetail}" class="title-more">${v3x:toHTML(trackSubject)}</a>
						  </v3x:column>
						  <v3x:column nowarp="nowarp" type="Date" width="15%" label="common.date.donedate.label">
							   <fmt:formatDate value="${track.completeTime}" pattern="${datetimePattern}"/>
						  </v3x:column>
						  <v3x:column nowarp="nowarp" type="String" width="10%" label="common.sender.label" value="${v3x:showMemberName(track.senderId)}">
						  </v3x:column>
						  <v3x:column nowarp="nowarp" type="String" label="application.type.label" width="10%">
						   	  <fmt:message key='${categoryLabel }' bundle='${v3xCommonI18N}' var="appName" />
						   	  <%-- branches_a8_v350_r_gov GOV-3001  唐桂林修改个人空间-已办事项会议链接 start --%>
							  <c:choose>
							  	<c:when test="${(isGov && track.app==6) || track.app==32}">
							  		<c:choose>
							  		<c:when test="${not empty typeURL}">
										<a title="${appName}" href="${typeURL}" >${appName} ${trackState}</a>	
									</c:when>
									<c:otherwise>
									    ${appName} ${trackState}
									</c:otherwise>
									</c:choose>
							  	</c:when>
							  	<c:otherwise>
							  		<a title="${appName}" href="${typeURL}" >${appName} ${trackState}</a>	
							  	</c:otherwise>
							  </c:choose>
							  <%-- branches_a8_v350_r_gov GOV-3001  唐桂林修改个人空间-已办事项会议链接 end --%>
						  </v3x:column>
					</v3x:table>
					</form>
				</div>
			</div>
		</div>
</body>
</html>