<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<html>
<head>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript">
	window.onload = function(){
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	}
	
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key="oper.top" />", 
			"topData('${bulDataURL}?method=top', '${topCount}', '${topedCount}');", 
			"<c:url value='/apps_res/bulletin/images/newColl.gif'/>", 
			"", 
			null
			)
	);
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key="oper.cancel" /><fmt:message key="oper.top" />", 
			"topData('${bulDataURL}?method=top&oper=cancel', '${topCount}', '${topedCount}', 'cancel');", 
			"<c:url value='/apps_res/bulletin/images/newColl.gif'/>", 
			"", 
			null
			)
	);
	
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.pigeonhole.label' bundle='${v3xCommonI18N}' />", 
			"myPigeonhole('<%=com.seeyon.v3x.common.constants.ApplicationCategoryEnum.bulletin%>');", 
			"<c:url value='/common/images/toolbar/pigeonhole.gif'/>", 
			"", 
			null
			)
	);
		
	myBar.add(
		new WebFXMenuButton(
			"delBtn", 
			"<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", 
			"deleteRecord('${bulDataURL}?method=delete');", 
			"<c:url value='/common/images/toolbar/delete.gif'/>", 
			"", 
			null
			)
	);
	baseUrl='${bulDataURL}?method=';
	
</script>
</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
			<div class="div-float">
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel"><a target="_parent" href="${bulDataURL}?method=deptListAll&type=${sessionScope['bulletin.typeId']}" class="non-a"><fmt:message key="oper.view" /><fmt:message key="bul.data_shortname" /></a></div>
				<div class="tab-tag-right"></div>

<c:if test="${sessionScope['bulletin.isShowManage']}">					
				<div class="tab-separator"></div>
				
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel"><a target="_parent" href="${bulDataURL}?method=deptPublishListMain" class="non-a"><fmt:message key="oper.publish" /><fmt:message key="bul.data_shortname" /></a></div>
				<div class="tab-tag-right"></div>
</c:if>		
			</div>
		</td>
		<td valign="bottom" width="3" rowspan="2"><div class="tab-tag-1">&nbsp;</div></td>
	</tr>
</table>



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
			<select name="condition"   id="condition"
			onChange="showNextCondition(this)" class="condition">
				<option value="title"><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
				<option value="title"><fmt:message key="bul.data.title" /></option>
				<option value="state"><fmt:message key="bul.data.state" /></option>
			</select>
		</div>

		<!-- 每一个选项对应一个DIV，它的id命名规定为"选项option.value + Div" input框规定为textfield -->
		<div id="titleDiv" class="div-float">
			<input type="text" name="textfield" class="textfield">
		</div>
		<div id="stateDiv" class="div-float hidden">
			<select name="textfield" id="textfield" style="width:130px" class="textfield">
				<option value="20"><fmt:message key="bul.data.state.20" /></option>
				<option value="30"><fmt:message key="bul.data.state.30" /></option>
				<option value="100"><fmt:message key="bul.data.state.100" /></option>
			</select>
		</div>
		
		<!-- 按钮事件已经封装，直接copy -->
		<div onclick="javascript:doSearch()" class="condition-search-button"></div>
	</div>
</form>
</div>
</td></tr>
</table>
<div class="scrollList">
<c:set scope="request" var="onDblClick" value="publishDataLine" />
<c:set scope="request" var="detailMethod" value="detail" />
<%@ include file="../include/dataList.jsp"%>
<%@ include file="../../apps/doc/pigeonholeHeader.jsp"%>
</div>
</body>
</html>
