<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<html>
<head>
<script type="text/javascript">
	window.onload = function(){
		showCondition("${condition}", "<v3x:out value='${textfield}' escapeJavaScript='true' />", "<v3x:out value='${textfield1}' escapeJavaScript='true' />");
	}
	
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
		
	myBar.add(
		new WebFXMenuButton(
			"returnBtn", 
			"<fmt:message key='common.toolbar.back.label' bundle='${v3xCommonI18N}' />", 
			"window.location.href='${bulDataURL}?method=userList';", 
			[7,4], 
			"", 
			null
			)
	);
		
</script>
</head>
<body class="tab-body">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
			<div class="div-float">
				<div class="tab-tag-left-sel"></div>
				<div class="tab-tag-middel-sel"><a href="#" class="non-a"><fmt:message key="oper.view" /><fmt:message key="bul.data_shortname" /></a></div>
				<div class="tab-tag-right-sel"></div>
<c:if test="${sessionScope['bulletin.isShowManage']}">			
				<div class="tab-separator"></div>
				
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel"><a href="${bulDataURL}?method=deptPublishListMain&condition=type&textfield=${sessionScope['bulletin.typeId']}" class="non-a"><fmt:message key="common.toolbar.oper.publish.label" bundle='${v3xCommonI18N}' /><fmt:message key="bul.data_shortname" /></a></div>
				<div class="tab-tag-right"></div>
				
</c:if>				
			</div>
		</td>
		<td valign="bottom" width="3" rowspan="2"><div class="tab-tag-1">&nbsp;</div></td>
	</tr>
	<tr>
		<td height="26" class="tab-operate-bg" width="100%">
		
<form action="" name="searchForm" id="searchForm" method="post"
	onsubmit="return false" style="margin: 0px">
	<input type="hidden" value="<c:out value='${param.method}' />" name="method">
	<input type="hidden" value="<c:out value='${param.more}' />" name="more">
	<div class="div-float-right">
		<div class="div-float">
			<select name="condition"  id="condition"
			onChange="showNextCondition(this)" class="condition">
				<option value="title"><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
				<option value="title"><fmt:message key="bul.data.title" /></option>
			</select>
		</div>

		<!-- 每一个选项对应一个DIV，它的id命名规定为"选项option.value + Div" input框规定为textfield -->
		<div id="titleDiv" class="div-float">
			<input type="text" name="textfield" class="textfield">
		</div>
		
		<!-- 按钮事件已经封装，直接copy -->
		<div onclick="javascript:doSearch()" class="condition-search-button"></div>
	</div>
</form>
		</td>
	</tr>
	<tr>
		<td colspan="2" class="my-tab-body-bg">

<form>
<v3x:table htmlId="listTable" data="list" var="bean" >
	<c:choose>
		<c:when test="${bean.readFlag}">
			<c:set value="title-already-visited" var="readStyle" />
		</c:when>
		<c:otherwise>
			<c:set value="title-more-visited" var="readStyle" />
		</c:otherwise>
	</c:choose>
	<v3x:column type="String"
		label="bul.biaoti.label" className="cursor-hand sort"
		hasAttachments="${bean.attachmentsFlag}"
		bodyType="${bean.dataFormat}"		
		read="${bean.readFlag}"
		>
		<c:if test="${bean.topOrder>0}">
		<font color="red">[<fmt:message key="label.top" />]</font>
		</c:if>
		<a href="${bulDataURL}?method=userView&id=${bean.id}" class="${readStyle}" title="${bean.title}">
		${v3x:getLimitLengthString(bean.title,40,'...')}</a>
	</v3x:column>

	
	<v3x:column width="100" type="String"
		label="common.issueScope.label" className="cursor-hand sort"
		 maxLength="16" value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}"
		 symbol="..."
		/>
	
	<v3x:column width="10%" type="String"
		label="bul.data.createUser" className="cursor-hand sort"
		value="${v3x:showMemberName(bean.createUser)}"
		/>
	
	<v3x:column width="15%" type="Date"
		label="bul.data.createDate" className="cursor-hand sort">
		<fmt:formatDate value="${bean.createDate}" pattern="${datePattern}"/>
	</v3x:column>
</v3x:table>
</form>
		</td>
	</tr>
</table>
</body>
</html>
