<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.inquiry.resources.i18n.InquiryResources" var="inquiryI18N"/>
<html>
<head>
<script type="text/javascript">
	function articleDetail(articleId){
		var url = "${detailURL}?method=showPost&articleId="+articleId+"&resourceMethod=listLatestFiveArticleAndAllBoard&group=${group}";
		var articleId = getMultyWindowId("articleId", url);
		openCtpWindow({'url':url,'id':articleId});
	}
	
	function newBtnEvent(boardId){
        openCtpWindow({'url':'${detailURL}?method=issuePost&spaceType=${param.spaceType}&boardId=' + boardId + '&group=${group}&spaceId=${param.spaceId}'});
    }
</script>
<style type="text/css">
.border_b {
border-bottom-color:#b6b6b6;
border-bottom-width:1px;
border-bottom-style:solid;
}
</style>
</head>
<body class="page_content public_page" oncontextmenu=self.event.returnValue=false>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="41" valign="top" >
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr>
		        	<!-- <td width="45"><div class="bbsIndex"></div></td>-->
					<td class="page2-header-bg border_b" width="380"><span style="font-size: 24px;color: #888;font-family:黑体;font-weight: normal;">${publicCustom ? spaceName : (param.group=='true'||param.group=='group' ? groupName : accountName)}<fmt:message key='application.9.label' bundle="${v3xCommonI18N}" /></span></td>
					<td class="padding-right border_b" align="right"></td>
					<td class="border_b">&nbsp;</td>
				</tr>	
			</table>
		</td>
		<c:if test="${fn:length(boardAndBbsList)>0}">
		<td class="border_b" height="20" width="35%">
			<form action="${detailURL}" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
				<input type="hidden" value="bbsSearch" name="method"> 
				<input type="hidden" name="id" value="${board.id}">
				<input type="hidden" name="group" value="${group}">
				<input type="hidden" name="spaceId" id="spaceId" value="${param.spaceId}">
				<input type="hidden" name="spaceType" id="spaceType" value="${param.spaceType}"> 
				<div class="div-float-right">
					<div class="div-float">
						<select name="condition"  id="condition" onChange="showNextCondition(this)" class="condition">
							<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}"/></option>
							<option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/></option>
							<option value="issueUser"><fmt:message key="bbs.issue.poster.label"/></option>
							<option value="issueTime"><fmt:message key="bbs.date.create"/></option>
						</select>
					</div>
						
					<div id="subjectDiv" class="div-float hidden"><input type="text" name="textfield" maxlength="50" onkeydown="javascript:searchWithKey()" class="textfield"></div>
					<div id="issueUserDiv" class="div-float hidden"><input type="text" name="textfield" maxlength="50" onkeydown="javascript:searchWithKey()" class="textfield"></div>
					<div id="issueTimeDiv" class="div-float hidden">
						<input type="text" id="startdate" name="textfield" class="input-date"
							onclick="whenstart('${pageContext.request.contextPath}',this,640,265);" readonly> - 
						<input type="text" id="enddate" name="textfield1" class="input-date"
							onclick="whenstart('${pageContext.request.contextPath}',this,720,265);" readonly>
					</div>
					<div onclick="javascript:doMySearch()" class="condition-search-button div-float button-font-color"></div>
				</div>
			</form>
			
			<div class="div-float-right">
				<a href="${detailURL}?method=listAllElite&group=${group}&spaceType=${param.spaceType}&spaceId=${param.spaceId}" class="link-blue">[<fmt:message key="bbs.see.HavingBoard.elite.label" />]</a>&nbsp;&nbsp;
			</div>
		</td>
	</tr>
	<tr>
		<td valign="top" class="padding_lr_10" colspan="2">
		<div class="scrollList" id="scrollListDiv" style="overflow:hidden;">
			<c:set var="loop" value="0" />
			<c:forEach items="${boardAndBbsList}" var="articleList" varStatus="status">
				<div class="index-type-name" style="padding-left:0; float:none;">
					${v3x:toHTML(boardModelList[loop].boardName)}
				</div>
				
				<div>				
					<v3x:table htmlId="pending${status.index}" dragable="false" className="sort ellipsis" data="${articleList}" var="col" showPager="false" size="6">
						<v3x:column width="45%" type="String" label="common.subject.label" className="cursor-hand sort" hasAttachments="${col.attachmentFlag}" alt="${col.articleName}" onmouseover="titlemouseover(this);" onmouseout="titlemouseout(this);" >
							<a href="javascript:articleDetail('${col.id}')" class="defaulttitlecss" title="${v3x:toHTML(col.articleName)}">
								<c:set value="50" var="nameLength" />
								<c:if test="${col.topSequence==1}">
									<font color="red">[<fmt:message key="bbs.top.label" />]</font>
									<c:set value="${nameLength - 4}" var="nameLength" />
								</c:if>
								<c:set var="tempV" value="${col.articleName}" />
								${v3x:toHTML(tempV)}
								<c:if test="${col.eliteFlag}">
									<font color="red">[<fmt:message key="bbs.elite.label" />]</font>
								</c:if>
							</a>
						</v3x:column>
						
						<c:set var="currentUserId" value="${v3x:currentUser().id}" />
						<c:choose>
							<c:when test="${col.anonymousFlag && currentUserId!=col.issueUser}">
								<fmt:message key="anonymous.label" var="createrUser"/>
							</c:when>
							<c:otherwise>
								<c:set value="${v3x:showOrgEntitiesOfIds(col.issueUser, 'Member', pageContext)}" var="createrUser"/>
							</c:otherwise>
						</c:choose>
						
						<v3x:column width="15%" type="String" label="bbs.issue.poster.label" value="${createrUser}" />
						
						<v3x:column width="18%" type="Date" align="left" label="bbs.date.create">
							<fmt:formatDate value="${col.issueTime}" pattern="${dataPattern}" />
						</v3x:column>
						
						<v3x:column width="10%" type="Number" align="center" label="bbs.clicknumber.label" value="${col.clickNumber}" />
						
						<v3x:column width="12%" type="Number" align="center" label="bbs.replynumber.label" value="${col.replyNumber}" />
					</v3x:table>
				</div>
				
				<div class="index-bottom">
				 	<div class="index-bottom index-bottom-left color_gray">
				 	<c:set value="," var="separator" />
				 	<c:set value="${v3x:joinDirectWithSpecialSeparator(boardModelList[loop].board.admins, separator)}"  var="boardAdminIds" />
							<fmt:message key="bbs.admin.label" />: <span class="" title="${v3x:showOrgEntitiesOfIds(boardAdminIds, "Member", pageContext)}">${v3x:toHTML(v3x:getLimitLengthString(v3x:showOrgEntitiesOfIds(boardAdminIds, "Member", pageContext),80,"..."))}</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</div>

					<div class="index-bottom index-bottom-right">
						<c:if test="${boardModelList[loop].isAdminFlag || boardModelList[loop].hasAuthIssue}">
							<input type="button" onclick="newBtnEvent('${boardModelList[loop].board.id}');" value="<fmt:message key='new.bbs.button' />" class="button-default-4">&nbsp;&nbsp;&nbsp;&nbsp;
						</c:if>
						
						<c:if test="${boardModelList[loop].isAdminFlag}">
							<input type="button" onclick="javascript:location.href='${detailURL}?method=listArticleMain&spaceType=${param.spaceType}&boardId=${boardModelList[loop].board.id}&dept=${dept}&group=${group}&spaceId=${param.spaceId}&where=${param.where}'" value="<fmt:message key='bbs.boardmanager.label' />" class="button-default-4">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</c:if>
							
						<a href="${detailURL}?method=listAllArticle&spaceType=${param.spaceType}&boardId=${boardModelList[loop].board.id}&group=${group}&spaceId=${param.spaceId}" class="link-blue"><fmt:message key="common.more.label" bundle="${v3xCommonI18N}" /></a>							
						<c:set value="${loop+1}" var="loop"/>
					</div>
				</div>
				<div style="clear:both;"></div>	
			</c:forEach>
		</div>
		</td>
	</tr>
</c:if>
	
<c:if test="${fn:length(boardAndBbsList)==0 }">
	<tr>
		<td align="center" style="background-position:right bottom ; background-repeat: no-repeat;" background="<c:url value="/apps_res/v3xmain/images/publicMessageBg.jpg"/>">
			<font style="font-size: 32px;color: #6c82ac"><fmt:message key="inquiry.type.no.create" bundle="${inquiryI18N}"/></font>
		</td>
	</tr>
</c:if>
</table>
<script type="text/javascript">
initIpadScroll("scrollListDiv",500,870);
var flag = '${param.group}';
if (flag == 'group' || flag == 'true') {
    showCtpLocation('F05_bbsIndexGroup');
} else {
    showCtpLocation('F05_bbsIndexAccount');
}
 if('18'=='${param.spaceType}'||'17'=='${param.spaceType}'||'space'=='${param.where}'){
    var theHtml=toHtml("${publicCustom ? spaceName : (param.group=='true'||param.group=='group' ? groupName : accountName)}",'<fmt:message key="application.9.label" bundle="${v3xCommonI18N}" />');
    showCtpLocation("",{html:theHtml});
}
</script>
</body>
</html>