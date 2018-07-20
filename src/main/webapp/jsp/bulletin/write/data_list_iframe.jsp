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
	
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.new.label' bundle="${v3xCommonI18N}" /><fmt:message key="bul.data_shortname" />", 
			"parent.window.location.href='${bulDataURL}?method=create';", 
			"<c:url value='/apps_res/bulletin/images/newColl.gif'/>", 
			"", 
			null
			)
	);
	myBar.add(
		new WebFXMenuButton(
			"editBtn", 
			"<fmt:message key='common.toolbar.edit.label' bundle="${v3xCommonI18N}" /><fmt:message key="bul.data_shortname" />", 
			"editData();", 
			"<c:url value='/apps_res/bulletin/images/editContent.gif'/>", 
			"", 
			null
			)
	);
	myBar.add(
		new WebFXMenuButton(
			"delBtn", 
			"<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", 
			"deleteRecord('${bulDataURL}?method=writeDelete');", 
			"<c:url value='/common/images/toolbar/delete.gif'/>", 
			"", 
			null
			)
	);
	myBar.add(
		new WebFXMenuButton(
			"refBtn", 
			"<fmt:message key='common.toolbar.refresh.label' bundle='${v3xCommonI18N}' />", 
			"parent.window.location.reload();", 
			"<c:url value='/common/images/toolbar/refresh.gif'/>", 
			"", 
			null
			)
	);
	
	
	myBar.add(
		new WebFXMenuButton(
			"returnBtn", 
			"<fmt:message key='common.toolbar.back.label' bundle='${v3xCommonI18N}' />", 
			"parent.window.location.href='${bulDataURL}?method=userList';", 
			"<c:url value='/common/images/toolbar/back.gif'/>", 
			"", 
			null
			)
	);
	baseUrl='${bulDataURL}?method=';
	
</script>
</head>
<body>
<div class="scrollList">
<%@ include file="../include/operate_button.jsp"%>

<table width="100%" height="22px" border="0" cellpadding="0" cellspacing="0" background="<c:url value='/common/js/menu/images/toolbar_bg.gif'/>">
<tr><td>
<script type="text/javascript">
	document.write(myBar);	
</script>
</td><td align="right">
<div>
<form action="" name="searchForm" id="searchForm" method="post"
	onsubmit="return false" style="margin: 0px">
	<input type="hidden" value="<c:out value='${param.method}' />" name="method">
	<div class="div-float-right">
		<div class="div-float">
			<select name="condition" id="condition" 
			onChange="showNextCondition(this)" class="condition">
				<option value="title"><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
				<option value="title"><fmt:message key="bul.data.title" /></option>
				<option value="type"><fmt:message key="bul.data.type" /></option>
				<option value="state"><fmt:message key="bul.data.state" /></option>
			</select>
		</div>

		<!-- 每一个选项对应一个DIV，它的id命名规定为"选项option.value + Div" input框规定为textfield -->
		<div id="titleDiv" class="div-float">
			<input type="text" name="textfield" class="textfield">
		</div>
		<div id="typeDiv" class="div-float hidden">
			<select name="textfield" id="textfield" style="width:130px" class="textfield">
				<c:forEach items="${typeList}" var="type">
						<option value="${type.id}">${type.typeName}</option>
				</c:forEach>
			</select>
		</div>
		<div id="stateDiv" class="div-float hidden">
			<select name="textfield" id="textfield" style="width:130px" class="textfield">
				<option value="0"><fmt:message key="bul.data.state.0" /></option>
				<option value="10"><fmt:message key="bul.data.state.10" /></option>
			</select>
		</div>
		
		<!-- 按钮事件已经封装，直接copy -->
		<div onclick="javascript:doSearch()" class="condition-search-button"></div>
	</div>
</form>
</div>
</td></tr>
</table>

<c:set scope="request" var="onDblClick" value="editDataLine" />
<c:set scope="request" var="detailMethod" value="writeDetail" />
<%@ include file="../include/dataList.jsp"%>
</div>
</body>
</html>
