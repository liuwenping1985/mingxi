<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="../docHeader.jsp" %>
<%@ include file="../../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docManager.js${v3x:resSuffix()}" />"></script>
<link type="text/css" rel="stylesheet" href="<c:url value='/apps_res/doc/css/docMenu.css${v3x:resSuffix()}' />">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<style type="text/css">
.tab-tag-middel-sel{
    max-width:255px;
}
.webfx-menu-bar-gray{ 
	height: auto;
	vertical-align:top;
	background: none;
}
.tab-tag-middel,.tab-disabled-middle{
    border-bottom:0px #b6b6b6 solid;
}
</style>
</head>
<body scroll="no" class="with-header  border-button">
<span id="nowLocation"></span>
<form name="mainForm" id="mainForm" method="post">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<table width="100%" height="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td valign="bottom" class="tab-tag" height="28" style="height:28px; background:#fff;">
						<c:set value="" var="flagGroup" />
				<c:if test="${isGroupAdmin}">
				<c:set value="group" var="flagGroup" />
				</c:if>
					<div class="div-float">
					<div class="tab-separator"></div>
					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel"><a href="${managerURL}?method=docLibIndex&flag=${flagGroup}" target="_parent" class=""><fmt:message key="doc.menu.admin.libs" /></a></div>
					<div class="tab-tag-right-sel"></div>
					<div class="tab-separator"></div>
					
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel"><a href="${managerURL}?method=docTypeIndex&flag=${flagGroup}" target="_parent" class=""><fmt:message key="doc.menu.admin.types" /></a></div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>
					
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel"><a href="${managerURL}?method=docPropertyIndex&flag=${flagGroup}" target="_parent" class=""><fmt:message key="doc.menu.admin.properties" /></a></div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>
					</div>
				</td>
			</tr>
		
			<tr>
				<td height="38" style="height:38px; background:#fafafa;">
					<script type="text/javascript">
						var flag = '${param.flag}';
						var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />", "gray");
						if("${isGroupAdmin}" != "true" && "${param.status}" != "0" && "${v3x:getSystemProperty('system.ProductId')}" != "7")
							myBar.add(new WebFXMenuButton("add", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />", "createDocLib();", [1,1], "", null));
						if("${param.status}" != "0")
							myBar.add(new WebFXMenuButton("edit", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", "editDocLib('undefined','edit');", [1,2], "", null));
						if("${isGroupAdmin}" != "true" && "${v3x:getSystemProperty('system.ProductId')}" != "7"){
							myBar.add(new WebFXMenuButton("delete", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "deleteDocLib()", [1,3], "", null));
							if("${param.status}" != "0")
								myBar.add(new WebFXMenuButton("sort", "<fmt:message key='common.toolbar.order.label' bundle='${v3xCommonI18N}'/>", "sort();", [8,9], "", null));
						}
						<c:if test="${param.status ne '0'}">
							myBar.add(new WebFXMenuButton("disable", "<fmt:message key='common.toolbar.disable.label' bundle='${v3xCommonI18N}' />", "disableDocLibs();", [2,4], "", null));
						</c:if>
						<c:if test="${param.status eq '0'}">
							myBar.add(new WebFXMenuButton("enable", "<fmt:message key='common.toolbar.enable.label' bundle='${v3xCommonI18N}' />", "enableDocLibs();", [2,3], "", null));
						</c:if>
						var viewmenu = new WebFXMenu;
					    viewmenu.add(new WebFXMenuItem("", "<fmt:message key='doc.lib.disabled' />", "viewDocLibs('0')", "", null));
						viewmenu.add(new WebFXMenuItem("", "<fmt:message key='doc.lib.enabled' />", "viewDocLibs('1')",  "", null));
			        	myBar.add(new WebFXMenuButton("viewmenu", "<fmt:message key='common.toolbar.viewswitch.label' bundle='${v3xCommonI18N}' />", null, [5,5], "", viewmenu));
						document.write(myBar);
					</script>
				</td>
			</tr>
		</table>
    
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<c:if  test="${isGroupAdmin != true}">
		<v3x:table data="${docTableVo}" var="vo" isChangeTRColor="true" showHeader="true" pageSize="20" showPager="true"  htmlId="ddd">
		<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' id="id" value="${vo.doclib.id}" docLibType="${vo.doclib.type}" />
			</v3x:column>
			<v3x:column label="common.name.label" width="20%" value="${v3x:_(pageContext, vo.doclib.name)}" alt="${v3x:_(pageContext, vo.doclib.name)}" maxLength="24" symbol="..." onClick="editDocLib('${vo.doclib.id}','view');" onDblClick="editDocLib('${vo.doclib.id }','edit');" type="String"></v3x:column>
			<v3x:column label="common.type.label" width="20%" onClick="editDocLib('${vo.doclib.id}','view');" onDblClick="editDocLib('${vo.doclib.id}','edit');" type="String"><fmt:message key="${vo.docLibType}"/></v3x:column>
			<v3x:column label="doc.jsp.properties.common.lib.admin" width="35%" 
				value="${v3x:showOrgEntitiesOfTypeAndId(vo.managerName, pageContext)}" 
				alt="${v3x:showOrgEntitiesOfTypeAndId(vo.managerName, pageContext)}" 
				onClick="editDocLib('${vo.doclib.id }','view');" onDblClick="editDocLib('${vo.doclib.id}','edit');" type="String"></v3x:column>
		 	<v3x:column label="doc.metadata.def.lastupdate" width="20%" align="left" type="Date" onClick="editDocLib('${vo.doclib.id}','view');" onDblClick="editDocLib('${vo.doclib.id}','edit');">
		 		<fmt:formatDate value="${vo.doclib.lastUpdate}" pattern="${datetimePattern}"/>
		 	</v3x:column>		
		</v3x:table>
		</c:if>
		<c:if  test="${isGroupAdmin == true}">
		<v3x:table data="${docTableVo}" var="vo" isChangeTRColor="true" showHeader="true" pageSize="20"  htmlId="dsds" className="sort ellipsis">
		<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' id="id" value="${vo.doclib.id}" docLibType="${vo.doclib.type}" />
			</v3x:column>
			<v3x:column label="common.name.label" width="20%" value="${v3x:_(pageContext, vo.doclib.name)}" alt="${v3x:_(pageContext, vo.doclib.name)}" maxLength="24" symbol="..." onClick="editDocLib('${vo.doclib.id}','view');" onDblClick="editDocLib('${vo.doclib.id }','edit');" type="String"></v3x:column>
			<v3x:column label="common.type.label" width="20%" onClick="editDocLib('${vo.doclib.id}','view');" onDblClick="editDocLib('${vo.doclib.id}','edit');" type="String"><fmt:message key="${vo.docLibType}"/></v3x:column>
			<v3x:column label="doc.jsp.properties.common.lib.admin" width="35%" 
				value="${v3x:showOrgEntitiesOfTypeAndId(vo.managerName, pageContext)}" 
				alt="${v3x:showOrgEntitiesOfTypeAndId(vo.managerName, pageContext)}" 
				onClick="editDocLib('${vo.doclib.id }','view');" onDblClick="editDocLib('${vo.doclib.id}','edit');" type="String"></v3x:column>
		 	<v3x:column label="doc.metadata.def.lastupdate" width="20%" align="left" type="Date" onClick="editDocLib('${vo.doclib.id}','view');" onDblClick="editDocLib('${vo.doclib.id}','edit');">
		 		<fmt:formatDate value="${vo.doclib.lastUpdate}" pattern="${datetimePattern}"/>
		 	</v3x:column>		
		</v3x:table>
		</c:if>
		<div id="deleteInfo"></div>
    </div>
  </div>
</div>
</form>
<iframe name="empty" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
</iframe>
<script type="text/javascript">
	var count="${count}";
	
	if('${flagGroup}' != 'group'){
		showDetailPageBaseInfo("bottom", "<fmt:message key="doc.menu.admin.libs" />", [3,1], count, _("DocLang.detail_info_70022"));
	}	
	else{
		showDetailPageBaseInfo("bottom", "<fmt:message key="doc.menu.admin.libs" />", [3,1], count, _("DocLang.detail_info_7007"));	
	}
	showCtpLocation('F04_docLibIndex');
</script> 
</body>
</html>