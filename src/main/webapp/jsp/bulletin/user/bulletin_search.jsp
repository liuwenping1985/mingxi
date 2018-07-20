<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<%@ include file="../include/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript">
<!--
	window.onload = function(){		
		if('${param.condition}' == 'publishUserId')
			bulShowCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", '${param.showPer}');	
		else 
			showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "${param.textfield1}");
	}
	//TODO zhangxw 2012-10-30 getA8Top().hiddenNavigationFrameset();
//-->
</script>
<style>
.mxtgrid div.hDiv,.mxtgrid div.bDiv,.page2-list-border{border-width:1px 1;}
</style>
</head>
<body scroll="no" class="with-header">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">		
			<tr class="page2-header-line" height="41">
				<td height="41">
					 <table width="100%" align="center"  border="0" cellpadding="0" cellspacing="0">
				     	<tr class="page2-header-line" height="25">
							<td class="page2-header-bg" width="500">${spaceType==0?groupName:accountName}<fmt:message key="bul.title" /></td>
							<td class="page2-header-line padding-right" align="right"></td>
						</tr>	
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" class="page2-list-border">
						<tr>
							<td height="20" class="webfx-menu-bar page2-list-header">
								<b><fmt:message key="bul.search.title"/></b>
							</td>
							<td class="webfx-menu-bar ">
								<form action="${bulDataURL}" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
									<input type="hidden" value="<c:out value='${param.method}' />" name="method">
									<input type="hidden" value="${group}" name="group">
									<input type="hidden" value="${spaceType}" name="spaceType">
									<input type="hidden" value="${param.spaceId}" name="spaceId" id="spaceId">
									<div class="div-float-right condition-search-div">
										<div class="div-float">
											<select name="condition"  id="condition"
											onChange="showNextCondition(this)" class="condition">
												<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
												<option value="title"><fmt:message key="bul.biaoti.label" /></option>
												<option value="publishUserId"><fmt:message key="bul.data.createUser" /></option>
												<option value="publishDepartmentName"><fmt:message key="bul.data.publishDepartmentId" /></option>
												<option value="publishDate"><fmt:message key="bul.data.publishDate" /></option>
												<option value="updateDate"><fmt:message key="bul.data.updateDate" /></option>
											</select>
										</div>
										<div id="titleDiv" class="div-float hidden">
											<input type="text" name="textfield" id="titleInput" class="textfield" onkeydown="javascript:searchWithKey()">
										</div>
										<div id="publishUserIdDiv" class="div-float hidden">
											<input type="text" name="textfield" id="publishUserIdInput" class="textfield" onkeydown="javascript:searchWithKey()">	
										</div>
										<div id="publishDepartmentNameDiv" class="div-float hidden">
											<input type="text" name="textfield" id="publishDepartmentNameInput" class="textfield" onkeydown="javascript:searchWithKey()">	
										</div>
										<div id="publishDateDiv" class="div-float hidden">		
											<input type="text" name="textfield" id="startdate" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly > - 
											<input type="text" name="textfield1" id="enddate" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly >
										</div>
										<div id="updateDateDiv" class="div-float hidden">		
											<input type="text" name="textfield" id="startdate1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly > - 
											<input type="text" name="textfield1" id="enddate1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly >
										</div>
										<div onclick="javascript:doSearchInq()" class="condition-search-button div-float" style="color:black"></div>
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
			<v3x:table data="list" var="bulletin" htmlId="sdsdsd">			      
				<c:set value="openWin('${bulDataURL}?method=userView&id=${bulletin.id}')" var="clickEvent"/>
				<c:choose>
					<c:when test="${bulletin.readFlag}">
						<c:set value="title-already-visited" var="readStyle" />
					</c:when>
					<c:otherwise>
						<c:set value="title-more-visited" var="readStyle" />
					</c:otherwise>
				</c:choose>
				<v3x:column type="String" width="25%" label="bul.biaoti.label" className="cursor-hand sort " hasAttachments="${bulletin.attachmentsFlag}" bodyType="${empty bulletin.ext5 ? bulletin.dataFormat : 'Pdf'}" alt="${bulletin.title}" 
					onmouseover="titlemouseover(this);" onmouseout="titlemouseout(this);">
					<c:if test="${bulletin.topOrder>0}">
						<font color="red">[<fmt:message key="label.top" />]</font>
					</c:if>	
					<a href="javascript:openWin('${bulDataURL}?method=userView&id=${bulletin.id}&spaceId=${param.spaceId}')" class="${readStyle}">${v3x:toHTML(v3x:getLimitLengthString(bulletin.title,55,'...'))}</a>
				</v3x:column>
				<v3x:column width="20%" type="String" align="left" label="common.issueScope.label" 
				   alt = "${v3x:showOrgEntitiesOfTypeAndId(bulletin.publishScope, pageContext)}">
				<c:set value="${v3x:showOrgEntitiesOfTypeAndId(bulletin.publishScope, pageContext)}" var="scopeValue" />
					${v3x:getLimitLengthString(scopeValue,16,'...')}
				</v3x:column>
				<v3x:column width="15%" type="String" label="bul.data.createUser" value="${v3x:showOrgEntitiesOfIds(bulletin.createUser, 'Member', pageContext)}" />
				<v3x:column width="15%" type="Date" label="bul.data.createDate">
					<fmt:formatDate value="${bulletin.publishDate}" pattern="${datePattern}"/>
				</v3x:column>
				<v3x:column width="15%" type="Date" label="bul.data.updateDate">
					<fmt:formatDate value="${bulletin.updateDate}" pattern="${datePattern}"/>
				</v3x:column>
				<v3x:column width="10%" type="Number" align="center" label="label.readCount">
					${bulletin.readCount}
				</v3x:column>
			</v3x:table>
		</form>
    </div>
  </div>
</div>
</body>
</html>