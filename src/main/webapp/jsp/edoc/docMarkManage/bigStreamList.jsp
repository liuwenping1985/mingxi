<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@include file="../edocHeader.jsp"%>
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body scroll="no">
<form id="mainForm" name="mainForm" method="post">	
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2 webfx-menu-bar">
		<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="26">
<script type="text/javascript">
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","");
	myBar.add(new WebFXMenuButton("add", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />", "addBigStreamPage();", [1,1], "", null));
	myBar.add(new WebFXMenuButton("edit", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", "editBigStreamPage('undefined');", [1,2], "", null));
	myBar.add(new WebFXMenuButton("delete", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "deleteBigStream();",[1,3], "", null));
	document.write(myBar);
</script>
		</td>
	</tr>
	</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
	<v3x:table data="${categories}" var="category" isChangeTRColor="true" showHeader="true" showPager="true" pageSize="20">
		<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
			<input type='checkbox' name='id' id="id" value="${category.id}" isReadonly="${category.readonly}"/>
		</v3x:column>
		<v3x:column label="common.name.label" width="30%" onDblClick="editBigStreamPage('${category.id}');" value="${category.categoryName}" alt="${category.categoryName}" maxLength="24" symbol="..." type="String"></v3x:column>
		<v3x:column label="edoc.docmark.minNo" onDblClick="editBigStreamPage('${category.id}');" width="15%" value="${category.minNo}"  type="Number"></v3x:column>
		<v3x:column label="edoc.docmark.maxNo" onDblClick="editBigStreamPage('${category.id}');" width="15%" value="${category.maxNo}"  type="Number"></v3x:column>
	 	<v3x:column label="edoc.docmark.currentNo" onDblClick="editBigStreamPage('${category.id}');" width="15%" value="${category.currentNo}"  type="Number"></v3x:column>	
		<v3x:column label="edoc.docmark.sortbyyear" onDblClick="editBigStreamPage('${category.id}');" width="20%" type="String"><ftm:message key="common.true" bundle="${v3xCommonI18N}"/>
			<c:choose>
				<c:when test="${category.yearEnabled == true}">
					<fmt:message key='common.yes' bundle="${v3xCommonI18N}"/>
				</c:when>
				<c:otherwise>
					<fmt:message key='common.no' bundle="${v3xCommonI18N}"/>
				</c:otherwise>
			</c:choose>
		</v3x:column>
	</v3x:table>
</div>
  </div>
</div>
<div id="deleteInfo"></div>
</form>

<iframe name="empty" style="display:none;" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
</iframe>

</body>
</html>