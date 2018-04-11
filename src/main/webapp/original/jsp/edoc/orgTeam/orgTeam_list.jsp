<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="../edocHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
		function deleteItem() {
		
		  var checkedIds = document.getElementsByName('id');

		  var len = checkedIds.length;
		  
		  var str = "";
		  
		  for(var i = 0; i < len; i++) {
		  		var checkedId = checkedIds[i];
				
				if(checkedId && checkedId.checked && checkedId.parentNode.parentNode.tagName == "TD"){			
					str += checkedId.value;
					str +=","
				}
			}
			
			if(str==null || str==""){
		  	alert(_("edocLang.edoc_select_one"));
		  	return false;
		  }
			str = str.substring(0,str.length-1);
			
		if(window.confirm(_("edocLang.edoc_del_confirm"))){
			
				document.location.href='${edocObjTeamUrl}?method=delete&id='+str;
			
			}
		}
		
		
	function newEdocTeam()
	{
		parent.detailFrame.location.href='${edocObjTeamUrl}?method=addNew';
	}
	
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");

		myBar.add(
		new WebFXMenuButton(
			"templateTypeMenu", 
			"<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />",  
			"newEdocTeam();",
			[1,1], 
			"", 
			null
			)
	);
	myBar.add(new WebFXMenuButton("edit", 
		"<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", 
		"editOneLine();", [1,2], 
		"", null));
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />",  
			"deleteItem();", 
			[1,3],
			"", 
			null
			)
	);	
	baseUrl='${edocDocTemplate}?method=';
	
	function editPlan(id){

		parent.detailFrame.window.location='${edocObjTeamUrl}?method=edit&id='+id;
}
	function singleClick(id){

		parent.detailFrame.window.location='${edocObjTeamUrl}?method=edit&flag=readonly&id='+id;
}
function editOneLine(){
		var chkid = document.getElementsByName('id');
	var count = 0;
	var id = "";
	for(var i = 0; i < chkid.length; i++){
		if(chkid[i].checked){
			count++;
			id = chkid[i].value;
		}
	}
	
	if(count == 0){
		alert(v3x.getMessage('edocLang.edoc_select_one'));
		return false;
	}else if(count > 1){
		//alert(v3x.getMessage('edocLang.edoc_del_confirm'));
		alert(v3x.getMessage('edocLang.edoc_select_one'));
		return false;
	}
	
	parent.detailFrame.window.location='${edocDocTemplate}?method=edit&id='+id;	

}

	function showByStatus(){
		window.document.searchForm.submit();
	}
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body scroll="no" class="page-color">

<form name="mainForm" id="mainForm" method="post">

<div class="main_div_row2">
<div class="right_div_row2">

<div class="top_div_row2 webfx-menu-bar" style="border-top:0;">
	<table width="100%" height="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<script type="text/javascript">
					document.write(myBar.toString());	
					document.close();
				</script>
			</td>
		</tr>
	</table>
</div>

<div class="center_div_row2" id="scrollListDiv">
	<c:set value="${productEdition eq 'GROUP'?'edoc.objTeam.include.label':'edoc.objTeam.include.dep.label'}" var="includeLabel" />
	
<v3x:table data="teamList"   className="sort ellipsis" var="bean" htmlId="listTable" showHeader="true" showPager="true">
	<v3x:column width="5%" align="center"
		label="<input type='checkbox' onclick='selectAllValues(this, \"id\")'/>" className="cursor-hand sort">
		<input type='checkbox' id='id' name='id' value="<c:out value="${bean.id}"/>" />
	</v3x:column>	
	<v3x:column width="25%" type="String" onClick="singleClick('${bean.id}');" onDblClick="editPlan('${bean.id}');"
		label="common.name.label" className="cursor-hand sort mxtgrid_black" maxLength="30" symbol="..." alt="${bean.name}" value="${bean.name}">
		
	</v3x:column>
	<v3x:column width="35%" type="String" onClick="singleClick('${bean.id}');" onDblClick="editPlan('${bean.id}');"
		label="${includeLabel}" className="cursor-hand sort" value="${v3x:showOrgEntitiesOfTypeAndId(bean.selObjsStr, pageContext)}"  symbol="..." alt="${v3x:showOrgEntitiesOfTypeAndId(bean.selObjsStr, pageContext)}">
	</v3x:column>
	<v3x:column width="34%" type="String" onClick="singleClick('${bean.id}');" onDblClick="editPlan('${bean.id}');"
		label="common.description.label" className="cursor-hand sort"
		maxLength="50" symbol="..."
		value="${bean.description}"
		>
	</v3x:column>
</v3x:table>
    </div>
  </div>
</div>
</form>
<iframe id="temp_frame" name="temp_frame" style="display: none;">&nbsp;</iframe>
<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.edoc.ogrTeam' bundle="${v3xMainI18N}"/>", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_4006"));	
initIpadScroll("scrollListDiv",550,870);
</script>
</body>
</html>
