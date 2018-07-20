<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<html>
<head>
<script type="text/javascript">
	window.onload = function(){
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "${param.textfield1}");	
	}
</script>
</head>
<body scroll="no">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr>
		<td width="100%" height="45" valign="top" bgcolor="rgb(237,237,237)">
		<table height="100%" width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr class="page2-header-line">
				<td width="45"  valign="top"><div class="bulltenIndex"></div></td>
				<td class="page2-header-bg" valign="top"><fmt:message key="bul.more" /></td>
				<td class="page2-header-line page2-header-link" align="right">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td align="right" height="10">
                            <%--TODO yangwulin 2012-11-28 javascript:getA8Top().contentFrame.topFrame.back() 
							<c:set value="javascript:getA8Top().back()" var="backEvent" />
							<a href="${backEvent}"><fmt:message key='common.toolbar.back.label' bundle="${v3xCommonI18N}" /></a>--%>
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td valign="top" class="padding5">
			<table id="bulMoreTable" align="center" width="100%" height="100%" cellpadding="0" cellspacing="0"
				class="page2-list-border">
				<tr>
					<td width="30%" height="22" class="webfx-menu-bar page2-list-header" ><b><fmt:message key='menu.member.bulletin' bundle="${v3xMainI18N}" /></b></td>
					<td class="webfx-menu-bar">
					<form action="${bulDataURL}" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
						<input type="hidden" value="myBulMore" name="method">
						<div class="div-float-right">
						<div class="div-float">
						<select name="condition" id="condition"  onChange="showNextCondition(this)" class="condition">
							<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							<option value="title"><fmt:message key="bul.data.title" /></option>
							<option value="publishUserId"><fmt:message key="bul.data.createUser" /></option>
							<option value="publishDate"><fmt:message key="bul.data.publishDate" /></option>
						</select>
						</div>
						<div id="titleDiv" class="div-float hidden"><input type="text" name="textfield" id="titleInput"
							class="textfield"  maxlength="50" onkeydown="javascript:searchWithKey()"></div>
						<div id="publishUserIdDiv" class="div-float hidden"><input type="text" name="textfield"
							id="publishUserIdInput"  maxlength="50" class="textfield" onkeydown="javascript:searchWithKey()"></div>
						<div id="publishDateDiv" class="div-float hidden">		
							<input type="text" name="textfield" id="startdate" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly > - 
							<input type="text" name="textfield1" id="enddate" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly >
			 			</div>
						<div onclick="javascript:doSearchInq()" class="condition-search-button div-float" style="color:black"></div>
					</form>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div class="scrollList">
							<form name="listForm" action="" id="listForm" method="post" style="margin: 0px">
								<v3x:table htmlId="listTable" data="${list}" var="bean" subHeight="90" className="sort ellipsis">
									<c:choose>
										<c:when test="${bean.readFlag}">
											<c:set value="title-already-visited" var="readStyle" />
										</c:when>
										<c:otherwise>
											<c:set value="title-more-visited" var="readStyle" />
										</c:otherwise>
									</c:choose>
									<v3x:column width="45%" type="String" label="bul.biaoti.label" className="sort"
										hasAttachments="${bean.attachmentsFlag}" bodyType="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}" read="true" maxLength="23" symbol="...">
										<a href="javascript:openWin('${bulDataURL}?method=userView&id=${bean.id}')" class="${readStyle}"
											title="${v3x:toHTML(bean.title)}"> ${v3x:getLimitLengthString(v3x:toHTML(bean.title), 70, '...')} </a>
									</v3x:column>
									<c:set value="${bulDataURL}?method=bulMore&typeId=${bean.type.id}&spaceType=${bean.type.spaceType}" var="linkColumn"></c:set>
									<fmt:message key='space.${bean.type.spaceType}.name' var="boardName" />
									<v3x:column width="15%" type="String" label="bul.data.type" className="${readStyle}-span sort" value="(${boardName})${bean.type.typeName}" href="${linkColumn}"/>
									<v3x:column width="15%" type="String" label="common.issueScope.label" className="${readStyle}-span sort"
										value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" maxLength="16" symbol="..." />
									<v3x:column width="15%" type="String" label="bul.data.createUser" className="${readStyle}-span sort"
										value="${v3x:showMemberName(bean.createUser)}" maxLength="15" symbol="..." />
									<v3x:column width="10%" type="Date" label="bul.data.publishDate" className="${readStyle}-span sort">
										<fmt:formatDate value="${bean.publishDate}" pattern="${datePattern}" />
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

<iframe height="0%" name="empty" id="empty" width="0%" frameborder="0"></iframe>

</body>
</html>
