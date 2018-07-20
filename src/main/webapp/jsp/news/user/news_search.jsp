<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	}
	//TODO yangwulin 2012-11-1 top.hiddenNavigationFrameset();
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
			<tr class="page2-header-line">
				<td colspan="2" height="40">
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
						<tr class="page2-header-line" height="25">
							<td width="80" height="40" class="page2-header-img"><img align="absmiddle" src="<c:url value="/apps_res/bulletin/images/pic.gif"/>" /></td>
							<td class="page2-header-bg" width="500">${spaceName}<fmt:message key="news.title" /></td>
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
								<b><fmt:message key="news.search.title"/></b>
							</td>
							<td class="webfx-menu-bar">
								<form action="${newsDataURL}" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
									<input type="hidden" value="indexSearch" name="method">
									<input type="hidden" value="${group}" name="group">
									<input type="hidden" value="${spaceType}" name="spaceType">
                                    <input type="hidden" value="${param.spaceId}" name="spaceId" id="spaceId">
									<div class="div-float-right condition-search-div">
										<div class="div-float">
											<select name="condition" id="condition"  onChange="showNextCondition(this)" class="condition">
												<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
												<option value="title"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/></option>
												<option value="createUser"><fmt:message key="news.data.createUser" /></option>
												<option value="keywords"><fmt:message key="news.data.keywords" /></option>
												<option value="brief"><fmt:message key="news.data.brief" /></option>
                                                <option value="departMent"><fmt:message key="news.data.publishDepartmentId" /></option>
												<option value="publishDate"><fmt:message key="news.data.publishDate" /></option>
												<option value="updateDate"><fmt:message key="news.data.updateDate" /></option>
											</select>
										</div>
                                        <div id="departMentDiv" class="div-float hidden">
                                            <input type="text" name="textfield" class="textfield"  maxlength="50"  onkeydown="javascript:searchWithKey()">
                                        </div>                                        
										<div id="titleDiv" class="div-float hidden">
											<input type="text" name="textfield" class="textfield" onkeydown="javascript:searchWithKey()">
										</div>
										<div id="createUserDiv" class="div-float hidden">
											<input type="text" name="textfield" class="textfield" onkeydown="javascript:searchWithKey()">
										</div>
										<div id="keywordsDiv" class="div-float hidden">
											<input type="text" name="textfield" class="textfield" onkeydown="javascript:searchWithKey()">
										</div>
										<div id="briefDiv" class="div-float hidden">
											<input type="text" name="textfield" class="textfield" onkeydown="javascript:searchWithKey()">
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
			<v3x:table htmlId="leaveWord" data="${list}"  var="bean" >
				<c:choose>
					<c:when test="${bean.readFlag}">
						<c:set value="title-already-visited" var="readStyle" />
					</c:when>
					<c:otherwise>
						<c:set value="title-more-visited" var="readStyle" />
					</c:otherwise>
				</c:choose>
				<c:set value="openWin('${newsDataURL}?method=userView&id=${bean.id}&spaceId=${param.spaceId}')" var="clickEvent"/>
					<v3x:column width="30%" type="String" label="news.biaoti.label" className="cursor-hand sort" hasAttachments="${bean.attachmentsFlag}"
						bodyType="${bean.dataFormat}" read="true" alt="${bean.title}" onmouseover="titlemouseover(this);" onmouseout="titlemouseout(this);">
						<c:if test="${bean.topOrder>0}">
							<span class="icon_com news_com inline-block"></span>
						</c:if>
						<c:if test="${bean.focusNews==true}">
		                    <font color='red'>[<fmt:message key="news.focus" />]</font>
		                </c:if>
						<a href="javascript:${clickEvent}" class="${readStyle}">${v3x:toHTML(v3x:getLimitLengthString(bean.title,54,'...'))}</a>
					</v3x:column>
					
					<c:choose>
						<c:when test="${publicCustom}">
							<v3x:column width="25%" type="String" label="news.data.publishDepartmentId" className="sort"
								maxLength="50" alt="${spaceName}">
								${v3x:getLimitLengthString(spaceName,50,'...')}
							</v3x:column>
						</c:when>
						<c:otherwise>
							<v3x:column width="25%" type="String" label="news.data.publishDepartmentId" className="sort"
								property="publishDepartmentName" maxLength="50" alt="${bean.publishDepartmentName}">
							</v3x:column>
						</c:otherwise>
					</c:choose>
					
					<v3x:column width="20%" type="String" label="news.data.createUser" className="sort">
						${bean.createUserName}
					</v3x:column> 
					<v3x:column width="15%" type="Date" label="news.data.publishDate" className="sort">
						<fmt:formatDate value="${bean.publishDate}" pattern="${datePattern}"/>
					</v3x:column>
					<v3x:column width="10%" type="Date" label="news.data.updateDate" className="sort">
						<fmt:formatDate value="${bean.updateDate}" pattern="${datePattern}"/>
					</v3x:column>
			</v3x:table>
		</form>
    </div>
  </div>
</div>

</body>
</html>