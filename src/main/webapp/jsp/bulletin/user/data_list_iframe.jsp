<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<%@ include file="../include/header.jsp"%>
<html>
<head>
<style type="text/css">
.border_b {
border-bottom-color:#b6b6b6;
border-bottom-width:1px;
border-bottom-style:solid;
}
</style>
</head>
<body class="page_content public_page" oncontextmenu=self.event.returnValue=false >
<c:set value="${v3x:currentUser().id}" var="currentUserId"/>
<table width="100%" border="0" cellspacing="0" cellpadding="0">		
	<tr>
		<td height="20" valign="top" class="">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr>
		        	<!--<td width="45"><div class="bulltenIndex"></div></td>-->
					<td class="page2-header-bg border_b" width="100%"><span style="font-size: 24px;color: #888;font-family:黑体;font-weight: normal;">${publicCustom ? spaceName : ( spaceType == 3 ? groupName : accountName)}<fmt:message key="bul.title" /></span></td>
					<td class="border_b padding-right" align="right"></td>
					<td class="border_b">&nbsp;</td>
				</tr>
			</table>
		</td>
		<c:if test="${fn:length(typeList)>0 }">
		<td class="border_b" height="20">
		<form action="${bulDataURL}" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
			<input type="hidden" value="indexSearch" name="method">
			<input type="hidden" value="${group}" name="group">
			<input type="hidden" value="${spaceType}" name="spaceType">
			<input type="hidden" value="${param.spaceId}" name="spaceId" id="spaceId">
			<div class="div-float-right">
				<div class="div-float">
					<select name="condition"   id="condition" onChange="showNextCondition(this)" class="condition">
						<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
						<option value="title"><fmt:message key="bul.biaoti.label" /></option>
						<option value="publishUserId"><fmt:message key="bul.data.createUser" /></option>
						<option value="publishDepartmentName"><fmt:message key="bul.data.publishDepartmentId" /></option>
						<option value="publishDate"><fmt:message key="bul.data.publishDate" /></option>
						<option value="updateDate"><fmt:message key="bul.data.updateDate" /></option>
					</select>
				</div>
				<div id="titleDiv" class="div-float hidden">
					<input type="text" name="textfield" id="titleInput"  maxlength="50" class="textfield" onkeydown="javascript:searchWithKey()">
				</div>
				<div id="publishUserIdDiv" class="div-float hidden">
					<input type="text" name="textfield" id="publishUserIdInput"  maxlength="50" class="textfield" onkeydown="javascript:searchWithKey()">
				</div>
				<div id="publishDepartmentNameDiv" class="div-float hidden">
					<input type="text" name="textfield" id="publishDepartmentNameInput"  maxlength="50" class="textfield" onkeydown="javascript:searchWithKey()">
				</div>
				<div id="publishDateDiv" class="div-float hidden">		
					<input type="text" name="textfield" id="startdate" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly  onkeydown="javascript:searchWithKey()"> - 
					<input type="text" name="textfield1" id="enddate" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly  onkeydown="javascript:searchWithKey()">
		 		</div>
				<div id="updateDateDiv" class="div-float hidden">		
					<input type="text" name="textfield" id="startdate1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly  onkeydown="javascript:searchWithKey()"> - 
					<input type="text" name="textfield1" id="enddate1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly  onkeydown="javascript:searchWithKey()">
		 		</div>
				<div onclick="javascript:doSearchInq()" class="condition-search-button div-float" style="color:black"></div>
			</div>
		</form>
		</td>
	</tr>
	<tr>
		<td valign="top" colspan="3" class="padding_lr_10">
		<div class="scrollList" id="scrollListDiv" style="overflow:hidden;">		
		<c:forEach items="${typeList}" var="bulletinType" varStatus="status">
			<c:set value="" var="bulDataList"/>
			<c:set value="" var="adminManager"/>
			<c:set value="" var="adminAudit"/>
			
			<c:if test="${bulletinType.bulType.managerUserIds != ''}">
				<c:set var="adminManager" value="${v3x:showOrgEntitiesOfIds(bulletinType.bulType.managerUserIds, 'Member', pageContext)}" />			
			</c:if>
			<c:if test="${bulletinType.bulType.auditUser != ''}">
				<c:set var="adminAudit" value="${v3x:showOrgEntitiesOfIds(bulletinType.bulType.auditUser, 'Member', pageContext)}" />
			</c:if>			
			
			<c:forEach var="alist" items="${list2}" varStatus="status2">
				<c:if test="${status.index == status2.index}">
					<c:set value="${alist}" var="bulDataList"/>
				</c:if>
			</c:forEach>
			
			<div class="index-type-name" style="padding-left:0; float:none;">
				${v3x:toHTML(bulletinType.bulType.typeName)}
			</div>
			
			<div>
				<v3x:table htmlId="leaveWord${status.index}" dragable="false"  className="sort ellipsis" data="${bulDataList}" showPager="false" var="bulletin" size="6" varIndex="dataIndex" >
					<c:choose>
						<c:when test="${bulletin.readFlag}">
							<c:set value="title-already-visited" var="readStyle" />
						</c:when>
						<c:otherwise>
							<c:set value="title-more-visited" var="readStyle" />
						</c:otherwise>
					</c:choose>	
							  
					<c:set value="javascript:openWin('${bulDataURL}?method=userView&id=${bulletin.id}&auditFlag=0&spaceId=${param.spaceId}')" 
						   var="clickEvent"/>
					
					<v3x:column type="String" width="25%" label="common.subject.label" 
						className="cursor-hand sort titleList" hasAttachments="${bulletin.attachmentsFlag}" 
						bodyType="${empty bulletin.ext5 ? bulletin.dataFormat : 'Pdf'}" alt="${bulletin.title}" 
						onmouseover="titlemouseover(this);" onmouseout="titlemouseout(this);">
						<c:if test="${bulletin.topOrder>0}">
							<font color="red">[<fmt:message key="label.top" />]</font>
						</c:if>	
						<a href="${clickEvent}"  class="${readStyle}" title="${v3x:toHTML(bulletin.title)}">
							${v3x:toHTML(bulletin.title)}
						</a>
					</v3x:column>
					<v3x:column width="15%" type="String" label="bul.data.publishDepartmentId" className="${readStyle}-span sort"
						value="${bulletin.publishDeptName}" maxLength="25" symbol="..." />
					<v3x:column width="13%" type="String" label="bul.data.createUser" className="${readStyle}-span sort"
						value="${bulletin.publishMemberName}" maxLength="25" symbol="..." />
					<v3x:column width="14%" type="Date" label="bul.data.publishDate" className="${readStyle}-span sort">
						<fmt:formatDate value="${bulletin.publishDate}" pattern="${datePattern}"/>
					</v3x:column>
					<v3x:column width="13%" type="Date" label="bul.data.updateDate" className="${readStyle}-span sort">
						<fmt:formatDate value="${bulletin.updateDate}" pattern="${datePattern}"/>
					</v3x:column>
					<v3x:column width="5%" type="Number" label="bul.data.readCount" className="${readStyle}-span sort"
						value="${bulletin.readCount}"/>

				</v3x:table>
			</div>
					
			<div class="index-bottom">
				<div class="index-bottom index-bottom-left color_gray">
					<fmt:message key="bul.type.managerUsers" />: <span class="">${adminManager}</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<c:if test="${bulletinType.bulType.auditFlag}">
						<fmt:message key="bul.type.auditUser" />: <span class="">${adminAudit}</span>
					</c:if>
				</div>
				
				<div class="index-bottom index-bottom-right">
					<c:if test="${bulletinType.canNewOfCurrent}">
						<input type="button" onclick="javascript:location.href='${bulDataURL}?method=publishListIndex&spaceType=${spaceType}&bulTypeId=${bulletinType.bulType.id}&spaceId=${param.spaceId}'" 
							value="<fmt:message key="oper.publish" /><fmt:message key="bul.data_shortname" />" class="button-default-4">&nbsp;&nbsp;&nbsp;&nbsp;						
					</c:if>
					<c:if test="${bulletinType.canAdminOfCurrent}">					
						<input type="button" onclick="javascript:location.href='${bulDataURL}?method=listBoardIndex&spaceType=${spaceType}&bulTypeId=${bulletinType.bulType.id}&showAdmin=true&spaceId=${param.spaceId}'" 
							value="<fmt:message key="bul.board" /><fmt:message key="oper.manage" />" class="button-default-4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</c:if>
					
					<c:if test="${!bulletinType.canAdminOfCurrent && bulletinType.bulType.auditUser==currentUserId}">					
						<input type="button" onclick="javascript:location.href='${bulDataURL}?method=auditIndex&spaceType=${spaceType}&showAudit=true&spaceId=${param.spaceId}&bulTypeId=${bulletinType.bulType.id}'" 
							value="<fmt:message key="bul.board" /><fmt:message key="oper.manage" />" class="button-default-4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</c:if>
											
					<c:set value="javascript:location.href='${bulDataURL}?method=bulMore&spaceType=${spaceType}&where=${param.where}&homeFlag=true&typeId=${bulletinType.bulType.id}&spaceId=${param.spaceId}';" var="clickHref" />
					<a href="${clickHref}" class="link-blue"><fmt:message key="common.more.label" bundle="${v3xCommonI18N}" /></a>&nbsp;							
				</div>
			</div>		
			<div style="clear:both;"></div>		
		</c:forEach>
		</div>
		</td>
	</tr>
	</c:if>
	
	<c:if test="${fn:length(typeList)==0 }">
		<tr>
			<td align="center" style="background-position:right bottom ; background-repeat: no-repeat;" background="<c:url value="/apps_res/v3xmain/images/publicMessageBg.jpg"/>">
				<font style="font-size: 32px;color: #6c82ac"><fmt:message key="inquiry.type.no.create" bundle="${inquiryI18N}" /></font>
			</td>
		</tr>
	</c:if>
</table>
<script type="text/javascript">
initIpadScroll("scrollListDiv",500,870);
if ('${spaceType}' == '3') {
    showCtpLocation('F05_bulIndexGroup');
} else {
    showCtpLocation('F05_bulIndexAccount');
}

if('18'=='${spaceType}'||'17'=='${spaceType}'||'space'=='${param.where}'){
    var theHtml=toHtml("${publicCustom ? spaceName : ( spaceType == 3 ? groupName : accountName)}",'<fmt:message key="bul.title"/>');
    showCtpLocation("",{html:theHtml});
}
</script>
</body>
</html>