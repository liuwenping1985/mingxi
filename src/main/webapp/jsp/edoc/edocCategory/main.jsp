<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../edocHeader.jsp" %>
<%@ include file="../../common/INC/noCache.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='edoc.category.storetype' /></title>
</head>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/edocCategory.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script language="javascript">
var defaultContent = v3x.getMessage("edocLang.edoc_category_defaultContent");
</script>
<body scroll="no"> 

<div class="main_div_row2">
<div class="right_div_row2">
<div class="top_div_row2 webfx-menu-bar-gray">
<table class="popupTitleRight" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="bg-advance-middel" style="padding:0;">
		<script language="javascript">
		var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
		var newButton = new WebFXMenuButton("create", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}'/>", "javascript:addCategory()", [1,1], "", null);
		var updateButton = new WebFXMenuButton("update", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}'/>", "javascript:modifyCategory()", [1,2], "", null);
		var deleteButton = new WebFXMenuButton("delete", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}'/>", "javascript:deleteCategory()", [1,3], "", null);
		myBar.add(newButton);
		myBar.add(updateButton);
		myBar.add(deleteButton);
		document.write(myBar);
		document.close();
		</script>
		</td>
		<td height="25">
      		<form action="" name="searchForm" id="searchForm" method="get" style="margin: 0px" onsubmit="return false" onkeydown="doSearchEnter()">
      			<input type="hidden" value="${param.method}" name="method">
				<div class="div-float-right">
					<div class="div-float">
						<select id="condition" name="condition" onChange="showNextCondition(this)" class="condition">
					    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
						    <option value="categoryName" ${param.condition=="categoryName" ? "selected":""}><fmt:message key="edoc.category.send" /></option>
					  	</select>
				  	</div>
				  	
				  	<div id="categoryNameDiv" class="div-float ${empty(param.condition)?'hidden':'' }"><input type="text" id="categoryName" name="textfield" value="${v3x:toHTML(param.textfield)}"  style="height:18px;"  class="textfield" maxlength="100"></div>
				  	
					<div onclick="javascript:doSearch()" class="div-float condition-search-button"></div>
				</div>
			</form>
       </td>
	</tr>
</table>
</div>
<div class="center_div_row2" id="scrollListDiv">
<form id="mainForm" name="mainForm" method="post">
<v3x:table data="list" var="bean" htmlId="listTable" showHeader="true" showPager="true" className="sort ellipsis">
	<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
		<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" isSystem="${bean.storeType == 0}"/>
	</v3x:column>
	<v3x:column width="24%" type="String"  alt="${v3x:toHTML(bean.name)}" onClick="showCategory('${bean.id}')" onDblClick="modifyCategory();" label="edoc.category.send" className="cursor-hand sort mxtgrid_black">
		<lable id="name${bean.id }">${v3x:toHTML(bean.name)}</lable>
	</v3x:column>
	<v3x:column width="24%" type="Date" onClick="showCategory('${bean.id}')" onDblClick="modifyCategory();" label="common.date.lastupdate.label" className="cursor-hand sort">
		<fmt:formatDate value="${bean.modifyTime == null ? defaultModifTime:bean.modifyTime}" pattern="${datePattern}"/>
	</v3x:column>
	<v3x:column width="24%" type="String" onClick="showCategory('${bean.id}')" onDblClick="modifyCategory();" label="common.workflow.modifyBy" className="cursor-hand sort">
		${v3x:showMemberName(bean.modifyUserId == null ? defaultModifyUser:bean.modifyUserId) }
	</v3x:column>
</v3x:table>
</form>
</div>
</div>
</div>
<iframe height="0" width="0" style="display:none;" name="categoryFrame"></iframe>
<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='edoc.category.send'/>", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_4003"));	
</script>
</body>
</html>