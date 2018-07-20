<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="mainResource"/>
<html>
<head>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript"
	src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">	
<script type="text/javascript">
<!--
	//TODO getA8Top()问题
    /* if('0' == '${spaceType}'){
    	getA8Top().showLocation(null, v3x.getMessage("bulletin.group_bulletin_audit"));
    }else if('1' == '${spaceType}'){
    	getA8Top().showLocation(null, v3x.getMessage("bulletin.account_bulletin_audit"));
    }  */

	if('${v3x:escapeJavascript(showAudit)}'=='true')
		var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	else
		var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");		
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key="oper.cancel" /><fmt:message key="oper.audit" />", 
			"cancelAudit();", 
			"<c:url value='/common/images/toolbar/cancelaudit.gif'/>", 
			"", 
			null
			)
	);
	myBar.add(
		new WebFXMenuButton(
			"refBtn", 
			"<fmt:message key='common.toolbar.refresh.label' bundle='${v3xCommonI18N}' />", 
			"window.location.reload();", 
			"<c:url value='/common/images/toolbar/refresh.gif'/>", 
			"", 
			null
			)
	);
	baseUrl='${bulDataURL}?method=';
	var managerName = "ajaxBulDataManager";
	
	function showPageByMethodAudit(id,method){
		parent.detailFrame.location.href=baseUrl+method+'&id='+id+"&needBreak=true&spaceId=${param.spaceId}";
	}
//-->
</script>
</head>
<body class="listPadding">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="25px" class="webfx-menu-bar-gray">
		<script type="text/javascript">
		<!--
		//TODO zhangxw 2012-10-26 v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>
			document.write(myBar);
		//-->	
		</script>
		</td>
		<c:if test="${showAudit}">
			<td align="right" class="webfx-menu-bar">
		</c:if>
		<c:if test="${!showAudit}">
			<td align="right" class="webfx-menu-bar-gray">
		</c:if>
		
			<div>
			<form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
			<input type="hidden" value="<c:out value='${param.method}' />" name="method">
			<input type="hidden" value="${spaceType}" name="spaceType">
			<input type="hidden" value="${showAudit}" name="showAudit">
			<input type="hidden" value="${param.spaceId}" name="spaceId" id="spaceId"/>
			<div class="div-float-right">
				<div class="div-float">
					<select name="condition"  id="condition"
					onChange="showNextCondition(this)" class="condition">
						<option value="title"><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
						<option value="title"><fmt:message key="bul.biaoti.label" /></option>
						<%-- <option value="type"><fmt:message key="bul.data.type" /></option>--%>
						<%--<option value="state"><fmt:message key="bul.data.state" /></option> --%>
					</select>
				</div>
				<div id="titleDiv" class="div-float hidden">
					<input type="text" name="textfield" class="textfield"  maxlength="50" onkeydown="javascript:searchWithKey()">
				</div>
				<div id="typeDiv" class="div-float hidden">
					<select name="textfield"  id="textfield" style="width:130px" class="textfield">
						<c:forEach items="${typeList}" var="type">
							<option value="${type.id}">${type.typeName}</option>
						</c:forEach>
					</select>
				</div>
				<div id="stateDiv" class="div-float hidden">
					<select name="textfield" id="textfield" style="width:130px" class="textfield">
						<option value="10"><fmt:message key="bul.data.state.10" /></option>
						<option value="20"><fmt:message key="bul.data.state.20" /></option>
					</select>
				</div>
				<div onclick="javascript:doSearch()" class="condition-search-button div-float"></div>
			</div>
			</form>
		</div>
	</td>
	</tr>
</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
			<c:set scope="request" var="onDblClick" value="auditDataLine" />
			
			<c:set var="fromPage" value="audit" />
			
			<form id="auditListForm" name="auditListForm" method="post">
			<v3x:table htmlId="listTable" data="list" var="bean" >
						<c:if test="${bean.state == 10}">
							<c:set scope="request" var="detailMethod" value="audit" />
						</c:if>
						<c:if test="${bean.state != 10}">
							<c:set scope="request" var="detailMethod" value="auditDetail" />
						</c:if>
			
				<v3x:column width="5%" align="center"
					label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
					<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" 
						dataState='${bean.state}' dataTopOrder='${bean.topOrder}'
						${v3x:outConditionExpression(bean.state=='10', 'disabled', '')}
					/>
				</v3x:column>
				<c:set var="topStr" value="" />
				
				<v3x:column  type="String" width="25%" onClick="showPageByMethodAudit('${bean.id}','${detailMethod}');"
					label="bul.biaoti.label" className="sort"
					hasAttachments="${bean.attachmentsFlag}"
					bodyType="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}"
					alt="${bean.title}"
					symbol="..."
					>
					<%-- //zhangxw 2012-10-26 修改审核项标题不能显示的问题
					<c:if test="${bean.topOrder>0}">
						<font color='red'>[<fmt:message key="label.top" />]</font>
					</c:if>
					<a href="javascript:showPageByMethodAudit('${bean.id}','${detailMethod}')" class="title-more-visited">
					<c:choose>
					<c:when test="${isAudit=='true' }">
						${v3x:showSubject(bean,v3x:currentUser().id,40,7,bean.state==20)}
					</c:when>
					<c:otherwise>
						${v3x:toHTML(v3x:getLimitLengthString(bean.title, 40,'...'))} otherwise
					</c:otherwise>
					</c:choose>
					</a> --%>
					${v3x:showSubject(bean,v3x:currentUser().id,40,7,bean.state==20)}
					
				</v3x:column>
				
				 <v3x:column width="15%" type="Date" label="bul.data.createDate">
							<fmt:formatDate value="${bean.createDate}" pattern="${datePattern}"/>
				 </v3x:column>
				
				<v3x:column width="15%" type="String"
					label="bul.data.type" className="sort"
					property="type.typeName" alt="${bean.type.typeName}" maxLength="20" symbol="..."
					>
				</v3x:column>
				<v3x:column width="15%" type="String" maxLength="25" symbol="..."
					label="bul.data.createUser" className="sort" value="${v3x:showMemberName(bean.createUser)}"
					>
					
				</v3x:column>
				<v3x:column width="15%" type="String"
					label="common.issueScope.label" className="sort"
					maxLength="16" value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" symbol="..."/>
				<v3x:column width="10%" type="String"
					label="bul.data.state" className="sort">
					<fmt:message key="bul.data.state.${bean.state}" />
					<input type="hidden" id="${bean.id}_state" value="${bean.state}" />
				</v3x:column>
			
			</v3x:table>
			</form>
    </div>
  </div>
</div>

<script type="text/javascript">
<!--
showDetailPageBaseInfo("detailFrame", "<fmt:message key="bul.data_shortname" /><fmt:message key="oper.audit" />", "/common/images/detailBannner/7002.gif", pageQueryMap.get('count'), _("bulletin.detail_info_607"));	
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
//-->
</script>
<iframe name="emptyIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>