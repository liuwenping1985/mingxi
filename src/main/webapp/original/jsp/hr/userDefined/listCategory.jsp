<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" />
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>    
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/jquery.jetspeed.json.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
	//getA8Top().showLocation(1207, "<fmt:message key='hr.userDefined.option.label' bundle='${v3xHRI18N}'/><fmt:message key='hr.userDefined.category.label' bundle='${v3xHRI18N}'/>");
</script>
<script type="text/javascript">
	function newCategory(){
		parent.detailFrame.location.href = "${hrUserDefined}?method=newCategory&settingType=${param.settingType}";
	}
	
	function viewCategory(id){
		parent.detailFrame.location.href = "${hrUserDefined}?method=viewCategory&category_id="+id+"&settingType=${param.settingType}"+"&readonly=true&disabled=true";
	}
	
	function modify(){
		if(checkSelectedId(this)){
			alert(v3x.getMessage("HRLang.hr_userDefined_data_choose_message"));
			return false;
		}
		var id = getSelectIds(this);
		parent.detailFrame.location.href = "${hrUserDefined}?method=viewCategory&category_id="+id+"&settingType=${param.settingType}"+"&readonly=false&disabled=false";
	}
	
	function del(){
		var cIds = getSelectIds(this);
		if(cIds == ''){
			alert(v3x.getMessage("HRLang.hr_userDefined_data_choose_message"));
			return false;
		}
		var deleted = 1;
		
		if(!confirm(v3x.getMessage("HRLang.hr_staffInfo_is_delete")))
			return false;
		
		var options = {
   			url: '${hrUserDefined}?method=isEmptyOfCategory',
   			params: {cIds: cIds},
   			success: function(json) {
			        for (var i = 0; i < json.length; i++) {
			        	if (json[i].isEmpty == false) {
				        	alert(json[i].categoryName + v3x.getMessage("HRLang.hr_userDefined_category_isempty_message"));
				        	deleted = 0;
				        	break;
				        }
			      	}
			      	if(deleted == 1)	
						parent.listFrame.location.href = "${hrUserDefined}?method=destroyCategory&cIds="+cIds+"&settingType=${param.settingType}";
		    }
		};
   		getJetspeedJSON(options);
	}
</script>
</head>
<body class="listPadding">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td height="22">
		<script>	
			var myBar1 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");
			
			myBar1.add(new WebFXMenuButton("new", "<fmt:message key='hr.toolbar.salaryinfo.new.label' bundle='${v3xHRI18N}' />",  "newCategory()", [1,1]));
			myBar1.add(new WebFXMenuButton("modify", "<fmt:message key='hr.staffInfo.modify.label' bundle='${v3xHRI18N}' />", "modify()", [1,2], "", null));
			myBar1.add(new WebFXMenuButton("delete", "<fmt:message key='hr.toolbar.salaryinfo.delete.label' bundle='${v3xHRI18N}' />", "del()", [1,3], "",null));
			
			document.write(myBar1);
			document.close();
		</script>
	</td></tr>
	<tr>
		<td>
			<div class="scrollList">
				<form id="salaryform" method="post">
					<v3x:table data="${categories}" var="category" htmlId="salarylist" subHeight="30">
						<c:set var="click" value="viewCategory('${category.id}')"/>
						<c:if test="${!category.sysFlag}">
							<c:set var="Dclick" value="modify()"/>
						</c:if>
						<v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
							<input type="checkbox" name="id" value="${category.id}" ${category.sysFlag ? 'disabled' : ''}/>
						</v3x:column>
						<v3x:column width="50%" label="hr.userDefined.category.name.label" type="String" onDblClick="${Dclick}" value="${category.name}" onClick="${click}" className="cursor-hand sort" symbol="..." alt="${category.name}" maxLength="90" />
						<fmt:message key='common.attribute.isSystem.${category.sysFlag}' bundle='${v3xCommonI18N}' var="attribute_label"/>
						<v3x:column width="45%" label="common.attribute.label" type="String" onDblClick="${Dclick}" value="${attribute_label}" onClick="${click}" className="cursor-hand sort" symbol="..." alt="${attribute_label}" maxLength="90" />
					</v3x:table>
				</form>
			</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
	showDetailPageBaseInfo("detailFrame", "   "+"<fmt:message key='hr.userDefined.category.label' bundle='${v3xHRI18N}'/>", [2,4], pageQueryMap.get('count'),  v3x.getMessage("HRLang.detail_hr_120701"));
</script>
</body>
</html>
