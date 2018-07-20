<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>

<html>
<head>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript"
	src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}

<script type="text/javascript">
window.onload = function(){
	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
}

	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />", 
			"parent.location.href='${bulTemplateURL}?method=create';", 
			"<c:url value='/common/images/toolbar/new.gif'/>", 
			"", 
			null
			)
	);
	
	myBar.add(
		new WebFXMenuButton(
			"editBtn", 
			"<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", 
			"editTemplate();", 
			"<c:url value='/common/images/toolbar/update.gif'/>", 
			"", 
			null
			)
	);
	myBar.add(
		new WebFXMenuButton(
			"delBtn", 
			"<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", 
			"deleteRecord('${bulTemplateURL}?method=delete');", 
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
	
	
	//detailBaseUrl='<c:url value="/bulTemplate.do?method=detail" />';
	baseUrl='${bulTemplateURL}?method=';
</script>
</head>
<body>

<table width="100%" border="0" cellspacing="0" cellpadding="0"
	height="100%">
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
		<div class="div-float">
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"><a target="_parent"
			href="${bulTypeURL}?method=listMain" class="non-a"><fmt:message
			key="bul.type" /></a></div>
		<div class="tab-tag-right"></div>

		<div class="tab-separator"></div>

		<div class="tab-tag-left-sel"></div>
		<div class="tab-tag-middel-sel"><a href="#" class="non-a"><fmt:message
			key="bul.template" /></a></div>
		<div class="tab-tag-right-sel"></div>

		</div>
		</td>
	</tr>


	<tr>
		<td height="25" class="webfx-menu-bar-gray">
			<div style="width:450px;float:left;">
			<script type="text/javascript">
				document.write(myBar);	
			</script>
			</div>
			
			<form action="" name="searchForm" id="searchForm" method="post"
				onsubmit="return false" style="margin: 0px"><input
				type="hidden" value="<c:out value='${param.method}' />"
				name="method">
			<div class="div-float-right">
			<div class="div-float"><select name="condition"  id="condition"
				onChange="showNextCondition(this)" class="condition">
				<option value="templateName"><fmt:message
					key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
				<option value="templateName"><fmt:message
					key="bul.template.templateName" /></option>
				<option value="usedFlag"><fmt:message
					key="bul.template.usedFlag" /></option>
				<option value="description"><fmt:message
					key="bul.template.description" /></option>
			</select></div>

			<!-- 每一个选项对应一个DIV，它的id命名规定为"选项option.value + Div" input框规定为textfield -->
			<div id="templateNameDiv" class="div-float"><input type="text"
				name="textfield" class="textfield"></div>
			<div id="usedFlagDiv" class="div-float hidden"><select
				name="textfield" class="textfield">
				<option value="1"><fmt:message key="label.used" /></option>
				<option value="0"><fmt:message key="label.noused" /></option>
			</select></div>
			<div id="descriptionDiv" class="div-float hidden"><input
				type="text" name="textfield" class="textfield"></div>

			<!-- 按钮事件已经封装，直接copy -->
			<div onclick="javascript:doSearch()" class="condition-search-button"></div>
			</div>
			</form>
	
			</td>
		</tr>



<tr>
		<td class="tab-body-border" height="100%" valign="top" colspan="1">
			<div class="scrollList">
			
	<form><!-- Edit By Lif Start --> <v3x:table htmlId="listTable"
		data="list" var="bean" leastSize="0">
		<!-- Edit End -->
		<v3x:column width="5%" align="center"
			label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
			<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" />
		</v3x:column>
		<v3x:column width="30%" type="String"
			onDblClick="editTemplateLine('${bean.id}');"
			onClick="displayDetail('${bean.id}');"
			label="bul.template.templateName" className="cursor-hand sort"
			bodyType="${bean.templateFormat}" property="templateName"
			alt="${bean.templateName}" maxLength="30">
		</v3x:column>
		<v3x:column width="65%" type="String"
			onDblClick="editTemplateLine('${bean.id}');"
			onClick="displayDetail('${bean.id}');"
			label="bul.template.description" className="cursor-hand sort"
			value="${bean.description}" alt="${bean.description}" maxLength="40">
		</v3x:column>

			</v3x:table>
		</form>
	</div>
	</td>
	</tr>
</table>
	
</body>
</html>
