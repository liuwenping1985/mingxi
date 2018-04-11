<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>    
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<script type="text/javascript">
	//getA8Top().showLocation(1207, "<fmt:message key='hr.userDefined.option.label' bundle='${v3xHRI18N}'/>");
</script>
<script type="text/javascript"><!--
	function newOption(){
		parent.detailFrame.location.href = "${hrUserDefined}?method=newOption&settingType=${param.settingType}";
	}
	
	function viewOption(id){
		parent.detailFrame.location.href = "${hrUserDefined}?method=viewOption&property_id="+id+"&settingType=${param.settingType}&readonly=true&disabled=true";
	}
	
	function modify(){
		if(checkSelectedId(this)){
			alert(v3x.getMessage("HRLang.hr_userDefined_data_choose_message"));
			return false;
		}
		var id = getSelectIds(this);
		parent.detailFrame.location.href = "${hrUserDefined}?method=viewOption&property_id="+id+"&settingType=${param.settingType}&readonly=false&disabled=false";
	}
	
	function delOption(){
		var oIds = getSelectIds(this);
		if(oIds == ''){
			alert(v3x.getMessage("HRLang.hr_userDefined_data_choose_message"));
			return false;
		}
		if(!confirm(v3x.getMessage("HRLang.hr_staffInfo_is_delete")))
		return false;
		
		parent.listFrame.location.href = "${hrUserDefined}?method=destroyOption&oIds="+oIds+"&settingType=${param.settingType}";
	}
	
--></script>
</head>
<body  class="listPadding">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td height="22">
		<script>	
			var myBar1 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");
			
			myBar1.add(new WebFXMenuButton("new", "<fmt:message key='hr.toolbar.salaryinfo.new.label' bundle='${v3xHRI18N}' />",  "newOption()", [1,1]));
			myBar1.add(new WebFXMenuButton("modify", "<fmt:message key='hr.staffInfo.modify.label' bundle='${v3xHRI18N}' />", "modify()", [1,2], "", null));
			myBar1.add(new WebFXMenuButton("delete", "<fmt:message key='hr.toolbar.salaryinfo.delete.label' bundle='${v3xHRI18N}' />", "delOption()", [1,3]), "",null );
			
			document.write(myBar1);
			document.close();
		</script>
	</td></tr>
	<tr>
		<td>
			<div class="scrollList">
				<form id="salaryform" method="post">
					<v3x:table data="${properties}" var="property" htmlId="salarylist" subHeight="30">
						<c:set var="click" value="viewOption('${property.property_id}')"/>
						<c:set var="Dclick" value="modify()"/>
						<v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
							<input type="checkbox" name="id" value="${property.property_id}">
						</v3x:column>
						<v3x:column width="25%" type="String" label="hr.userDefined.option.name.label"  onDblClick="${Dclick}" value="${property.propertyName}" onClick="${click}" className="cursor-hand sort" symbol="..." alt="${property.propertyName}"  maxLength="18" />
						<v3x:column width="25%" type="String" label="hr.userDefined.name.english.label"  onDblClick="${Dclick}" value="${property.labelName_en}" onClick="${click}" className="cursor-hand sort" symbol="..." alt="${property.labelName_en}"  maxLength="11" />
						<v3x:column width="10%" type="String" label="hr.userDefined.type.label"  onDblClick="${Dclick}" onClick="${click}" className="cursor-hand sort" symbol="...">
							<fmt:message key="${property.type}"/>
						</v3x:column>	
						<fmt:message key='${property.not_null}' bundle='${v3xCommonI18N}' var="not_null"/>				
						<v3x:column width="10%" type="String" label="hr.userDefined.notNull.label"  onDblClick="${Dclick}" onClick="${click}" className="cursor-hand sort" symbol="..." alt="${not_null}">
							<fmt:message key="${property.not_null}" />
						</v3x:column>
						<v3x:column width="15%" type="String" label="hr.userDefined.option.category.label"  onDblClick="${Dclick}" value="${property.category}" onClick="${click}" className="cursor-hand sort" symbol="..." alt="${property.category}" maxLength="15" />
						<fmt:message key='common.attribute.isSystem.${property.sysFlag}' bundle='${v3xCommonI18N}' var="attribute_label"/>
						<v3x:column width="10%" label="common.attribute.label" type="String" onDblClick="${Dclick}" value="${attribute_label}" onClick="${click}" className="cursor-hand sort" symbol="..." alt="${attribute_label}" maxLength="90" />
					</v3x:table>
				</form>
			</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
    showDetailPageBaseInfo("detailFrame", "   "+"<fmt:message key='hr.userDefined.option.label' bundle='${v3xHRI18N}'/>", [2,4], pageQueryMap.get('count'),  v3x.getMessage("HRLang.detail_hr_120703"));
</script>
</body>
</html>
