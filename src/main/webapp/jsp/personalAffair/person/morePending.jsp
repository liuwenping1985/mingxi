<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%@page import="com.seeyon.ctp.portal.section.templete.BaseSectionTemplete"%><html>
<head>	
<%
    int exchangeType = com.seeyon.v3x.edoc.EdocEnum.edocType.recEdoc.ordinal();
    
    request.setAttribute("exchangeType",exchangeType);
    request.setAttribute("href", BaseSectionTemplete.OPEN_TYPE.href);
    request.setAttribute("open", BaseSectionTemplete.OPEN_TYPE.openWorkSpace);
%>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../header.jsp" %>
<%@ taglib uri="http://v3x.seeyon.com/taglib/collaboration" prefix="col"%>
<html:link renderURL="/main.do" var="mainURL" />
<html:link renderURL="/collaboration.do" var="collURL" />
<html:link renderURL="/mtMeeting.do" var="meetingURL" />
<html:link renderURL="/edocController.do" var="edocURL" />
<html:link renderURL="/newsData.do" var="newsURL" />
<html:link renderURL="/bulData.do" var="bulletinURL" />
<html:link renderURL="/inquirybasic.do" var="inquiryURL" />
<html:link renderURL="/exchangeEdoc.do" var="exchangeURL" />
<c:if test ="${(v3x:getSysFlagByName('sys_isGovVer')=='true') && (v3x:hasPlugin('govInfoPlugin'))}">
<html:link renderURL="/infoNavigationController.do" var="govInfoNavigationURL" />
<html:link renderURL="/infoDetailController.do" var="govInfoDetailURL" />
<html:link renderURL="/mtSummary.do" var="mtSummaryURL" />
<html:link renderURL="/mtAppMeetingController.do" var="mtAppMeetingURL" />
<html:link renderURL="/mtMeeting.do" var="mtMeetingURL" />
<html:link renderURL="/meetingroom.do" var="meetingroomURL" />

</c:if>
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/collaboration/css/collaboration.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/collaboration.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/batch.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>    
<%--引用结束 --%>
<script type="text/javascript">
<!--
function openPendingDetail(_url, openType, w, h) {
	if(openType == 'href'){
		location.href = _url;
	}else {	
		if(_url.indexOf("inquirybasic") > 0) {
			 openWin(_url) ;
		} else if(_url.indexOf("newsData") < 0 && _url.indexOf("bulData") < 0) {
		    var rv = v3x.openWindow({
		        url: _url,
		        width : w,
		        height : h,
		        workSpace: w ? '' : 'yes',
		        dialogType:v3x.getBrowserFlag('openWindow')?'modal':'open'
		    });
			if(_url.indexOf("inquirybasic.do?method=showInquiryFrame") != -1){
				getA8Top().reFlesh();
			}
			else if (rv == "true" || rv == true) {
		        getA8Top().reFlesh();
		    }
	    } else {
	    	v3x.openWindow({
		        url: _url,
		        width : w || screen.width-155,
				height : h || screen.height-190,
				top : 130,
				left : 140,
		        dialogType: 'open'
		    });
	    }
    }
}
//getA8Top().showShortCut();

var ExtendId = "${ExtendId}";
if(ExtendId){
	try{
		var ExtendObj = getA8Top().contentFrame.leftFrame.document.getElementById('person_space_' + ExtendId);
		if(ExtendObj){
			ExtendObj.innerHTML = "${v3x:getPaginationRowCount()}";
		}
	}
	catch(e){}
}
//-->
</script>
<title><fmt:message key="common.my.pending.title"/></title>
</head>
<body class="with-header${(panelSize!=1 && panelSize!=0) ? '-tab' : ''}">
<div class="main_div_row2">
  <div class="right_div_row2">
  	<div class="top_div_row2">
<c:set var="openType" value="${open}" />
<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
	<tr class="page2-header-line">
		<td width="100%" height="38" valign="top"  class="page-list-border-LRD gov_noborder gov_border_bottom">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     <tr class="page2-header-line">
		        <td width="45" class="page2-header-img"><div class="morePending"></div></td>
		        <td class="page2-header-bg">
		        ${(not empty ExtendTitle) ? v3x:_(pageContext, ExtendTitle) : v3x:_(pageContext, "common.my.pending.title")} (${v3x:getPaginationRowCount()})
		        </td>
			</tr>
			</table>
		</td>
	</tr>

<tr>
<td>
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	  <c:if test="${panelSize !=1 && panelSize!=0}">
	   <tr>
	       <td valign="bottom" height="26" colspan="2" class="tab-tag">
				 <c:forEach var="panel" items="${allPanels}">
					<c:set var="sel" value="${currentPanel == panel.id?'-sel':''}"></c:set>
					<div class="tab-tag-left${sel} "></div>
					<div class="tab-tag-middel${sel} cursor-hand" onclick="javascript:location.href='${mainURL}?method=morePending&fragmentId=${param.fragmentId }&ordinal=${param.ordinal }&currentPanel=${panel.id }'">
						${panel.name }
						<fmt:message key="common.items.count.label" bundle='${v3xCommonI18N}'>
						<fmt:param value="${panel.affairCount}" />
					    </fmt:message>
					</div>
					<div class="tab-tag-right${sel}"></div>
				</c:forEach>
			 </td>
		</tr>
		</c:if>
		<tr>
		  	 <td height="26" class="webfx-menu-bar" >
		  	 <c:if test="${isHiddenBach ne true}">
				<script type="text/javascript">
				var myBar = new WebFXMenuBar("${pageContext.request.contextPath}","webfx-menu-bar-gray");
				myBar.add(new WebFXMenuButton("batch", "<fmt:message key='batch.title' bundle='${v3xCommonI18N}' />", "javascript:batchColl()", [10,1], "", null));
				document.write(myBar);
		    	document.close();
				</script>
			  </c:if>
			  </td>
			  <td height="26" width="40%" class="webfx-menu-bar">
				<div class="div-float-right condition-search-div">
					<form action="" name="searchForm" id="searchForm" method="get" onkeypress="doSearchEnter()" onsubmit="return false" style="margin: 0px">
						<input type="hidden" name="pendingType" value="${param.pendingType }">
						<input type="hidden" name="method" value="${param.method }">
						<input type="hidden" name="app" value="${param.app}">
						<input type="hidden" name="fragmentId" value="${param.fragmentId }">
						<input type="hidden" name="ordinal" value="${param.ordinal }">
						<input type="hidden" name="currentPanel" value="${currentPanel }">
						<div class="div-float">
							<select id="condition" name="condition" onChange="showNextSpecialCondition(this)" class="condition">
						    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							    <option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" /></option>
							    <option value="sender"><fmt:message key="common.sender.label" bundle="${v3xCommonI18N}" /></option>
							    <option value="createDate"><fmt:message key="common.date.sendtime.label" bundle="${v3xCommonI18N}" /></option>
							    <c:if test="${SampleSearch ne true}">
							    <option value="importLevel"><fmt:message key="common.importance.label" bundle='${v3xCommonI18N}' /></option>
						  		<option value="subState"><fmt:message key="common.state.label" bundle="${v3xCommonI18N}" /></option>
						  		<option value="applicationEnum"><fmt:message key="common.app.type" bundle="${v3xCommonI18N}" /></option>
						  		</c:if>
						  	</select>
					  	</div>
					  	<div id="subjectDiv" class="div-float hidden"><input id="textfield" type="text" name="textfield" class="textfield"/></div>
					  	<div id="senderDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
					  	<c:if test="${SampleSearch ne true}">
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
					  			<option value="4,16,19,20,21,22,23,24,34"><fmt:message key="application.4.label" bundle="${v3xCommonI18N}" /></option>
					  			<option value="6"><fmt:message key="application.6.label" bundle="${v3xCommonI18N}" /></option>
					  			<option value="8"><fmt:message key="application.public.label" bundle="${v3xCommonI18N}" /></option>
					  			<%--综合办公 --%>
					  			<option value="26"><fmt:message key="application.26.label" bundle="${v3xCommonI18N}" /></option>
					  			<%--调查--%>
					  			<option value="10"><fmt:message key="application.10.label" bundle="${v3xCommonI18N}" /></option>
					  			<c:if test="${v3x:hasPlugin('govInfoPlugin')}">
					  			<option value="32"><fmt:message key="application.32.label" bundle="${v3xCommonI18N}" /></option>
					  			</c:if>
					  		</select>
					  	</div>
					  	</c:if>
					  	<div id="createDateDiv" class="div-float hidden">
					  		<input type="text" name="textfield" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
					  		-
					  		<input type="text" name="textfield1" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
					  	</div>
					  	<div onclick="javascript:doSearch()" class="div-float condition-search-button"></div>
					</form>
				</div>
	    	</td>
	    </tr>
        </table>
        </td></tr></table>
        </div>
        	<c:set value="${(v3x:getSysFlagByName('sys_isGovVer')=='true')}" var="isGov"></c:set>
            <c:set value="${hasEdocDistributeGrant }" var="hasEdocDistributeGrant"></c:set>
            <fmt:message key='edoc.gov.retreat.label' bundle='${v3xCommonI18N }' var="retreatLabel" />
            
        <div class="center_div_row2" id="scrollListDiv">
	  <form action="" name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
	  		<c:url value='/common/images/overTime.gif' var="overTime" />
			<c:url value='/common/images/timeout.gif' var="timeOut" />
			<v3x:table width="100%" htmlId="pending" data="pendingList" var="pending" className="sort ellipsis">
			      <c:set value="${v3x:toString(v3x:getApplicationCategoryEnum(pending.app))}" var="appCategory"/>
			      <c:set var="subjects" value="${v3x:showColSubject(pending, -1)}"/>
                  <c:set var="subject" value="${v3x:toHTML(subjects)}"/>
                  <c:set var="altSubject" value="${v3x:escapeJavascript(subjects) }"/>
			      <c:set var="openType" value="${open}" />
			      <c:set var="isRead" value="${pending.read}"/>		
			      <c:set var="categoryLabel" value="application.${pending.app}.label" />	
    			  <c:set var="winWidth" value="0" />
    			  <c:set var="winHeight" value="0" />		
    			  <c:set var="typeURL" value=""/>	            
    			  <c:set var="isProxy" value="${pending.memberId != currentUser.id }"/>	            
			      <c:choose>
			      <%-- branches_a8_v350sp1_r_gov GOV-4029 魏俊标 首页信息报送批处理 start--%>
			      	<c:when test="${pending.app != 1 && pending.app != 2 && pending.app != 19 && pending.app != 20 && pending.app != 21 && pending.app != 32}">
			      		<c:set var="isDisabled" value="disabled"/>
			      	</c:when>
			      	<%-- branches_a8_v350sp1_r_gov GOV-4029 魏俊标 首页信息报送批处理 end--%>
			      	<c:otherwise>
			      		<c:set var="isDisabled" value=""/>
			      	</c:otherwise>
			      </c:choose>
			      <v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
			      	<c:set var="disabled" value="${pending.app eq ApplicationCategoryEnum.office.key}"/>
			      	<input type="checkbox" name='id' value="${pending.objectId}" ${disabled} category="${pending.app}" affairId="${pending.id}" colSubject="${subject}" ${isDisabled}>
				  </v3x:column>
				  <c:choose>
				    <c:when test="${appCategory == 'collaboration'}">
    				  <c:set var="url" value="${collURL}?method=detail&from=Pending&affairId=${pending.id}&from=Pending"/>
    				  <c:set var="typeURL" value="${collURL}?method=collaborationFrame&from=Pending"/>
				    </c:when>
				    <%-- branches_a8_v350_r_gov GOV-2808 唐桂林修改会议审核/通知代理人处理及代理显示 start--%>
				    <c:when test="${appCategory == 'meeting'}">
				      <c:if test="${(pending.subApp == 5 || pending.subApp == 6 || pending.subApp == 7 || pending.subApp == 8)}">
                          <c:set var="categoryLabel" value="application.${pending.app }.${pending.subApp}${v3x:suffix() }.label" />
                      </c:if>
				      <c:choose>
				       <%--政务版 会议申请审核--%>
				       <c:when test="${(v3x:getSysFlagByName('sys_isGovVer')=='true') && pending.subApp == 6}">
				          <c:set var="url" value="${mtAppMeetingURL}?method=mydetail&id=${pending.objectId}&notApprove=1&affairId=${pending.id }"/>
				          <c:if test="${isMeetingReviewRight}">
                          <c:set var="typeURL" value="${meetingURL}?method=listHome&menuId=2101&listMethod=listAudit&listType=listAppAuditingMeeting&from=auditing"/>
                          </c:if>
				          </c:when>
				       <%--政务版 会议纪要审核 --%>
				       <c:when test="${(v3x:getSysFlagByName('sys_isGovVer')=='true') && pending.subApp == 7}">
				          <c:set var="url" value="${mtSummaryURL}?method=mydetail&recordId=${pending.objectId}&affairId=${pending.id }"/>
				          <c:set var="typeURL" value="${mtSummaryURL}?method=listHome&from=audit&listType=waitAudit"/>
				       </c:when>
				       <%--政务版 会议通知 --%>
				       <c:when test="${(v3x:getSysFlagByName('sys_isGovVer')=='true') && pending.subApp == 5}">
				          <c:set var="url" value="${meetingURL}?method=mydetail&id=${pending.objectId}&affairId=${pending.id }"/>
				          <c:set var="typeURL" value="${meetingURL}?method=entryManager&entry=myMeetingManager"/>
				       </c:when>
				       <c:otherwise>
				       		<c:choose>
				       	  		<c:when test="${isProxy}">
				       	  			<c:set var="url" value="${meetingURL}?method=mydetail&id=${pending.objectId}&proxy=1&proxyId=${pending.memberId}"/>
				       	  		</c:when>
				       	  		<c:otherwise>
				       	  			<c:set var="url" value="${meetingURL}?method=mydetail&id=${pending.objectId}"/>
				       	  		</c:otherwise>
				       	  	</c:choose>
				          <c:set var="typeURL" value="${meetingURL}?method=listMain"/>
				       </c:otherwise>
				      </c:choose>
				    </c:when>
				    <%--政务版 会议室审核 --%>
				    <c:when test="${(v3x:getSysFlagByName('sys_isGovVer')=='true') && pending.subApp == 8}">
				       <c:set var="url" value="${meetingroomURL}?method=createPerm&id=${pending.objectId}&affairId=${pending.id }"/>
				       <c:set var="typeURL" value="${meetingroomURL}?method=index"/><%-- branches_a8_v350_r_gov GOV-1346 向凡--%>
				    </c:when>
				    <%-- branches_a8_v350_r_gov GOV-2808 唐桂林修改会议审核/通知代理人处理及代理显示 end--%>
				    <c:when test="${appCategory == 'edoc' || appCategory == 'edocSend'}">
				      <c:set var="url" value="${edocURL}?method=detail&from=Pending&affairId=${pending.id}"/>
					  <c:if test="${v3x:hasMenu(201) }">
				     	<c:set var="typeURL" value="${edocURL}?method=entryManager&entry=sendManager"/>
					  </c:if>
				    </c:when>
				    <c:when test="${appCategory == 'edocRec'}">
				      <c:set var="url" value="${edocURL}?method=detail&from=Pending&affairId=${pending.id}"/>	
					  <c:if test="${v3x:hasMenu(202) }">
					  	 <%-- branches_a8_v350_r_gov GOV-2641  唐桂林修改政务收文阅件链接 start --%>
					  	<c:choose>
					     	<c:when test="${(v3x:getSysFlagByName('sys_isGovVer')=='true')}"> 
					     		<c:set var="typeURL" value="${edocURL}?method=entryManager&entry=recManager&objectId=${pending.objectId }"/>
					     	</c:when>
					     	<c:otherwise>
					     		<c:set var="typeURL" value="${edocURL}?method=entryManager&entry=recManager"/>
					     	</c:otherwise>
				     	</c:choose>
				     	 <%-- branches_a8_v350_r_gov GOV-2641  唐桂林修改政务收文阅件链接 end--%>
					  </c:if>
				    </c:when>
				    <c:when test="${appCategory == 'edocSign'}">
				      <c:set var="url" value="${edocURL}?method=detail&from=Pending&affairId=${pending.id}"/>	
					  <c:if test="${v3x:hasMenu(206) }">
				     	<c:set var="typeURL" value="${edocURL}?method=entryManager&entry=signReport"/>
					  </c:if>
				    </c:when>
				    <c:when test="${appCategory == 'news'}">
		    			<%--<c:set value="${main:getPendingCategoryLink(pending)}" var="links" />--%>
		    			<c:set value="" var="links" />
		    			<c:url var="url" value="${links[0]}"/>
				    	<c:url var="typeURL" value="${links[1]}"/>
				    </c:when>
				    <c:when test="${appCategory == 'bulletin'}">
		    			<%--<c:set value="${main:getPendingCategoryLink(pending)}" var="links" />--%>
                        <c:set value="" var="links" />
		    			<c:url var="url" value="${links[0]}"/>
				    	<c:url var="typeURL" value="${links[1]}"/>
				    </c:when>
				    <c:when test="${appCategory == 'inquiry'}">
				    	<%--<c:set value="${main:getPendingCategoryLink(pending)}" var="links" />--%>
                        <c:set value="" var="links" />
		    			<c:url var="url" value="${links[0]}"/>
				    	<c:url var="typeURL" value="${links[1]}"/>
				    </c:when>
				    <c:when test="${appCategory == 'exSend'}">
				      <c:set var="openType" value="${open}" />
				      <c:set var="url" value="${exchangeURL}?method=sendDetail&modelType=toSend&id=${pending.subObjectId}&affairId=${pending.id}"/>	
					  
			     	<!-- branches_a8_v350_r_gov GOV-2073  唐桂林修改政务收文待发送链接 start -->
			     	<c:choose>
						<c:when test="${(v3x:getSysFlagByName('sys_isGovVer')=='true')}">
							<c:set var="categoryLabel" value="application.${pending.app }${v3x:suffix() }.label" />
							<%-- branches_a8_v350_r_gov GOV-5016.公文的首页代办中，有一条公文分发数据，点击公文发文链接进去却没有数据 start --%>
							<c:set var="modelType" value="toSend" />
							<c:set value="false" var="isEdocExSendRetreat"></c:set>
							<c:forEach items="${pending.extProperties }" var="extProp">
								<c:if test="${extProp.key=='edocExSendRetreat' }">
									<c:set value="true" var="isEdocExSendRetreat"></c:set>		
								</c:if>
							</c:forEach>
							<c:if test="${pending.app==22 && isEdocExSendRetreat }">
								<c:set var="subject" value="${subject }(${retreatLabel })" />
								<c:set var="modelType" value="sent" />
							</c:if>
							<c:choose>	
								<c:when test="${v3x:hasMenu(205) }">
									<c:set var="typeURL" value="${edocURL }?method=entryManager&entry=sendManager&toFrom=listFenfa&modelType=${modelType }" />
								</c:when>
								<c:otherwise>
									<c:set var="typeURL" value="" />
								</c:otherwise>
							</c:choose>
							<%-- branches_a8_v350_r_gov GOV-5016.公文的首页代办中，有一条公文分发数据，点击公文发文链接进去却没有数据 end --%>
						</c:when>
						<c:otherwise>
							<c:if test="${v3x:hasMenu(205) }">
								<c:set var="typeURL" value="${exchangeURL}?method=listMainEntry&modelType=toSend" />
							</c:if>
						</c:otherwise>
					</c:choose>
			     	<!-- branches_a8_v350_r_gov GOV-2073  唐桂林修改政务收文待发送链接 end -->
					  
					</c:when>
				    <c:when test="${appCategory == 'exSign'}">
				      	<c:set var="openType" value="${open}" />
				      	<c:set var="url" value="${exchangeURL}?method=receiveDetail&modelType=toReceive&id=${pending.subObjectId}&affairId=${pending.id}"/>	
					  	<!-- branches_a8_v350_r_gov GOV-2646 常屹 修改从代理事项中点击待签收后进入的页面不对 start -->
					  	<c:choose>
							<c:when test="${(v3x:getSysFlagByName('sys_isGovVer')=='true')}">
								<c:set var="categoryLabel" value="application.${pending.app }${v3x:suffix() }.label" />
								<c:set var="modelType" value="toReceive" />
								<c:set value="false" var="isEdocRecieveRetreat"></c:set>
								<c:forEach items="${pending.extProperties }" var="extProp">
									<c:if test="${extProp.key=='edocRecieveRetreat' }">
										<c:set value="true" var="isEdocRecieveRetreat"></c:set>		
									</c:if>
								</c:forEach>
								<c:if test="${pending.app==23 && isEdocRecieveRetreat }">
									<c:set var="subject" value="${subject }(${retreatLabel })" />
									<c:set var="modelType" value="retreat" />		
								</c:if>
								<c:set var="url" value="${exchangeURL}?method=receiveDetail&modelType=${modelType }&id=${pending.subObjectId}&affairId=${pending.id}"/>
								
								<c:choose>	
									<c:when test="${v3x:hasMenu(205) }">
										<c:set var="typeURL" value="edocController.do?method=entryManager&entry=recManager&toFrom=listRecieve&edocType=1" />
										<c:if test="${isEdocRecieveRetreat }">
						     				<c:set var="typeURL" value="${typeURL }&listType=listRecieveRetreat" />	
						     			</c:if>
									</c:when>
									<c:otherwise>
										<c:set var="typeURL" value="" />
									</c:otherwise>
								</c:choose>
						  	</c:when>
						  	<c:otherwise>
						  		<c:choose>
							  	 	<c:when test="${v3x:hasMenu(205) }">
							  	 		<c:set var="typeURL" value="${exchangeURL}?method=listMainEntry&modelType=toReceive" />
							  	 	</c:when>
							  	 	<c:otherwise>
							  	 		<c:set var="typeURL" value="" />
							  	 	</c:otherwise>	
						  	 	</c:choose>
						  	</c:otherwise>
					  	</c:choose>
					  	<!-- branches_a8_v350_r_gov GOV-2646 常屹 修改从代理事项中点击待签收后进入的页面不对 end -->

					</c:when>
				    <c:when test="${appCategory == 'edocRegister'}">
					  	<c:choose>
				        <%--政务版 收文登记 --%>
				      	<c:when test="${v3x:getSysFlagByName('sys_isGovVer') eq 'true'}">
				      		<c:set var="openType" value="${href}" />
				      		<c:set var="categoryLabel" value="application.${pending.app }${v3x:suffix() }.label" />
				      		<c:set value="false" var="isEdocRegisterRetreat"></c:set>
				      		<c:forEach items="${pending.extProperties }" var="extProp">
								<c:if test="${extProp.key=='edocRegisterRetreat' }">
									<c:set value="true" var="isEdocRegisterRetreat"></c:set>		
								</c:if>
							</c:forEach>
							<c:if test="${pending.app==24 && isEdocRegisterRetreat }">
								<c:set var="subject" value="${subject }(${retreatLabel })" />
							</c:if>
				      		<c:set var="url" value="${edocURL}?method=entryManager&entry=recManager&edocType=1&toFrom=newEdocRegister&exchangeId=${pending.subObjectId}&edocId=${pending.objectId}&affairId=${pending.id }&app=${param.app }" />	
					  		<c:if test="${isEdocCreateRegister}">
				     			<c:set var="typeURL" value="${edocURL}?method=entryManager&entry=recManager&toFrom=listRegister&edocType=1" />
				     			<c:if test="${isEdocRegisterRetreat }">
				     				<c:set var="typeURL" value="${typeURL }&listType=registerRetreat" />	
				     			</c:if>
					  		</c:if>
					  	</c:when>
					  	<c:otherwise>
					  		<c:set var="openType" value="${href}" />
				      		<c:set var="url" value="${edocURL}?method=entryManager&entry=newEdoc&comm=register&edocType=${exchangeType}&exchangeId=${pending.subObjectId}&edocId=${pending.objectId}&affairId=${pending.id}" />	
					  		<c:if test="${v3x:hasMenu(202) }">
					  		    <!-- 待登记的公文 无需链接 -->
					  		</c:if>
					  	</c:otherwise>
					  </c:choose>
				    </c:when>			  
				      
				    <%-- branches_a8_v350_r_gov GOV-2991  唐桂林修改个人空间-待办事项信息报送链接 start --%>
					    <c:when test="${appCategory == 'info'}">
					     	<c:set var="url" value="infoDetailController.do?method=detail&summaryId=${track.objectId }&from=Pending&affairId=${pending.id }"/>
				      		<c:set var="typeURL" value="infoNavigationController.do?method=indexManager&entry=infoAuditing&affairId=${track.id }"/>
					    </c:when>
				    <%-- branches_a8_v350_r_gov GOV-2991  唐桂林修改个人空间-待办事项信息报送链接 end --%>
				    
				    <%--wangjingjing 政务 收文分发 begin--%>
				    <c:when test="${v3x:getSysFlagByName('sys_isGovVer') eq 'true' && appCategory == 'edocRecDistribute'}">
				    	<c:set var="openType" value="${href}" />
				        <c:set var="url" value="${edocURL}?method=entryManager&entry=recManager&toFrom=newEdoc&edocType=1&id=${pending.objectId}&affairId=${pending.id }&app=${param.app }" />
				        <c:if test="${hasEdocDistributeGrant }">
				        	<c:set var="typeURL" value="${edocURL}?method=listIndex&from=listDistribute&edocType=1&list=listDistribute" />	
				        </c:if>
				    </c:when>
				    <%--wangjingjing 政务 收文分发 end--%>
				    <c:when test="${appCategory == 'office'}">
		    			<c:set var="categoryLabel" value="application.26.${pending.subApp}.label" />
		    			<c:set var="winWidth" value="750" />
		    			<c:set var="winHeight" value="360" />
				    	<c:choose>
				    		<c:when test="${pending.subApp == 0}">
				    			<c:set var="url" value="autoAudit.do?method=edit&from=portal&applyId=${pending.objectId}" />
				    			<c:set var="typeURL" value="autoInfo.do?method=index&type=3" />
				    		</c:when>
				    		<c:when test="${pending.subApp == 1}">
				    			<c:set var="url" value="stockAudit.do?method=edit&from=portal&applyId=${pending.objectId}" />
				    			<c:set var="typeURL" value="stockInfo.do?method=index&type=3" />
				    		</c:when>
				    		<c:when test="${pending.subApp == 2}">
				    			<c:set var="url" value="asset.do?method=create_perm&from=portal&fs=1&id=${pending.objectId}" />
				    			<c:set var="typeURL" value="asset.do?method=jumpUrl&from=portal&url=office/asset/frameset" />
				    		</c:when>
				    		<c:when test="${pending.subApp == 3}">
				    			<c:set var="url" value="book.do?method=create_perm&from=portal&show=1&id=${pending.objectId}" />
				    			<c:set var="typeURL" value="book.do?method=jumpUrl&from=portal&url=office/book/frameset" />
				    		</c:when>
				    		<c:when test="${pending.subApp == 4}">
				    			<c:set var="url" value="meetingroom.do?method=createPerm&openWin=1&id=${pending.objectId}" />
				    			<c:set var="typeURL" value="meetingroom.do?method=index&from=portal" />
				    		</c:when>
				    	</c:choose>
				    </c:when>
				  </c:choose>
                  <c:set var="click" value="openPendingDetail('${url}', '${openType}', ${winWidth }, ${winHeight })"/>
                  <c:set var="isGovAgent" value="${(v3x:getSysFlagByName('sys_isGovVer')=='true') && (appCategory == 'meeting' || appCategory == 'edoc' || appCategory == 'edocSend'  || appCategory == 'edocRec' || appCategory == 'edocSign' || appCategory == 'exSend' || appCategory == 'exSign' || appCategory == 'edocRegister' || appCategory == 'edocRecDistribute' || (v3x:hasPlugin('govInfoPlugin') && appCategory == 'info'))  }"/>
				  <c:choose>
					<c:when test="${pending.deadlineDate ne null && pending.deadlineDate ne 0}">
						<v3x:column width="35%" type="String" className="sort proxy-false nowrap" 
						   label="common.subject.label"  maxLength="50" symbol="..." read="${isRead}"
						   bodyType="${pending.bodyType}" hasAttachments="${pending.hasAttachments}" 
						   importantLevel="${pending.importantLevel}"
						   extIcons="${pending.isOvertopTime eq true ? timeOut : overTime}" alt="${altSubject }">
						   <%-- branches_a8_v350_r_gov GOV-2808 唐桂林修改会议审核/通知代理人处理及代理显示 start--%>
						   <a href="javascript:${click}" class="title-more">${subject}
						   		<c:if test="${isGovAgent && pending.memberId!=currentUser.id}">
						   			(<fmt:message key="common.agent.label" bundle="${v3xCommonI18N }" />${v3x:showMemberName(pending.memberId)}) 
						   		</c:if>
						   </a>	
						   <%-- branches_a8_v350_r_gov GOV-2808 唐桂林修改会议审核/通知代理人处理及代理显示 end --%>
						   </v3x:column>
					</c:when>
					<c:otherwise>
						<v3x:column width="35%" type="String" className="sort proxy-false nowrap" 
						   label="common.subject.label"  maxLength="50" symbol="..."  read="${isRead}"
						   bodyType="${pending.bodyType}" hasAttachments="${pending.hasAttachments}" 
						   importantLevel="${pending.importantLevel}" alt="${altSubject }">
						   <a  href="javascript:${click}" class="title-more">${subject}
						   		<c:if test="${isGovAgent && pending.memberId!=currentUser.id}">
						   			(<fmt:message key="common.agent.label" bundle="${v3xCommonI18N }" />${v3x:showMemberName(pending.memberId)})
						   		</c:if>
						   </a>	
						   </v3x:column>
					</c:otherwise>
				</c:choose>
				  	   
				  <v3x:column width="10%" type="String" align="left" label="common.sender.label" className="sort" read="${isRead}"
					   value="${v3x:showMemberName(pending.senderId)}" alt="${v3x:showMemberName(pending.senderId)}"/>
				  
				  <%--发起时间 --%>
				  <fmt:formatDate value="${pending.createDate}" pattern="${datetimePattern}" var="cTime"/>
				  <v3x:column width="15%" type="Date" align="left" label="common.date.sendtime.label" className="sort" value="${cTime }" read="${isRead}" alt="${cTime }" >
				  </v3x:column>
				  
				  <%--接受时间 --%>
				  <fmt:formatDate value="${pending.receiveTime}" pattern="${datetimePattern}" var="rTime"/>
				  <v3x:column width="15%" type="Date" align="left" label="col.time.receive.label" className="sort" value="${rTime }" read="${isRead}" alt="${rTime }" >
				  </v3x:column>
				
				<fmt:message var="isOvertop" key='pending.overtop.${pending.isOvertopTime}.label' />
				<c:choose>
				  <c:when test="${pending.deadlineDate eq null}">
					  <v3x:column width="10%" type="String" align="center" label="pending.deadlineDate.label" className="sort" read="${isRead}">
					  	<fmt:message key='common.default' bundle='${v3xCommonI18N}'/>
					  </v3x:column>
				  </c:when>
				  <c:otherwise>
				  	  <fmt:message var="isOvertop" key='pending.overtop.${pending.isOvertopTime}.label' />
					  <v3x:column width="10%" type="String" align="center" label="pending.deadlineDate.label" className="sort deadline-false" 
					   alt="${v3x:_(pageContext, isOvertop)}" read="${isRead}">
						  <v3x:metadataItemLabel metadata="${colMetadata.collaboration_deadline}" value="${pending.deadlineDate}"/>
					  </v3x:column>
				  </c:otherwise>
				  </c:choose>
				
			  <v3x:column width="10%" type="String" align="left" label="application.type.label" className="sort" read="${isRead}">
				<c:choose>
					<c:when test="${not empty typeURL}">
						<a  href="${typeURL}"><fmt:message key='${categoryLabel }' bundle='${v3xCommonI18N}'/></a>
					</c:when>
					<c:otherwise>
					    <fmt:message key='${categoryLabel }' bundle='${v3xCommonI18N}'/>
					</c:otherwise>
				</c:choose>
			  </v3x:column>
			</v3x:table>
			</form>
		</div>
	    </div>
  </div>

<script type="text/javascript">
	var oHeight = parseInt(document.body.clientHeight)-112;
	var oWidth = parseInt(document.body.clientWidth)-5;
	initFFScroll('scrollListDiv2',oHeight,oWidth);

//branches_a8_v350sp1_r_gov 常屹修改 GOV-4563  【代理事项】小查询中，输入特殊字符，查询，报错。  
  <c:choose>
  <c:when test ="${v3x:getSysFlagByName('sys_isGovVer')=='true'}">
      showCondition("${param.condition}", "${v3x:escapeJavascript(param.textfield)}", "${v3x:escapeJavascript(param.textfield1)}");
  </c:when>
  <c:otherwise>
  showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
  </c:otherwise>
  </c:choose>
	
	
	
</script>
</body>
</html>