<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="mainResource"/>
<html>
<head>
<%@ include file="../include/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript"
	src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<script type="text/javascript">
<!--
    if('1' == '${spaceType}'){
    	//TODO 2012-10-22 getA8Top().showLocation(null, v3x.getMessage("NEWSLang.account_news_audit"));
    }else if('0' == '${spaceType}'){
      //TODO 2012-10-22 getA8Top().showLocation(null, v3x.getMessage("NEWSLang.group_news_audit"));
    } 
    
	if('${showAudit}'=='true')
		var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	else
		var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");	

	<%-- myBar.add(
		new WebFXMenuButton(
			"editBtn", 
			"<fmt:message key="oper.audit" />", 
			"auditData('audit','${from}');", 
			"<c:url value='/apps_res/bulletin/images/editContent.gif'/>", 
			"", 
			null
			)
	);--%>
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key="oper.cancel" /><fmt:message key="oper.audit" />", 
			"cancelAudit();", 
			[4,2], 
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
	baseUrl='${newsDataURL}?method=';
	var managerName = "ajaxNewsDataManager";
	
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
				//TODO yangwulin 2012-10-26<%-- <v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/> --%>
					document.write(myBar);	
				//-->
				</script>
				</td>
				
				<c:if test="${showAudit }">
					<td align="right" class="webfx-menu-bar">
				</c:if>
				<c:if test="${!showAudit }">
					<td align="right" class="webfx-menu-bar-gray">
				</c:if>
				
					<div>
		<form action="" name="searchForm" id="searchForm" method="post"
			onsubmit="return false" style="margin: 0px">
			<input type="hidden" value="<c:out value='${param.method}' />" name="method">
			<input type="hidden" value="${spaceType}" name="spaceType">
			<input type="hidden" value="${showAudit}" name="showAudit">
			<input type="hidden" value="${param.spaceId}" name="spaceId" id="spaceId"/>
            
			<div class="div-float-right">
				<div class="div-float">
					<select name="condition" id="condition" 
					onChange="showNextCondition(this)" class="condition">
						<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
						<option value="title"><fmt:message key="news.biaoti.label" /></option>
						<%-- <option value="type"><fmt:message key="news.data.type" /></option>--%>
						<%-- <option value="state"><fmt:message key="news.data.state" /></option>--%>
						<option value="keywords"><fmt:message key="news.data.keywords" /></option>
						<option value="brief"><fmt:message key="news.data.brief" /></option>
					</select>
				</div>
		
				<!-- 每一个选项对应一个DIV，它的id命名规定为"选项option.value + Div" input框规定为textfield -->
				<div id="titleDiv" class="div-float hidden">
					<input type="text" name="textfield" class="textfield"  maxlength="50" onkeydown="javascript:searchWithKey()">
				</div>
				<%--
				<div id="typeDiv" class="div-float hidden">
					<select name="textfield" id="textfield" style="width:130px"  maxlength="50" class="textfield" onkeydown="javascript:searchWithKey()">
						<c:forEach items="${typeList}" var="type">
							<option value="${type.id}">${type.typeName}</option>
						</c:forEach>
					</select>
				</div>
				 --%>
				<div id="keywordsDiv" class="div-float hidden">
					<input type="text" name="textfield" class="textfield"  maxlength="50" onkeydown="javascript:searchWithKey()">
				</div>
				<div id="briefDiv" class="div-float hidden">
					<input type="text" name="textfield" class="textfield"  maxlength="50" onkeydown="javascript:searchWithKey()">
				</div>
				
				<!-- 按钮事件已经封装，直接copy -->
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
			<!-- Edit By Lif Start -->
			<v3x:table htmlId="listTable" data="list" var="bean" className="sort ellipsis">
			<!-- Edit End -->
						<c:if test="${bean.state == 10}">
							<c:set scope="request" var="detailMethod" value="audit" />
						</c:if>
						<c:if test="${bean.state != 10}">
							<c:set scope="request" var="detailMethod" value="auditDetail" />
						</c:if>
						
				<v3x:column width="5%" align="center"
					label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
					<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" 
										dataState='${bean.state}'
										${v3x:outConditionExpression(bean.state=='10', 'disabled', '')}
					/>
				</v3x:column> 
			 <v3x:column width="35%" type="String" onClick="showPageByMethodAudit('${bean.id}','${detailMethod}');"
                    label="news.biaoti.label" className="cursor-hand sort"
                    hasAttachments="${bean.attachmentsFlag}"
                    bodyType="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}" 
                    >
                    ${v3x:showSubject(bean,v3x:currentUser().id,-1,8,bean.state==20)}
                </v3x:column>
				
				  <v3x:column width="15%" type="Date" label="news.data.publishDate">
							<fmt:formatDate value="${bean.updateDate}" pattern="${datePattern}"/>
				</v3x:column>
				
				<v3x:column width="15%" type="String" onClick="showPageByMethodAudit('${bean.id}','${detailMethod}');"
					label="news.data.type" className="cursor-hand sort"
					property="type.typeName" alt="${bean.type.typeName}" maxLength="20"
					>
				</v3x:column>
				<v3x:column width="15%" type="String" onClick="showPageByMethodAudit('${bean.id}','${detailMethod}');"
					label="news.data.createUser" className="cursor-hand sort"
					>
					${bean.createUserName}
				</v3x:column>
				
				<v3x:column width="15%" type="String" onClick="showPageByMethodAudit('${bean.id}','${detailMethod}');"
					label="news.data.state" className="cursor-hand sort">
					<fmt:message key="news.data.state.${bean.state}" />
					<input type="hidden" id="${bean.id}_state" value="${bean.state}" />
				</v3x:column>
			
			</v3x:table>
			</form>	
    </div>
  </div>
</div>


<script type="text/javascript">
<!--
showDetailPageBaseInfo("detailFrame", "<fmt:message key="news.data_shortname" /><fmt:message key="oper.audit" />", [2,1], pageQueryMap.get('count'), _("NEWSLang.detail_info_607"));	
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
//-->
</script>

<iframe id="emptyIframe" name="emptyIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>

</body>
</html>
