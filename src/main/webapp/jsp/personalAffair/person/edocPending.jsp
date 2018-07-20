<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
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
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<%@ taglib uri="http://v3x.seeyon.com/taglib/collaboration" prefix="col"%>
<html:link renderURL="/main.do" var="mainURL" />
<html:link renderURL="/edocController.do" var="edocURL" />
<html:link renderURL="/exchangeEdoc.do" var="exchangeURL" />

<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/collaboration/css/collaboration.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/collaboration.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/edoc.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/batch.js${v3x:resSuffix()}" />"></script>
<%--引用结束 --%>
<script type="text/javascript">
<!--
function openPendingDetail(_url, openType) {
	if(openType == 'href'){
		location.href = _url;
	}else{

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
<title>待办公文-更多</title>
</head>
<body scroll="no" style="overflow: hidden">
<c:set value="${param.searchType =='1'?'title-more-visited':'' }" var="isS1"/>
<c:set value="${param.searchType =='3'?'title-more-visited':'' }" var="isS3"/>
<c:set value="${param.searchType ==''||param.searchType ==null?'title-more-visited':'' }" var="isS0"/>
<c:set var="openType" value="${open}" />
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr class="page2-header-line">
		<td height="41" valign="top" class="page-list-border-LRD">
			 <table width="100%"  border="0" cellpadding="0" cellspacing="0">
		     <tr class="page2-header-line">
		     	<td width="45" class="page2-header-img"><div class="notepager"></div></td>
		        <td class="page2-header-bg"><fmt:message key="common.my.edocPending.title"/> (${countEdoc})</td>
		        <td class="page2-header-line page2-header-link" align="right"><a href="javascript:getA8Top().contentFrame.topFrame.back()"><fmt:message key='common.toolbar.back.label' bundle="${v3xCommonI18N}"/></a></td>
			</tr>
			</table>
		</td>
	</tr>
<tr>
<td valign="top" class="padding5">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   <%--
	   <tr>
	       <td valign="bottom" height="26" class="tab-tag">
				<div class="div-float">
					<div class="tab-separator"></div>
					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel">
						<fmt:message key='application.4.label' bundle='${v3xCommonI18N}'/>
						<fmt:message key="common.items.count.label" bundle='${v3xCommonI18N}'>
					      <fmt:param value="${countEdoc}" />
					    </fmt:message>
					</div>
					<div class="tab-tag-right-sel"></div>
				</div>

			 </td>
		</tr>
		 --%>
		<tr>
		   <td height="26" width="100%" class="webfx-menu-bar-gray webfx-menu-bar-gray-left" align="left">
	   			<div style="float: left; vertical-align: bottom; padding-top: 2px;">
					<script type="text/javascript">
					    	var edocContorller="${detailURL}";
					    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}","webfx-menu-bar-gray");

					    	if(v3x.getBrowserFlag('hideMenu')){
					    		myBar.add(new WebFXMenuButton("batch", "<fmt:message key='batch.title' bundle='${v3xCommonI18N}'/>", "javascript:batchEdoc()", [10,1], "", null));
							}
					    	document.write(myBar);
					    	document.close();
		   			</script>
		   		</div>
		   		<div style="float: left; padding-left: 10px; padding-top: 9px;">
					<a href="javascript:location.href='${mainURL}?method=edocPending&fragmentId=${param.fragmentId}&ordinal=${param.ordinal}&currentPanel=${param.currentPanel}&resultValue=${param.resultValue }'" class="${isS0 }"><fmt:message key="common.pending.all"/></a>&nbsp;&nbsp;|&nbsp;&nbsp;
		   			<a href="javascript:location.href='${mainURL}?method=edocPending&fragmentId=${param.fragmentId}&ordinal=${param.ordinal}&currentPanel=${param.currentPanel}&searchType=1&resultValue=${param.resultValue }'" class="${isS1 }"><fmt:message key="common.pending.col"/>
		   			<fmt:message key="common.items.count.label" bundle='${v3xCommonI18N}'>
					      <fmt:param value="${tempeleteCount}" />
					</fmt:message></a>&nbsp;&nbsp;|&nbsp;&nbsp;
		   			<a href="javascript:location.href='${mainURL}?method=edocPending&fragmentId=${param.fragmentId}&ordinal=${param.ordinal}&currentPanel=${param.currentPanel}&searchType=3&resultValue=${param.resultValue }'" class="${isS3 }"><fmt:message key="common.pending.overtime"/>
		   			<fmt:message key="common.items.count.label" bundle='${v3xCommonI18N}'>
					      <fmt:param value="${overTimeColCount}" />
					</fmt:message></a>
				</div>
	    	</td>
	    </tr>
	  <tr>
	    <td valign="top" colspan="2" class="">
	    <div class="scrollList">
	  <form action="" name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
	  		<c:url value='/common/images/overTime.gif' var="overTime" />
			<c:url value='/common/images/timeout.gif' var="timeOut" />
			<v3x:table width="100%" htmlId="pending" data="pendingList" var="pending" className="sort ellipsis" subHeight="120">
			      <c:set value="${v3x:toString(v3x:getApplicationCategoryEnum(pending.app))}" var="appCategory"/>
			      <c:set var="openType" value="${open}" />
			       <c:set var="subjects" value="${col:showSubject(pending, -1)}"/>
                  <c:set var="subject" value="${v3x:toHTML(subjects)}"/>
                  <c:set var="categoryLabel" value="application.${pending.app }.label" />
			      <v3x:column width="35" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
			      	<input type='checkbox' name='id' value="${pending.objectId }" affairId="${pending.id}" subject="${subject}"/>
				  </v3x:column>
				  <c:choose>
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
				     		<!-- branches_a8_v350_r_gov GOV-2073  唐桂林修改政务收文待发送链接 start -->
					     	<c:choose>
							<c:when test="${(v3x:getSysFlagByName('sys_isGovVer')=='true')}">
								<c:set var="categoryLabel" value="application.${pending.app }${v3x:suffix() }.label" />
								<c:set var="typeURL" value="${edocURL }?method=entryManager&entry=sendManager&toFrom=listFenfa" />
							</c:when>
							<c:otherwise>
								<c:set var="typeURL" value="${exchangeURL}?method=listMainEntry&modelType=toSend" />
							</c:otherwise>
							</c:choose>
					     	<!-- branches_a8_v350_r_gov GOV-2073  唐桂林修改政务收文待发送链接 end -->
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
				     		
				     		<c:choose>
							<c:when test="${(v3x:getSysFlagByName('sys_isGovVer')=='true')}">
							<c:set var="categoryLabel" value="application.${pending.app }${v3x:suffix() }.label" />
							<c:set var="typeURL" value="edocController.do?method=entryManager&entry=recManager&toFrom=listRecieve&edocType=1" />
							</c:when>
							<c:otherwise>
							<c:set var="typeURL" value="${exchangeURL}?method=listMainEntry&modelType=toReceive" />
							</c:otherwise>
							</c:choose>
							
					  	</c:when>
					  	<c:otherwise>
					  		<c:set var="typeURL" value=""/>
					  	</c:otherwise>
					  </c:choose>
					</c:when>
				    <c:when test="${appCategory == 'edocRegister'}">
				      	<c:set var="openType" value="${href}" />
				      
				     	 <!-- branches_a8_v350_r_gov GOV-2073  唐桂林修改政务收文登记链接 start -->
					     	<c:choose>
							<c:when test="${(v3x:getSysFlagByName('sys_isGovVer')=='true')}">
								<c:set var="categoryLabel" value="application.${pending.app }${v3x:suffix() }.label" />
								<c:set var="url" value="${edocURL}?method=entryManager&entry=recManager&edocType=1&toFrom=newEdocRegister&exchangeId=${pending.subObjectId}&edocId=${pending.objectId}&affairId=${pending.id }" />
								  <c:choose>
								  	<c:when test="${v3x:hasMenu(202) }">
							     		 <c:set var="typeURL" value="${edocURL }?method=entryManager&entry=recManager&toFrom=listRegister" />
								  	</c:when>
								  	<c:otherwise>
								  		<c:set var="typeURL" value=""/>
								  	</c:otherwise>
								  </c:choose>
							</c:when>
							<c:otherwise>
								  <c:set var="url" value="${edocURL}?method=entryManager&entry=newEdoc&comm=register&edocType=${exchangeType}&exchangeId=${pending.subObjectId}&edocId=${pending.objectId}" />
								  <c:choose>
								  	<c:when test="${v3x:hasMenu(202) }">
							     		 <c:set var="typeURL" value="${edocURL}?method=entryManager&entry=edocFrame&from=listRegisterPending" />
								  	</c:when>
								  	<c:otherwise>
								  		<c:set var="typeURL" value=""/>
								  	</c:otherwise>
								  </c:choose>
							</c:otherwise>
							</c:choose>
					     	<!-- branches_a8_v350_r_gov GOV-2073  唐桂林修改政务收文待发送链接 end -->
					</c:when>
					 <%-- 政务 收文分发 begin--%>
				    <c:when test="${v3x:getSysFlagByName('sys_isGovVer') eq 'true' && appCategory == 'edocRecDistribute'}">
				    	<c:set var="openType" value="${href}" />
				        <c:set var="url" value="${edocURL}?method=entryManager&entry=recManager&toFrom=newEdoc&edocType=1&id=${pending.objectId}&affairId=${pending.id }" />	
				     	<c:set var="typeURL" value="${edocURL}?method=listIndex&from=listDistribute&edocType=1&list=listDistribute" />
				    </c:when>
				    <%-- 政务 收文分发 end--%>
				  </c:choose>
                  <c:set var="click" value="openPendingDetail('${url}', '${openType}')"/>
                   <c:set var="altSubject" value="${v3x:escapeJavascript(subjects) }"/>
				  <c:choose>
					<c:when test="${pending.deadlineDate ne null && pending.deadlineDate ne ''}">
						<v3x:column width="42%" type="String" className="sort proxy-false nowrap"
						   label="common.subject.label"  maxLength="50" symbol="..."
						   bodyType="${pending.bodyType}" hasAttachments="${pending.hasAttachments}"
						   importantLevel="${pending.importantLevel}"
						   extIcons="${pending.isOvertopTime eq true ? timeOut : overTime}" alt="${altSubject}">
						   <a  href="javascript:${click}" class="title-more">${subject}</a>
						   </v3x:column>
					</c:when>
					<c:otherwise>
						<v3x:column width="42%" type="String" className="sort proxy-false nowrap"
						   label="common.subject.label"  maxLength="50" symbol="..."
						   bodyType="${pending.bodyType}" hasAttachments="${pending.hasAttachments}"
						   importantLevel="${pending.importantLevel}" alt="${altSubject}">
						   <a  href="javascript:${click}" class="title-more">${subject}</a>
						   </v3x:column>
					</c:otherwise>
				</c:choose>

				  <v3x:column width="18%" type="String" align="left" label="common.sender.label" maxLength="18" className="sort"
					   value="${v3x:showMemberName(pending.senderId)}"/>

				  <v3x:column width="20%" type="Date" align="left" label="common.date.sendtime.label" className="sort" >
					   <fmt:formatDate value="${pending.createDate}" pattern="${datetimePattern}"/>
				  </v3x:column>

				<fmt:message var="isOvertop" key='pending.overtop.${pending.isOvertopTime}.label' />
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
	    </td>
    </tr>
</table>
</td>
</tr>
</table>
</body>
</html>