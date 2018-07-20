<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/commonFuncs.js${v3x:resSuffix()}" />"></script>
</head>
<script type="text/javascript">
<!--
window.onload = function(){
	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
}
function setSearchPeopleFields(elements) {
	if(elements) {
		document.getElementById("createUserId").value = getIdsString(elements, false);	
		document.getElementById("createUserName").value = getNamesString(elements);
		document.getElementById("createUserName").title = getNamesString(elements);
	}
}
function changeMeetingType(obj){
	if(obj.checked){
		window.location.href = '${mtMeetingURL}?method=list4Quote&stateStr=' + obj.value + '&random=' + new Date().getTime();
	}
}

    function viewMeetingInfo(id, proxy, proxyId) {
        var url = '${mtMeetingURL}?method=mydetail&id=' + id + '&proxy='
                + proxy + '&proxyId=' + proxyId;
        var ret = v3x.openWindow({
            url : url,
            workSpaceRight : 'yes',
            dialogType: "open",
            FullScrean: 'yes',
        });
    }
//-->
</script>
<body scroll="no" onkeypress="listenerKeyESC()">
<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0" class="add-coll-border">
	<form action="" name="searchForm" id="searchForm" method="post" onkeypress="doSearchEnter()" onsubmit="return false" style="margin: 0px">
	<input type="hidden" value="<c:out value='${param.method}' />" name="method">
	<tr class="webfx-menu-bar-gray">
		<td height="22" class="webfx-menu-bar-gray">
			<label for="convoked"><input id="convoked" name="stateStr" type="radio" value="20" onclick="changeMeetingType(this)" ${(param.stateStr eq '20' || empty param.stateStr) ? 'checked' : ''}><fmt:message key='mt.mtMeeting.state.convoked'/></label>
			<label for="notConvoked"><input id="notConvoked" name="stateStr" type="radio" value="10" onclick="changeMeetingType(this)" ${param.stateStr eq '10' ? 'checked' : ''}><fmt:message key="mt.mtMeeting.state.10" /></label>
		</td>
		<td class="webfx-menu-bar-gray">
			<div class="div-float-right">
				<div class="div-float">
					<select name="condition" onChange="showNextCondition(this)" class="condition">
				    	<option><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
					    <option value="title"><fmt:message key="mt.mtMeeting.title" /></option>
					    <option value="createUser"><fmt:message key='mt.mtMeeting.createUser' /></option>
					    <option value="createDate"><fmt:message key="common.date.sendtime.label" bundle="${v3xCommonI18N}" /></option>
				  	</select>
			  	</div>
			  	<div id="titleDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
			  	
			  	<div id="createUserDiv" class="div-float hidden">
			  		<v3x:selectPeople id="createUser" panels="Department,Team" selectType="Member" departmentId="${currentUser.departmentId}" 
						jsFunction="setSearchPeopleFields(elements)" minSize="0" maxSize="1"  />
					<input type="text" name="textfield" id="createUserName" class="textfield" readonly="true" onclick="selectPeopleFun_createUser('createUserName', 'createUserId')" />
					<input type="hidden" name="textfield1" id="createUserId" />
			  	</div>
			  	
			  	<div id="createDateDiv" class="div-float hidden">
			  		<input type="text" name="textfield" id="startdate" class="input-date" onpropertychange="setDate('startdate')" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly />
			  		-
			  		<input type="text" name="textfield1" id="enddate" class="input-date" onpropertychange="setDate('enddate')" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly />
			  	</div>
			  	<div onclick="javascript:doSearch()" class="div-float condition-search-button"></div>
		  	</div>
		</td></form>
	</tr>
	<tr>
		<td colspan="2"><div class="scrollList">
			<form name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
			<v3x:table htmlId="pending" data="meetings" var="bean" isChangeTRColor="false" className="sort ellipsis">
				<c:choose>
					<c:when test="${bean.proxy}">
						<c:set value="1" var="proxy"/>
						<c:set value="${bean.proxyId}" var="proxyId"/>
					</c:when>
					<c:otherwise>
						<c:set value="0" var="proxy"/>
						<c:set value="-1" var="proxyId"/>
					</c:otherwise>
				</c:choose>
				
				<c:choose>
					<c:when test="${bean.accountId != v3x:currentUser().accountId}">
						<c:set value="(${v3x:showOrgEntitiesOfIds(bean.accountId, 'Account', pageContext)})" var="createAccountName"/>
					</c:when>
					<c:otherwise>
						<c:set value="" var="createAccountName"/>
					</c:otherwise>
				</c:choose>
				
				<c:set value="viewMeetingInfo('${bean.id}','${proxy}','${proxyId}');" var="click" />
				
				<fmt:formatDate value="${mt.createDate}" pattern="yyyy-MM-dd HH:mm:ss" var="createDate"/>
				<v3x:column width="35px" align="center" label="">
					<input type='checkbox' name='id' value="${bean.id}" createDate="${createDate }"
					  onclick="parent.quoteDocumentSelected(this, '${v3x:toHTMLWithoutSpaceEscapeQuote(bean.title)}', 'meeting', '${bean.id}')" />
				</v3x:column>

				<v3x:column width="50%" type="String" label="mt.mtMeeting.title" onClick="${click}"
					bodyType="${bean.dataFormat}" hasAttachments="${bean.hasAttachments}"
					alt="${createAccountName}${bean.title}" className="cursor-hand sort">
					<c:choose>
						<c:when test="${bean.proxy}">
							<div class="link-blue">
								${createAccountName}${v3x:toHTML(bean.title)}(<fmt:message key="mt.agent"/>${v3x:showMemberName(bean.proxyId)})
							</div>
						</c:when>
						<c:otherwise>
							${createAccountName}${v3x:toHTML(bean.title)}
						</c:otherwise>
					</c:choose>
				</v3x:column>
				
				<v3x:column width="12%" type="String" label="mt.mtMeeting.createUser" value="${v3x:showMemberName(bean.createUser)}" />
				
				<v3x:column width="15%" type="Date" label="mt.mtMeeting.beginDate">
					<fmt:formatDate pattern="${datePattern}" value="${bean.beginDate}" />
				</v3x:column>
				
				<v3x:column width="15%" type="Date" label="common.date.endtime.label">
					<fmt:formatDate pattern="${datePattern}" value="${bean.endDate}" />
				</v3x:column>
			</v3x:table>
			</form>
		</div></td>
	</tr>		
</table>
</body>
</html>