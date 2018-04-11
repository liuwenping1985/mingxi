<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="../include/taglib.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../include/header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link type="text/css" rel="stylesheet" href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
<script type="text/javascript">
	<c:set value="${v3x:currentUser().groupAdmin ? 2002 : 1515}" var="locationMenuId" />
 	getA8Top().showLocation(${locationMenuId});

	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","");
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />", 
			"parent.location.href='${mtContentTemplateURL}?method=create';", 
			[1,1],
			"", 
			null
			)
	);
	
	myBar.add(
		new WebFXMenuButton(
			"editBtn", 
			"<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", 
			"editMtTextTemplate();", 
			[1,2],
			"", 
			null
			)
	);
	myBar.add(
		new WebFXMenuButton(
			"delBtn", 
			"<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", 
			"deleteMtRecord('${mtContentTemplateURL}?method=delete');", 
			[1,3], 
			"", 
			null
			)
	);
	
	baseUrl='${mtContentTemplateURL}?method=';
	
	function editMtTextTemplate(){
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
	
	function changedType() {
		var optValue = document.getElementById("type");
		if(!optValue || !optValue.value || optValue.value == "undefined" || optValue.value == null){
			return;
		}
		parent.listFrame.location.href=baseUrl+"list"+"&type="+optValue.value;
	}
</script>
</head>
<body>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="25" width="88%" class="webfx-menu-bar">
			<script type="text/javascript">
				document.write(myBar);	
			</script>
		</td>
		
		<c:if test="${type=='all' || type==''}"><c:set value="selected" var="allSelected" /></c:if>
		<c:if test="${type=='3'}"><c:set value="selected" var="bulSelected" /></c:if>
		<c:if test="${type=='4'}"><c:set value="selected" var="newsSelected" /></c:if>
		<c:if test="${type=='2'}"><c:set value="selected" var="planSelected" /></c:if>
		<c:if test="${type=='1'}"><c:set value="selected" var="mtSelected" /></c:if>
		
		<td class="webfx-menu-bar" width="4%" align="right"><fmt:message key="mt.mtType.label" />:</td>
		<td class="webfx-menu-bar" width="8%" align="center">
			<form action="" name="listForm" id="listForm" method="post" onsubmit="return false" style="margin: 0px">
				<input type="hidden" value="" name="selectedValue" />
					<select id="type" name="type" onChange="changedType();">
				    	<option value="all" ${allSelected}><fmt:message key="mt.mtAllType.label" /></option>
				    	<option value="3" ${bulSelected}><fmt:message key="mt.mtBulletion"/></option>
						<option value="4" ${newsSelected}><fmt:message key="mt.mtNews"/></option>
				    	<c:if test="${v3x:currentUser().administrator}">
					    	<option value="2" ${planSelected}><fmt:message key="mt.mtPlan"/></option>
							<option value="1" ${mtSelected}><fmt:message key="mt.mtMeeting"/></option>							
						</c:if>
					</select>
			</form>
		</td>
	</tr>
	
	<tr>
		<td colspan="3">
			<div class="scrollList">
			<form>
			<v3x:table htmlId="listTable" data="list" var="bean" subHeight="30">
				<v3x:column width="5%" align="center"
					label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
					<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" />
				</v3x:column>
				
				<v3x:column width="45%" type="String" onDblClick="editTemplateLine('${bean.id}');" onClick="displayDetail('${bean.id}');"
					label="mt.mtSubject.label" className="cursor-hand sort"
					bodyType="${bean.templateFormat}" value="${bean.templateName}" />
				
				<v3x:column width="50%" type="String" onDblClick="editTemplateLine('${bean.id}');" onClick="displayDetail('${bean.id}');"
					label="mt.mtType.label" className="cursor-hand sort" symbol="..." maxLength="70">
					<c:choose>
						<c:when test="${bean.ext1 == '1'}">
							<fmt:message key="mt.mtMeeting"/>
						</c:when>
						<c:when test="${bean.ext1 == '2'}">
							<fmt:message key="mt.mtPlan"/>
						</c:when>
						<c:when test="${bean.ext1 == '3' || bean.ext2 == '3'}">
							<fmt:message key="mt.mtBulletion"/>
						</c:when>
						<c:when test="${bean.ext1 == '4' || bean.ext2 == '4'}">
							<fmt:message key="mt.mtNews"/>
						</c:when>						
					</c:choose>
				</v3x:column>
			
			</v3x:table>
			</form>
			</div>
		</td>
	</tr>
</table>

<script type="text/javascript">	 
	var desId = "detail_info_1515";
	if(${v3x:currentUser().groupAdmin}){
		desId = "detail_info_1516";
	}
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.common.format.setting' bundle='${v3xMainI18N}' />", [1,5], pageQueryMap.get('count'), v3x.getMessage("meetingLang."+desId));	
</script>	
</body>
</html>
