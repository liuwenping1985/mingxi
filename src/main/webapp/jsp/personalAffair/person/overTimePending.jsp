<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<%@ taglib uri="http://v3x.seeyon.com/taglib/collaboration" prefix="col"%>
<html:link renderURL="/collaboration.do" var="collURL" />
<html:link renderURL="/edocController.do" var="edocURL" />
<html:link renderURL="/main.do" var="mainURL" />
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/collaboration/css/collaboration.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/collaboration.js${v3x:resSuffix()}" />"></script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
<!--
function openPendingDetail(_url, openType) {
	if(openType == 'href'){
		location.href = _url;
	}else {	
	   var rv = v3x.openWindow({
		        url: _url,
		        workSpace: 'yes'
		    });
		    if (rv == "true" || rv == true) {
		        getA8Top().reFlesh();
		    }
    }
}
getA8Top().showShortCut();
//-->
</script>
</head>
<body scroll="no" style="overflow: hidden">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr>
		<td width="100%" height="60" valign="top">
			 <table width="100%"  border="0" cellpadding="0" cellspacing="0">
		     <tr class="page2-header-line" height="60">
		        <td width="80" height="60"><img src="<c:url value="/apps_res/peoplerelate/images/pic1.gif" />" width="80" height="60" /></td>
		        <td class="page2-header-bg"><fmt:message key="common.my.overtime.title"/></td>
		        <td class="page2-header-line page2-header-link" align="right">
		        <a href="javascript:getA8Top().contentFrame.topFrame.back()"><fmt:message key='common.toolbar.back.label' bundle="${v3xCommonI18N}"/></a>
		        </td>
			</tr>
			</table>
		</td>
	</tr>
<tr>
<td valign="top" class="padding5">
<table align="center" width="100%" height="100%" cellpadding="0" cellspacing="0" class="page2-list-border">	
    <tr>
	   <td height="22" class="webfx-menu-bar page2-list-header">
       <fmt:message key="common.my.overtime.label">
	      <fmt:param value="${countOverTime}"></fmt:param>
	   </fmt:message>
       </td>
	</tr>
	<tr>
	  <td>
	  <div class="scrollList">
	   <form action="" name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
			<v3x:table width="100%" htmlId="overTimeTable" data="result" var="pending" className="sort ellipsis">
			     <c:set value="${v3x:toString(v3x:getApplicationCategoryEnum(pending.app))}" var="appCategory"/>
				  <c:choose>
				    <c:when test="${appCategory == 'collaboration'}">
    				  <c:set var="url" value="${collURL}?method=detail&from=Pending&affairId=${pending.id}&from=Pending"/>
    				  <c:set var="typeURL" value="${collURL}?method=collaborationFrame&from=Pending"/>
				    </c:when>
				    <c:when test="${appCategory == 'meeting'}">
				      <c:set var="url" value="${meetingURL}?method=mydetail&id=${pending.objectId}"/>
				      <c:set var="typeURL" value="${meetingURL}?method=listMain"/>     
				    </c:when>
				    <c:when test="${appCategory == 'edoc' || appCategory == 'edocSend'}">
				      <c:set var="url" value="${edocURL}?method=detail&from=Pending&affairId=${pending.id}"/>
					  <c:choose>
					  	<c:when test="${v3x:hasMenu(201) }">
				     		<c:set var="typeURL" value="${edocURL}?method=entryManager&entry=sendManager"/>
					  	</c:when>
					  	<c:otherwise>
					  		<c:set var="typeURL" value=""/>
					  	</c:otherwise>
					  </c:choose>				      
				    </c:when>
				    <c:when test="${appCategory == 'edocRec'}">
				      <c:set var="url" value="${edocURL}?method=detail&from=Pending&affairId=${pending.id}"/>	
					  <c:choose>
					  	<c:when test="${v3x:hasMenu(202) }">
				     		<c:set var="typeURL" value="${edocURL}?method=entryManager&entry=recManager"/>
					  	</c:when>
					  	<c:otherwise>
					  		<c:set var="typeURL" value=""/>
					  	</c:otherwise>
					  </c:choose>	
				    </c:when>
				    <c:when test="${appCategory == 'edocSign'}">
				      <c:set var="url" value="${edocURL}?method=detail&from=Pending&affairId=${pending.id}"/>	
					  <c:choose>
					  	<c:when test="${v3x:hasMenu(206) }">
				     		<c:set var="typeURL" value="${edocURL}?method=entryManager&entry=signReport"/>
					  	</c:when>
					  	<c:otherwise>
					  		<c:set var="typeURL" value=""/>
					  	</c:otherwise>
					  </c:choose>
				    </c:when>
				     <c:when test="${appCategory == 'exSend'}">
				      <c:set var="openType" value="${open}" />
				      <c:set var="url" value="${exchangeURL}?method=sendDetail&modelType=toSend&id=${pending.subObjectId}"/>	
					  <c:choose>
					  	<c:when test="${v3x:hasMenu(205) }">
				     		<c:set var="typeURL" value="${exchangeURL}?method=listMainEntry&modelType=toSend" />
					  	</c:when>
					  	<c:otherwise>
					  		<c:set var="typeURL" value=""/>
					  	</c:otherwise>
					  </c:choose>
					</c:when>
				    <c:when test="${appCategory == 'exSign'}">
				      <c:set var="openType" value="${open}" />
				      <c:set var="url" value="${exchangeURL}?method=receiveDetail&modelType=toReceive&id=${pending.subObjectId}"/>	
					  <c:choose>
					  	<c:when test="${v3x:hasMenu(205) }">
				     		<c:set var="typeURL" value="${exchangeURL}?method=listMainEntry&modelType=toReceive" />
					  	</c:when>
					  	<c:otherwise>
					  		<c:set var="typeURL" value=""/>
					  	</c:otherwise>
					  </c:choose>
					</c:when>
				    <c:when test="${appCategory == 'edocRegister'&& v3x:hasMenu(205)}">
				      <c:set var="openType" value="${href}" />
				      <c:set var="url" value="${edocURL}?method=entryManager&entry=newEdoc&comm=register&edocType=${exchangeType}&exchangeId=${pending.subObjectId}&edocId=${pending.objectId}" />	
					  <c:choose>
					  	<c:when test="${v3x:hasMenu(205) }">
				     		 <c:set var="typeURL" value="${edocURL}?method=entryManager&entry=edocFrame&from=listRegisterPending" />
					  	</c:when>
					  	<c:otherwise>
					  		<c:set var="typeURL" value=""/>
					  	</c:otherwise>
					  </c:choose>
				    </c:when>
				  </c:choose>
                  <c:set var="click" value="openPendingDetail('${url}', '${openType}')"/>
				  <c:url value="/common/images/overTime.gif" var="overTime"/>
			      <v3x:column type="String" className="sort" align="left" width="42%"
					   label="common.subject.label"
					   bodyType="${pending.bodyType}" extIcons="${overTime }" hasAttachments="${pending.hasAttachments}" importantLevel="${pending.importantLevel}">
					   <a href="javascript:${click}" class="title-more">${col:showSubject(pending, 80)}</a>
				  </v3x:column>
				 <v3x:column width="18%" type="String" align="left" label="common.sender.label" maxLength="18" className="sort"
					   value="${v3x:showMemberName(pending.senderId)}" alt="${v3x:showMemberName(pending.senderId)}"/>
				  <fmt:formatDate value="${pending.createDate}" pattern="${datetimePattern}" var="cTime"/>
				  <v3x:column width="20%" type="Date" align="left" label="common.date.sendtime.label" className="sort" value="${cTime }" alt="${cTime }" >
				  </v3x:column>
				  <c:choose>
					  <c:when test="${pending.deadlineDate eq null}">
						  <v3x:column width="10%" type="String" align="center" label="pending.deadlineDate.label" className="sort" >
						  	<fmt:message key='common.default' bundle='${v3xCommonI18N}'/>
						  </v3x:column>
					  </c:when>
					  <c:otherwise>
					  	  <fmt:message var="isOvertop" key='pending.overtop.${pending.isOvertopTime}.label' />
						  <v3x:column width="10%" type="String" align="center" label="pending.deadlineDate.label" className="sort deadline-false" 
						   alt="${v3x:_(pageContext, isOvertop)}" >
							  <v3x:metadataItemLabel metadata="${colMetadata.collaboration_deadline}" value="${pending.deadlineDate}"/>
						  </v3x:column>
					  </c:otherwise>
				  </c:choose>
				  <v3x:column width="10%" type="String" align="left" label="application.type.label" className="sort">
					<c:choose>
						<c:when test="${typeURL ne ''}">
							<a  href="${typeURL}"><fmt:message key='application.${pending.app}.label' bundle='${v3xCommonI18N}'/></a>
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
</form>
</body>
</html>