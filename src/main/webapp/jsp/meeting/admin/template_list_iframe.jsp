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
	if(getA8Top()!=null && typeof(getA8Top().showLocation)!="undefined") {
		getA8Top().showLocation(3206);
	}
	var authProperties = new Properties();
	
	function selectPeople(elemId,idElem,nameElem){
		var returnValue =  eval('selectPeopleFun_'+elemId+'()');
		return returnValue;
	}
	
	function configTemplateUser(){
		var ids=getSelectIds();
		if(ids==''){
			alert(v3x.getMessage("meetingLang.choose_item_from_list"));
			return;
		}
		
		var index = ids.split(",");
		
		var returnValue = "";
		
		//判断选中的是不是一个
		if(index.length>2){
			returnValue = selectPeople('configTemplateUser','userIds','userNames');
		}else{
			returnValue = selectPeople('configTemplateUser'+authProperties.get(index[0]),'userIds','userNames');
		}
		
		//alert($('userIds').value);
		
		if(!returnValue){
			return false;
		}else{
		
			if($('userIds').value==''){
				//alert(v3x.getMessage("meetingLang.choose_auth_people"));
				$('configForm').id.value=ids;
				$('configForm').userIds.value="";
				$('configForm').submit();
				return;
			}
			
		}
		
		if(confirm(v3x.getMessage("meetingLang.sure_to_auth")+$('userNames').value)){
			$('configForm').id.value=ids;
			$('configForm').submit();
		}
	}

	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />", 
			"parent.location.href='${mtTemplateURL}?method=create&templateType=1';", 
			"<c:url value='/common/images/toolbar/new.gif'/>",
			"", 
			null
			)
	);
	myBar.add(
		new WebFXMenuButton(
			"editBtn", 
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
			"deleteMtRecord('${mtTemplateURL}?method=delete&templateType=1');", 
			"<c:url value='/common/images/toolbar/delete.gif'/>", 
			"", 
			null
			)
	);
	myBar.add(
		new WebFXMenuButton(
			"delBtn", 
			"<fmt:message key='common.toolbar.auth.label' bundle='${v3xCommonI18N}' />", 
			"configTemplateUser();", 
			"<c:url value='/common/images/toolbar/auth.gif'/>", 
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

	baseUrl='${mtTemplateURL}?templateType=1&method=';
	
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
	
	function deleteMtRecord(baseUrl){
		var ids=document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id=id+idCheckBox.value+',';
			}
		}
		if(id==''){
			alert(v3x.getMessage("meetingLang.choose_item_to_delete"));
			return;
		}
		
		
		
		if(confirm(v3x.getMessage("meetingLang.sure_to_delete")))
			parent.window.location.href=baseUrl+'&id='+id;
	}
	
	//授权只能选本单位人员
	var onlyLoginAccount_configTemplateUser = true;

</script>
</head>
<body>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">

	<tr>
		<td height="25"  class="webfx-menu-bar div-top-line-mercury">
		<div class="" style="width:500px;float:left;">
			<script type="text/javascript">
				document.write(myBar);	
			</script>
		</div>
			<form action="" name="searchForm" id="searchForm" method="post"
				onsubmit="return false" style="margin: 0px">
				<input type="hidden" name="templateType" value="1" />
				<input type="hidden" value="<c:out value='${param.method}' />" name="method">
				<div class="div-float-right">
					<div class="div-float">
						<select name="condition"
						onChange="showNextCondition(this)" class="condition">
							<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							<option value="title"><fmt:message key="mt.mtMeeting.title" /></option>
						</select>
					</div>
					<div id="" class="div-float hidden">
						<input type="text" name="" class="">
					</div>			
					<div id="titleDiv" class="div-float hidden">
						<input type="text" name="textfield" class="textfield">
					</div>
					
					<div onclick="javascript:doSearch()" class="condition-search-button"></div>
					
				</div>
			</form>
		</td>
	</tr>
	<tr>
		<td>
			<div class="scrollList">
				<form>
				<c:set value="0" var="loop" />
				<v3x:table htmlId="listTable" data="list" var="bean">
					<v3x:column width="5%" align="center"
						label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
						<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" />
						<c:set value="${v3x:parseElements(authMap[bean.id], 'id', 'entityType')}" var="authUsers" />
						<script>
							authProperties.put('${bean.id}','${loop}');
							eval("var onlyLoginAccount_configTemplateUser${loop} = true");
						</script>
						<v3x:selectPeople minSize="0" id="configTemplateUser${loop}" panels="Department,Team" originalElements="${authUsers}" selectType="Member,Department" jsFunction="setBulPeopleFields(elements,'userIds','userNames')" />
						<c:set value="${loop+1}" var="loop" />
					</v3x:column>
					<v3x:column width="20%" type="String" onDblClick="editTemplateLine('${bean.id}');" onClick="displayDetail('${bean.id}');"
						label="mt.mtMeeting.title" className="cursor-hand sort"
						bodyType="${bean.dataFormat}" value="${bean.title}" hasAttachments="${bean.attachmentsFlag}" maxLength="25" symbol="...">
					</v3x:column>
					<c:set value="${v3x:showOrgEntities(bean.templateUsers, 'authId', 'authType', pageContext)}" var="authStr" />
					<v3x:column width="25%" type="String" onDblClick="editTemplateLine('${bean.id}');" onClick="displayDetail('${bean.id}');"
						label="label.configUser" className="cursor-hand sort" alt="${authStr}" maxLength="35" value="${authStr}">
					</v3x:column>
					<v3x:column width="10%" type="String" onDblClick="editTemplateLine('${bean.id}');" onClick="displayDetail('${bean.id}');"
						label="mt.mtMeeting.emceeId" className="cursor-hand sort">
						${v3x:showOrgEntitiesOfIds(bean.emceeId, 'Member', pageContext)}
					</v3x:column>
					<v3x:column width="10%" type="String" onDblClick="editTemplateLine('${bean.id}');" onClick="displayDetail('${bean.id}');"
						label="mt.mtMeeting.recorderId" className="cursor-hand sort">
						${v3x:showOrgEntitiesOfIds(bean.recorderId, 'Member', pageContext)}
					</v3x:column>
					<v3x:column width="15%" type="String" onDblClick="editTemplateLine('${bean.id}');" onClick="displayDetail('${bean.id}');"
						label="mt.mtMeeting.beginDate" className="cursor-hand sort">
						<fmt:formatDate pattern="${datePattern}" value="${bean.beginDate}" />
					</v3x:column>
					<v3x:column width="15%" type="String" onDblClick="editTemplateLine('${bean.id}');" onClick="displayDetail('${bean.id}');"
						label="common.date.endtime.label" className="cursor-hand sort">
						<fmt:formatDate pattern="${datePattern}" value="${bean.endDate}" />
					</v3x:column>
				
				</v3x:table>
				</form>
				<form name="configForm" action="${mtTemplateURL}" method="post">
					<input type="hidden" name="method" value="configUser" /> 
					<input type="hidden" name="templateType" value="1" />
					<input type="hidden" name="id" value=""/>
					<input type="hidden" name="userIds" value=""/>
					<input type="hidden" name="userNames" value=""/>
					<v3x:selectPeople id="configTemplateUser" panels="Department,Team" selectType="Member,Department" jsFunction="setBulPeopleFields(elements,'userIds','userNames')" />
				</form>
			</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.meeting.manage' bundle="${v3xMainI18N}"/>", [1,5], pageQueryMap.get('count'), _("meetingLang.detail_info_8001"));	
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
</script>
</body>
</html>
