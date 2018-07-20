<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../docHeader.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<script type="text/javascript">



</script>
<body>

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr align="center">
		<td height="12" class="detail-top"><img src="/seeyon/common/images/button.preview.up.gif" height="8" onclick="previewFrame('Up')" class="cursor-hand"><img src="/seeyon/common/images/button.preview.down.gif" height="8" onclick="previewFrame('Down')" class="cursor-hand"></td>
	</tr>
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="150" nowrap="nowrap"><fmt:message key="doc.jsp.alert.admin.title"/></td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	<td class="categorySet-head"><div class="categorySet-body">
	<table height="100%" width="100%" cellpadding="0" cellspacing="0">
<tr>
<td>
	<table width="80%" border="0" cellspacing="0" cellpadding="0" align="center">
	
	<tr>
		<td align="center" valign="top">
	
	<fieldset style="width:95%" align="center"><legend><strong><fmt:message key='doc.jsp.alert.admin.prop'/></strong></legend>
		
		<table width="100%" border="0" cellspacing="0" align="center"
		cellpadding="0" id="propTable" style="word-break:break-all;word-wrap:break-word">
			<tr height="25">
				<td align="right" width="30%"><fmt:message key='doc.jsp.open.body.name'/>:&nbsp;&nbsp;</td>
				<td >${v3x:_(pageContext, vo.docResource.frName)}</td></tr>		
			<tr height="25">
				<td align="right"width="30%"><fmt:message key='doc.jsp.properties.common.contenttype'/>:&nbsp;&nbsp;</td>
				<td >${v3x:_(pageContext, vo.type)}</td></tr>			
			<tr height="25">
				<td align="right" width="30%"><fmt:message key='doc.jsp.properties.common.path'/>:&nbsp;&nbsp;</td>
				<td >${vo.path}</td></tr>				
			<tr height="25"><td align="right" width="30%"><fmt:message key='doc.metadata.def.creater'/>:&nbsp;&nbsp;</td>
				<td >${vo.docCreater}</td></tr>
			<tr height="25"><td align="right" width="30%"><fmt:message key='doc.metadata.def.createtime'/>:&nbsp;&nbsp;</td>
				<td ><fmt:formatDate value='${vo.docResource.createTime}' pattern='${datetimePattern}' /></td></tr>	
			<tr height="25">
				<td align="right" width="30%"><fmt:message key='doc.jsp.alert.admin.alerttype'/>:&nbsp;&nbsp;</td>
				<td >${vo.alertType}</td></tr>			
			<tr height="25">
				<td align="right" width="30%"><fmt:message key='doc.jsp.alert.admin.alerttime'/>:&nbsp;&nbsp;</td>
				<td ><fmt:formatDate value='${vo.alertCreateTime}' pattern='${datetimePattern}' /></td></tr>	
			<tr height="25"><td align="right" width="30%"><fmt:message key='doc.metadata.def.desc'/>:&nbsp;&nbsp;</td>
				<td >${vo.docResource.frDesc}</td></tr>
		</table>
		
		</fieldset>
		</td>
		</tr>
	
	
	</table>


</td>
</tr>

</table>
	</div></td></tr>

	</table>


	
<iframe id="empty" name="empty" marginheight="0" marginwidth="0" width="0" height="0"></iframe>
</body>
</html>