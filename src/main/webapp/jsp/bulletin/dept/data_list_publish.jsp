<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<html>
<head>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript">
	try {
	    getA8Top().endProc();
	}
	catch(e) {
	}
	window.onload = function(){
		showCondition("${condition}", "<v3x:out value='${textfield}' escapeJavaScript='true' />", "<v3x:out value='${textfield1}' escapeJavaScript='true' />");
	}
	
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	<c:if test="${sessionScope['bulletin.isWriter'] || sessionScope['bulletin.isAuditer'] || sessionScope['bulletin.isManager']}">
	if(v3x.getBrowserFlag("hideMenu") == true){
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.new.label' bundle="${v3xCommonI18N}" /><fmt:message key="bul.data_shortname" />", 
			"parent.window.location.href='${bulDataURL}?method=create&deptId=${sessionScope['bulletin.typeId']}';", 
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
	}
	myBar.add(
		new WebFXMenuButton(
			"delBtn", 
			"<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' /><fmt:message key="bul.data_shortname" />", 
			"deleteRecord('${bulDataURL}?method=writeDelete');", 
			"<c:url value='/common/images/toolbar/delete.gif'/>", 
			"", 
			null
			)
	);
	</c:if>
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.oper.publish.label' bundle='${v3xCommonI18N}'/><fmt:message key="bul.data_shortname" />", 
			"publishData();", 
			"<c:url value='/apps_res/bulletin/images/newColl.gif'/>", 
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
	baseUrl='${bulDataURL}?method=';
		
</script>
</head>
<body class="tab-body">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
			<div class="div-float">
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel"><a target="_parent" href="${bulDataURL}?method=deptListAll&type=${sessionScope['bulletin.typeId']}" class="non-a"><fmt:message key="oper.view" /><fmt:message key="bul.data_shortname" /></a></div>
				<div class="tab-tag-right"></div>
				<div class="tab-separator"></div>
				
				<div class="tab-tag-left-sel"></div>
				<div class="tab-tag-middel-sel"><a href="#" class="non-a"><fmt:message key="oper.publish" /><fmt:message key="bul.data_shortname" /></a></div>
				<div class="tab-tag-right-sel"></div>
			</div>
		</td>
	</tr>
</table>
<table width="100%" border="0"  cellspacing="0" cellpadding="0" background="<c:url value='/common/js/menu/images/toolbar_bg.gif'/>">
	<tr>
		<td width="100%" />
<div style="width:590px;float:left;">
<script type="text/javascript">
	document.write(myBar);	
</script>
</div>

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
		
		<!-- 按钮事件已经封装，直接copy1 -->
		<div onclick="javascript:doSearch()" class="condition-search-button "></div>
	</div>
</form>
		</td>
	</tr>
</table>
<div class="tab-body-border">
<c:set scope="request" var="onDblClick" value="editDataLine" />
<c:set scope="request" var="detailMethod" value="writeDetail" />
<%@ include file="../include/dataList.jsp"%>
</div>
<jsp:include page="../include/deal_exception.jsp" />
</body>
</html>
