<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>
<html>
<head>
<script type="text/javascript">
<!--
	function inquiryDetail(id,typeId){
		var acturl = "${basicURL}?method=showInquiryFrame&spaceType=${param.spaceType}&bid=" + id + "&surveytypeid=" + typeId+"&group=${param.group}&spaceId=${param.spaceId}";
		var bid = getMultyWindowId("bid", acturl);
        openCtpWindow({'url':acturl,'id':bid});
	}
	
    function dateChecks () {
        var condition = document.getElementById('condition').value;
        if (condition == 'createDate') {
            return dateCheck();
        } else {
            doSearch();
        }
    }
//-->
</script>
<style type="text/css">
.border_b {
border-bottom-color:#b6b6b6;
border-bottom-width:1px;
border-bottom-style:solid;
}
</style>
</head>
<body class="page_content public_page" oncontextmenu="self.event.returnValue=false" scroll="auto" style="overflow-y:auto;padding:0;">
<c:set value="${v3x:currentUser().id}" var="currentUserId"/>
<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="41" valign="top">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr>
		        	<!--<td width="45"><div class="inquiryIndex"></div></td>-->
					<td class="page2-header-bg border_b" width="380"><span style="font-size: 24px;color: #888;font-family:黑体;font-weight: normal;">${publicCustom ? spaceName : (param.group=='group' ? groupName : accountName)}<fmt:message key='application.10.label' bundle="${v3xCommonI18N}" /></span></td>
					<td class=" padding-right border_b" align="right"></td>
					<td class="border_b">&nbsp;</td>
				</tr>	
			</table>
		</td>
		<c:if test="${fn:length(typeAndBasicList)>0 }">
		<td height="20" class="border_b">
			<form action="${basicURL}" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
				<input type="hidden" value="inquirySearch" name="method">
				<input type="hidden" value="${param.group}" name="group">
				<input type="hidden" value="${param.spaceId}" name="spaceId" id="spaceId">
				<input type="hidden" value="${param.spaceType}" name="spaceType" id="spaceType">
				<div class="div-float-right">
					<div class="div-float">
						<select name="condition" id="condition"  onChange="showNextCondition(this)" class="condition">
							<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}"/></option>
							<option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/></option>
							<option value="creater"><fmt:message key="inquiry.creater.label"/></option>
							<option value="createDate"><fmt:message key="inquiry.date.create"/></option>
						</select>
					</div>
					<div id="subjectDiv" class="div-float hidden"><input type="text"  maxlength="50" name="textfield" class="textfield" onkeydown="javascript:searchWithKey()"></div>
					<div id="createrDiv" class="div-float hidden"><input type="text"  maxlength="50" name="textfield" class="textfield" onkeydown="javascript:searchWithKey()"></div>
					<div id="createDateDiv" class="div-float hidden">
						<input type="text" id="startdate" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,640,265);" readonly onkeydown="javascript:searchWithKey()"> - 
						<input type="text" id="enddate" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,640,265);" readonly onkeydown="javascript:searchWithKey()">
					</div>
					<div onclick="javascript:return dateChecks()" class="div-float condition-search-button button-font-color"></div>
				</div>
			</form>
		</td>
		</c:if>
	</tr>
<c:if test="${fn:length(typeAndBasicList)>0 }">
	<tr >
		<td valign="top" colspan="2" class="padding_lr_10">
		<div class="scrollList" id="scrollListDiv" style="height:auto;overflow:visible;">
			<c:set var="loop" value="0"/>
			<c:forEach items="${typeAndBasicList}" var="inquiryBasicList" varStatus="status">
				<div class="index-type-name" style="padding-left:0; float:none;">
				${v3x:toHTML(typeList[loop].inquirySurveytype.typeName)}
				</div>
				<div>
					<v3x:table htmlId="leaveWord${status.index}" className="sort ellipsis" dragable="false" data="${inquiryBasicList}" showPager="false" var="basic" size="6">
						<c:set value="inquiryDetail('${basic.inquirySurveybasic.id}','${basic.inquirySurveybasic.surveyTypeId}')" var="clickEvent"/>
						  <v3x:column type="String" label="common.subject.label" className="cursor-hand sort titleList" hasAttachments="${basic.inquirySurveybasic.attachmentsFlag}" alt="${basic.inquirySurveybasic.surveyName}" 
							onmouseover="titlemouseover(this);" onmouseout="titlemouseout(this);">
							<a href="javascript:${clickEvent}" class="title-more-visited" title="${v3x:toHTML(basic.inquirySurveybasic.surveyName)}">
								${v3x:toHTML(basic.inquirySurveybasic.surveyName)}
							</a>
						  </v3x:column>
						  
					      <v3x:column width="10%" type="String" label="inquiry.creater.label" value="${v3x:showOrgEntitiesOfIds(basic.inquirySurveybasic.createrId, 'Member', pageContext)}"
					       maxLength="10" symbol="..." />
						  
						  <v3x:column width="15%" type="Date" label="inquiry.date.create">
							<fmt:formatDate value="${basic.inquirySurveybasic.sendDate}" pattern="${datePattern}"/>
						  </v3x:column>
						  
				  		  <c:choose>
					          <c:when test="${ basic.inquirySurveybasic.closeDate eq null }">
					           		<v3x:column type="String"  label="inquiry.close.time.label"  className="sort" width="15%" align="left"><fmt:message key="inquiry.no.limit" /></v3x:column>		      
					          </c:when>
							  <c:otherwise>
							    	<v3x:column type="Date" label="inquiry.close.time.label"  className="sort" width="15%" align="left"><fmt:formatDate value="${basic.inquirySurveybasic.closeDate}" pattern="${ datePattern }"/></v3x:column>       
							  </c:otherwise>
		                  </c:choose>
					</v3x:table>
				 </div>
				 <div class="index-bottom">
				 	<div class="index-bottom index-bottom-left color_gray">
				 		<c:set value="${v3x:joinWithSpecialSeparator(typeList[loop].managers,'id', ',')}" var="managersStr"/>
						<fmt:message key="inquiry.manager.label" />: <span class="">${v3x:showOrgEntitiesOfIds(managersStr, "Member", pageContext)}</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<c:if test="${typeList[loop].checker != null}">
							<fmt:message key="inquiry.auditor.label" />: <span class="">${v3x:showOrgEntitiesOfIds(typeList[loop].checker.id, 'Member', pageContext)}</span>
						</c:if>
				 	</div>
				 	<div class="index-bottom index-bottom-right">
	 					<c:if test="${typeList[loop].hasPublicAuth}">									
							<input type="button" onclick="inquiryCategoryList('${typeList[loop].inquirySurveytype.id}', '${param.group}');" value="<fmt:message key='inquiry.publish.button' />" class="button-default-4">&nbsp;&nbsp;&nbsp;&nbsp;
						</c:if>
						<c:if test="${typeList[loop].hasManageAuth}">
							<input type="button" onclick="javascript:location.href='${basicURL}?method=survey_index&spaceType=${param.spaceType}&surveytypeid=${typeList[loop].inquirySurveytype.id}&mid=mid&group=${param.group}&spaceId=${param.spaceId}&where=${param.where}'" value="<fmt:message key='inquiry.board.manage' />" class="button-default-4">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</c:if>
						<c:set value="${typeList[loop].inquirySurveytype.id}" var="surveytypeid" />
						<c:if test="${!typeList[loop].hasManageAuth && typeList[loop].checker.id==currentUserId}">
							<input type="button" onclick="javascript:location.href='${basicURL}?method=checkIndex&spaceType=${param.spaceType}&group=${param.group}&surveytypeid=${surveytypeid}&spaceId=${param.spaceId}&where=${param.where}'" value="<fmt:message key='inquiry.board.manage' />" class="button-default-4">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</c:if>
						<a href="${basicURL}?method=more_recent_or_check&spaceType=${param.spaceType}&typeId=${typeList[loop].inquirySurveytype.id}&group=${param.group}&spaceId=${param.spaceId}" class="link-blue"><fmt:message key="common.more.label" bundle="${v3xCommonI18N}" /></a>&nbsp;								
						<c:set value="${loop+1}" var="loop"/>
				 	</div>
				 </div>
				 <div style="clear:both;"></div>
			</c:forEach>
		</div>
		</td>
	</tr>
</c:if>
<c:if test="${fn:length(typeAndBasicList)==0 }">
	<tr>
		<td align="center" style="background-position:right bottom ; background-repeat: no-repeat;" background="<c:url value="/apps_res/v3xmain/images/publicMessageBg.jpg"/>">
			<font style="font-size: 32px;color: #6c82ac"><fmt:message key="inquiry.type.no.create" /></font>
		</td>
	</tr>
</c:if>
</table>
<script type="text/javascript">
initIpadScroll("scrollListDiv",500,870);
var flag = '${param.group}';
if (flag == 'group') {
    showCtpLocation('F05_inquiryIndexGroup');
} else {
    showCtpLocation('F05_inquiryIndexAccount');
}
if('18'=='${param.spaceType}'||'17'=='${param.spaceType}'||'space'=='${param.where}'){
    var theHtml=toHtml("${publicCustom ? spaceName : (param.group=='group' ? groupName : accountName)}",'<fmt:message key="application.10.label"  bundle="${v3xCommonI18N}"/>');
    showCtpLocation("",{html:theHtml});
}
</script>
</body>
</html>