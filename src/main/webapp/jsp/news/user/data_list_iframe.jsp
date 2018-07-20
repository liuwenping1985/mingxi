<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<%@ include file="../include/header.jsp"%>
<html>
<head>
</head>
<body class="page_content public_page" oncontextmenu=self.event.returnValue=false>
<c:set value="${v3x:currentUser().id}" var="currentUserId"/>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">		
	<tr>
		<td  height="41" valign="top" >
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr>
		        	<!--  <td width="45"><div class="newsIndex"></div></td>-->
					<td class="page2-header-bg border_b" width="380"><span style="font-size: 24px;color: #888;font-family:黑体;font-weight: normal;">${publicCustom ? spaceName : (spaceType == 3 ? groupName : accountName)}<fmt:message key="news.title" /></span></td>
					<td class="padding-right border_b" align="right"></td>
					<td class="border_b">&nbsp;</td>
				</tr>	
			</table>
		</td>
		<c:if test="${fn:length(typeList)>0 }">
		<td height="20" class="border_b">
			<form action="${newsDataURL}" name="searchForm" id="searchForm" method="get"
				onsubmit="return false" style="margin: 0px">
				<input type="hidden" value="indexSearch" name="method">
				<input type="hidden" value="${param.spaceId}" name="spaceId" id="spaceId">
				<input type="hidden" value="${group}" name="group">
				<input type="hidden" value="${spaceType}" name="spaceType">
				<div class="div-float-right">
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
						<input type="text" name="textfield" class="textfield"  maxlength="50"  onkeydown="javascript:searchWithKey()">
					</div>
					<div id="createUserDiv" class="div-float hidden">
						<input type="text" name="textfield" class="textfield" maxlength="50" onkeydown="javascript:searchWithKey()">
					</div>
					<div id="keywordsDiv" class="div-float hidden">
						<input type="text" name="textfield" class="textfield" maxlength="50" onkeydown="javascript:searchWithKey()">
					</div>
					<div id="briefDiv" class="div-float hidden">
						<input type="text" name="textfield" class="textfield" maxlength="50" onkeydown="javascript:searchWithKey()">
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
	<tr>
		<td valign="top" class="padding_lr_10" colspan="2">
		<div class="scrollList" id="scrollListDiv" style="overflow:hidden;">
		<c:forEach items="${typeList}" var="bulletinType" varStatus="status">
			<c:set value="" var="bulDataList"/>
			<c:set value="" var="adminManager"/>
			<c:set value="" var="adminAudit"/>
			
			<c:if test="${bulletinType.newsType.managerUserIds != ''}">
				<c:set var="adminManager" value="${v3x:showOrgEntitiesOfIds(bulletinType.newsType.managerUserIds, 'Member', pageContext)}" />			
			</c:if>
			<c:if test="${bulletinType.newsType.auditUser != '' && bulletinType.newsType.auditUser != 0}">
				<c:set var="adminAudit" value="${v3x:showOrgEntitiesOfIds(bulletinType.newsType.auditUser, 'Member', pageContext)}" />
			</c:if>
			
			<c:forEach var="alist" items="${list2}" varStatus="status2">
				<c:if test="${status.index == status2.index}">
					<c:set value="${alist}" var="bulDataList"/>
				</c:if>
			</c:forEach>
		
			<div class="index-type-name" style="padding-left:0; float:none;">
				${v3x:toHTML(bulletinType.newsType.typeName)}
			</div>

			<div>		      
				<v3x:table htmlId="leaveWord${status.index}" className="sort ellipsis" data="${bulDataList}" dragable="false" showPager="false" var="bean" size="6">
					<c:set value="openWin('${newsDataURL}?method=userView&id=${bean.id}&spaceId=${param.spaceId}&auditFlag=0')" var="clickEvent"/>
					<c:choose>
						<c:when test="${bean.readFlag}">
							<c:set value="title-already-visited" var="readStyle" />
						</c:when>
						<c:otherwise>
							<c:set value="title-more-visited" var="readStyle" />
						</c:otherwise>
					</c:choose>
					
					<v3x:column width="28%" type="String" label="news.biaoti.label" className="cursor-hand sort" hasAttachments="${bean.attachmentsFlag}"
						bodyType="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}" read="true" alt="${bean.title}" onmouseover="titlemouseover(this);" onmouseout="titlemouseout(this);">
						<c:if test="${bean.topOrder>0}">
							<span class="icon_com news_com inline-block"></span>
						</c:if>			
						<c:if test="${bean.focusNews==true}">
		                    <font color='red'>[<fmt:message key="news.focus" />]</font>
		                </c:if>													
								<a href="javascript:${clickEvent}" class="${readStyle}">
									${v3x:toHTML(bean.title)}
								</a>
					</v3x:column>
					<v3x:column width="10%" type="String" label="news.data.publishDepartmentId" className="sort" alt="${bean.publishDepartmentName }">
						${v3x:toHTML(bean.publishDepartmentName)}
					</v3x:column>
					<v3x:column width="10%" type="String" label="news.data.createUser" className="sort" alt="${bean.createUserName }">
						${bean.createUserName }
					</v3x:column>
					<v3x:column width="10%" type="Date" label="news.data.publishDate" className="sort">
						<fmt:formatDate value="${bean.publishDate}" pattern="${datePattern}"/>
					</v3x:column>
					<v3x:column width="10%" type="Date" label="news.data.updateDate" className="sort">
						<fmt:formatDate value="${bean.updateDate}" pattern="${datePattern}"/>
					</v3x:column>
					<v3x:column width="5%" type="Number" label="news.data.readCount" value="${bean.readCount}"/>
					<v3x:column width="10%" type="String" label="news.data.keywords" className="sort"
								maxLength="16" alt="${bean.keywords}">
								${v3x:toHTML(v3x:getLimitLengthString(bean.keywords,16,'...'))}
					</v3x:column>
					<v3x:column width="15%" type="String" label="news.data.brief" className="sort"
								maxLength="16" alt="${bean.brief}">
								${v3x:toHTML(bean.brief)} 
					</v3x:column>
				</v3x:table>					
			</div>
			
			<div class="index-bottom">
				<div class="index-bottom index-bottom-left  color_gray">
					<fmt:message key="bul.type.managerUsers" bundle="${bulI18N}" />: <span class="">${adminManager}</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<c:if test="${bulletinType.newsType.auditFlag}">
						<fmt:message key="bul.type.auditUser"  bundle="${bulI18N}"  />: <span class="">${adminAudit}</span>
					</c:if>
				</div>
				
				<div class="index-bottom index-bottom-right" >
					<c:if test="${bulletinType.canNewOfCurrent}">
						<input type="button" onclick="javascript:location.href='${newsDataURL}?method=publishListIndex&spaceType=${spaceType}&newsTypeId=${bulletinType.newsType.id}&spaceId=${param.spaceId}'" value="<fmt:message key="oper.publish" /><fmt:message key="news.data_shortname" />" class="button-default-4">&nbsp;&nbsp;&nbsp;&nbsp;
					</c:if>
					<c:if test="${bulletinType.canAdminOfCurrent}">	
                        <input type="button" onclick="javascript:adminTypeEvent('${bulletinType.newsType.id}', '${spaceType}')" value="<fmt:message key="news.type_shortname" /><fmt:message key="oper.manage" />" class="button-default-4">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </c:if>
					<c:if test="${!bulletinType.canAdminOfCurrent && bulletinType.newsType.auditUser==currentUserId}">						
						<input type="button" onclick="javascript:location.href='${newsDataURL}?method=auditIndex&spaceType=${spaceType}&showAudit=true&spaceId=${param.spaceId}&newsTypeId=${bulletinType.newsType.id}'" value="<fmt:message key="news.type_shortname" /><fmt:message key="oper.manage" />" class="button-default-4">
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</c:if>
					
					<c:if test="${spaceType == 1}">
						<c:set value="account" var="orgType" />
					</c:if>
					<c:if test="${spaceType == 0}">
						<c:set value="group" var="orgType" />
					</c:if>
					<c:if test="${spaceType == 2}">
						<c:set value="dept" var="orgType" />
					</c:if>
					<c:if test="${spaceType == 4}">
						<c:set value="publicCustom" var="orgType" />
					</c:if>
											
					<c:set value="viewTypeList('${bulletinType.newsType.id}','${newsDataURL}?method=newsMore&spaceType=${spaceType}&where=${param.where}&orgType=${orgType}&spaceId=${param.spaceId}&isGroup=${isGroup}&homeFlag=true&typeId=${bulletinType.newsType.id}&');" var="clickHref" />
					<a href="javascript:${clickHref}" class="link-blue"><fmt:message key="common.more.label" bundle="${v3xCommonI18N}" /></a>								
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
	    showCtpLocation('F05_newsIndexGroup');
	} else {
	    showCtpLocation('F05_newsIndexAccount');
	}
	if('18'=='${spaceType}'||'17'=='${spaceType}'||'space'=='${param.where}'){
	    var theHtml=toHtml("${publicCustom ? spaceName : (spaceType == 3 ? groupName : accountName)}",'<fmt:message key="news.title" />');
	    showCtpLocation("",{html:theHtml});
	}
	</script>
</body>
</html>