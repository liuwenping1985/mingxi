<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<title>detail.jsp</title>
		<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<script type="text/javascript">
<!--
${script}

window.onload = function() {
	bindOnresize("categorySetBody", 30, 60);
}

//-->
</script>
	<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<base>
</head>
<body style="text-align:center" <c:choose><c:when test="${fs == 1}">onload="previewFrame('Up')"</c:when><c:otherwise></c:otherwise></c:choose>>

<!-- 
<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
	<tr align="center">
		<td height="12" class="detail-top"><img src="<c:url value="/apps_res/bulletin/images/button.preview.gif" />" height="8" onclick="previewFrame()" class="cursor-hand"></td>
	</tr>
</table>
-->

<v3x:selectPeople id="wf" panels="Department" selectType="Member" jsFunction="setBulPeopleFields(elements);" />
<v3x:selectPeople id="depart" panels="Department" selectType="Department" jsFunction="setBulDepartmentFields(elements);" />

<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" class="categorySet-bg">
	<tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
				getDetailPageBreak(); 
			</script>
		</td>
	</tr>
	
	<tr>
		<td class="categorySet-4" height="13"></td>
	</tr>
	<!-- 
	<tr>
		<td class="categorySet-head" height="19">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="categorySet-1" width="4"></td>
				<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key='mt.meetingroom.review.label'/></td>
				<td class="categorySet-2" width="4"></td>
				<td class="categorySet-head-space">&nbsp;</td>
			</tr>
		</table>
		</td>
	</tr>
	 -->
	<tr>
		<td id="categorySetId" class="categorySet-head" style="padding: 0px 0px 0px 0px;border:0px 0px 0px 0px;overflow-y:hidden;">
			<div id="categorySetBody" class="categorySet-body border-top border-right border-bottom">
				<table width="40%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mt.admin.button.administrator'/>:</td>
						<td width="35%" nowrap="nowrap" class="new-column"><input type="text" style="width:300px;" value="${bean.adminName }" disabled/></td>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='admin.label.mgemodel'/>:</td>
						<td width="35%" nowrap="nowrap" class="new-column" colspan="3"><input type="text" style="width:300px;" value="${bean.modelName}" disabled title="${bean.modelName}"/></td>
					</tr>
					<!--<tr>
						<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mt.admin.button.management.range'/>:</td>
						<td width="35%" nowrap="nowrap" class="new-column" colspan="3"><%-- <input type="text" style="width:300px;" value="${bean.depStr}" disabled/> --%> <textarea rows="6" cols="46" disabled>${bean.depStr}</textarea> </td>
					</tr>-->
					<tr>
						<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='admin.label.createdate'/>:</td>
						<td width="35%" nowrap="nowrap" class="new-column" colspan="3"><input type="text" style="width:300px;" value="<fmt:formatDate value='${bean.createDate}' pattern='yyyy年MM月dd日'/>" disabled/></td>
					</tr>
				</table>
			</div>		
		</td>
	</tr>
</table>

</body>
</html> 