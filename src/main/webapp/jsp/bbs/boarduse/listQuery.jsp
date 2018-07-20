<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<fmt:setBundle basename="com.seeyon.v3x.inquiry.resources.i18n.InquiryResources" var="inquiryI18N"/>
<script type="text/javascript">
<!--
	window.onload = function(){
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	}
	
	function articleDetail(articleId){
		var acturl = "${detailURL}?method=showPost&articleId="+articleId+"&resourceMethod=listLatestFiveArticleAndAllBoard&group=${group}&spaceId=${param.spaceId}";
		openWin(acturl);
	}
	
	//getA8Top().hiddenNavigationFrameset();
//-->
</script>
<style>
.mxtgrid div .hDiv,.mxtgrid div .bDiv,.page2-list-border{border-width:1px 0;}
</style>
</head>
<body scroll="no" class="with-header">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">		
	<tr class="page2-header-line">
		<td colspan="2" height="41">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
				<tr class="page2-header-line" height="32">
					<td width="80" height="41" class="page2-header-img"><img align="absmiddle" src="<c:url value="/apps_res/bulletin/images/pic.gif"/>" /></td>
					<td class="page2-header-bg" width="500">${spaceName}<fmt:message key='application.9.label' bundle="${v3xCommonI18N}" /></td>
					<td class="page2-header-line padding-right" align="right"></td>
				</tr>	
			</table>
		</td>
	</tr>
	<tr>
		<td class="padding5">
		<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" class="page2-list-border">
				<tr>
					<td height="22" class="webfx-menu-bar page2-list-header">
						<b><fmt:message key='application.9.label' bundle="${v3xCommonI18N}" /><fmt:message key='inquiry.search.button.label' bundle="${inquiryI18N}"/></b>
					</td>
					<td class="webfx-menu-bar">
					
						<form action="${detailURL}" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
							<input type="hidden" value="bbsSearch" name="method"> 
							<input type="hidden" name="id" value="${board.id}">
							<input type="hidden" name="group" value="${group}"> 
                            <input type="hidden" name="spaceId" id="spaceId" value="${param.spaceId}">
                            <input type="hidden" name="spaceType" id="spaceType" value="${param.spaceType}"> 
							<div class="div-float-right condition-search-div">
								<div class="div-float">
								<select name="condition"  id="condition" onChange="showNextCondition(this)" class="condition">
									<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}"/></option>
									<option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/></option>
									<option value="issueUser"><fmt:message key="common.issuer.label" bundle="${v3xCommonI18N}"/></option>
									<option value="issueTime"><fmt:message key="common.issueDate.label" bundle="${v3xCommonI18N}"/></option>
								</select></div>
								<div id="subjectDiv" class="div-float hidden"><input type="text" name="textfield"  maxlength="50" onkeydown="javascript:searchWithKey()" class="textfield"></div>
								<div id="issueUserDiv" class="div-float hidden"><input type="text" name="textfield"  maxlength="50" onkeydown="javascript:searchWithKey()" class="textfield"></div>
								<div id="issueTimeDiv" class="div-float hidden"><input
									type="text" id="startdate" name="textfield" class="input-date"
									onclick="whenstart('${pageContext.request.contextPath}',this,640,265);"
									readonly> - <input type="text" id="enddate" name="textfield1" class="input-date"
									onclick="whenstart('${pageContext.request.contextPath}',this,720,265);" readonly></div>
								<div onclick="javascript:doMySearch()" class="div-float condition-search-button , button-font-color"></div>
							</div>
						</form>
					</td>
				</tr>	
			</table>
		</td>
	</tr>
</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<form>
			<v3x:table htmlId="pending" data="${articleList}" var="col">
				<v3x:column type="String" width="45%" label="common.subject.label" onmouseover="titlemouseover(this);" onmouseout="titlemouseout(this);" className="cursor-hand sort" hasAttachments="${col.attachmentFlag}" alt="${col.articleName}" onClick="articleDetail('${col.id}');">
					<c:set value="50" var="nameLength" />
					<c:if test="${col.topSequence==1}">
						<font color="red">[<fmt:message key="bbs.top.label" />]</font>
						<c:set value="${nameLength - 4}" var="nameLength" />
					</c:if>
					${v3x:toHTML(v3x:getLimitLengthString(col.articleName, nameLength, "..."))}
					<c:if test="${col.eliteFlag}">
						<font color="red">[<fmt:message key="bbs.elite.label" />]</font>
					</c:if>
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
				<v3x:column type="String" width="15%" label="bbs.data.createUser" value="${createrUser}" />
				<v3x:column type="Date" width="18%" align="left" label="common.issueDate.label">
					<fmt:formatDate value="${col.issueTime}" pattern="${dataPattern}" />
				</v3x:column>
				<v3x:column type="Number" width="10%" align="center" label="bbs.clicknumber.label" value="${col.clickNumber}" />
				<v3x:column type="Number" width="12%" align="center" label="bbs.replynumber.label" value="${col.replyNumber}" />
			</v3x:table>
		</form>
    </div>
  </div>
</div>

</body>
</html>