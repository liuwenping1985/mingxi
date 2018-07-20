<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../docHeader.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<style type="text/css">
.mxtgrid div.bDiv td div {
    overflow:visible;
}
.scrollList{
     overflow:hidden;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<body scroll="no">
<div class="scrollList">
<form action="" method="post" name="theForm" id="theForm" >
  <v3x:table data="${metadataList}" var="metadata" isChangeTRColor="true" showHeader="true" showPager="false">
		    <v3x:column width="10%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' id="id" value="${metadata.metadataDef.id}" 
				 metaName="${v3x:toHTML(metadata.name)}" category="${metadata.metadataDef.category}" typeKey="<fmt:message key="${metadata.key}"/>"/>
			</v3x:column>            
			<v3x:column label="common.name.label" width="45%" type="string"  value="${metadata.name}" ></v3x:column>
			<v3x:column label="common.category.label" width="25%" type="string"  value="${v3x:_(pageContext, metadata.metadataDef.category)}" ></v3x:column>
			<v3x:column label="common.type.label" width="25%" type="string">
				<fmt:message key="${metadata.key}"/>
			</v3x:column>			
  </v3x:table>
</form>
</div>
</body>
</html>