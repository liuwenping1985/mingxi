<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>

<html>
<head>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript"
	src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link type="text/css" rel="stylesheet"
	href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
	
<script type="text/javascript">
window.onload = function(){
	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
}

	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key="oper.new" /><fmt:message key="mt.mtSummaryTemplate" />", 
			"parent.location.href='${mtSummaryTemplateURL}?method=create';", 
			"<c:url value='/apps_res/bulletin/images/newColl.gif'/>", 
			"", 
			null
			)
	);
	
	myBar.add(
		new WebFXMenuButton(
			"editBtn", 
			"<fmt:message key="oper.edit" /><fmt:message key="mt.mtSummaryTemplate" />", 
			"editMtTemplate();", 
			"<c:url value='/apps_res/bulletin/images/editContent.gif'/>", 
			"", 
			null
			)
	);
	myBar.add(
		new WebFXMenuButton(
			"delBtn", 
			"<fmt:message key="oper.delete" /><fmt:message key="mt.mtSummaryTemplate" />", 
			"deleteMtRecord('${mtSummaryTemplateURL}?method=delete');", 
			"<c:url value='/common/images/toolbar/delete.gif'/>", 
			"", 
			null
			)
	);
	myBar.add(
		new WebFXMenuButton(
			"refBtn", 
			"<fmt:message key='common.toolbar.refresh.label' bundle='${v3xCommonI18N}' />", 
			"parent.location.reload();", 
			"<c:url value='/common/images/toolbar/refresh.gif'/>", 
			"", 
			null
			)
	);
	
	myBar.add(new WebFXMenuSeparator());	
	myBar.add(
		new WebFXMenuButton(
			"bulTemplate", 
			"<fmt:message key="mt.mtContentTemplate" />", 
			"parent.location.href='${mtContentTemplateURL}?method=listMain'", 
			"<c:url value='/apps_res/bulletin/images/newColl.gif'/>", 
			"", 
			null
			)
	);
	
	myBar.add(
		new WebFXMenuButton(
			"bulTemplate", 
			"<fmt:message key="mt.mtSummaryTemplate" />", 
			"parent.location.href='${mtSummaryTemplateURL}?method=listMain'", 
			"<c:url value='/apps_res/bulletin/images/newColl.gif'/>", 
			"", 
			null
			)
	);
	
	//detailBaseUrl='<c:url value="/bulTemplate.do?method=detail" />';
	baseUrl='${mtSummaryTemplateURL}?method=';
</script>
</head>
<body>
<div class="scrollList">
<script type="text/javascript">
	document.write(myBar);	
</script>
<div style="position: absolute;top:0px;">
<form action="" name="searchForm" id="searchForm" method="post"
	onsubmit="return false" style="margin: 0px">
	<input type="hidden" value="<c:out value='${param.method}' />" name="method">
	<div class="div-float-right">
		<div class="div-float">
			<select name="condition"
			onChange="showNextCondition(this)" class="condition">
				<option value="templateName"><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
				<option value="templateName"><fmt:message key="mt.mtSummaryTemplate.templateName" /></option>
				<option value="description"><fmt:message key="common.description.label" bundle="${v3xCommonI18N}" /></option>
			</select>
		</div>

		<!-- 每一个选项对应一个DIV，它的id命名规定为"选项option.value + Div" input框规定为textfield -->
		<div id="templateNameDiv" class="div-float">
			<input type="text" name="textfield" class="textfield">
		</div>
		<div id="descriptionDiv" class="div-float hidden">
			<input type="text" name="textfield" class="textfield">
		</div>
		
		<!-- 按钮事件已经封装，直接copy -->
		<div onclick="javascript:doSearch()" class="condition-search-button"></div>
	</div>
</form>
</div>
<form>
<v3x:table htmlId="listTable" data="list" var="bean" leastSize="5">
	<v3x:column width="5%" align="center"
		label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
		<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" />
	</v3x:column>
	<v3x:column width="20%" type="String" onDblClick="editTemplateLine('${bean.id}');" onClick="displayDetail('${bean.id}');"
		label="mt.mtSummaryTemplate.templateName" className="cursor-hand sort"
		bodyType="${bean.templateFormat}"
		>
		${bean.templateName}
	</v3x:column>
	<v3x:column width="20%" type="String" onDblClick="editTemplateLine('${bean.id}');" onClick="displayDetail('${bean.id}');"
		label="mt.mtSummaryTemplate.createUser" className="cursor-hand sort">
		${bean.createUserName}
	</v3x:column>
	<v3x:column width="20%" type="String" onDblClick="editTemplateLine('${bean.id}');" onClick="displayDetail('${bean.id}');"
		label="mt.mtSummaryTemplate.createDate" className="cursor-hand sort">
		<fmt:formatDate pattern="${datePattern}" value="${bean.createDate}" />
	</v3x:column>
	<v3x:column width="20%" type="String" onDblClick="editTemplateLine('${bean.id}');" onClick="displayDetail('${bean.id}');"
		label="mt.mtSummaryTemplate.description" className="cursor-hand sort">
		${bean.description}
	</v3x:column>

</v3x:table>
</form>
</div>
</body>
</html>
