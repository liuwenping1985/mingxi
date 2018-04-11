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

	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />", "gray");
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />",
			"parent.location.href='${mtTemplateURL}?method=create';", 
			"<c:url value='/common/images/toolbar/new.gif'/>", 
			"", 
			null
			)
	);
	
	myBar.add(
		new WebFXMenuButton(
			"edtBtn", 
			"<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", 
			"editMtTemplate();", 
			"<c:url value='/common/images/toolbar/update.gif'/>", 
			"", 
			null
			)
	);

	myBar.add(
		new WebFXMenuButton(
			"delBtn", 
			"<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", 
			"deleteMtRecord('${mtTemplateURL}?method=delete');", 
			"<c:url value='/common/images/toolbar/delete.gif'/>", 
			"", 
			null
			)
	);

	myBar.add(
		new WebFXMenuButton(
		"",
		"<fmt:message key='common.toolbar.refresh.label' bundle='${v3xCommonI18N}' />", 
		"javascript:refreshIt()", 
		"<c:url value='/common/images/toolbar/refresh.gif'/>", 
		"", 
		null
		)
	);
	
	baseUrl='${mtTemplateURL}?templateType=0&method=';
	
	function editMtTemplate(){
		var id=getSelectId();
		if(id==''){
			alert(v3x.getMessage("meetingLang.choose_item_from_list"));
			return;
		}else if(validateCheckbox("id")>1){
			alert(v3x.getMessage("meetingLang.please_choose_one_date"));
			return;
		}
		parent.location.href=baseUrl+"edit"+'&id='+id;
	}
	
	function displayDetail(id){
		parent.detailFrame.location.href=baseUrl+'detail&id='+id+'&from=temp';
	}
	
</script>
</head>
<body>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="25"  class="webfx-menu-bar-gray">
		<div style="width:500px;float:left;">
			<script type="text/javascript">
				document.write(myBar);	
			</script>
		</div>
				<form action="" name="searchForm" id="searchForm" method="post"
					onsubmit="return false" style="margin: 0px">
					<input type="hidden" value="<c:out value='${param.method}' />" name="method">
					<input type="hidden" name="templateType" value="0" />
					<div class="div-float-right">
						<div class="div-float">
							<select name="condition"
							onChange="showNextCondition(this)" class="condition">
								<option value="title"><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
								<option value="title"><fmt:message key="mt.mtMeeting.title" /></option>
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
		<td valign="top" height="100%">
			<div class="scrollList">
				<form>
				<v3x:table htmlId="listTable" data="list" var="bean" leastSize="0">
					<v3x:column width="5%" align="center"
						label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
						<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" />
					</v3x:column>
					<v3x:column width="40%" type="String" onDblClick="editTemplateLine('${bean.id}');" onClick="displayDetail('${bean.id}');"
						label="mt.mtMeeting.title" className="cursor-hand sort" maxLength="45" symbol="..." bodyType="${bean.dataFormat}" value="${bean.title}" hasAttachments="${bean.attachmentsFlag}">
					</v3x:column>
					<v3x:column width="10%" type="String" align="center" onDblClick="editTemplateLine('${bean.id}');" onClick="displayDetail('${bean.id}');"
						label="mt.mtMeeting.emceeId" className="cursor-hand sort">
						${v3x:showOrgEntitiesOfIds(bean.emceeId, 'Member', pageContext)}
					</v3x:column>
					<v3x:column width="10%" type="String" align="center" onDblClick="editTemplateLine('${bean.id}');" onClick="displayDetail('${bean.id}');"
						label="mt.mtMeeting.recorderId" className="cursor-hand sort">
						${v3x:showOrgEntitiesOfIds(bean.recorderId, 'Member', pageContext)}
					</v3x:column>
					<v3x:column width="20%" type="String" align="center" onDblClick="editTemplateLine('${bean.id}');" onClick="displayDetail('${bean.id}');"
						label="mt.mtMeeting.beginDate" className="cursor-hand sort">
						<fmt:formatDate pattern="${datePattern}" value="${bean.beginDate}" />
					</v3x:column>
					<v3x:column width="20%" type="String" align="center" onDblClick="editTemplateLine('${bean.id}');" onClick="displayDetail('${bean.id}');"
						label="common.date.endtime.label" className="cursor-hand sort">
						<fmt:formatDate pattern="${datePattern}" value="${bean.endDate}" />
					</v3x:column>
				
				</v3x:table>
				</form>
			</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='mt.templet.personaltem' />", [1,5], pageQueryMap.get('count'), _("meetingLang.detail_info_603_2"));	
</script>
</body>
</html>